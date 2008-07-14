From: akpm@linux-foundation.org
Subject: - mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:36:08 -0700
Message-ID: <200807141936.m6EJa8kx024065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbYGNTgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd m25p80: fix bug - ATmel spi flash fails to be copied to
has been removed from the -mm tree.  Its filename was
     mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd m25p80: fix bug - ATmel spi flash fails to be copied to
From: Michael Hennerich <michael.hennerich@analog.com>

Atmel serial flash tends to power up with the protection status bits set.
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4089

[michael.hennerich@analog.com: remove duplicate code]
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to
+++ a/drivers/mtd/devices/m25p80.c
@@ -33,6 +33,7 @@
 /* Flash opcodes. */
 #define	OPCODE_WREN		0x06	/* Write enable */
 #define	OPCODE_RDSR		0x05	/* Read status register */
+#define	OPCODE_WRSR		0x01	/* Write status register 1 byte */
 #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_PP		0x02	/* Page program (up to 256 bytes) */
@@ -112,6 +113,17 @@ static int read_sr(struct m25p *flash)
 	return val;
 }
 
+/*
+ * Write status register 1 byte
+ * Returns negative if error occurred.
+ */
+static int write_sr(struct m25p *flash, u8 val)
+{
+	flash->command[0] = OPCODE_WRSR;
+	flash->command[1] = val;
+
+	return spi_write(flash->spi, flash->command, 2);
+}
 
 /*
  * Set write enable latch with Write Enable command.
@@ -589,6 +601,16 @@ static int __devinit m25p_probe(struct s
 	mutex_init(&flash->lock);
 	dev_set_drvdata(&spi->dev, flash);
 
+	/*
+	 * Atmel serial flash tend to power up
+	 * with the software protection bits set
+	 */
+
+	if (info->jedec_id >> 16 == 0x1f) {
+		write_enable(flash);
+		write_sr(flash, 0);
+	}
+
 	if (data && data->name)
 		flash->mtd.name = data->name;
 	else
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

