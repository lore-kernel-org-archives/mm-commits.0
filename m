From: akpm@linux-foundation.org
Subject: + pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:06:41 -0700
Message-ID: <200708172106.l7HL6fjH029457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426AbXHQVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@openvz.org, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     Use find_task_by_pid_ns() in places that operate with virtual pids
has been added to the -mm tree.  Its filename is
     pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use find_task_by_pid_ns() in places that operate with virtual pids
From: Pavel Emelyanov <xemul@openvz.org>

When the pid comes from the userspace, the find_task_by_pid_ns() should be
used to find the task by pid in particular (usually the current) namespace.
 These places were lost in earlier patches.

Think over: all these places work like this:

	if (pid == 0)
		task = current;
	else
		task = find_task_by_pid_ns(pid);

the question is: does it worth introducing a common helper for such
case and (if it does) what should its name be?

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c           |    6 ++++--
 kernel/futex.c        |    6 ++++--
 kernel/futex_compat.c |    3 ++-
 kernel/sched.c        |    3 ++-
 mm/mempolicy.c        |    3 ++-
 mm/migrate.c          |    3 ++-
 6 files changed, 16 insertions(+), 8 deletions(-)

diff -puN fs/ioprio.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual fs/ioprio.c
--- a/fs/ioprio.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/fs/ioprio.c
@@ -94,7 +94,8 @@ asmlinkage long sys_ioprio_set(int which
 			if (!who)
 				p = current;
 			else
-				p = find_task_by_pid(who);
+				p = find_task_by_pid_ns(who,
+						current->nsproxy->pid_ns);
 			if (p)
 				ret = set_task_ioprio(p, ioprio);
 			break;
@@ -181,7 +182,8 @@ asmlinkage long sys_ioprio_get(int which
 			if (!who)
 				p = current;
 			else
-				p = find_task_by_pid(who);
+				p = find_task_by_pid_ns(who,
+						current->nsproxy->pid_ns);
 			if (p)
 				ret = get_task_ioprio(p);
 			break;
diff -puN kernel/futex.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual kernel/futex.c
--- a/kernel/futex.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/kernel/futex.c
@@ -444,7 +444,8 @@ static struct task_struct * futex_find_g
 	struct task_struct *p;
 
 	rcu_read_lock();
-	p = find_task_by_pid(pid);
+	p = find_task_by_pid_ns(pid,
+			current->nsproxy->pid_ns);
 
 	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
 		p = ERR_PTR(-ESRCH);
@@ -1855,7 +1856,8 @@ sys_get_robust_list(int pid, struct robu
 
 		ret = -ESRCH;
 		rcu_read_lock();
-		p = find_task_by_pid(pid);
+		p = find_task_by_pid_ns(pid,
+				current->nsproxy->pid_ns);
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
diff -puN kernel/futex_compat.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual kernel/futex_compat.c
--- a/kernel/futex_compat.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/kernel/futex_compat.c
@@ -116,7 +116,8 @@ compat_sys_get_robust_list(int pid, comp
 
 		ret = -ESRCH;
 		read_lock(&tasklist_lock);
-		p = find_task_by_pid(pid);
+		p = find_task_by_pid_ns(pid,
+				current->nsproxy->pid_ns);
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
diff -puN kernel/sched.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual kernel/sched.c
--- a/kernel/sched.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/kernel/sched.c
@@ -4131,7 +4131,8 @@ struct task_struct *idle_task(int cpu)
  */
 static inline struct task_struct *find_process_by_pid(pid_t pid)
 {
-	return pid ? find_task_by_pid(pid) : current;
+	return pid ?
+		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
 }
 
 /* Actually do priority change: must hold rq lock. */
diff -puN mm/mempolicy.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual mm/mempolicy.c
--- a/mm/mempolicy.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/mm/mempolicy.c
@@ -930,7 +930,8 @@ asmlinkage long sys_migrate_pages(pid_t 
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
-	task = pid ? find_task_by_pid(pid) : current;
+	task = pid ?
+		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
 		return -ESRCH;
diff -puN mm/migrate.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual mm/migrate.c
--- a/mm/migrate.c~pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual
+++ a/mm/migrate.c
@@ -917,7 +917,8 @@ asmlinkage long sys_move_pages(pid_t pid
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
-	task = pid ? find_task_by_pid(pid) : current;
+	task = pid ?
+		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
 		return -ESRCH;
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
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
