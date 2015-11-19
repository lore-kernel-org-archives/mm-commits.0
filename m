From: akpm@linux-foundation.org
Subject: +
 ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 15:11:22 -0800
Message-ID: <564e571a.z6l/13qHoLBiytUt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbKSXLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 18:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, aryabinin@virtuozzo.com, jan.kratochvil@redhat.com, palves@redhat.com, roland@hack.frob.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: make wait_on_bit(JOBCTL_TRAPPING_BIT) in ptrace_attach() killable
has been added to the -mm tree.  Its filename is
     ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Tejun Heo <tj@kernel.org>
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

ptrace-make-wait_on_bitjobctl_trapping_bit-in-ptrace_attach-killable.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task.patch

