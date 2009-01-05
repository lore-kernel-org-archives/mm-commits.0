From: akpm@linux-foundation.org
Subject: - mfd-da903x-section-fix.patch removed from -mm tree
Date: Mon, 05 Jan 2009 01:26:47 -0800
Message-ID: <200901050926.n059Qlt2008874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbZAEJ1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 04:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, eric.miao@marvell.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd da903x: section fix
has been removed from the -mm tree.  Its filename was
     mfd-da903x-section-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd da903x: section fix
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes the following section warning:

  WARNING: vmlinux.o(.devinit.text+0x3d36): Section mismatch in reference from the function
  da903x_add_subdevs() to the function .devexit.text:da903x_remove_subdevs()
  The function __devinit da903x_add_subdevs() references
  a function __devexit da903x_remove_subdevs().
  This is often seen when error handling in the init function
  uses functionality in the exit path.
  The fix is often to remove the __devexit annotation of
  da903x_remove_subdevs() so it may be used outside an exit section.

It might be nice to have an "init and exit" section annotation for such
cases; in this case the waste is only about 40 bytes (x86 test build).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Eric Miao <eric.miao@marvell.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/da903x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/da903x.c~mfd-da903x-section-fix drivers/mfd/da903x.c
--- a/drivers/mfd/da903x.c~mfd-da903x-section-fix
+++ a/drivers/mfd/da903x.c
@@ -435,13 +435,13 @@ static const struct i2c_device_id da903x
 };
 MODULE_DEVICE_TABLE(i2c, da903x_id_table);
 
-static int __devexit __remove_subdev(struct device *dev, void *unused)
+static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 
-static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
+static int da903x_remove_subdevs(struct da903x_chip *chip)
 {
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
documentation-when-to-bug-and-when-to-not-bug.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch
drivers-spi-move-a-dereference-below-a-null-test.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch
gpio-pca953x-handles-more-chips-i2c-fault-codes.patch

