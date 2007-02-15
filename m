From: akpm@linux-foundation.org
Subject: - scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:07 -0800
Message-ID: <200702150848.l1F8m70t025025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39979 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965383AbXBOIsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:48:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 2
has been removed from the -mm tree.  Its filename was
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags fixups 2
From: Thomas Gleixner <tglx@linutronix.de>

The obsolete SA_xxx interrupt flags have been used despite the scheduled
removal.  Fixup the remaining users in -mm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/gpio_keys.c |    2 +-
 drivers/mtd/nand/cafe.c            |    3 ++-
 drivers/net/cxgb3/cxgb3_main.c     |    3 ++-
 drivers/net/sc92031.c              |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/input/keyboard/gpio_keys.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/input/keyboard/gpio_keys.c
--- a/drivers/input/keyboard/gpio_keys.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/input/keyboard/gpio_keys.c
@@ -78,7 +78,7 @@ static int __devinit gpio_keys_probe(str
 		int irq = IRQ_GPIO(pdata->buttons[i].gpio);
 
 		set_irq_type(irq, IRQ_TYPE_EDGE_BOTH);
-		error = request_irq(irq, gpio_keys_isr, SA_SAMPLE_RANDOM,
+		error = request_irq(irq, gpio_keys_isr, IRQF_SAMPLE_RANDOM,
 				     pdata->buttons[i].desc ? pdata->buttons[i].desc : "gpio_keys",
 				     pdev);
 		if (error) {
diff -puN drivers/mtd/nand/cafe.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/mtd/nand/cafe.c
--- a/drivers/mtd/nand/cafe.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/mtd/nand/cafe.c
@@ -597,7 +597,8 @@ static int __devinit cafe_nand_probe(str
 		cafe_writel(cafe, 0xffffffff, NAND_TIMING3);
 	}
 	cafe_writel(cafe, 0xffffffff, NAND_IRQ_MASK);
-	err = request_irq(pdev->irq, &cafe_nand_interrupt, SA_SHIRQ, "CAFE NAND", mtd);
+	err = request_irq(pdev->irq, &cafe_nand_interrupt, IRQF_SHARED,
+			  "CAFE NAND", mtd);
 	if (err) {
 		dev_warn(&pdev->dev, "Could not register IRQ %d\n", pdev->irq);
 
diff -puN drivers/net/cxgb3/cxgb3_main.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -757,7 +757,8 @@ static int cxgb_up(struct adapter *adap)
 				      t3_intr_handler(adap,
 						      adap->sge.qs[0].rspq.
 						      polling),
-				      (adap->flags & USING_MSI) ? 0 : SA_SHIRQ,
+				      (adap->flags & USING_MSI) ?
+				       0 : IRQF_SHARED,
 				      adap->name, adap)))
 		goto irq_err;
 
diff -puN drivers/net/sc92031.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/net/sc92031.c
--- a/drivers/net/sc92031.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/net/sc92031.c
@@ -1035,7 +1035,7 @@ static int sc92031_open(struct net_devic
 	priv->tx_head = priv->tx_tail = 0;
 
 	err = request_irq(pdev->irq, sc92031_interrupt,
-			SA_SHIRQ, dev->name, dev);
+			IRQF_SHARED, dev->name, dev);
 	if (unlikely(err < 0))
 		goto out_request_irq;
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
small-irq-management-simplification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
