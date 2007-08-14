From: akpm@linux-foundation.org
Subject: + pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:56 -0700
Message-ID: <200708142004.l7EK4u9W018603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbXHNUKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: make alloc_pid(), free_pid() and put_pid() work with struct upid
has been added to the -mm tree.  Its filename is
     pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: make alloc_pid(), free_pid() and put_pid() work with struct upid
From: Pavel Emelyanov <xemul@openvz.org>

Each struct upid element of struct pid has to be initialized properly, i.e. 
its nr mst be allocated from appropriate pidmap and ns set to appropriate
namespace.

When allocating a new pid, we need to know the namespace this pid will live
in, so the additional argument is added to alloc_pid().

On the other hand, the rest of the kernel still uses the pid->nr and
pid->pid_chain fields, so these ones are still initialized, but this will be
removed soon.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    2 -
 kernel/fork.c       |    2 -
 kernel/pid.c        |   49 +++++++++++++++++++++++++++++-------------
 3 files changed, 36 insertions(+), 17 deletions(-)

diff -puN include/linux/pid.h~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid
+++ a/include/linux/pid.h
@@ -111,7 +111,7 @@ extern struct pid *FASTCALL(find_pid(int
 extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr);
 
-extern struct pid *alloc_pid(void);
+extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void FASTCALL(free_pid(struct pid *pid));
 
 static inline pid_t pid_nr(struct pid *pid)
diff -puN kernel/fork.c~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid kernel/fork.c
--- a/kernel/fork.c~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid
+++ a/kernel/fork.c
@@ -1029,7 +1029,7 @@ static struct task_struct *copy_process(
 		goto bad_fork_cleanup_put_domain;
 
 	if (pid != &init_struct_pid) {
-		pid = alloc_pid();
+		pid = alloc_pid(task_active_pid_ns(p));
 		if (!pid)
 			goto bad_fork_put_binfmt_module;
 	}
diff -puN kernel/pid.c~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid
+++ a/kernel/pid.c
@@ -29,7 +29,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
 
-#define pid_hashfn(nr) hash_long((unsigned long)nr, pidhash_shift)
+#define pid_hashfn(nr, ns)	\
+	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
@@ -186,11 +187,13 @@ fastcall void put_pid(struct pid *pid)
 	if (!pid)
 		return;
 
-	/* FIXME - this must be the namespace this pid lives in */
-	ns = &init_pid_ns;
+	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
-	     atomic_dec_and_test(&pid->count))
+	     atomic_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
+		if (ns != &init_pid_ns)
+			put_pid_ns(ns);
+	}
 }
 EXPORT_SYMBOL_GPL(put_pid);
 
@@ -203,45 +206,61 @@ static void delayed_put_pid(struct rcu_h
 fastcall void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
+	int i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
 	hlist_del_rcu(&pid->pid_chain);
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
-	free_pidmap(&init_pid_ns, pid->nr);
+	for (i = 0; i <= pid->level; i++)
+		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(void)
+struct pid *alloc_pid(struct pid_namespace *ns)
 {
 	struct pid *pid;
 	enum pid_type type;
-	int nr = -1;
-	struct pid_namespace *ns;
+	int i, nr;
+	struct pid_namespace *tmp;
 
-	ns = task_active_pid_ns(current);
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
 		goto out;
 
-	nr = alloc_pidmap(ns);
-	if (nr < 0)
-		goto out_free;
+	tmp = ns;
+	for (i = ns->level; i >= 0; i--) {
+		nr = alloc_pidmap(tmp);
+		if (nr < 0)
+			goto out_free;
+
+		pid->numbers[i].nr = nr;
+		pid->numbers[i].ns = tmp;
+		tmp = tmp->parent;
+	}
+
+	if (ns != &init_pid_ns)
+		get_pid_ns(ns);
 
+	pid->level = ns->level;
+	pid->nr = pid->numbers[0].nr;
 	atomic_set(&pid->count, 1);
-	pid->nr = nr;
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
 	spin_lock_irq(&pidmap_lock);
-	hlist_add_head_rcu(&pid->pid_chain, &pid_hash[pid_hashfn(pid->nr)]);
+	hlist_add_head_rcu(&pid->pid_chain, &pid_hash[pid_hashfn(pid->nr, ns)]);
 	spin_unlock_irq(&pidmap_lock);
 
 out:
 	return pid;
 
 out_free:
+	for (i++; i <= ns->level; i++)
+		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+
 	kmem_cache_free(ns->pid_cachep, pid);
 	pid = NULL;
 	goto out;
@@ -253,7 +272,7 @@ struct pid * fastcall find_pid(int nr)
 	struct pid *pid;
 
 	hlist_for_each_entry_rcu(pid, elem,
-			&pid_hash[pid_hashfn(nr)], pid_chain) {
+			&pid_hash[pid_hashfn(nr, &init_pid_ns)], pid_chain) {
 		if (pid->nr == nr)
 			return pid;
 	}
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
