From: akpm@linux-foundation.org
Subject: + mfd-da903x-section-fix.patch added to -mm tree
Date: Tue, 18 Nov 2008 21:18:12 -0800
Message-ID: <200811190518.mAJ5ICwq010562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYKSFS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 00:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, eric.miao@marvell.com, sameo@openedhand.com


The patch titled
     mfd da903x: section fix
has been added to the -mm tree.  Its filename is
     mfd-da903x-section-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

pxa2xx_spi-bugfix-full-duplex-dma-data-corruption.patch
spi_imx-full-duplex-dma-corruption-bugfix.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch
mtd-m25p80-chip-erase-=-block-erase-=-sector-erase.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
mfd-da903x-section-fix.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
twl4030-gpio-cleanup-debounce.patch

