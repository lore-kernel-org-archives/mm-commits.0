From: akpm@linux-foundation.org
Subject: + mtd-sst25l-non-jedec-spi-flash-driver-update.patch added to -mm tree
Date: Wed, 24 Jun 2009 19:40:17 -0700
Message-ID: <200906250240.n5P2eHRn006108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbZFYClS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 22:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ryan@bluewatersys.com, andre@bluewatersys.com, avorontsov@ru.mvista.com, dwmw2@infradead.org, linus.walleij@stericsson.com


The patch titled
     mtd-sst25l-non-jedec-spi-flash-driver-update
has been added to the -mm tree.  Its filename is
     mtd-sst25l-non-jedec-spi-flash-driver-update.patch

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
Subject: mtd-sst25l-non-jedec-spi-flash-driver-update
From: Ryan Mallon <ryan@bluewatersys.com>

The updated patch below uses sector erases instead to allow for smaller
partition sizes.

Signed-off-by: Andre Renaud <andre@bluewatersys.com>
Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/sst25l.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/devices/sst25l.c~mtd-sst25l-non-jedec-spi-flash-driver-update drivers/mtd/devices/sst25l.c
--- a/drivers/mtd/devices/sst25l.c~mtd-sst25l-non-jedec-spi-flash-driver-update
+++ a/drivers/mtd/devices/sst25l.c
@@ -37,7 +37,7 @@
 #define SST25L_CMD_READ		0x03	/* High speed read */
 
 #define SST25L_CMD_EWSR		0x50	/* Enable write status register */
-#define SST25L_CMD_BLOCK_ERASE	0x52	/* Erase sector */
+#define SST25L_CMD_SECTOR_ERASE	0x20	/* Erase sector */
 #define SST25L_CMD_READ_ID	0x90	/* Read device ID */
 #define SST25L_CMD_AAI_PROGRAM	0xaf	/* Auto address increment */
 
@@ -65,8 +65,8 @@ struct flash_info {
 #define to_sst25l_flash(x) container_of(x, struct sst25l_flash, mtd)
 
 static struct flash_info __initdata sst25l_flash_info[] = {
-	{"sst25lf020a", 0xbf43, 256, 1024, 32 * 1024},
-	{"sst25lf040a",	0xbf44,	256, 2048, 32 * 1024},
+	{"sst25lf020a", 0xbf43, 256, 1024, 4096},
+	{"sst25lf040a",	0xbf44,	256, 2048, 4096},
 };
 
 static int sst25l_status(struct sst25l_flash *flash, int *status)
@@ -134,7 +134,7 @@ static int sst25l_wait_till_ready(struct
 	return -ETIMEDOUT;
 }
 
-static int sst25l_erase_block(struct sst25l_flash *flash, u32 offset)
+static int sst25l_erase_sector(struct sst25l_flash *flash, u32 offset)
 {
 	u8 command[4];
 	int err;
@@ -143,7 +143,7 @@ static int sst25l_erase_block(struct sst
 	if (err)
 		return err;
 
-	command[0] = SST25L_CMD_BLOCK_ERASE;
+	command[0] = SST25L_CMD_SECTOR_ERASE;
 	command[1] = offset >> 16;
 	command[2] = offset >> 8;
 	command[3] = offset;
@@ -184,7 +184,7 @@ static int sst25l_erase(struct mtd_info 
 		return err;
 
 	while (addr < end) {
-		err = sst25l_erase_block(flash, addr);
+		err = sst25l_erase_sector(flash, addr);
 		if (err) {
 			mutex_unlock(&flash->lock);
 			instr->state = MTD_ERASE_FAILED;
_

Patches currently in -mm which might be from ryan@bluewatersys.com are

origin.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch

