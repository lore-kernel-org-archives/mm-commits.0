From: akpm@linux-foundation.org
Subject: + ptrace-use-safer-wake-up-on-ptrace_detach.patch added to -mm tree
Date: Tue, 01 Feb 2011 16:27:35 -0800
Message-ID: <201102020027.p120RZlW007403__40235.1677803837$1296606518$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077Ab1BBA2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 19:28:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, oleg@redhat.com, roland@redhat.com, stable@kernel.org


The patch titled
     ptrace: use safer wake up on ptrace_detach()
has been added to the -mm tree.  Its filename is
     ptrace-use-safer-wake-up-on-ptrace_detach.patch

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
Subject: ptrace: use safer wake up on ptrace_detach()
From: Tejun Heo <tj@kernel.org>

The wake_up_process() call in ptrace_detach() is spurious and not
interlocked with the tracee state.  IOW, the tracee could be running or
sleeping in any place in the kernel by the time wake_up_process() is
called.  This can lead to the tracee waking up unexpectedly which can be
dangerous.

The wake_up is spurious and should be removed but for now reduce its
toxicity by only waking up if the tracee is in TRACED or STOPPED state.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~ptrace-use-safer-wake-up-on-ptrace_detach kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-use-safer-wake-up-on-ptrace_detach
+++ a/kernel/ptrace.c
@@ -313,7 +313,7 @@ int ptrace_detach(struct task_struct *ch
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 		if (!child->exit_state)
-			wake_up_process(child);
+			wake_up_state(child, TASK_TRACED | TASK_STOPPED);
 	}
 	write_unlock_irq(&tasklist_lock);
 
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
ptrace-use-safer-wake-up-on-ptrace_detach.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
scatterlist-new-helper-functions.patch

