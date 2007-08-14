From: akpm@linux-foundation.org
Subject: + pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:11 -0700
Message-ID: <200708142005.l7EK5Bo8018690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765385AbXHNUFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: miscelaneous preparations for pid namespaces
has been added to the -mm tree.  Its filename is
     pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: miscelaneous preparations for pid namespaces
From: Pavel Emelyanov <xemul@openvz.org>

* remove pid.h from pid_namespaces.h;
* rework is_(container|global)_init;
* optimize (get|put)_pid_ns for init_pid_ns;
* declare task_child_reaper to return actual reaper.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |   10 ++++++----
 include/linux/sched.h         |   12 +++++-------
 kernel/pid.c                  |   21 ++++++++++++++-------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff -puN include/linux/pid_namespace.h~pid-namespaces-miscelaneous-preparations-for-pid-namespaces include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-miscelaneous-preparations-for-pid-namespaces
+++ a/include/linux/pid_namespace.h
@@ -4,7 +4,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/threads.h>
-#include <linux/pid.h>
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
 
@@ -32,7 +31,8 @@ extern struct pid_namespace init_pid_ns;
 
 static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
 {
-	kref_get(&ns->kref);
+	if (ns != &init_pid_ns)
+		kref_get(&ns->kref);
 	return ns;
 }
 
@@ -41,7 +41,8 @@ extern void free_pid_ns(struct kref *kre
 
 static inline void put_pid_ns(struct pid_namespace *ns)
 {
-	kref_put(&ns->kref, free_pid_ns);
+	if (ns != &init_pid_ns)
+		kref_put(&ns->kref, free_pid_ns);
 }
 
 static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
@@ -51,7 +52,8 @@ static inline struct pid_namespace *task
 
 static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
 {
-	return init_pid_ns.child_reaper;
+	BUG_ON(tsk != current);
+	return tsk->nsproxy->pid_ns->child_reaper;
 }
 
 #endif /* _LINUX_PID_NS_H */
diff -puN include/linux/sched.h~pid-namespaces-miscelaneous-preparations-for-pid-namespaces include/linux/sched.h
--- a/include/linux/sched.h~pid-namespaces-miscelaneous-preparations-for-pid-namespaces
+++ a/include/linux/sched.h
@@ -1299,19 +1299,17 @@ static inline int pid_alive(struct task_
  * @tsk: Task structure to be checked.
  *
  * Check if a task structure is the first user space task the kernel created.
- *
- * TODO: We should inline this function after some cleanups in pid_namespace.h
  */
-extern int is_global_init(struct task_struct *tsk);
+static inline int is_global_init(struct task_struct *tsk)
+{
+	return tsk->pid == 1;
+}
 
 /*
  * is_container_init:
  * check whether in the task is init in its own pid namespace.
  */
-static inline int is_container_init(struct task_struct *tsk)
-{
-	return tsk->pid == 1;
-}
+extern int is_container_init(struct task_struct *tsk);
 
 extern struct pid *cad_pid;
 
diff -puN kernel/pid.c~pid-namespaces-miscelaneous-preparations-for-pid-namespaces kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-miscelaneous-preparations-for-pid-namespaces
+++ a/kernel/pid.c
@@ -72,10 +72,20 @@ struct pid_namespace init_pid_ns = {
 	.child_reaper = &init_task,
 };
 
-int is_global_init(struct task_struct *tsk)
+int is_container_init(struct task_struct *tsk)
 {
-	return tsk == init_pid_ns.child_reaper;
+	int ret = 0;
+	struct pid *pid;
+
+	rcu_read_lock();
+	pid = task_pid(tsk);
+	if (pid != NULL && pid->numbers[pid->level].nr == 1)
+		ret = 1;
+	rcu_read_unlock();
+
+	return ret;
 }
+EXPORT_SYMBOL(is_container_init);
 
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
@@ -191,8 +201,7 @@ fastcall void put_pid(struct pid *pid)
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
-		if (ns != &init_pid_ns)
-			put_pid_ns(ns);
+		put_pid_ns(ns);
 	}
 }
 EXPORT_SYMBOL_GPL(put_pid);
@@ -243,9 +252,7 @@ struct pid *alloc_pid(struct pid_namespa
 		tmp = tmp->parent;
 	}
 
-	if (ns != &init_pid_ns)
-		get_pid_ns(ns);
-
+	get_pid_ns(ns);
 	pid->level = ns->level;
 	pid->nr = pid->numbers[0].nr;
 	atomic_set(&pid->count, 1);
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
