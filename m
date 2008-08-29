From: akpm@linux-foundation.org
Subject: + rtc-cmos-wake-again-from-s5.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:19:35 -0700
Message-ID: <200808290019.m7T0Ja3F021941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbYH2ATs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, dbrownell@users.sourceforge.net, rui.zhang@intel.com, yakui.zhao@intel.com


The patch titled
     rtc-cmos: wake again from S5
has been added to the -mm tree.  Its filename is
     rtc-cmos-wake-again-from-s5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos: wake again from S5
From: Rafael J. Wysocki <rjw@sisk.pl>

Update rtc-cmos shutdown handling to leave RTC alarms active, resolving
http://bugzilla.kernel.org/show_bug.cgi?id=11411 on several boards.  There
are still some systems where the ACPI event handling doesn't cooperate. 
(Possibly related to bugid 11312, reporting the spontaneous disabling of
RTC events.)

Bug 11411 reported that changes to work around some ACPI event issues
broke wake-from-S5 handling, as used for DVR applications.  (They like to
power off, then wake later to record programs.)

[yakui.zhao@intel.com: add shutdown for PNP devices]
[dbrownell@users.sourceforge.net: update comments]
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-wake-again-from-s5 drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-wake-again-from-s5
+++ a/drivers/rtc/rtc-cmos.c
@@ -800,7 +800,6 @@ static void __exit cmos_do_remove(struct
 static int cmos_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	int		do_wake = device_may_wakeup(dev);
 	unsigned char	tmp;
 
 	/* only the alarm might be a wakeup event source */
@@ -809,7 +808,7 @@ static int cmos_suspend(struct device *d
 	if (tmp & (RTC_PIE|RTC_AIE|RTC_UIE)) {
 		unsigned char	mask;
 
-		if (do_wake)
+		if (device_may_wakeup(dev))
 			mask = RTC_IRQMASK & ~RTC_AIE;
 		else
 			mask = RTC_IRQMASK;
@@ -837,6 +836,17 @@ static int cmos_suspend(struct device *d
 	return 0;
 }
 
+/* We want RTC alarms to wake us from e.g. ACPI G2/S5 "soft off", even
+ * after a detour through G3 "mechanical off", although the ACPI spec
+ * says wakeup should only work from G1/S4 "hibernate".  To most users,
+ * distinctions between S4 and S5 are pointless.  So when the hardware
+ * allows, don't draw that distinction.
+ */
+static inline int cmos_poweroff(struct device *dev)
+{
+	return cmos_suspend(dev, PMSG_HIBERNATE);
+}
+
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -884,6 +894,12 @@ static int cmos_resume(struct device *de
 #else
 #define	cmos_suspend	NULL
 #define	cmos_resume	NULL
+
+static inline int cmos_poweroff(struct device *dev)
+{
+	return -ENOSYS;
+}
+
 #endif
 
 /*----------------------------------------------------------------*/
@@ -903,10 +919,6 @@ static int cmos_resume(struct device *de
 static int __devinit
 cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	/* REVISIT paranoia argues for a shutdown notifier, since PNP
-	 * drivers can't provide shutdown() methods to disable IRQs.
-	 * Or better yet, fix PNP to allow those methods...
-	 */
 	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
 		/* Some machines contain a PNP entry for the RTC, but
 		 * don't define the IRQ. It should always be safe to
@@ -942,6 +954,13 @@ static int cmos_pnp_resume(struct pnp_de
 #define	cmos_pnp_resume		NULL
 #endif
 
+static void cmos_pnp_shutdown(struct device *pdev)
+{
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
+		return;
+
+	cmos_do_shutdown();
+}
 
 static const struct pnp_device_id rtc_ids[] = {
 	{ .id = "PNP0b00", },
@@ -961,6 +980,10 @@ static struct pnp_driver cmos_pnp_driver
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.suspend	= cmos_pnp_suspend,
 	.resume		= cmos_pnp_resume,
+	.driver		= {
+		.name	  = (char *)driver_name,
+		.shutdown = cmos_pnp_shutdown,
+	}
 };
 
 #endif	/* CONFIG_PNP */
@@ -986,6 +1009,9 @@ static int __exit cmos_platform_remove(s
 
 static void cmos_platform_shutdown(struct platform_device *pdev)
 {
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pdev->dev))
+		return;
+
 	cmos_do_shutdown();
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
skty2-adapt-to-the-reworked-pci-pm.patch
e100-adapt-to-the-reworked-pci-pm.patch
pci-pm-introduce-function-pci_wake_from_d3-rev-2.patch
debugobjects-fix-lockdep-warning.patch
rtc-cmos-wake-again-from-s5.patch
forcedeth-fix-kexec-regression.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem-fix-freezer-kconfig.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

