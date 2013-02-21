From: akpm@linux-foundation.org
Subject: [nacked] coredump-cleanup-the-waiting-for-coredump_finish-code.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:50:06 -0800
Message-ID: <20130221235007.0CE1131C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:50814 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab3BUXuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:50:08 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so13015vbb.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:50:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: cleanup the waiting for coredump_finish code
has been removed from the -mm tree.  Its filename was
     coredump-cleanup-the-waiting-for-coredump_finish-code.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Mandeep Singh Baines <msb@chromium.org>
Subject: coredump: cleanup the waiting for coredump_finish code

Replace the for loop with a simple if.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ben Chan <benchan@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~coredump-cleanup-the-waiting-for-coredump_finish-code kernel/exit.c
--- a/kernel/exit.c~coredump-cleanup-the-waiting-for-coredump_finish-code
+++ a/kernel/exit.c
@@ -481,12 +481,9 @@ static void exit_mm(struct task_struct *
 		if (atomic_dec_and_test(&core_state->nr_threads))
 			complete(&core_state->startup);
 
-		for (;;) {
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (self.task) /* see coredump_finish() */
 			schedule();
-		}
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
_

Patches currently in -mm which might be from msb@chromium.org are

coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-v2.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

