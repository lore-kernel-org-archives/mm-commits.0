From: akpm@linux-foundation.org
Subject: - uninline-find_task_by_xxx-set-of-functions.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:01 -0700
Message-ID: <200710192252.l9JMq1T3024230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759928AbXJSXMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:12:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, mingo@elte.hu, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Uninline find_task_by_xxx set of functions
has been removed from the -mm tree.  Its filename was
     uninline-find_task_by_xxx-set-of-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c           |    6 ++----
 include/linux/sched.h |   15 ++++++---------
 kernel/capability.c   |    6 ++----
 kernel/futex.c        |    7 ++-----
 kernel/futex_compat.c |    3 +--
 kernel/pid.c          |   19 +++++++++++++++++++
 kernel/ptrace.c       |    3 +--
 kernel/sched.c        |    3 +--
 kernel/signal.c       |    2 +-
 kernel/sys.c          |    9 ++++-----
 mm/mempolicy.c        |    3 +--
 mm/migrate.c          |    3 +--
 12 files changed, 41 insertions(+), 38 deletions(-)

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
@@ -1523,9 +1523,8 @@ extern struct pid_namespace init_pid_ns;
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
@@ -1535,12 +1534,10 @@ extern struct pid_namespace init_pid_ns;
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
@@ -125,8 +125,7 @@ compat_sys_get_robust_list(int pid, comp
 
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
@@ -4168,8 +4168,7 @@ struct task_struct *idle_task(int cpu)
  */
 static struct task_struct *find_process_by_pid(pid_t pid)
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
@@ -152,8 +152,7 @@ asmlinkage long sys_setpriority(int whic
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			else
 				p = current;
 			if (p)
@@ -210,8 +209,7 @@ asmlinkage long sys_getpriority(int whic
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
-				p = find_task_by_pid_ns(who,
-						current->nsproxy->pid_ns);
+				p = find_task_by_vpid(who);
 			else
 				p = current;
 			if (p) {
@@ -1067,7 +1065,8 @@ asmlinkage long sys_setsid(void)
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
