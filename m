From: akpm@linux-foundation.org
Subject: [merged] fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:47 -0800
Message-ID: <20120308191747.888A7A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:39208 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab2CHTRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:49 -0500
Received: by vbnl22 with SMTP id l22so104082vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@arm.linux.org.uk, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: irqs: fix long-term regression in genirq irq_set_irq_type() handling
has been removed from the -mm tree.  Its filename was
     fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Russell King <linux@arm.linux.org.uk>
Subject: irqs: fix long-term regression in genirq irq_set_irq_type() handling

In 2008, commit 0c5d1eb77a8be ("genirq: record trigger type") modified the
way set_irq_type() handles the 'no trigger' condition.  However, this has
an adverse effect on PCMCIA support on Intel StrongARM and probably PXA
platforms.

PCMCIA has several status signals on the socket which can trigger
interrupts; some of these status signals depend on the card's mode
(whether it is configured in memory or IO mode).  For example, cards have
a 'Ready/IRQ' signal: in memory mode, this provides an indication to
PCMCIA that the card has finished its power up initialization.  In IO
mode, it provides the device interrupt signal.  Other status signals
switch between on-board battery status and loud speaker output.

In classical PCMCIA implementations, where you have a specific socket
controller, the controller provides a method to mask interrupts from the
socket, and importantly ignore any state transitions on the pins which
correspond with interrupts once masked.  This masking prevents unwanted
events caused by the removal and application of socket power being
forwarded.

However, on platforms where there is no socket controller, the PCMCIA
status and interrupt signals are routed to standard edge-triggered GPIOs. 
These GPIOs can be configured to interrupt on rising edge, falling edge,
or never.  This is where the problems start.

Edge triggered interrupts are required to record events while disabled via
the usual methods of {free,request,disable,enable}_irq() to prevent
problems with dropped interrupts (eg, the 8390 driver uses disable_irq()
to defer the delivery of interrupts).  As a result, these interfaces can
not be used to implement the desired behaviour.

The side effect of this is that if the 'Ready/IRQ' GPIO is disabled via
disable_irq() on suspend, and enabled via enable_irq() after resume, we
will record the state transitions caused by powering events as valid
interrupts, and foward them to the card driver, which may attempt to
access a card which is not powered up.

This leads delays resume while drivers spin in their interrupt handlers,
and complaints from drivers before they realize what's happened.

Moreover, in the case of the 'Ready/IRQ' signal, this is requested and
freed by the card driver itself; the PCMCIA core has no idea whether the
interrupt is requested, and, therefore, whether a call to disable_irq()
would be valid.  (We tried this around 2.4.17 / 2.5.1 kernel era, and
ended up throwing it out because of this problem.)

Therefore, it was decided back in around 2002 to disable the edge
triggering instead, resulting in all state transitions on the GPIO being
ignored.  That's what we actually need the hardware to do.

The commit above changes this behaviour; it explicitly prevents the 'no
trigger' state being selected.

The reason that request_irq() does not accept the 'no trigger' state is
for compatibility with existing drivers which do not provide their desired
triggering configuration.  The set_irq_type() function is 'new' and not
used by non-trigger aware drivers.

Therefore, revert this change, and restore previously working platforms
back to their former state.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/irq/chip.c~fix-long-term-regression-in-genirq-irq_set_irq_type-handling kernel/irq/chip.c
--- a/kernel/irq/chip.c~fix-long-term-regression-in-genirq-irq_set_irq_type-handling
+++ a/kernel/irq/chip.c
@@ -63,8 +63,7 @@ int irq_set_irq_type(unsigned int irq, u
 		return -EINVAL;
 
 	type &= IRQ_TYPE_SENSE_MASK;
-	if (type != IRQ_TYPE_NONE)
-		ret = __irq_set_trigger(desc, irq, type);
+	ret = __irq_set_trigger(desc, irq, type);
 	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from linux@arm.linux.org.uk are

linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
remove-remaining-bits-of-io_remap_page_range.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
proc-speedup-proc-stat-handling.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch

