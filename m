From: akpm@linux-foundation.org
Subject: - rtc-cmos-lockdep-fix-irq-updates.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:56 -0700
Message-ID: <200704022303.l32N3uOf011943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966074AbXDBXEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos lockdep fix, irq updates
has been removed from the -mm tree.  Its filename was
     rtc-cmos-lockdep-fix-irq-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-cmos lockdep fix, irq updates
From: David Brownell <david-b@pacbell.net>

Lockdep reported cmos_suspend() and cmos_resume() calling rtc_update_irq()
with IRQs enabled; not allowed.

Also fix problems seen on some hardware, whereby false alarm IRQs could be
reported (primarily to userspace); and update two comments to match changes
in ACPI.  Those make up most of this patch, by volume.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   50 +++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-lockdep-fix-irq-updates drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-lockdep-fix-irq-updates
+++ a/drivers/rtc/rtc-cmos.c
@@ -59,6 +59,19 @@ struct cmos_rtc {
 
 static const char driver_name[] = "rtc_cmos";
 
+/* The RTC_INTR register may have e.g. RTC_PF set even if RTC_PIE is clear;
+ * always mask it against the irq enable bits in RTC_CONTROL.  Bit values
+ * are the same: PF==PIE, AF=AIE, UF=UIE; so RTC_IRQMASK works with both.
+ */
+#define	RTC_IRQMASK	(RTC_PF | RTC_AF | RTC_UF)
+
+static inline int is_intr(u8 rtc_intr)
+{
+	if (!(rtc_intr & RTC_IRQF))
+		return 0;
+	return rtc_intr & RTC_IRQMASK;
+}
+
 /*----------------------------------------------------------------*/
 
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
@@ -188,7 +201,8 @@ static int cmos_set_alarm(struct device 
 	rtc_control &= ~RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-	if (rtc_intr)
+	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	if (is_intr(rtc_intr))
 		rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
 
 	/* update alarm */
@@ -207,7 +221,8 @@ static int cmos_set_alarm(struct device 
 		rtc_control |= RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-		if (rtc_intr)
+		rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+		if (is_intr(rtc_intr))
 			rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
 	}
 
@@ -287,7 +302,8 @@ cmos_rtc_ioctl(struct device *dev, unsig
 	}
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
 	rtc_intr = CMOS_READ(RTC_INTR_FLAGS);
-	if (rtc_intr)
+	rtc_intr &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	if (is_intr(rtc_intr))
 		rtc_update_irq(&cmos->rtc->class_dev, 1, rtc_intr);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
@@ -353,12 +369,10 @@ static irqreturn_t cmos_interrupt(int ir
 
 	spin_lock(&rtc_lock);
 	irqstat = CMOS_READ(RTC_INTR_FLAGS);
+	irqstat &= (CMOS_READ(RTC_CONTROL) & RTC_IRQMASK) | RTC_IRQF;
 	spin_unlock(&rtc_lock);
 
-	if (irqstat) {
-		/* NOTE: irqstat may have e.g. RTC_PF set
-		 * even when RTC_PIE is clear...
-		 */
+	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
 		return IRQ_HANDLED;
 	} else
@@ -525,25 +539,26 @@ static int cmos_suspend(struct device *d
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	int		do_wake = device_may_wakeup(dev);
-	unsigned char	tmp, irqstat;
+	unsigned char	tmp;
 
 	/* only the alarm might be a wakeup event source */
 	spin_lock_irq(&rtc_lock);
 	cmos->suspend_ctrl = tmp = CMOS_READ(RTC_CONTROL);
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
+		unsigned char	irqstat;
+
 		if (do_wake)
 			tmp &= ~(RTC_PIE|RTC_UIE);
 		else
 			tmp &= ~(RTC_PIE|RTC_AIE|RTC_UIE);
 		CMOS_WRITE(tmp, RTC_CONTROL);
 		irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	} else
-		irqstat = 0;
+		irqstat &= (tmp & RTC_IRQMASK) | RTC_IRQF;
+		if (is_intr(irqstat))
+			rtc_update_irq(&cmos->rtc->class_dev, 1, irqstat);
+	}
 	spin_unlock_irq(&rtc_lock);
 
-	if (irqstat)
-		rtc_update_irq(&cmos->rtc->class_dev, 1, irqstat);
-
 	/* ACPI HOOK:  enable ACPI_EVENT_RTC when (tmp & RTC_AIE)
 	 * ... it'd be best if we could do that under rtc_lock.
 	 */
@@ -573,9 +588,10 @@ static int cmos_resume(struct device *de
 		spin_lock_irq(&rtc_lock);
 		CMOS_WRITE(tmp, RTC_CONTROL);
 		tmp = CMOS_READ(RTC_INTR_FLAGS);
-		spin_unlock_irq(&rtc_lock);
-		if (tmp)
+		tmp &= (cmos->suspend_ctrl & RTC_IRQMASK) | RTC_IRQF;
+		if (is_intr(tmp))
 			rtc_update_irq(&cmos->rtc->class_dev, 1, tmp);
+		spin_unlock_irq(&rtc_lock);
 	}
 
 	pr_debug("%s: resume, ctrl %02x\n",
@@ -594,7 +610,7 @@ static int cmos_resume(struct device *de
 /*----------------------------------------------------------------*/
 
 /* The "CMOS" RTC normally lives on the platform_bus.  On ACPI systems,
- * the device node may alternatively be created as a PNP device.
+ * the device node will always be created as a PNPACPI device.
  */
 
 #ifdef	CONFIG_PNPACPI
@@ -673,7 +689,7 @@ module_exit(cmos_exit);
 /*----------------------------------------------------------------*/
 
 /* Platform setup should have set up an RTC device, when PNPACPI is
- * unavailable ... this is the normal case, common even on PCs.
+ * unavailable ... this could happen even on (older) PCs.
  */
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
scsi-newstyle-hotplug-coldplug-support.patch
fix-hotplug-for-legacy-platform-drivers.patch
update-documentation-driver-model-platformtxt.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
