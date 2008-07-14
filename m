From: akpm@linux-foundation.org
Subject: - atmel_nand-speedup-via-readwritesbw.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:39 -0700
Message-ID: <200807141935.m6EJZdHG023939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbYGNTgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org, haavard.skinnemoen@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     atmel_nand speedup via {read,write}s{b,w}()
has been removed from the -mm tree.  Its filename was
     atmel_nand-speedup-via-readwritesbw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_nand speedup via {read,write}s{b,w}()
From: David Brownell <david-b@pacbell.net>

This uses __raw_{read,write}s{b,w}() primitives to access data on NAND
chips for more efficient I/O.

On an arm926 with memory clocked at 100 MHz, this reduced the elapsed time
for a 64 MByte read by 16%.  ("dd" /dev/mtd0 to /dev/null, with an 8-bit
NAND using hardware ECC and 128KB blocksize.)

Also some minor section tweaks:

  - Use platform_driver_probe() so no pointer to probe() lingers
    after that code has been removed at run-time.

  - Use __exit and __exit_p so the remove() code will normally be
    removed by the linker.

Since these buffer read/write calls are new, this increases the runtime
code footprint (by 88 bytes on my build, after the section tweaks).

[haavard.skinnemoen@atmel.com: rebase onto atmel_nand rename]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/atmel_nand.c |   46 ++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/nand/atmel_nand.c~atmel_nand-speedup-via-readwritesbw drivers/mtd/nand/atmel_nand.c
--- a/drivers/mtd/nand/atmel_nand.c~atmel_nand-speedup-via-readwritesbw
+++ a/drivers/mtd/nand/atmel_nand.c
@@ -142,6 +142,37 @@ static int atmel_nand_device_ready(struc
 }
 
 /*
+ * Minimal-overhead PIO for data access.
+ */
+static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsb(nand_chip->IO_ADDR_R, buf, len);
+}
+
+static void atmel_read_buf16(struct mtd_info *mtd, u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_readsw(nand_chip->IO_ADDR_R, buf, len / 2);
+}
+
+static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesb(nand_chip->IO_ADDR_W, buf, len);
+}
+
+static void atmel_write_buf16(struct mtd_info *mtd, const u8 *buf, int len)
+{
+	struct nand_chip	*nand_chip = mtd->priv;
+
+	__raw_writesw(nand_chip->IO_ADDR_W, buf, len / 2);
+}
+
+/*
  * write oob for small pages
  */
 static int atmel_nand_write_oob_512(struct mtd_info *mtd,
@@ -436,8 +467,14 @@ static int __init atmel_nand_probe(struc
 
 	nand_chip->chip_delay = 20;		/* 20us command delay time */
 
-	if (host->board->bus_width_16)		/* 16-bit bus width */
+	if (host->board->bus_width_16) {	/* 16-bit bus width */
 		nand_chip->options |= NAND_BUSWIDTH_16;
+		nand_chip->read_buf = atmel_read_buf16;
+		nand_chip->write_buf = atmel_write_buf16;
+	} else {
+		nand_chip->read_buf = atmel_read_buf;
+		nand_chip->write_buf = atmel_write_buf;
+	}
 
 	platform_set_drvdata(pdev, host);
 	atmel_nand_enable(host);
@@ -546,7 +583,7 @@ err_nand_ioremap:
 /*
  * Remove a NAND device.
  */
-static int __devexit atmel_nand_remove(struct platform_device *pdev)
+static int __exit atmel_nand_remove(struct platform_device *pdev)
 {
 	struct atmel_nand_host *host = platform_get_drvdata(pdev);
 	struct mtd_info *mtd = &host->mtd;
@@ -564,8 +601,7 @@ static int __devexit atmel_nand_remove(s
 }
 
 static struct platform_driver atmel_nand_driver = {
-	.probe		= atmel_nand_probe,
-	.remove		= atmel_nand_remove,
+	.remove		= __exit_p(atmel_nand_remove),
 	.driver		= {
 		.name	= "atmel_nand",
 		.owner	= THIS_MODULE,
@@ -574,7 +610,7 @@ static struct platform_driver atmel_nand
 
 static int __init atmel_nand_init(void)
 {
-	return platform_driver_register(&atmel_nand_driver);
+	return platform_driver_probe(&atmel_nand_driver, atmel_nand_probe);
 }
 
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
pm-boot-time-suspend-selftest-update.patch
atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
rtc-marvell-soc-rtc-driver.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

