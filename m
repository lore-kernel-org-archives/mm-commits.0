From: akpm@linux-foundation.org
Subject: - mtd-m25p80-chip-erase-=-block-erase-=-sector-erase.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:23 -0800
Message-ID: <200812011949.mB1JnNbC025233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbYLATuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.chen@freescale.com, clumsycg@gmail.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd m25p80: chip erase != block erase != sector erase
has been removed from the -mm tree.  Its filename was
     mtd-m25p80-chip-erase-=-block-erase-=-sector-erase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd m25p80: chip erase != block erase != sector erase
From: Chen Gong <g.chen@freescale.com>

This fixes broken terminology added in the "m25p80.c erase enhance" patch,
which added a chip erase command but called it "block erase".  There are
already two block erase commands; blocks are 4KiB or 32KiB.  There's also
a sector erase (usually 64 KiB).  Chip erase typically covers Megabytes.

  OPCODE_BE   ==> OPCODE_CHIP_ERASE
  erase_block ==> erase_chip

[dbrownell@users.sourceforge.net: update sector erase comments too ]

Signed-off-by: Chen Gong <clumsycg@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-chip-erase-=-block-erase-=-sector-erase drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-chip-erase-=-block-erase-=-sector-erase
+++ a/drivers/mtd/devices/m25p80.c
@@ -37,9 +37,9 @@
 #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_PP		0x02	/* Page program (up to 256 bytes) */
-#define	OPCODE_BE_4K 		0x20	/* Erase 4KiB block */
+#define	OPCODE_BE_4K		0x20	/* Erase 4KiB block */
 #define	OPCODE_BE_32K		0x52	/* Erase 32KiB block */
-#define	OPCODE_BE		0xc7	/* Erase whole flash block */
+#define	OPCODE_CHIP_ERASE	0xc7	/* Erase whole flash block */
 #define	OPCODE_SE		0xd8	/* Sector erase (usually 64KiB) */
 #define	OPCODE_RDID		0x9f	/* Read JEDEC ID */
 
@@ -167,7 +167,7 @@ static int wait_till_ready(struct m25p *
  *
  * Returns 0 if successful, non-zero otherwise.
  */
-static int erase_block(struct m25p *flash)
+static int erase_chip(struct m25p *flash)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB\n",
 			dev_name(&flash->spi->dev), __func__,
@@ -181,7 +181,7 @@ static int erase_block(struct m25p *flas
 	write_enable(flash);
 
 	/* Set up command buffer. */
-	flash->command[0] = OPCODE_BE;
+	flash->command[0] = OPCODE_CHIP_ERASE;
 
 	spi_write(flash->spi, flash->command, 1);
 
@@ -250,15 +250,18 @@ static int m25p80_erase(struct mtd_info 
 
 	mutex_lock(&flash->lock);
 
-	/* REVISIT in some cases we could speed up erasing large regions
-	 * by using OPCODE_SE instead of OPCODE_BE_4K
-	 */
