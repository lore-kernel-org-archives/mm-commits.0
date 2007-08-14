From: akpm@linux-foundation.org
Subject: + pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:00 -0700
Message-ID: <200708142005.l7EK51qa018609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbXHNUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: helpers to find the task by its numerical ids
has been added to the -mm tree.  Its filename is
     pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: helpers to find the task by its numerical ids
From: Pavel Emelyanov <xemul@openvz.org>

When searching the task by numerical id on may need to find it using global
pid (as it is done now in kernel) or by its virtual id, e.g.  when sending a
signal to a task from one namespace the sender will specify the task's virtual
id and we should find the task by this value.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |    2 -
 include/linux/pid.h   |   16 +++++++++++++--
 include/linux/sched.h |   31 +++++++++++++++++++++++++++--
 kernel/pid.c          |   42 +++++++++++++++++++++++-----------------
 4 files changed, 69 insertions(+), 22 deletions(-)

diff -puN fs/proc/base.c~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids
+++ a/fs/proc/base.c
@@ -2251,7 +2251,7 @@ static struct task_struct *next_tgid(uns
 	rcu_read_lock();
 retry:
 	task = NULL;
-	pid = find_ge_pid(tgid);
+	pid = find_ge_pid(tgid, &init_pid_ns);
 	if (pid) {
 		tgid = pid->nr + 1;
 		task = pid_task(pid, PIDTYPE_PID);
diff -puN include/linux/pid.h~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids
+++ a/include/linux/pid.h
@@ -99,17 +99,29 @@ extern void FASTCALL(detach_pid(struct t
 extern void FASTCALL(transfer_pid(struct task_struct *old,
 				  struct task_struct *new, enum pid_type));
 
+struct pid_namespace;
+extern struct pid_namespace init_pid_ns;
+
 /*
  * look up a PID in the hash table. Must be called with the tasklist_lock
  * or rcu_read_lock() held.
+ *
+ * find_pid_ns() finds the pid in the namespace specified
+ * find_pid() find the pid by its global id, i.e. in the init namespace
+ * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
+ *
+ * see also find_task_by_pid() set in include/linux/sched.h
  */
-extern struct pid *FASTCALL(find_pid(int nr));
+extern struct pid *FASTCALL(find_pid_ns(int nr, struct pid_namespace *ns));
+
+#define find_vpid(pid)	find_pid_ns(pid, current->nsproxy->pid_ns)
+#define find_pid(pid)	find_pid_ns(pid, &init_pid_ns)
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
  */
 extern struct pid *find_get_pid(int nr);
-extern struct pid *find_ge_pid(int nr);
+extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
 extern void FASTCALL(free_pid(struct pid *pid));
diff -puN include/linux/sched.h~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids include/linux/sched.h
--- a/include/linux/sched.h~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids
+++ a/include/linux/sched.h
@@ -1478,8 +1478,35 @@ extern struct task_struct init_task;
 
 extern struct   mm_struct init_mm;
 
-#define find_task_by_pid(nr)	find_task_by_pid_type(PIDTYPE_PID, nr)
-extern struct task_struct *find_task_by_pid_type(int type, int pid);
+extern struct pid_namespace init_pid_ns;
+
+/*
+ * find a task by one of its numerical ids
+ *
+ * find_task_by_pid_type_ns():
+ *      it is the most generic call - it finds a task by all id,
+ *      type and namespace specified
+ * find_task_by_pid_ns():
+ *      finds a task by its pid in the specified namespace
+ * find_task_by_pid_type():
+ *      finds a task by its global id with the specified type, e.g.
+ *      by global session id
+ * find_task_by_pid():
+ *      finds a task by its global pid
+ *
+ * see also find_pid() etc in include/linux/pid.h
+ */
+
+extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
+		struct pid_namespace *ns);
+
+#define find_task_by_pid_ns(nr, ns)	\
+		find_task_by_pid_type_ns(PIDTYPE_PID, nr, ns)
+#define find_task_by_pid_type(type, nr)	\
+		find_task_by_pid_type_ns(type, nr, &init_pid_ns)
+#define find_task_by_pid(nr)		\
+		find_task_by_pid_type(PIDTYPE_PID, nr)
+
 extern void __set_special_pids(pid_t session, pid_t pgrp);
 
 /* per-UID process charging. */
diff -puN kernel/pid.c~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids
+++ a/kernel/pid.c
@@ -210,7 +210,8 @@ fastcall void free_pid(struct pid *pid)
 	unsigned long flags;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
-	hlist_del_rcu(&pid->pid_chain);
+	for (i = 0; i <= pid->level; i++)
+		hlist_del_rcu(&pid->numbers[i].pid_chain);
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
 	for (i = 0; i <= pid->level; i++)
@@ -225,6 +226,7 @@ struct pid *alloc_pid(struct pid_namespa
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
+	struct upid *upid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
@@ -251,7 +253,11 @@ struct pid *alloc_pid(struct pid_namespa
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
 	spin_lock_irq(&pidmap_lock);
-	hlist_add_head_rcu(&pid->pid_chain, &pid_hash[pid_hashfn(pid->nr, ns)]);
+	for (i = ns->level; i >= 0; i--) {
+		upid = &pid->numbers[i];
+		hlist_add_head_rcu(&upid->pid_chain,
+				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
+	}
 	spin_unlock_irq(&pidmap_lock);
 
 out:
@@ -266,19 +272,20 @@ out_free:
 	goto out;
 }
 
-struct pid * fastcall find_pid(int nr)
+struct pid * fastcall find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
-	struct pid *pid;
+	struct upid *pnr;
+
+	hlist_for_each_entry_rcu(pnr, elem,
+			&pid_hash[pid_hashfn(nr, ns)], pid_chain)
+		if (pnr->nr == nr && pnr->ns == ns)
+			return container_of(pnr, struct pid,
+					numbers[ns->level]);
 
-	hlist_for_each_entry_rcu(pid, elem,
-			&pid_hash[pid_hashfn(nr, &init_pid_ns)], pid_chain) {
-		if (pid->nr == nr)
-			return pid;
-	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(find_pid);
+EXPORT_SYMBOL_GPL(find_pid_ns);
 
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
@@ -338,12 +345,13 @@ struct task_struct * fastcall pid_task(s
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
  */
-struct task_struct *find_task_by_pid_type(int type, int nr)
+struct task_struct *find_task_by_pid_type_ns(int type, int nr,
+		struct pid_namespace *ns)
 {
-	return pid_task(find_pid(nr), type);
+	return pid_task(find_pid_ns(nr, ns), type);
 }
 
-EXPORT_SYMBOL(find_task_by_pid_type);
+EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
@@ -370,7 +378,7 @@ struct pid *find_get_pid(pid_t nr)
 	struct pid *pid;
 
 	rcu_read_lock();
-	pid = get_pid(find_pid(nr));
+	pid = get_pid(find_vpid(nr));
 	rcu_read_unlock();
 
 	return pid;
@@ -394,15 +402,15 @@ pid_t pid_nr_ns(struct pid *pid, struct 
  *
  * If there is a pid at nr this function is exactly the same as find_pid.
  */
-struct pid *find_ge_pid(int nr)
+struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
 	struct pid *pid;
 
 	do {
-		pid = find_pid(nr);
+		pid = find_pid_ns(nr, ns);
 		if (pid)
 			break;
-		nr = next_pidmap(task_active_pid_ns(current), nr);
+		nr = next_pidmap(ns, nr);
 	} while (nr > 0);
 
 	return pid;
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
