From: akpm@linux-foundation.org
Subject: + cred_guard_mutex-do-not-return-eintr-to-user-space.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:20:47 -0700
Message-ID: <200906292220.n5TMKlIk031400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbZF2WVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com


The patch titled
     cred_guard_mutex: do not return -EINTR to user-space
has been added to the -mm tree.  Its filename is
     cred_guard_mutex-do-not-return-eintr-to-user-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
signals-change-__wake_up_parent-to-use-filtered-wakeup.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

