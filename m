From: akpm@linux-foundation.org
Subject: + proc-fix-a-race-in-do_io_accounting.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:13:13 -0700
Message-ID: <201107052113.p65LDDlO024429__35608.1480080777$1309900423$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625Ab1GEVN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk


The patch titled
     proc: fix a race in do_io_accounting()
has been added to the -mm tree.  Its filename is
     proc-fix-a-race-in-do_io_accounting.patch

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
Subject: proc: fix a race in do_io_accounting()
From: Vasiliy Kulikov <segoon@openwall.com>

There is a ptrace_may_access() check in do_io_accounting() to prevent
gathering information of setuid'ed and similar binaries.  However, there
is a race against execve().  Holding task->signal->cred_guard_mutex while
gathering the information should protect against the race.

The order of locking is similar to the one inside of ptrace_attach():
first goes cred_guard_mutex, then lock_task_sighand().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-fix-a-race-in-do_io_accounting fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-a-race-in-do_io_accounting
+++ a/fs/proc/base.c
@@ -2718,9 +2718,16 @@ static int do_io_accounting(struct task_
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
+	int result;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
+	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (result)
+		return result;
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		result = -EACCES;
+		goto out_unlock;
+	}
 
 	if (whole && lock_task_sighand(task, &flags)) {
 		struct task_struct *t = task;
@@ -2731,7 +2738,7 @@ static int do_io_accounting(struct task_
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result = sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2746,6 +2753,9 @@ static int do_io_accounting(struct task_
 			(unsigned long long)acct.read_bytes,
 			(unsigned long long)acct.write_bytes,
 			(unsigned long long)acct.cancelled_write_bytes);
+out_unlock:
+	mutex_unlock(&task->signal->cred_guard_mutex);
+	return result;
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
_

Patches currently in -mm which might be from segoon@openwall.com are

arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
proc-fix-a-race-in-do_io_accounting.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

