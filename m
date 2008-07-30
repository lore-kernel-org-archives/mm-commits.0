From: akpm@linux-foundation.org
Subject: + mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch added to -mm tree
Date: Tue, 29 Jul 2008 22:22:40 -0700
Message-ID: <200807300522.m6U5MepT008947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbYG3FXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 01:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, cooloney@kernel.org, dwmw2@infradead.org, michael.hennerich@analog.com


The patch titled
     MTD DataFlash: bugfix, binary page sizes now handled
has been added to the -mm tree.  Its filename is
     mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch

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
Subject: MTD DataFlash: bugfix, binary page sizes now handled
From: David Brownell <dbrownell@users.sourceforge.net>

The wrong version of the "teach dataflash about binary density" patch
just got merged (v2 not v3) ... this restores the missing updates:

  * Fix the cmdlinepart *regression* that caused testing failures (!!)
    by restoring the original part labels in relevant cases.

  * Don't reference things that don't exist (!)
	- An opcode that doesn't even exist for DataFlash
	- The part is "at45db642" not "at45db641"
	- ID zero in this JEDEC table

  * Make the JEDEC probe routine report and handle errors better:
	- If the SPI calls fail, return the error codes.
	- Don't depend on ordering of table entries.
	- Unrecognized ids are different from parts that have no ID.
          We won't actually know how to handle them correctly; display
	  the ID and ignore the chip.

  * Move the original block comment about the "legacy" chip ID scheme
    back next to the code to which it applies ... not next to the new
    JEDEC query code, which uses an entirely different strategy.

  * Don't print a guessed erasesize; /proc/mtd has the real value.

And add a few more comments.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |  130 ++++++++++++++++----------
 1 file changed, 83 insertions(+), 47 deletions(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3 drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -15,6 +15,8 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
@@ -487,9 +489,8 @@ add_dataflash(struct spi_device *spi, ch
 	device->write = dataflash_write;
 	device->priv = priv;
 
-	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes, "
-		"erasesize %d bytes\n", name, device->size/1024,
-		 pagesize, pagesize * 8);	/* 8 pages = 1 block */
+	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes\n",
+			name, DIV_ROUND_UP(device->size, 1024), pagesize);
 	dev_set_drvdata(&spi->dev, priv);
 
 	if (mtd_has_partitions()) {
@@ -518,65 +519,57 @@ add_dataflash(struct spi_device *spi, ch
 	return add_mtd_device(device) == 1 ? -ENODEV : 0;
 }
 
-/*
- * Detect and initialize DataFlash device:
- *
- *   Device      Density         ID code          #Pages PageSize  Offset
- *   AT45DB011B  1Mbit   (128K)  xx0011xx (0x0c)    512    264      9
- *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1024    264      9
- *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
- *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
- *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
- *   AT45DB0321B 32Mbit  (4M)    xx1101xx (0x34)   8192    528     10
- *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
- *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
- */
-
 struct flash_info {
 	char		*name;
 
-	/* JEDEC id zero means "no ID" (most older chips); otherwise it has
-	 * a high byte of zero plus three data bytes: the manufacturer id,
-	 * then a two byte device id.
+	/* JEDEC id has a high byte of zero plus three data bytes:
+	 * the manufacturer id, then a two byte device id.
 	 */
 	uint32_t	jedec_id;
 
-	/* The size listed here is what works with OPCODE_SE, which isn't
-	 * necessarily called a "sector" by the vendor.
-	 */
+	/* The size listed here is what works with OP_ERASE_PAGE. */
 	unsigned	nr_pages;
 	uint16_t	pagesize;
 	uint16_t	pageoffset;
 
 	uint16_t	flags;
-#define	SUP_POW2PS	0x02
-#define	IS_POW2PS	0x01
+#define SUP_POW2PS	0x0002		/* supports 2^N byte pages */
+#define IS_POW2PS	0x0001		/* uses 2^N byte pages */
 };
 
 static struct flash_info __devinitdata dataflash_data [] = {
 
-	{ "at45db011d",  0x1f2200, 512, 264, 9, SUP_POW2PS},
+	/*
+	 * NOTE:  chips with SUP_POW2PS (rev D and up) need two entries,
+	 * one with IS_POW2PS and the other without.  The entry with the
+	 * non-2^N byte page size can't name exact chip revisions without
+	 * losing backwards compatibility for cmdlinepart.
+	 *
+	 * These newer chips also support 128-byte security registers (with
+	 * 64 bytes one-time-programmable) and software write-protection.
+	 */
+	{ "AT45DB011B",  0x1f2200, 512, 264, 9, SUP_POW2PS},
 	{ "at45db011d",  0x1f2200, 512, 256, 8, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db021d",  0x1f2300, 1024, 264, 9, SUP_POW2PS},
+	{ "AT45DB021B",  0x1f2300, 1024, 264, 9, SUP_POW2PS},
 	{ "at45db021d",  0x1f2300, 1024, 256, 8, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db041d",  0x1f2400, 2048, 264, 9, SUP_POW2PS},
+	{ "AT45DB041x",  0x1f2400, 2048, 264, 9, SUP_POW2PS},
 	{ "at45db041d",  0x1f2400, 2048, 256, 8, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db081d",  0x1f2500, 4096, 264, 9, SUP_POW2PS},
+	{ "AT45DB081B",  0x1f2500, 4096, 264, 9, SUP_POW2PS},
 	{ "at45db081d",  0x1f2500, 4096, 256, 8, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db161d",  0x1f2600, 4096, 528, 10, SUP_POW2PS},
+	{ "AT45DB161x",  0x1f2600, 4096, 528, 10, SUP_POW2PS},
 	{ "at45db161d",  0x1f2600, 4096, 512, 9, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db321c",  0x1f2700, 8192, 528, 10, },
+	{ "AT45DB321x",  0x1f2700, 8192, 528, 10, 0},		/* rev C */
 
-	{ "at45db321d",  0x1f2701, 8192, 528, 10, SUP_POW2PS},
+	{ "AT45DB321x",  0x1f2701, 8192, 528, 10, SUP_POW2PS},
 	{ "at45db321d",  0x1f2701, 8192, 512, 9, SUP_POW2PS | IS_POW2PS},
 
-	{ "at45db641d",  0x1f2800, 8192, 1056, 11, SUP_POW2PS},
-	{ "at45db641d",  0x1f2800, 8192, 1024, 10, SUP_POW2PS | IS_POW2PS},
+	{ "AT45DB642x",  0x1f2800, 8192, 1056, 11, SUP_POW2PS},
+	{ "at45db642d",  0x1f2800, 8192, 1024, 10, SUP_POW2PS | IS_POW2PS},
 };
 
 static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
@@ -588,17 +581,23 @@ static struct flash_info *__devinit jede
 	struct flash_info	*info;
 	int status;
 
-
 	/* JEDEC also defines an optional "extended device information"
 	 * string for after vendor-specific data, after the three bytes
 	 * we use here.  Supporting some chips might require using it.
+	 *
+	 * If the vendor ID isn't Atmel's (0x1f), assume this call failed.
+	 * That's not an error; only rev C and newer chips handle it, and
+	 * only Atmel sells these chips.
 	 */
 	tmp = spi_write_then_read(spi, &code, 1, id, 3);
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
 			spi->dev.bus_id, tmp);
-		return NULL;
+		return ERR_PTR(tmp);
 	}
+	if (id[0] != 0x1f)
+		return NULL;
+
 	jedec = id[0];
 	jedec = jedec << 8;
 	jedec |= id[1];
@@ -609,19 +608,53 @@ static struct flash_info *__devinit jede
 			tmp < ARRAY_SIZE(dataflash_data);
 			tmp++, info++) {
 		if (info->jedec_id == jedec) {
+			DEBUG(MTD_DEBUG_LEVEL1, "%s: OTP, sector protect%s\n",
+				dev_name(spi->dev),
+				(info->flags & SUP_POW2PS)
+					? ", binary pagesize" : ""
+				);
 			if (info->flags & SUP_POW2PS) {
 				status = dataflash_status(spi);
-				if (status & 0x1)
-					/* return power of 2 pagesize */
-					return ++info;
-				else
-					return info;
+				if (status < 0) {
+					DEBUG(MTD_DEBUG_LEVEL1,
+						"%s: status error %d\n",
+						dev_name(spi->dev), status);
+					return ERR_PTR(status);
+				}
+				if (status & 0x1) {
+					if (info->flags & IS_POW2PS)
+						return info;
+				} else {
+					if (!(info->flags & IS_POW2PS))
+						return info;
+				}
 			}
 		}
 	}
-	return NULL;
+
+	/*
+	 * Treat other chips as errors ... we won't know the right page
+	 * size (it might be binary) even when we can tell which density
+	 * class is involved (legacy chip id scheme).
+	 */
+	dev_warn(&spi->dev, "JEDEC id %06x not handled\n", jedec);
+	return ERR_PTR(-ENODEV);
 }
 
+/*
+ * Detect and initialize DataFlash device, using JEDEC IDs on newer chips
+ * or else the ID code embedded in the status bits:
+ *
+ *   Device      Density         ID code          #Pages PageSize  Offset
+ *   AT45DB011B  1Mbit   (128K)  xx0011xx (0x0c)    512    264      9
+ *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1024    264      9
+ *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
+ *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
+ *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
+ *   AT45DB0321B 32Mbit  (4M)    xx1101xx (0x34)   8192    528     10
+ *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
+ *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
+ */
 static int __devinit dataflash_probe(struct spi_device *spi)
 {
 	int status;
@@ -632,14 +665,17 @@ static int __devinit dataflash_probe(str
 	 * If it succeeds we know we have either a C or D part.
 	 * D will support power of 2 pagesize option.
 	 */
-
 	info = jedec_probe(spi);
-
+	if (IS_ERR(info))
+		return PTR_ERR(info);
 	if (info != NULL)
 		return add_dataflash(spi, info->name, info->nr_pages,
 				 info->pagesize, info->pageoffset);
 
-
+	/*
+	 * Older chips support only legacy commands, identifing
+	 * capacity using bits in the status byte.
+	 */
 	status = dataflash_status(spi);
 	if (status <= 0 || status == 0xff) {
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: status error %d\n",
@@ -661,13 +697,13 @@ static int __devinit dataflash_probe(str
 		status = add_dataflash(spi, "AT45DB021B", 1024, 264, 9);
 		break;
 	case 0x1c:	/* 0 1 1 1 x x */
-		status = add_dataflash(spi, "AT45DB041B", 2048, 264, 9);
+		status = add_dataflash(spi, "AT45DB041x", 2048, 264, 9);
 		break;
 	case 0x24:	/* 1 0 0 1 x x */
 		status = add_dataflash(spi, "AT45DB081B", 4096, 264, 9);
 		break;
 	case 0x2c:	/* 1 0 1 1 x x */
-		status = add_dataflash(spi, "AT45DB161B", 4096, 528, 10);
+		status = add_dataflash(spi, "AT45DB161x", 4096, 528, 10);
 		break;
 	case 0x34:	/* 1 1 0 1 x x */
 		status = add_dataflash(spi, "AT45DB321x", 8192, 528, 10);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
rtc-dev-stop-periodic-interrupts-on-device-release.patch
linux-next.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

