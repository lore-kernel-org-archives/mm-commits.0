From: akpm@linux-foundation.org
Subject: [merged] proc-fix-a-race-in-do_io_accounting.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:39 -0700
Message-ID: <201107271927.p6RJRP63003211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1G0T2J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: fix a race in do_io_accounting()
has been removed from the -mm tree.  Its filename was
     proc-fix-a-race-in-do_io_accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix a race in do_io_accounting()
From: Vasiliy Kulikov <segoon@openwall.com>

If an inode's mode permits opening /proc/PID/io and the resulting file
descriptor is kept across execve() of a setuid or similar binary, the
ptrace_may_access() check tries to prevent using this fd against the task
with escalated privileges.

Unfortunately, there is a race in the check against execve().  If execve()
is processed after the ptrace check, but before the actual io information
gathering, io statistics will be gathered from the privileged process.  At
least in theory this might lead to gathering sensible information (like
ssh/ftp password length) that wouldn't be available otherwise.

Holding task->signal->cred_guard_mutex while gathering the io information
should protect against the race.

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
@@ -2706,9 +2706,16 @@ static int do_io_accounting(struct task_
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
@@ -2719,7 +2726,7 @@ static int do_io_accounting(struct task_
 
 		unlock_task_sighand(task, &flags);
 	}
-	return sprintf(buffer,
+	result = sprintf(buffer,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2734,6 +2741,9 @@ static int do_io_accounting(struct task_
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

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

