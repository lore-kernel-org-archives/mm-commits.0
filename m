From: akpm@linux-foundation.org
Subject: + at91_cf-minor-fix.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:27:32 -0700
Message-ID: <200704070627.l376RWn6029043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXDGG1m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@dominikbrodowski.net


The patch titled
     at91_cf, minor fix
has been added to the -mm tree.  Its filename is
     at91_cf-minor-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: at91_cf, minor fix
From: David Brownell <david-b@pacbell.net>

This is a minor correctness fix: since the at91_cf driver probe() routine
is in the init section, it should use platform_driver_probe() instead of
leaving that pointer around in the driver struct after init section
removal.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/at91_cf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/pcmcia/at91_cf.c~at91_cf-minor-fix drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~at91_cf-minor-fix
+++ a/drivers/pcmcia/at91_cf.c
@@ -360,7 +360,6 @@ static struct platform_driver at91_cf_dr
 		.name		= (char *) driver_name,
 		.owner		= THIS_MODULE,
 	},
-	.probe		= at91_cf_probe,
 	.remove		= __exit_p(at91_cf_remove),
 	.suspend	= at91_cf_suspend,
 	.resume		= at91_cf_resume,
@@ -370,7 +369,7 @@ static struct platform_driver at91_cf_dr
 
 static int __init at91_cf_init(void)
 {
-	return platform_driver_register(&at91_cf_driver);
+	return platform_driver_probe(&at91_cf_driver, at91_cf_probe);
 }
 module_init(at91_cf_init);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

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
