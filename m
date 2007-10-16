From: akpm@linux-foundation.org
Subject: - rtc-cmos-probe-cleanup.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:32 -0700
Message-ID: <200710162041.l9GKfWkv015800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965667AbXJPVcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos probe() cleanup
has been removed from the -mm tree.  Its filename was
     rtc-cmos-probe-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-cmos probe() cleanup
From: David Brownell <david-b@pacbell.net>

Some cleanups for the rtc-cmos probe logic:

 - Claim i/o ports with request_region() not request_resource(),
   for better coexistence betwen platform and pnp bus glues.

 - Claim those ports earlier, to help work around procfs bugs
   (it allows duplicate names, like /proc/driver/rtc).

 - Fix some glitches in cleanup code, notably a cut'n'paste-o
   where the i/o port region might not get released during
   cleanup after a probe fault.

And some comment clarifications, including noting that this code
must work with PNPBIOS not just PNPACPI..

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   56 +++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-probe-cleanup drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-probe-cleanup
+++ a/drivers/rtc/rtc-cmos.c
@@ -433,6 +433,19 @@ cmos_do_probe(struct device *dev, struct
 	if (!ports)
 		return -ENODEV;
 
+	/* Claim I/O ports ASAP, minimizing conflict with legacy driver.
+	 *
+	 * REVISIT non-x86 systems may instead use memory space resources
+	 * (needing ioremap etc), not i/o space resources like this ...
+	 */
+	ports = request_region(ports->start,
+			ports->end + 1 - ports->start,
+			driver_name);
+	if (!ports) {
+		dev_dbg(dev, "i/o registers already in use\n");
+		return -EBUSY;
+	}
+
 	cmos_rtc.irq = rtc_irq;
 	cmos_rtc.iomem = ports;
 
@@ -454,24 +467,13 @@ cmos_do_probe(struct device *dev, struct
 
 	cmos_rtc.rtc = rtc_device_register(driver_name, dev,
 				&cmos_rtc_ops, THIS_MODULE);
-	if (IS_ERR(cmos_rtc.rtc))
-		return PTR_ERR(cmos_rtc.rtc);
+	if (IS_ERR(cmos_rtc.rtc)) {
+		retval = PTR_ERR(cmos_rtc.rtc);
+		goto cleanup0;
+	}
 
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
-
-	/* platform and pnp busses handle resources incompatibly.
-	 *
-	 * REVISIT for non-x86 systems we may need to handle io memory
-	 * resources: ioremap them, and request_mem_region().
-	 */
-	if (is_pnp()) {
-		retval = request_resource(&ioport_resource, ports);
-		if (retval < 0) {
-			dev_dbg(dev, "i/o registers already in use\n");
-			goto cleanup0;
-		}
-	}
 	rename_region(ports, cmos_rtc.rtc->dev.bus_id);
 
 	spin_lock_irq(&rtc_lock);
@@ -534,9 +536,10 @@ cmos_do_probe(struct device *dev, struct
 	return 0;
 
 cleanup1:
-	rename_region(ports, NULL);
-cleanup0:
+	cmos_rtc.dev = NULL;
 	rtc_device_unregister(cmos_rtc.rtc);
+cleanup0:
+	release_region(ports->start, ports->end + 1 - ports->start);
 	return retval;
 }
 
@@ -555,19 +558,21 @@ static void cmos_do_shutdown(void)
 static void __exit cmos_do_remove(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
+	struct resource *ports;
 
 	cmos_do_shutdown();
 
-	if (is_pnp())
-		release_resource(cmos->iomem);
-	rename_region(cmos->iomem, NULL);
-
 	if (is_valid_irq(cmos->irq))
-		free_irq(cmos->irq, cmos_rtc.rtc);
+		free_irq(cmos->irq, cmos->rtc);
 
-	rtc_device_unregister(cmos_rtc.rtc);
+	rtc_device_unregister(cmos->rtc);
+	cmos->rtc = NULL;
 
-	cmos_rtc.dev = NULL;
+	ports = cmos->iomem;
+	release_region(ports->start, ports->end + 1 - ports->start);
+	cmos->iomem = NULL;
+
+	cmos->dev = NULL;
 	dev_set_drvdata(dev, NULL);
 }
 
@@ -654,7 +659,8 @@ static int cmos_resume(struct device *de
 /*----------------------------------------------------------------*/
 
 /* The "CMOS" RTC normally lives on the platform_bus.  On ACPI systems,
- * the device node will always be created as a PNPACPI device.
+ * the device node will always be created as a PNPACPI device.  Plus
+ * pre-ACPI PCs probably list it in the PNPBIOS tables.
  */
 
 #ifdef	CONFIG_PNP
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
