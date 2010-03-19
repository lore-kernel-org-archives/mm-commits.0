From: akpm@linux-foundation.org
Subject: + coredump-factor-out-the-not-ispipe-file-checks.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:09:08 -0700
Message-ID: <201003192209.o2JM98N1015088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab0CSWJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com


The patch titled
     coredump: factor out the not-ispipe file checks
has been added to the -mm tree.  Its filename is
     coredump-factor-out-the-not-ispipe-file-checks.patch

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
Subject: coredump: factor out the not-ispipe file checks
From: Oleg Nesterov <oleg@redhat.com>

do_coredump() does a lot of file checks after it opens the file or calls
usermode helper.  But all of these checks are only needed in !ispipe case.

Move this code into the "else" branch and kill the ugly repetitive ispipe
checks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   63 +++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff -puN fs/exec.c~coredump-factor-out-the-not-ispipe-file-checks fs/exec.c
--- a/fs/exec.c~coredump-factor-out-the-not-ispipe-file-checks
+++ a/fs/exec.c
@@ -1834,7 +1834,6 @@ void do_coredump(long signr, int exit_co
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
-	struct inode * inode;
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
@@ -1911,9 +1910,6 @@ void do_coredump(long signr, int exit_co
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
-		goto fail_unlock;
-
  	if (ispipe) {
 		if (cprm.limit == 1) {
 			/*
@@ -1966,39 +1962,42 @@ void do_coredump(long signr, int exit_co
 			       corename);
 			goto fail_dropcount;
  		}
- 	} else
+	} else {
+		struct inode *inode;
+
+		if (cprm.limit < binfmt->min_coredump)
+			goto fail_unlock;
+
 		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(cprm.file))
-		goto fail_dropcount;
-	inode = cprm.file->f_path.dentry->d_inode;
-	if (inode->i_nlink > 1)
-		goto close_fail;	/* multiple links - don't dump */
-	if (!ispipe && d_unhashed(cprm.file->f_path.dentry))
-		goto close_fail;
-
-	/* AK: actually i see no reason to not allow this for named pipes etc.,
-	   but keep the previous behaviour for now. */
-	if (!ispipe && !S_ISREG(inode->i_mode))
-		goto close_fail;
-	/*
-	 * Dont allow local users get cute and trick others to coredump
-	 * into their pre-created files:
-	 * Note, this is not relevant for pipes
-	 */
-	if (!ispipe && (inode->i_uid != current_fsuid()))
-		goto close_fail;
-	if (!cprm.file->f_op)
-		goto close_fail;
-	if (!cprm.file->f_op->write)
-		goto close_fail;
-	if (!ispipe &&
-	    do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file) != 0)
-		goto close_fail;
+		if (IS_ERR(cprm.file))
+			goto fail_unlock;
 
-	retval = binfmt->core_dump(&cprm);
+		inode = cprm.file->f_path.dentry->d_inode;
+		if (inode->i_nlink > 1)
+			goto close_fail;
+		if (d_unhashed(cprm.file->f_path.dentry))
+			goto close_fail;
+		/*
+		 * AK: actually i see no reason to not allow this for named
+		 * pipes etc, but keep the previous behaviour for now.
+		 */
+		if (!S_ISREG(inode->i_mode))
+			goto close_fail;
+		/*
+		 * Dont allow local users get cute and trick others to coredump
+		 * into their pre-created files.
+		 */
+		if (inode->i_uid != current_fsuid())
+			goto close_fail;
+		if (!cprm.file->f_op || !cprm.file->f_op->write)
+			goto close_fail;
+		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
+			goto close_fail;
+	}
 
+	retval = binfmt->core_dump(&cprm);
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch

