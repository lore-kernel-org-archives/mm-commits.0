From: akpm@linux-foundation.org
Subject: + uninline-find_task_by_xxx-set-of-functions.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:35:10 -0700
Message-ID: <200709262035.l8QKZARn002608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbXIZUgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     Uninline find_task_by_xxx set of functions
has been added to the -mm tree.  Its filename is
     uninline-find_task_by_xxx-set-of-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Uninline find_task_by_xxx set of functions
From: Pavel Emelyanov <xemul@openvz.org>

The find_task_by_something is a set of macros are used to find task by pid
depending on what kind of pid is proposed - global or virtual one.  All of
them are wrappers above the most generic one - find_task_by_pid_type_ns() -
and just substitute some args for it.

It turned out, that dereferencing the current->nsproxy->pid_ns construction
and pushing one more argument on the stack inline cause kernel text size to
grow.

This patch moves all this stuff out-of-line into kernel/pid.c.  Together
with the next patch it saves a bit less than 400 bytes from the .text
section.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ioprio.c~uninline-find_task_by_xxx-set-of-functions fs/ioprio.c
--- a/fs/ioprio.c~uninline-find_task_by_xxx-set-of-functions
+++ a/fs/ioprio.c
@@ -94,8 +94,7 @@ asmlinkage long sys_ioprio_set(int which
 			if (!who)
 				p = current;
 			else
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			if (p)
 				ret = set_task_ioprio(p, ioprio);
 			break;
@@ -182,8 +181,7 @@ asmlinkage long sys_ioprio_get(int which
 			if (!who)
 				p = current;
 			else
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			if (p)
 				ret = get_task_ioprio(p);
 			break;
diff -puN include/linux/sched.h~uninline-find_task_by_xxx-set-of-functions include/linux/sched.h
--- a/include/linux/sched.h~uninline-find_task_by_xxx-set-of-functions
+++ a/include/linux/sched.h
@@ -1487,9 +1487,8 @@ extern struct pid_namespace init_pid_ns;
  *      type and namespace specified
  * find_task_by_pid_ns():
  *      finds a task by its pid in the specified namespace
- * find_task_by_pid_type():
- *      finds a task by its global id with the specified type, e.g.
- *      by global session id
+ * find_task_by_vpid():
+ *      finds a task by its virtual pid
  * find_task_by_pid():
  *      finds a task by its global pid
  *
@@ -1499,12 +1498,10 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-#define find_task_by_pid_ns(nr, ns)	\
-		find_task_by_pid_type_ns(PIDTYPE_PID, nr, ns)
-#define find_task_by_pid_type(type, nr)	\
-		find_task_by_pid_type_ns(type, nr, &init_pid_ns)
-#define find_task_by_pid(nr)		\
-		find_task_by_pid_type(PIDTYPE_PID, nr)
+extern struct task_struct *find_task_by_pid(pid_t nr);
+extern struct task_struct *find_task_by_vpid(pid_t nr);
+extern struct task_struct *find_task_by_pid_ns(pid_t nr,
+		struct pid_namespace *ns);
 
 extern void __set_special_pids(pid_t session, pid_t pgrp);
 
diff -puN kernel/capability.c~uninline-find_task_by_xxx-set-of-functions kernel/capability.c
--- a/kernel/capability.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/capability.c
@@ -63,8 +63,7 @@ asmlinkage long sys_capget(cap_user_head
 	read_lock(&tasklist_lock);
 
 	if (pid && pid != task_pid_vnr(current)) {
-		target = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		target = find_task_by_vpid(pid);
 		if (!target) {
 			ret = -ESRCH;
 			goto out;
@@ -198,8 +197,7 @@ asmlinkage long sys_capset(cap_user_head
 	read_lock(&tasklist_lock);
 
 	if (pid > 0 && pid != task_pid_vnr(current)) {
-		target = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		target = find_task_by_vpid(pid);
 		if (!target) {
 			ret = -ESRCH;
 			goto out;
diff -puN kernel/futex.c~uninline-find_task_by_xxx-set-of-functions kernel/futex.c
--- a/kernel/futex.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/futex.c
@@ -446,9 +446,7 @@ static struct task_struct * futex_find_g
 	struct task_struct *p;
 
 	rcu_read_lock();
-	p = find_task_by_pid_ns(pid,
-			current->nsproxy->pid_ns);
-
+	p = find_task_by_vpid(pid);
 	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
 		p = ERR_PTR(-ESRCH);
 	else
@@ -1858,8 +1856,7 @@ sys_get_robust_list(int pid, struct robu
 
 		ret = -ESRCH;
 		rcu_read_lock();
-		p = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
diff -puN kernel/futex_compat.c~uninline-find_task_by_xxx-set-of-functions kernel/futex_compat.c
--- a/kernel/futex_compat.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/futex_compat.c
@@ -118,8 +118,7 @@ compat_sys_get_robust_list(int pid, comp
 
 		ret = -ESRCH;
 		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid,
-				current->nsproxy->pid_ns);
+		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
 		ret = -EPERM;
diff -puN kernel/pid.c~uninline-find_task_by_xxx-set-of-functions kernel/pid.c
--- a/kernel/pid.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/pid.c
@@ -369,6 +369,25 @@ struct task_struct *find_task_by_pid_typ
 
 EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
+struct task_struct *find_task_by_pid(pid_t nr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
+}
+EXPORT_SYMBOL(find_task_by_pid);
+
+struct task_struct *find_task_by_vpid(pid_t vnr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, vnr,
+			current->nsproxy->pid_ns);
+}
+EXPORT_SYMBOL(find_task_by_vpid);
+
+struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, ns);
+}
+EXPORT_SYMBOL(find_task_by_pid_ns);
+
 struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid;
diff -puN kernel/ptrace.c~uninline-find_task_by_xxx-set-of-functions kernel/ptrace.c
--- a/kernel/ptrace.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/ptrace.c
@@ -444,8 +444,7 @@ struct task_struct *ptrace_get_task_stru
 		return ERR_PTR(-EPERM);
 
 	read_lock(&tasklist_lock);
-	child = find_task_by_pid_ns(pid,
-			current->nsproxy->pid_ns);
+	child = find_task_by_vpid(pid);
 	if (child)
 		get_task_struct(child);
 
diff -puN kernel/sched.c~uninline-find_task_by_xxx-set-of-functions kernel/sched.c
--- a/kernel/sched.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/sched.c
@@ -4160,8 +4160,7 @@ struct task_struct *idle_task(int cpu)
  */
 static inline struct task_struct *find_process_by_pid(pid_t pid)
 {
-	return pid ?
-		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
+	return pid ? find_task_by_vpid(pid) : current;
 }
 
 /* Actually do priority change: must hold rq lock. */
diff -puN kernel/signal.c~uninline-find_task_by_xxx-set-of-functions kernel/signal.c
--- a/kernel/signal.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/signal.c
@@ -2237,7 +2237,7 @@ static int do_tkill(int tgid, int pid, i
 	info.si_uid = current->uid;
 
 	read_lock(&tasklist_lock);
-	p = find_task_by_pid_ns(pid, current->nsproxy->pid_ns);
+	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
 		error = check_kill_permission(sig, &info, p);
 		/*
diff -puN kernel/sys.c~uninline-find_task_by_xxx-set-of-functions kernel/sys.c
--- a/kernel/sys.c~uninline-find_task_by_xxx-set-of-functions
+++ a/kernel/sys.c
@@ -151,8 +151,7 @@ asmlinkage long sys_setpriority(int whic
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			else
 				p = current;
 			if (p)
@@ -209,8 +208,7 @@ asmlinkage long sys_getpriority(int whic
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			else
 				p = current;
 			if (p) {
@@ -1065,7 +1063,8 @@ asmlinkage long sys_setsid(void)
 	 * session id and so the check will always fail and make it so
 	 * init cannot successfully call setsid.
 	 */
-	if (session > 1 && find_task_by_pid_type(PIDTYPE_PGID, session))
+	if (session > 1 && find_task_by_pid_type_ns(PIDTYPE_PGID,
+				session, &init_pid_ns))
 		goto out;
 
 	group_leader->signal->leader = 1;
diff -puN mm/mempolicy.c~uninline-find_task_by_xxx-set-of-functions mm/mempolicy.c
--- a/mm/mempolicy.c~uninline-find_task_by_xxx-set-of-functions
+++ a/mm/mempolicy.c
@@ -941,8 +941,7 @@ asmlinkage long sys_migrate_pages(pid_t 
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
-	task = pid ?
-		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
+	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
 		return -ESRCH;
diff -puN mm/migrate.c~uninline-find_task_by_xxx-set-of-functions mm/migrate.c
--- a/mm/migrate.c~uninline-find_task_by_xxx-set-of-functions
+++ a/mm/migrate.c
@@ -925,8 +925,7 @@ asmlinkage long sys_move_pages(pid_t pid
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
-	task = pid ?
-		find_task_by_pid_ns(pid, current->nsproxy->pid_ns) : current;
+	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
 		return -ESRCH;
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
git-nfsd.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
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
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
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
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
cleanup-macros-for-distinguishing-mandatory-locks.patch
gfs2-cleanup-explicit-check-for-mandatory-locks.patch
9pfs-cleanup-explicit-check-for-mandatory-locks.patch
afs-cleanup-explicit-check-for-mandatory-locks.patch
nfs-cleanup-explicit-check-for-mandatory-locks.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
