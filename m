From: akpm@linux-foundation.org
Subject: - irq-warn-about-irqf_disabledirqf_shared.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:46:23 -0700
Message-ID: <200810012146.m91LkNKi005630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbYJAVqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     irq: warn about (IRQF_DISABLED|IRQF_SHARED)
has been removed from the -mm tree.  Its filename was
     irq-warn-about-irqf_disabledirqf_shared.patch

This patch was dropped because everyone's trees are all incredibly fucked up

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: warn about (IRQF_DISABLED|IRQF_SHARED)
From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems caused by the IRQ
framework not respecting IRQF_DISABLED for some shared IRQ cases.  Linus
views this as "will not fix", but we're still left with the bugs caused by
this misbehavior.

This patch adds a nag message in request_irq(), so that drivers can fix
their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they run with
LOCKDEP, so it's no wonder these bugs are hard to find.  (That also means
LOCKDEP is overlooking some IRQ-related bugs involving IRQ handlers that
don't set IRQF_DISABLED...)

This was the root cause of some USB oopsing a while back ...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/irq/manage.c~irq-warn-about-irqf_disabledirqf_shared kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-warn-about-irqf_disabledirqf_shared
+++ a/kernel/irq/manage.c
@@ -614,6 +614,18 @@ int request_irq(unsigned int irq, irq_ha
 	int retval;
 	struct irq_desc *desc;
 
+	/*
+	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
+	 * the _first_ irqaction (sigh).  That can cause oopsing, but
+	 * the behavior is classified as "will not fix" so we need to
+	 * start nudging drivers away from using that idiom.
+	 */
+	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED))
+			== (IRQF_SHARED|IRQF_DISABLED))
+		pr_warning("IRQ %d/%s: IRQF_DISABLED is not "
+				"guaranteed on shared IRQs\n",
+				irq, devname);
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * Lockdep wants atomic interrupt handlers:
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
git-arm.patch
git-avr32.patch
git-x86.patch
git-mtd.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
spi-simplify-spi_write_then_read.patch
spi_s3c24xx-pin-configuration-updates.patch
pxa2xx_spi-minor-cleanup.patch
pxa2xx_spi-fix-chip_info-defaults-and-documentation.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
rtc-cmos-export-second-nvram-bank.patch
make-gpiochip-label-const.patch
irq-warn-about-irqf_disabledirqf_shared.patch

