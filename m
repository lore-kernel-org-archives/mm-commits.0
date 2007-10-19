From: akpm@linux-foundation.org
Subject: - pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:42 -0700
Message-ID: <200710192251.l9JMpggY024206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966705AbXJSXG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: miscellaneous preparations for pid namespaces
has been removed from the -mm tree.  Its filename was
     pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: miscellaneous preparations for pid namespaces
From: Pavel Emelyanov <xemul@openvz.org>

* remove pid.h from pid_namespaces.h;
* rework is_(cgroup|global)_init;
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
@@ -1329,19 +1329,17 @@ static inline int pid_alive(struct task_
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
@@ -73,10 +73,20 @@ struct pid_namespace init_pid_ns = {
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
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
@@ -192,8 +202,7 @@ fastcall void put_pid(struct pid *pid)
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
 		kmem_cache_free(ns->pid_cachep, pid);
-		if (ns != &init_pid_ns)
-			put_pid_ns(ns);
+		put_pid_ns(ns);
 	}
 }
 EXPORT_SYMBOL_GPL(put_pid);
@@ -244,9 +253,7 @@ struct pid *alloc_pid(struct pid_namespa
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

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
