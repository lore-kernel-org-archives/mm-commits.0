From: akpm@linux-foundation.org
Subject: + irqs-fix-handling-of-pending-irqs-at-request-time.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:39:58 -0800
Message-ID: <20120117223958.B191C10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:38717 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2AQWj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:39:59 -0500
Received: by qadb12 with SMTP id b12so595376qad.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:39:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@arm.linux.org.uk, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     Subject: irqs: fix handling of pending IRQs at request time
has been added to the -mm tree.  Its filename is
     irqs-fix-handling-of-pending-irqs-at-request-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN kernel/irq/manage.c~fix-handling-of-pending-irqs-at-request-time kernel/irq/manage.c
--- a/kernel/irq/manage.c~fix-handling-of-pending-irqs-at-request-time
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
Subject: Subject: irqs: fix handling of pending IRQs at request time

Patches currently in -mm which might be from linux@arm.linux.org.uk are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch
irqs-fix-handling-of-pending-irqs-at-request-time.patch

