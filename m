From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch added
 to -mm tree
Date: Mon, 21 Apr 2014 14:25:44 -0700
Message-ID: <53558cd8.+s/CMlFMCQAUEh/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaDUVZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, a.zummo@towertech.it, macro@linux-mips.org

Subject: + rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch added to -mm tree
To: macro@linux-mips.org,a.zummo@towertech.it,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:25:44 -0700


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: drivers/char/rtc.c features for DECstation support
has been added to the -mm tree.  Its filename is
     rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: drivers/rtc/rtc-cmos.c: drivers/char/rtc.c features for DECstation support

This brings in drivers/char/rtc.c functionality required for DECstation
and, should the maintainers decide to switch, Alpha systems to use
rtc-cmos.

Specifically these features are made available:

* RTC iomem rather than x86/PCI port I/O mapping, controlled with the
  RTC_IOMAPPED macro as with the original driver.  The DS1287A chip in all
  DECstation systems is mapped in the host bus address space as a
  contiguous block of 64 32-bit words of which the least significant byte
  accesses the RTC chip for both reads and writes.  All the address and
  data window register accesses are made transparently by the chipset glue
  logic so that the device appears directly mapped on the host bus.

* A way to set the size of the address space explicitly with the
  newly-added `address_space' member of the platform part of the RTC
  device structure.  This avoids the unreliable heuristics that does not
  work in a setup where the RTC is not explicitly accessed with the usual
  address and data window register pair.

* The ability to use the RTC periodic interrupt as a system clock
  device, which is implemented by arch/mips/kernel/cevt-ds1287.c for
  DECstation systems and takes the RTC interrupt away from the RTC driver.
   Eventually hooking back to the clock device's interrupt handler should
  be possible for the purpose of the alarm clock and possibly also
  update-in-progress interrupt, but this is not done by this change.

  o To avoid interfering with the clock interrupt all the places where
    the RTC interrupt mask is fiddled with are only executed if and IRQ
    has been assigned to the RTC driver.

  o To avoid changing the clock setup Register A is not fiddled with
    if CMOS_RTC_FLAGS_NOFREQ is set in the newly-added `flags' member of
    the platform part of the RTC device structure.  Originally, in
    drivers/char/rtc.c, this was keyed with the absence of the RTC
    interrupt, just like the interrupt mask, but there only the periodic
    interrupt frequency is set, whereas rtc-cmos also sets the divider
    bits.  Therefore a new flag is introduced so that systems where the
    RTC interrupt is not usable rather than used as a system clock device
    can fully initialise the RTC.

* A small clean-up is made to the IRQ assignment code that makes the IRQ
  number hardcoded to -1 rather than arbitrary -ENXIO (or whatever error
  happens to be returned by platform_get_irq) where no IRQ has been
  assigned to the RTC driver (NO_IRQ might be another candidate, but it
  looks like this macro has inconsistent or missing definitions and
  limited use and might therefore be unsafe).

Verified to work correctly with a DECstation 5000/240 system.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c      |   85 ++++++++++++++++++++++++----------
 include/linux/mc146818rtc.h |    4 +
 2 files changed, 64 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support
+++ a/drivers/rtc/rtc-cmos.c
@@ -647,6 +647,7 @@ cmos_do_probe(struct device *dev, struct
 	int				retval = 0;
 	unsigned char			rtc_control;
 	unsigned			address_space;
+	u32				flags = 0;
 
 	/* there can be only one ... */
 	if (cmos_rtc.dev)
@@ -660,9 +661,12 @@ cmos_do_probe(struct device *dev, struct
 	 * REVISIT non-x86 systems may instead use memory space resources
 	 * (needing ioremap etc), not i/o space resources like this ...
 	 */
-	ports = request_region(ports->start,
-			resource_size(ports),
-			driver_name);
+	if (RTC_IOMAPPED)
+		ports = request_region
+			(ports->start, resource_size(ports), driver_name);
+	else
+		ports = request_mem_region
+			(ports->start, resource_size(ports), driver_name);
 	if (!ports) {
 		dev_dbg(dev, "i/o registers already in use\n");
 		return -EBUSY;
@@ -699,6 +703,11 @@ cmos_do_probe(struct device *dev, struct
 	 * expect CMOS_READ and friends to handle.
 	 */
 	if (info) {
+		if (info->flags)
+			flags = info->flags;
+		if (info->address_space)
+			address_space = info->address_space;
+
 		if (info->rtc_day_alarm && info->rtc_day_alarm < 128)
 			cmos_rtc.day_alrm = info->rtc_day_alarm;
 		if (info->rtc_mon_alarm && info->rtc_mon_alarm < 128)
@@ -726,18 +735,21 @@ cmos_do_probe(struct device *dev, struct
 
 	spin_lock_irq(&rtc_lock);
 
-	/* force periodic irq to CMOS reset default of 1024Hz;
-	 *
-	 * REVISIT it's been reported that at least one x86_64 ALI mobo
-	 * doesn't use 32KHz here ... for portability we might need to
-	 * do something about other clock frequencies.
-	 */
-	cmos_rtc.rtc->irq_freq = 1024;
-	hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq);
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
+	if (!(flags & CMOS_RTC_FLAGS_NOFREQ)) {
+		/* force periodic irq to CMOS reset default of 1024Hz;
+		 *
+		 * REVISIT it's been reported that at least one x86_64 ALI
+		 * mobo doesn't use 32KHz here ... for portability we might
+		 * need to do something about other clock frequencies.
+		 */
+		cmos_rtc.rtc->irq_freq = 1024;
+		hpet_set_periodic_freq(cmos_rtc.rtc->irq_freq);
+		CMOS_WRITE(RTC_REF_CLCK_32KHZ | 0x06, RTC_FREQ_SELECT);
+	}
 
 	/* disable irqs */
-	cmos_irq_disable(&cmos_rtc, RTC_PIE | RTC_AIE | RTC_UIE);
+	if (is_valid_irq(rtc_irq))
+		cmos_irq_disable(&cmos_rtc, RTC_PIE | RTC_AIE | RTC_UIE);
 
 	rtc_control = CMOS_READ(RTC_CONTROL);
 
@@ -802,14 +814,18 @@ cleanup1:
 	cmos_rtc.dev = NULL;
 	rtc_device_unregister(cmos_rtc.rtc);
 cleanup0:
-	release_region(ports->start, resource_size(ports));
+	if (RTC_IOMAPPED)
+		release_region(ports->start, resource_size(ports));
+	else
+		release_mem_region(ports->start, resource_size(ports));
 	return retval;
 }
 
-static void cmos_do_shutdown(void)
+static void cmos_do_shutdown(int rtc_irq)
 {
 	spin_lock_irq(&rtc_lock);
-	cmos_irq_disable(&cmos_rtc, RTC_IRQMASK);
+	if (is_valid_irq(rtc_irq))
+		cmos_irq_disable(&cmos_rtc, RTC_IRQMASK);
 	spin_unlock_irq(&rtc_lock);
 }
 
@@ -818,7 +834,7 @@ static void __exit cmos_do_remove(struct
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	struct resource *ports;
 
-	cmos_do_shutdown();
+	cmos_do_shutdown(cmos->irq);
 
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
 
@@ -831,7 +847,10 @@ static void __exit cmos_do_remove(struct
 	cmos->rtc = NULL;
 
 	ports = cmos->iomem;
-	release_region(ports->start, resource_size(ports));
+	if (RTC_IOMAPPED)
+		release_region(ports->start, resource_size(ports));
+	else
+		release_mem_region(ports->start, resource_size(ports));
 	cmos->iomem = NULL;
 
 	cmos->dev = NULL;
@@ -1065,10 +1084,13 @@ static void __exit cmos_pnp_remove(struc
 
 static void cmos_pnp_shutdown(struct pnp_dev *pnp)
 {
-	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pnp->dev))
+	struct device *dev = &pnp->dev;
+	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(dev))
 		return;
 
-	cmos_do_shutdown();
+	cmos_do_shutdown(cmos->irq);
 }
 
 static const struct pnp_device_id rtc_ids[] = {
@@ -1143,11 +1165,21 @@ static inline void cmos_of_init(struct p
 
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
+	struct resource *resource;
+	int irq;
+
 	cmos_of_init(pdev);
 	cmos_wake_setup(&pdev->dev);
-	return cmos_do_probe(&pdev->dev,
-			platform_get_resource(pdev, IORESOURCE_IO, 0),
-			platform_get_irq(pdev, 0));
+
+	if (RTC_IOMAPPED)
+		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	else
+		resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		irq = -1;
+
+	return cmos_do_probe(&pdev->dev, resource, irq);
 }
 
 static int __exit cmos_platform_remove(struct platform_device *pdev)
@@ -1158,10 +1190,13 @@ static int __exit cmos_platform_remove(s
 
 static void cmos_platform_shutdown(struct platform_device *pdev)
 {
-	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pdev->dev))
+	struct device *dev = &pdev->dev;
+	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(dev))
 		return;
 
-	cmos_do_shutdown();
+	cmos_do_shutdown(cmos->irq);
 }
 
 /* work with hotplug and coldplug */
diff -puN include/linux/mc146818rtc.h~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support include/linux/mc146818rtc.h
--- a/include/linux/mc146818rtc.h~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support
+++ a/include/linux/mc146818rtc.h
@@ -31,6 +31,10 @@ struct cmos_rtc_board_info {
 	void	(*wake_on)(struct device *dev);
 	void	(*wake_off)(struct device *dev);
 
+	u32	flags;
+#define CMOS_RTC_FLAGS_NOFREQ	(1 << 0)
+	int	address_space;
+
 	u8	rtc_day_alarm;		/* zero, or register index */
 	u8	rtc_mon_alarm;		/* zero, or register index */
 	u8	rtc_century;		/* zero, or register index */
_

Patches currently in -mm which might be from macro@linux-mips.org are

rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
dec-switch-decstation-systems-to-rtc-cmos.patch
linux-next.patch

