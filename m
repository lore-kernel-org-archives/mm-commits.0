From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:33:32 -0700
Message-ID: <53960c0c.naBbWuqx+R6AUKps%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, oleg@redhat.com

Subject: [merged] ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch removed from -mm tree
To: oleg@redhat.com,peterz@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:32 -0700


The patch titled
     Subject: ptrace: task_clear_jobctl_trapping()->wake_up_bit() needs mb()
has been removed from the -mm tree.  Its filename was
     ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: task_clear_jobctl_trapping()->wake_up_bit() needs mb()

__wake_up_bit() checks waitqueue_active() and thus the caller needs mb()
as wake_up_bit() documents, fix task_clear_jobctl_trapping().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/signal.c~ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb kernel/signal.c
--- a/kernel/signal.c~ptrace-task_clear_jobctl_trapping-wake_up_bit-needs-mb
+++ a/kernel/signal.c
@@ -277,6 +277,7 @@ void task_clear_jobctl_trapping(struct t
 {
 	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
 		task->jobctl &= ~JOBCTL_TRAPPING;
+		smp_mb();	/* advised by wake_up_bit() */
 		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
 	}
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current.patch
nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-but-current-fix.patch

