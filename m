From: akpm@linux-foundation.org
Subject: + fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:36:20 -0800
Message-ID: <20120117223620.CA91210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:39965 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2AQWgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:36:22 -0500
Received: by qcsg1 with SMTP id g1so55176qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:36:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@arm.linux.org.uk, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, tglx@linutronix.de


The patch titled
     Subjectirqs: fix long-term regression in genirq irq_set_irq_type() handling
has been added to the -mm tree.  Its filename is
     fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Russell King <linux@arm.linux.org.uk>
Subjectirqs: fix long-term regression in genirq irq_set_irq_type() handling

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
@@ -61,8 +61,7 @@ int irq_set_irq_type(unsigned int irq, u
 		return -EINVAL;
 
 	type &= IRQ_TYPE_SENSE_MASK;
-	if (type != IRQ_TYPE_NONE)
-		ret = __irq_set_trigger(desc, irq, type);
+	ret = __irq_set_trigger(desc, irq, type);
 	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
_
Subject: Subjectirqs: fix long-term regression in genirq irq_set_irq_type() handling

Patches currently in -mm which might be from linux@arm.linux.org.uk are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
fix-long-term-regression-in-genirq-irq_set_irq_type-handling.patch

