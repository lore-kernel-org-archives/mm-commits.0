From: akpm@linux-foundation.org
Subject: + mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch added to -mm tree
Date: Mon, 19 May 2008 23:03:57 -0700
Message-ID: <200805200603.m4K63vGr007950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbYETGKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd m25p80: fix bug - ATmel spi flash fails to be copied to
has been added to the -mm tree.  Its filename is
     mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

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
Subject: mtd m25p80: fix bug - ATmel spi flash fails to be copied to
From: Michael Hennerich <michael.hennerich@analog.com>

Atmel serial flash tends to power up with the protection status bits set.
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=4089

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

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
@@ -112,6 +113,19 @@ static int read_sr(struct m25p *flash)
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
+	spi_write(flash->spi, flash->command, 2);
+
+	return spi_write(flash->spi, flash->command, 2);
+}
 
 /*
  * Set write enable latch with Write Enable command.
@@ -587,6 +601,16 @@ static int __devinit m25p_probe(struct s
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

input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

