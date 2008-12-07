From: akpm@linux-foundation.org
Subject: - genirq-warn-when-irqf_disabled-may-be-ignored.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:31 -0800
Message-ID: <200812070005.mB705VJ1021406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbYLGAFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: warn when IRQF_DISABLED may be ignored
has been removed from the -mm tree.  Its filename was
     genirq-warn-when-irqf_disabled-may-be-ignored.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: warn when IRQF_DISABLED may be ignored
From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems from the genirq
framework not respecting IRQF_DISABLED for some shared IRQ cases.  Linus
views this as "will not fix", but we're still left with the bugs caused by
this misbehavior.

This patch adds a nag message in request_irq(), so that drivers can fix
their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they run with
LOCKDEP, so it's no wonder these bugs are hard to find.  (That also means
LOCKDEP is overlooking some IRQ-related bugs involving IRQ handlers that
don't set IRQF_DISABLED...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/irq/manage.c~genirq-warn-when-irqf_disabled-may-be-ignored kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-warn-when-irqf_disabled-may-be-ignored
+++ a/kernel/irq/manage.c
@@ -671,6 +671,18 @@ int request_irq(unsigned int irq, irq_ha
 	struct irq_desc *desc;
 	int retval;
 
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

linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
genirq-record-irq_level-in-irq_desc.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch

