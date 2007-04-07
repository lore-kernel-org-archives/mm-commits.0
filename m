From: akpm@linux-foundation.org
Subject: + omap_cf-oops-on-suspend-fix.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:30:16 -0700
Message-ID: <200704070630.l376UG1N029117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46053 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXDGGaZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:30:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@dominikbrodowski.net


The patch titled
     omap_cf: oops-on-suspend fix
has been added to the -mm tree.  Its filename is
     omap_cf-oops-on-suspend-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: omap_cf: oops-on-suspend fix
From: David Brownell <david-b@pacbell.net>

Convert omap_cf into a platform_driver ...  this resolves oopsing during
suspend/resume.

Evidently folk haven't tried suspend/resume on an OSK (the main platform
for this driver) since September or so, which is when platform_device
learned about suspend_late()/resume_early() and stopped being able to
suspend/resume without a platform_driver.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/omap_cf.c |   41 ++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff -puN drivers/pcmcia/omap_cf.c~omap_cf-oops-on-suspend-fix drivers/pcmcia/omap_cf.c
--- a/drivers/pcmcia/omap_cf.c~omap_cf-oops-on-suspend-fix
+++ a/drivers/pcmcia/omap_cf.c
@@ -202,15 +202,14 @@ static struct pccard_operations omap_cf_
  * "what chipselect is used".  Boards could want more.
  */
 
-static int __devinit omap_cf_probe(struct device *dev)
+static int __init omap_cf_probe(struct platform_device *pdev)
 {
 	unsigned		seg;
 	struct omap_cf_socket	*cf;
-	struct platform_device	*pdev = to_platform_device(dev);
 	int			irq;
 	int			status;
 
-	seg = (int) dev->platform_data;
+	seg = (int) pdev->dev.platform_data;
 	if (seg == 0 || seg > 3)
 		return -ENODEV;
 
@@ -227,7 +226,7 @@ static int __devinit omap_cf_probe(struc
 	cf->timer.data = (unsigned long) cf;
 
 	cf->pdev = pdev;
-	dev_set_drvdata(dev, cf);
+	platform_set_drvdata(pdev, cf);
 
 	/* this primarily just shuts up irq handling noise */
 	status = request_irq(irq, omap_cf_irq, IRQF_SHARED,
@@ -291,7 +290,7 @@ static int __devinit omap_cf_probe(struc
 		omap_cf_present() ? "present" : "(not present)");
 
 	cf->socket.owner = THIS_MODULE;
-	cf->socket.dev.parent = dev;
+	cf->socket.dev.parent = &pdev->dev;
 	cf->socket.ops = &omap_cf_ops;
 	cf->socket.resource_ops = &pccard_static_ops;
 	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP
@@ -318,9 +317,9 @@ fail0:
 	return status;
 }
 
-static int __devexit omap_cf_remove(struct device *dev)
+static int __exit omap_cf_remove(struct platform_device *pdev)
 {
-	struct omap_cf_socket *cf = dev_get_drvdata(dev);
+	struct omap_cf_socket *cf = platform_get_drvdata(pdev);
 
 	cf->active = 0;
 	pcmcia_unregister_socket(&cf->socket);
@@ -332,26 +331,36 @@ static int __devexit omap_cf_remove(stru
 	return 0;
 }
 
-static struct device_driver omap_cf_driver = {
-	.name		= (char *) driver_name,
-	.bus		= &platform_bus_type,
-	.probe		= omap_cf_probe,
-	.remove		= __devexit_p(omap_cf_remove),
-	.suspend	= pcmcia_socket_dev_suspend,
-	.resume		= pcmcia_socket_dev_resume,
+static int omap_cf_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+}
+
+static int omap_cf_resume(struct platform_device *pdev)
+{
+	return pcmcia_socket_dev_resume(&pdev->dev);
+}
+
+static struct platform_driver omap_cf_driver = {
+	.driver = {
+		.name	= (char *) driver_name,
+	},
+	.remove		= __exit_p(omap_cf_remove),
+	.suspend	= omap_cf_suspend,
+	.resume		= omap_cf_resume,
 };
 
 static int __init omap_cf_init(void)
 {
 	if (cpu_is_omap16xx())
-		return driver_register(&omap_cf_driver);
+		return platform_driver_probe(&omap_cf_driver, omap_cf_probe);
 	return -ENODEV;
 }
 
 static void __exit omap_cf_exit(void)
 {
 	if (cpu_is_omap16xx())
-		driver_unregister(&omap_cf_driver);
+		platform_driver_unregister(&omap_cf_driver);
 }
 
 module_init(omap_cf_init);
_

Patches currently in -mm which might be from david-b@pacbell.net are

omap_cf-oops-on-suspend-fix.patch
make-proc-acpi-wakeup-more-useful.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
fix-hotplug-for-legacy-platform-drivers.patch
fix-hotplug-for-legacy-platform-drivers-update.patch
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
pnpacpi-sets-pnpdev-devarchdata.patch
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
