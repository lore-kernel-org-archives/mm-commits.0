From: akpm@osdl.org
Subject: + scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch added to -mm tree
Date: Tue, 23 Jan 2007 12:04:16 -0800
Message-ID: <200701232004.l0NK4GSI029877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52566 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965481AbXAWUEx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 15:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 2
has been added to the -mm tree.  Its filename is
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags fixups 2
From: Thomas Gleixner <tglx@linutronix.de>

The obsolete SA_xxx interrupt flags have been used despite the scheduled
removal.  Fixup the remaining users in -mm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmitime.c         |   10 ++++------
 drivers/char/nozomi.c              |    2 +-
 drivers/firewire/fw-ohci.c         |    2 +-
 drivers/input/keyboard/gpio_keys.c |    2 +-
 drivers/mtd/nand/cafe.c            |    3 ++-
 drivers/net/cxgb3/cxgb3_main.c     |    3 ++-
 drivers/net/sc92031.c              |    2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/vmitime.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/arch/i386/kernel/vmitime.c
@@ -121,12 +121,10 @@ static struct clocksource clocksource_vm
 static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id);
 
 struct irqaction vmi_timer_irq  = {
-	vmi_timer_interrupt,
-	SA_INTERRUPT,
-	CPU_MASK_NONE,
-	"VMI-alarm",
-	NULL,
-	NULL
+	.handler = vmi_timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "VMI-alarm",
 };
 
 /* Alarm rate */
diff -puN drivers/char/nozomi.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/char/nozomi.c
@@ -1378,7 +1378,7 @@ static int nozomi_setup_interrupt(struct
 {
 	int rval;
 
-	rval = request_irq(dc->pdev->irq, &interrupt_handler, SA_SHIRQ,
+	rval = request_irq(dc->pdev->irq, &interrupt_handler, IRQF_SHARED,
 			   NOZOMI_NAME, dc);
 	if (rval)
 		dev_err(&dc->pdev->dev, "Cannot open because IRQ %d "
diff -puN drivers/firewire/fw-ohci.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2 drivers/firewire/fw-ohci.c
--- a/drivers/firewire/fw-ohci.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2
+++ a/drivers/firewire/fw-ohci.c
@@ -714,7 +714,7 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
 	if (request_irq(dev->irq, irq_handler,
-			SA_SHIRQ, ohci_driver_name, ohci)) {
+			IRQF_SHARED, ohci_driver_name, ohci)) {
 		fw_error("Failed to allocate shared interrupt %d.\n",
 			 dev->irq);
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
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
@@ -596,7 +596,8 @@ static int __devinit cafe_nand_probe(str
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
@@ -709,7 +709,8 @@ static int cxgb_up(struct adapter *adap)
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
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
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
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
