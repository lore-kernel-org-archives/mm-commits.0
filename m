From: akpm@linux-foundation.org
Subject: [merged] cred_guard_mutex-do-not-return-eintr-to-user-space.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:56 -0700
Message-ID: <200907142032.n6EKWu0v012651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756422AbZGNUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cred_guard_mutex: do not return -EINTR to user-space
has been removed from the -mm tree.  Its filename was
     cred_guard_mutex-do-not-return-eintr-to-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred_guard_mutex: do not return -EINTR to user-space
From: Oleg Nesterov <oleg@redhat.com>

do_execve() and ptrace_attach() return -EINTR if
mutex_lock_interruptible(->cred_guard_mutex) fails.

This is not right, change the code to return ERESTARTNOINTR.

Perhaps we should also change proc_pid_attr_write().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c     |    4 ++--
 fs/exec.c       |    4 ++--
 kernel/ptrace.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/compat.c~cred_guard_mutex-do-not-return-eintr-to-user-space fs/compat.c
--- a/fs/compat.c~cred_guard_mutex-do-not-return-eintr-to-user-space
+++ a/fs/compat.c
@@ -1486,8 +1486,8 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
 		goto out_free;
 	current->in_execve = 1;
 
diff -puN fs/exec.c~cred_guard_mutex-do-not-return-eintr-to-user-space fs/exec.c
--- a/fs/exec.c~cred_guard_mutex-do-not-return-eintr-to-user-space
+++ a/fs/exec.c
@@ -1277,8 +1277,8 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
 		goto out_free;
 	current->in_execve = 1;
 
diff -puN kernel/ptrace.c~cred_guard_mutex-do-not-return-eintr-to-user-space kernel/ptrace.c
--- a/kernel/ptrace.c~cred_guard_mutex-do-not-return-eintr-to-user-space
+++ a/kernel/ptrace.c
@@ -181,8 +181,8 @@ int ptrace_attach(struct task_struct *ta
 	 * interference; SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&task->cred_guard_mutex))
 		goto out;
 
 	task_lock(task);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

