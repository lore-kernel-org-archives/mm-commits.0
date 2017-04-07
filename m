From: akpm@linux-foundation.org
Subject: [patch 05/10] ptrace: fix PTRACE_LISTEN race corrupting
 task->state
Date: Fri, 07 Apr 2017 16:04:51 -0700
Message-ID: <58e81b13.LKvI8vJZ1etgHK/t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37244 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755242AbdDGXEw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bsegall@google.com, oleg@redhat.com, stable@vger.kernel.org

From: bsegall@google.com
Subject: ptrace: fix PTRACE_LISTEN race corrupting task->state

In PT_SEIZED + LISTEN mode STOP/CONT signals cause a wakeup against
__TASK_TRACED. If this races with the ptrace_unfreeze_traced at the end
of a PTRACE_LISTEN, this can wake the task /after/ the check against
__TASK_TRACED, but before the reset of state to TASK_TRACED. This causes
it to instead clobber TASK_WAKING, allowing a subsequent wakeup against
TRACED while the task is still on the rq wake_list, corrupting it.

Oleg said:

The kernel can crash or this can lead to other hard-to-debug problems.  In
short, "task->state = TASK_TRACED" in ptrace_unfreeze_traced() assumes
that nobody else can wake it up, but PTRACE_LISTEN breaks the contract. 
Obviusly it is veru wrong to manipulate task->state if this task is
already running, or WAKING, or it sleeps again.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 9899d11f ("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL")
Link: http://lkml.kernel.org/r/xm26y3vfhmkp.fsf_-_@bsegall-linux.mtv.corp.google.com
Signed-off-by: Ben Segall <bsegall@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-ptrace_listen-race-corrupting-task-state
+++ a/kernel/ptrace.c
@@ -184,11 +184,17 @@ static void ptrace_unfreeze_traced(struc
 
 	WARN_ON(!task->ptrace || task->parent != current);
 
+	/*
+	 * PTRACE_LISTEN can allow ptrace_trap_notify to wake us up remotely.
+	 * Recheck state under the lock to close this race.
+	 */
 	spin_lock_irq(&task->sighand->siglock);
-	if (__fatal_signal_pending(task))
-		wake_up_state(task, __TASK_TRACED);
-	else
-		task->state = TASK_TRACED;
+	if (task->state == __TASK_TRACED) {
+		if (__fatal_signal_pending(task))
+			wake_up_state(task, __TASK_TRACED);
+		else
+			task->state = TASK_TRACED;
+	}
 	spin_unlock_irq(&task->sighand->siglock);
 }
 
_
