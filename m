From: akpm@linux-foundation.org
Subject: + coredump-cleanup-the-waiting-for-coredump_finish-code.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:32:58 -0800
Message-ID: <20130215233259.2756931C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:65238 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3BOXdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:33:00 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so404317ves.5
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:32:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, benchan@chromium.org, mingo@redhat.com, oleg@redhat.com, rjw@sisk.pl, tj@kernel.org


The patch titled
     Subject: coredump: cleanup the waiting for coredump_finish code
has been added to the -mm tree.  Its filename is
     coredump-cleanup-the-waiting-for-coredump_finish-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

