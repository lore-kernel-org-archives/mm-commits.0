From: akpm@linux-foundation.org
Subject: [merged] ptrace-use-safer-wake-up-on-ptrace_detach.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:20 -0800
Message-ID: <201102142019.p1EKJKrp022980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab1BNUTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:19:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, oleg@redhat.com, roland@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ptrace: use safer wake up on ptrace_detach()
has been removed from the -mm tree.  Its filename was
     ptrace-use-safer-wake-up-on-ptrace_detach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

This bug can possibly be used as an attack vector.  I don't think it will
take too much effort to come up with an attack which triggers oops
somewhere.  Most sleeps are wrapped in condition test loops and should be
safe but we have quite a number of places where sleep and wakeup
conditions are expected to be interlocked.  Although the window of
opportunity is tiny, ptrace can be used by non-privileged users and with
some loading the window can definitely be extended and exploited.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Roland McGrath <roland@redhat.com>
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

origin.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
scatterlist-new-helper-functions.patch
fs-devpts_pty_new-return-enomem-if-dentry-allocation-failed.patch

