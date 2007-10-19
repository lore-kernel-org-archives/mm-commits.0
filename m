From: akpm@linux-foundation.org
Subject: - pid-namespaces-move-alloc_pid-lower-in-copy_process.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:38 -0700
Message-ID: <200710192251.l9JMpcmV024200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966738AbXJSXGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: move alloc_pid() lower in copy_process()
has been removed from the -mm tree.  Its filename was
     pid-namespaces-move-alloc_pid-lower-in-copy_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: move alloc_pid() lower in copy_process()
From: Pavel Emelyanov <xemul@openvz.org>

When we create new namespace we will need to allocate the struct pid, that
will have one extra struct upid in array, comparing to the parent.

Thus we need to know the new namespace (if any) in alloc_pid() to init this
struct upid properly, so move the alloc_pid() call lower in copy_process().

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff -puN kernel/fork.c~pid-namespaces-move-alloc_pid-lower-in-copy_process kernel/fork.c
--- a/kernel/fork.c~pid-namespaces-move-alloc_pid-lower-in-copy_process
+++ a/kernel/fork.c
@@ -1040,16 +1040,9 @@ static struct task_struct *copy_process(
 	if (p->binfmt && !try_module_get(p->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
 
-	if (pid != &init_struct_pid) {
-		pid = alloc_pid(task_active_pid_ns(p));
-		if (!pid)
-			goto bad_fork_put_binfmt_module;
-	}
-
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
-	p->pid = pid_nr(pid);
 	retval = -EFAULT;
 	if (clone_flags & CLONE_PARENT_SETTID)
 		if (put_user(p->pid, parent_tidptr))
@@ -1133,10 +1126,6 @@ static struct task_struct *copy_process(
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
-	p->tgid = p->pid;
-	if (clone_flags & CLONE_THREAD)
-		p->tgid = current->tgid;
-
 	if ((retval = security_task_alloc(p)))
 		goto bad_fork_cleanup_policy;
 	if ((retval = audit_alloc(p)))
@@ -1162,6 +1151,18 @@ static struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_cleanup_namespaces;
 
+	if (pid != &init_struct_pid) {
+		retval = -ENOMEM;
+		pid = alloc_pid(task_active_pid_ns(p));
+		if (!pid)
+			goto bad_fork_cleanup_namespaces;
+	}
+
+	p->pid = pid_nr(pid);
+	p->tgid = p->pid;
+	if (clone_flags & CLONE_THREAD)
+		p->tgid = current->tgid;
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1259,7 +1260,7 @@ static struct task_struct *copy_process(
 		spin_unlock(&current->sighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 		retval = -ERESTARTNOINTR;
-		goto bad_fork_cleanup_namespaces;
+		goto bad_fork_free_pid;
 	}
 
 	if (clone_flags & CLONE_THREAD) {
@@ -1308,6 +1309,9 @@ static struct task_struct *copy_process(
 	cgroup_post_fork(p);
 	return p;
 
+bad_fork_free_pid:
+	if (pid != &init_struct_pid)
+		free_pid(pid);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_keys:
@@ -1337,9 +1341,6 @@ bad_fork_cleanup_cgroup:
 	cgroup_exit(p, cgroup_callbacks_done);
 bad_fork_cleanup_delays_binfmt:
 	delayacct_tsk_free(p);
-	if (pid != &init_struct_pid)
-		free_pid(pid);
-bad_fork_put_binfmt_module:
 	if (p->binfmt)
 		module_put(p->binfmt->module);
 bad_fork_cleanup_put_domain:
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
