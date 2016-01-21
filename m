From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:59:45 -0800
Message-ID: <56a162e1.H+24rcXZVV0IcwLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbcAUW7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, aryabinin@virtuozzo.com, jan.kratochvil@redhat.com, palves@redhat.com, roland@hack.frob.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: make wait_on_bit(JOBCTL_TRAPPING_BIT) in ptrace_attach() killable
has been removed from the -mm tree.  Its filename was
     ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: make wait_on_bit(JOBCTL_TRAPPING_BIT) in ptrace_attach() killable

ptrace_attach() can hang waiting for STOPPED -> TRACED transition if the
tracee gets frozen in between, change wait_on_bit() to use TASK_KILLABLE.

This doesn't really solve the problem(s) and we probably need to fix the
freezer.  In particular, note that this means that pm freezer will fail if
it races attach-to-stopped-task.

And otoh perhaps we can just remove JOBCTL_TRAPPING_BIT altogether, it is
not clear if we really need to hide this transition from debugger, WNOHANG
after PTRACE_ATTACH can fail anyway if it races with SIGCONT.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Roland McGrath <roland@hack.frob.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <palves@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/ptrace.c~ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable
+++ a/kernel/ptrace.c
@@ -364,8 +364,14 @@ unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
 	if (!retval) {
-		wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT,
-			    TASK_UNINTERRUPTIBLE);
+		/*
+		 * We do not bother to change retval or clear JOBCTL_TRAPPING
+		 * if wait_on_bit() was interrupted by SIGKILL. The tracer will
+		 * not return to user-mode, it will exit and clear this bit in
+		 * __ptrace_unlink() if it wasn't already cleared by the tracee;
+		 * and until then nobody can ptrace this task.
+		 */
+		wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT, TASK_KILLABLE);
 		proc_ptrace_connector(task, PTRACE_ATTACH);
 	}
 
_

Patches currently in -mm which might be from oleg@redhat.com are


