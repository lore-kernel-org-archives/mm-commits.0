From: akpm@linux-foundation.org
Subject: - at91_cf-minor-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:23 -0700
Message-ID: <200705080001.l4801NAw008766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967302AbXEHABm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     at91_cf, minor fix
has been removed from the -mm tree.  Its filename was
     at91_cf-minor-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900-update.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
spi-kerneldoc.patch
spi-kerneldoc-fix.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
