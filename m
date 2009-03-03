From: akpm@linux-foundation.org
Subject: + mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch added to -mm tree
Date: Tue, 03 Mar 2009 12:50:58 -0800
Message-ID: <200903032050.n23KoxsR002333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822AbZCCUv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:51:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kmpark@infradead.org, dwmw2@infradead.org, kyungmin.park@samsung.com


The patch titled
     mtd: onenand: add bbt_wait & unlock_all as replaceable for some platform
has been added to the -mm tree.  Its filename is
     mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch

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
@@ -1511,7 +1511,7 @@ int onenand_bbt_read_oob(struct mtd_info
 
 		onenand_update_bufferram(mtd, from, 0);
 
-		ret = onenand_bbt_wait(mtd, FL_READING);
+		ret = this->bbt_wait(mtd, FL_READING);
 		if (unlikely(ret))
 			ret = onenand_recover_lsb(mtd, from, ret);
 
@@ -2532,6 +2532,10 @@ static void onenand_unlock_all(struct mt
 		    & ONENAND_CTRL_ONGO)
 			continue;
 
+		/* Don't check lock status */
+		if (this->options & ONENAND_SKIP_UNLOCK_CHECK)
+			return;
+
 		/* Check lock status */
 		if (onenand_check_lock_status(this))
 			return;
@@ -3407,6 +3411,10 @@ int onenand_scan(struct mtd_info *mtd, i
 		this->command = onenand_command;
 	if (!this->wait)
 		onenand_setup_wait(mtd);
+	if (!this->bbt_wait)
+		this->bbt_wait = onenand_bbt_wait;
+	if (!this->unlock_all)
+		this->unlock_all = onenand_unlock_all;
 
 	if (!this->read_bufferram)
 		this->read_bufferram = onenand_read_bufferram;
@@ -3524,7 +3532,7 @@ int onenand_scan(struct mtd_info *mtd, i
 	mtd->owner = THIS_MODULE;
 
 	/* Unlock whole block */
-	onenand_unlock_all(mtd);
+	this->unlock_all(mtd);
 
 	ret = this->scan_bbt(mtd);
 	if ((!FLEXONENAND(this)) || ret)
diff -puN include/linux/mtd/onenand.h~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform include/linux/mtd/onenand.h
--- a/include/linux/mtd/onenand.h~mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform
+++ a/include/linux/mtd/onenand.h
@@ -97,6 +97,8 @@ struct onenand_bufferram {
  * @command:		[REPLACEABLE] hardware specific function for writing
  *			commands to the chip
  * @wait:		[REPLACEABLE] hardware specific function for wait on ready
+ * @bbt_wait:		[REPLACEABLE] hardware specific function for bbt wait on ready
+ * @unlock_all:		[REPLACEABLE] hardware specific function for unlock all
  * @read_bufferram:	[REPLACEABLE] hardware specific function for BufferRAM Area
  * @write_bufferram:	[REPLACEABLE] hardware specific function for BufferRAM Area
  * @read_word:		[REPLACEABLE] hardware specific function for read
@@ -141,6 +143,8 @@ struct onenand_chip {
 
 	int (*command)(struct mtd_info *mtd, int cmd, loff_t address, size_t len);
 	int (*wait)(struct mtd_info *mtd, int state);
+	int (*bbt_wait)(struct mtd_info *mtd, int state);
+	void (*unlock_all)(struct mtd_info *mtd);
 	int (*read_bufferram)(struct mtd_info *mtd, int area,
 			unsigned char *buffer, int offset, size_t count);
 	int (*write_bufferram)(struct mtd_info *mtd, int area,
@@ -207,6 +211,7 @@ struct onenand_chip {
 #define ONENAND_HAS_CONT_LOCK		(0x0001)
 #define ONENAND_HAS_UNLOCK_ALL		(0x0002)
 #define ONENAND_HAS_2PLANE		(0x0004)
+#define ONENAND_SKIP_UNLOCK_CHECK	(0x0100)
 #define ONENAND_PAGEBUF_ALLOC		(0x1000)
 #define ONENAND_OOBBUF_ALLOC		(0x2000)
 
_

Patches currently in -mm which might be from kmpark@infradead.org are

mtd-onenand-add-write-while-program-support.patch
mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch

