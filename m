From: akpm@linux-foundation.org
Subject: [alternative-merged] irqs-fix-handling-of-pending-irqs-at-request-time.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:19:19 -0800
Message-ID: <20120227221920.3E356A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:37499 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2B0WTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:19:21 -0500
Received: by qabg24 with SMTP id g24so93812qab.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:19:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@arm.linux.org.uk, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: irqs: fix handling of pending IRQs at request time
has been removed from the -mm tree.  Its filename was
     irqs-fix-handling-of-pending-irqs-at-request-time.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: irqs: fix handling of pending IRQs at request time

When an interrupt is marked as pending, and then subsequently requested,
the interrupt is not delivered to the handler.  The pending status is
entirely ignored, and is left set.  The patch below ensures that this
pending status is acted upon while requesting the interrupt.

This matters for two reasons:

1. If a suspend/resume cycle subsequently occurs, upon resume, we call
   check_irq_resend() while the interrupt layer is resuming.  This notices
   the pending IRQ, and tries to deliver it.

   However, at this time, the device drivers have not been resumed.  If
   the device is behind a serial bus which has not been configured, this
   can cause the kernel to hang or timeout while trying to access the
   inaccessible device.

2. If the device whose interrupt is being requested has already asserted
   its interrupt signal (and is holding it at its own active level) we
   need to process that interrupt to clear down the interrupt, to allow
   an edge-triggered interrupt input to respond to subsequent activations.

This can be caused by an interrupt occuring after free_irq(), the flow
handler noticing that it's been disabled, and recording an IRQS_PENDING
status, or by use of the probe_irq_*() functions.  Either gets us to the
state where we have IRQS_PENDING set, and remaining set indefinitely after
a subsequent request_irq() succeeds.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/irq/manage.c~irqs-fix-handling-of-pending-irqs-at-request-time kernel/irq/manage.c
--- a/kernel/irq/manage.c~irqs-fix-handling-of-pending-irqs-at-request-time
+++ a/kernel/irq/manage.c
@@ -1026,9 +1026,10 @@ __setup_irq(unsigned int irq, struct irq
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
 
-		if (irq_settings_can_autoenable(desc))
+		if (irq_settings_can_autoenable(desc)) {
 			irq_startup(desc);
-		else
+			check_irq_resend(desc, irq);
+		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
 
_

Patches currently in -mm which might be from linux@arm.linux.org.uk are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
arm-use-set_current_blocked-and-block_sigmask.patch
fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch
posix_types-make-__kernel_id32_t-default-to-unsigned-int.patch
posix_types-make-it-possible-to-override-__kernel_fsid_t.patch
arm-use-generic-posix_typesh.patch
posix_types-remove-fd_set-macros.patch
proc-speedup-proc-stat-handling.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch

