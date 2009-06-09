From: akpm@linux-foundation.org
Subject: [merged] mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:11:53 -0700
Message-ID: <200906091811.n59IBrRl018211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626AbZFISMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kmpark@infradead.org, dwmw2@infradead.org, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     mtd: onenand: add bbt_wait & unlock_all as replaceable for some platform
has been removed from the -mm tree.  Its filename was
     mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: onenand: add bbt_wait & unlock_all as replaceable for some platform
From: Kyungmin Park <kmpark@infradead.org>

Add bbt_wait & unlock_all as replaceable for some platform such as
  s3c64xx s3c64xx has its own OneNAND controller and another interface

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_base.c |   12 ++++++++++--
 include/linux/mtd/onenand.h        |    5 +++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/onenand/onenand_base.c~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform drivers/mtd/onenand/onenand_base.c
--- a/drivers/mtd/onenand/onenand_base.c~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform
+++ a/drivers/mtd/onenand/onenand_base.c
@@ -1506,7 +1506,7 @@ int onenand_bbt_read_oob(struct mtd_info
 
 		onenand_update_bufferram(mtd, from, 0);
 
-		ret = onenand_bbt_wait(mtd, FL_READING);
+		ret = this->bbt_wait(mtd, FL_READING);
 		if (unlikely(ret))
 			ret = onenand_recover_lsb(mtd, from, ret);
 
@@ -2527,6 +2527,10 @@ static void onenand_unlock_all(struct mt
 		    & ONENAND_CTRL_ONGO)
 			continue;
 
+		/* Don't check lock status */
+		if (this->options & ONENAND_SKIP_UNLOCK_CHECK)
+			return;
+
 		/* Check lock status */
 		if (onenand_check_lock_status(this))
 			return;
@@ -3441,6 +3445,10 @@ int onenand_scan(struct mtd_info *mtd, i
 		this->command = onenand_command;
 	if (!this->wait)
 		onenand_setup_wait(mtd);
+	if (!this->bbt_wait)
+		this->bbt_wait = onenand_bbt_wait;
+	if (!this->unlock_all)
+		this->unlock_all = onenand_unlock_all;
 
 	if (!this->read_bufferram)
 		this->read_bufferram = onenand_read_bufferram;
@@ -3558,7 +3566,7 @@ int onenand_scan(struct mtd_info *mtd, i
 	mtd->owner = THIS_MODULE;
 
 	/* Unlock whole block */
-	onenand_unlock_all(mtd);
+	this->unlock_all(mtd);
 
 	ret = this->scan_bbt(mtd);
 	if ((!FLEXONENAND(this)) || ret)
diff -puN include/linux/mtd/onenand.h~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform include/linux/mtd/onenand.h
--- a/include/linux/mtd/onenand.h~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform
+++ a/include/linux/mtd/onenand.h
@@ -74,6 +74,8 @@ struct onenand_bufferram {
  * @command:		[REPLACEABLE] hardware specific function for writing
  *			commands to the chip
  * @wait:		[REPLACEABLE] hardware specific function for wait on ready
+ * @bbt_wait:		[REPLACEABLE] hardware specific function for bbt wait on ready
+ * @unlock_all:		[REPLACEABLE] hardware specific function for unlock all
  * @read_bufferram:	[REPLACEABLE] hardware specific function for BufferRAM Area
  * @write_bufferram:	[REPLACEABLE] hardware specific function for BufferRAM Area
  * @read_word:		[REPLACEABLE] hardware specific function for read
@@ -118,6 +120,8 @@ struct onenand_chip {
 
 	int (*command)(struct mtd_info *mtd, int cmd, loff_t address, size_t len);
 	int (*wait)(struct mtd_info *mtd, int state);
+	int (*bbt_wait)(struct mtd_info *mtd, int state);
+	void (*unlock_all)(struct mtd_info *mtd);
 	int (*read_bufferram)(struct mtd_info *mtd, int area,
 			unsigned char *buffer, int offset, size_t count);
 	int (*write_bufferram)(struct mtd_info *mtd, int area,
@@ -184,6 +188,7 @@ struct onenand_chip {
 #define ONENAND_HAS_CONT_LOCK		(0x0001)
 #define ONENAND_HAS_UNLOCK_ALL		(0x0002)
 #define ONENAND_HAS_2PLANE		(0x0004)
+#define ONENAND_SKIP_UNLOCK_CHECK	(0x0100)
 #define ONENAND_PAGEBUF_ALLOC		(0x1000)
 #define ONENAND_OOBBUF_ALLOC		(0x2000)
 
_

Patches currently in -mm which might be from kmpark@infradead.org are

linux-next.patch
samsung-soc-framebuffer-driver-add-alpha-channel-support.patch

