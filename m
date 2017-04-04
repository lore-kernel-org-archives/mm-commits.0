From: akpm@linux-foundation.org
Subject: + ptrace-fix-ptrace_listen-race-corrupting-task-state.patch added to -mm tree
Date: Tue, 04 Apr 2017 14:57:10 -0700
Message-ID: <58e416b6.BIb/JkkYa7mr6HzL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753834AbdDDV5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2017 17:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsegall@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: fix PTRACE_LISTEN race corrupting task->state
has been added to the -mm tree.  Its filename is
     ptrace-fix-ptrace_listen-race-corrupting-task-state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-fix-ptrace_listen-race-corrupting-task-state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-fix-ptrace_listen-race-corrupting-task-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: bsegall@google.com
Subject: ptrace: fix PTRACE_LISTEN race corrupting task->state

In PT_SEIZED + LISTEN mode STOP/CONT signals cause a wakeup against
__TASK_TRACED. If this races with the ptrace_unfreeze_traced at the end
of a PTRACE_LISTEN, this can wake the task /after/ the check against
__TASK_TRACED, but before the reset of state to TASK_TRACED. This causes
it to instead clobber TASK_WAKING, allowing a subsequent wakeup against
TRACED while the task is still on the rq wake_list, corrupting it.

Link: http://lkml.kernel.org/r/xm26y3vfhmkp.fsf_-_@bsegall-linux.mtv.corp.google.com
Signed-off-by: Ben Segall <bsegall@google.com>
---

v2: slight clarification in comments, put the conditional around the
whole wakeup area

Oleg mentioned a preference for making LISTEN unfreeze instead; I have
no preference there, just wanted to make sure that this doesn't get
forgotten entirely.

 1 file changed, 10 insertions(+), 4 deletions(-)

index 0af928712174..7cc49c3e73af 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state
+++ a/kernel/ptrace.c
@@ -184,11 +184,17 @@ static void ptrace_unfreeze_traced(struc
 
 	WARN_ON(!task->ptrace || task->parent != current);
 
+       /*
+        * PTRACE_LISTEN can allow ptrace_trap_notify to wake us up
+        * remotely. Recheck state under the lock to close this race.
+        */
 	spin_lock_irq(&task->sighand->siglock);
-	if (__fatal_signal_pending(task))
-		wake_up_state(task, __TASK_TRACED);
-	else
-		task->state = TASK_TRACED;
+       if (task->state == __TASK_TRACED) {
+               if (__fatal_signal_pending(task))
+                       wake_up_state(task, __TASK_TRACED);
+               else
+                       task->state = TASK_TRACED;
+       }
 	spin_unlock_irq(&task->sighand->siglock);
 }
 
_

Patches currently in -mm which might be from bsegall@google.com are

ptrace-fix-ptrace_listen-race-corrupting-task-state.patch

