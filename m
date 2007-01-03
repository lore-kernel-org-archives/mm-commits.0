From: akpm@osdl.org
Subject: - mmc-add-support-for-sdhc-cards-take-2.patch removed from -mm tree
Date: Wed, 03 Jan 2007 15:06:16 -0800
Message-ID: <200701032306.l03N6gBr002162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58851 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbXACXHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 18:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipl@overt.org, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: Add support for SDHC cards
has been removed from the -mm tree.  Its filename was
     mmc-add-support-for-sdhc-cards-take-2.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: mmc: Add support for SDHC cards
From: Philip Langdale <philipl@overt.org>

Thanks to the generous donation of an SDHC card by John Gilmore, and the
surprisingly enlightened decision by the SD Card Association to publish useful
specs, I've been able to bash out support for SDHC.  The changes are not too
profound:

i) Add a card flag indicating the card uses block level addressing and
   check it in the block driver.  As we never took advantage of byte-level
   addressing, this simply involves skipping the block -> byte translation
   when sending commands.

ii) The layout of the CSD is changed - a set of fields are discarded to
   make space for a larger C_SIZE.  We did not reference any of the discarded
   fields except those related to the C_SIZE.

iii) Read and write timeouts are fixed values and not calculated from CSD
   values.

iv) Before invoking SEND_APP_OP_COND, we must invoke the new SEND_IF_COND
   to inform the card we support SDHC.

I've done some basic read and write tests and everything seems to work fine
but one should obviously use caution in case it eats your data.

Signed-off-by: Philipl Langdale <philipl@overt.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/mmc.c            |  115 +++++++++++++++++++++++++--------
 drivers/mmc/mmc_block.c      |    8 ++
 include/linux/mmc/card.h     |    3 
 include/linux/mmc/mmc.h      |    3 
 include/linux/mmc/protocol.h |   13 +++
 5 files changed, 112 insertions(+), 30 deletions(-)

diff -puN drivers/mmc/mmc.c~mmc-add-support-for-sdhc-cards-take-2 drivers/mmc/mmc.c
--- a/drivers/mmc/mmc.c~mmc-add-support-for-sdhc-cards-take-2
+++ a/drivers/mmc/mmc.c
@@ -294,7 +294,10 @@ void mmc_set_data_timeout(struct mmc_dat
 		else
 			limit_us = 100000;
 
-		if (timeout_us > limit_us) {
+		/*
+		 * SDHC cards always use these fixed values.
+		 */
+		if (timeout_us > limit_us || mmc_card_blockaddr(card)) {
 			data->timeout_ns = limit_us * 1000;
 			data->timeout_clks = 0;
 		}
@@ -593,34 +596,65 @@ static void mmc_decode_csd(struct mmc_ca
 
 	if (mmc_card_sd(card)) {
 		csd_struct = UNSTUFF_BITS(resp, 126, 2);
-		if (csd_struct != 0) {
+
+		switch (csd_struct) {
+		case 0:
+			m = UNSTUFF_BITS(resp, 115, 4);
+			e = UNSTUFF_BITS(resp, 112, 3);
+			csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
+			csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;
+
+			m = UNSTUFF_BITS(resp, 99, 4);
+			e = UNSTUFF_BITS(resp, 96, 3);
+			csd->max_dtr	  = tran_exp[e] * tran_mant[m];
+			csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
+
+			e = UNSTUFF_BITS(resp, 47, 3);
+			m = UNSTUFF_BITS(resp, 62, 12);
+			csd->capacity	  = (1 + m) << (e + 2);
+
+			csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
+			csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
+			csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
+			csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
+			csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
+			csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
+			csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
+			break;
+		case 1:
+			/*
+			 * This is a block-addressed SDHC card. Most
+			 * interesting fields are unused and have fixed
+			 * values. To avoid getting tripped by buggy cards,
+			 * we assume those fixed values ourselves.
+			 */
+			mmc_card_set_blockaddr(card);
+
+			csd->tacc_ns	 = 0; /* Unused */
+			csd->tacc_clks	 = 0; /* Unused */
+
+			m = UNSTUFF_BITS(resp, 99, 4);
+			e = UNSTUFF_BITS(resp, 96, 3);
+			csd->max_dtr	  = tran_exp[e] * tran_mant[m];
+			csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
+
+			m = UNSTUFF_BITS(resp, 48, 22);
+			csd->capacity     = (1 + m) << 10;
+
+			csd->read_blkbits = 9;
+			csd->read_partial = 0;
+			csd->write_misalign = 0;
+			csd->read_misalign = 0;
+			csd->r2w_factor = 4; /* Unused */
+			csd->write_blkbits = 9;
+			csd->write_partial = 0;
+			break;
+		default:
 			printk("%s: unrecognised CSD structure version %d\n",
 				mmc_hostname(card->host), csd_struct);
 			mmc_card_set_bad(card);
 			return;
 		}
-
-		m = UNSTUFF_BITS(resp, 115, 4);
-		e = UNSTUFF_BITS(resp, 112, 3);
-		csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
-		csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;
-
-		m = UNSTUFF_BITS(resp, 99, 4);
-		e = UNSTUFF_BITS(resp, 96, 3);
-		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
-		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
-
-		e = UNSTUFF_BITS(resp, 47, 3);
-		m = UNSTUFF_BITS(resp, 62, 12);
-		csd->capacity	  = (1 + m) << (e + 2);
-
-		csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
-		csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
-		csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
-		csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
-		csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
-		csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
-		csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
 	} else {
 		/*
 		 * We only understand CSD structure v1.1 and v1.2.
@@ -1391,10 +1425,37 @@ static void mmc_setup(struct mmc_host *h
 	 * all get the idea that they should be ready for CMD2.
 	 * (My SanDisk card seems to need this.)
 	 */
-	if (host->mode == MMC_MODE_SD)
-		mmc_send_app_op_cond(host, host->ocr, NULL);
-	else
+	if (host->mode == MMC_MODE_SD) {
+		struct mmc_command cmd;
+		int err, ocr = host->ocr;
+		static const u8 test_pattern = 0xAA;
+
+		/*
+	 	* To support SD 2.0 cards, we must always invoke SD_SEND_IF_COND
+	 	* before SD_APP_OP_COND. This command will harmlessly fail for
+	 	* SD 1.0 cards.
+	 	*/
+		cmd.opcode = SD_SEND_IF_COND;
+		cmd.arg = ((host->ocr & 0xFF8000) != 0) << 8 | test_pattern;
+		cmd.flags = MMC_RSP_R7 | MMC_CMD_BCR;
+
+		err = mmc_wait_for_cmd(host, &cmd, 0);
+		if (err != MMC_ERR_NONE ||
+		    (cmd.resp[0] & 0xFF) == test_pattern) {
+			if (err == MMC_ERR_NONE) {
+				/*
+				 * If SD_SEND_IF_COND succeeded, we are dealing
+				 * with an SD 2.0 compliant card and we should
+				 * set bit 30 of the ocr to indicate that we
+				 * can handle block-addressed SDHC cards.
+				 */
+				ocr |= 1 << 30;
+			}
+			mmc_send_app_op_cond(host, ocr, NULL);
+		}
+	} else {
 		mmc_send_op_cond(host, host->ocr, NULL);
+	}
 
 	mmc_discover_cards(host);
 
diff -puN drivers/mmc/mmc_block.c~mmc-add-support-for-sdhc-cards-take-2 drivers/mmc/mmc_block.c
--- a/drivers/mmc/mmc_block.c~mmc-add-support-for-sdhc-cards-take-2
+++ a/drivers/mmc/mmc_block.c
@@ -237,7 +237,9 @@ static int mmc_blk_issue_rq(struct mmc_q
 		brq.mrq.cmd = &brq.cmd;
 		brq.mrq.data = &brq.data;
 
-		brq.cmd.arg = req->sector << 9;
+		brq.cmd.arg = req->sector;
+		if (!mmc_card_blockaddr(card))
+			brq.cmd.arg <<= 9;
 		brq.cmd.flags = MMC_RSP_R1 | MMC_CMD_ADTC;
 		brq.data.blksz = 1 << md->block_bits;
 		brq.stop.opcode = MMC_STOP_TRANSMISSION;
@@ -496,6 +498,10 @@ mmc_blk_set_blksize(struct mmc_blk_data 
 	struct mmc_command cmd;
 	int err;
 
+	/* Block-addressed cards ignore MMC_SET_BLOCKLEN. */
+	if (mmc_card_blockaddr(card))
+		return 0;
+
 	mmc_card_claim_host(card);
 	cmd.opcode = MMC_SET_BLOCKLEN;
 	cmd.arg = 1 << md->block_bits;
diff -puN include/linux/mmc/card.h~mmc-add-support-for-sdhc-cards-take-2 include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-add-support-for-sdhc-cards-take-2
+++ a/include/linux/mmc/card.h
@@ -71,6 +71,7 @@ struct mmc_card {
 #define MMC_STATE_SDCARD	(1<<3)		/* is an SD card */
 #define MMC_STATE_READONLY	(1<<4)		/* card is read-only */
 #define MMC_STATE_HIGHSPEED	(1<<5)		/* card is in high speed mode */
+#define MMC_STATE_BLOCKADDR	(1<<6)		/* card uses block-addressing */
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
 	u32			raw_scr[2];	/* raw card SCR */
@@ -87,6 +88,7 @@ struct mmc_card {
 #define mmc_card_sd(c)		((c)->state & MMC_STATE_SDCARD)
 #define mmc_card_readonly(c)	((c)->state & MMC_STATE_READONLY)
 #define mmc_card_highspeed(c)	((c)->state & MMC_STATE_HIGHSPEED)
+#define mmc_card_blockaddr(c)	((c)->state & MMC_STATE_BLOCKADDR)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_dead(c)	((c)->state |= MMC_STATE_DEAD)
@@ -94,6 +96,7 @@ struct mmc_card {
 #define mmc_card_set_sd(c)	((c)->state |= MMC_STATE_SDCARD)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
+#define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		((c)->dev.bus_id)
diff -puN include/linux/mmc/mmc.h~mmc-add-support-for-sdhc-cards-take-2 include/linux/mmc/mmc.h
--- a/include/linux/mmc/mmc.h~mmc-add-support-for-sdhc-cards-take-2
+++ a/include/linux/mmc/mmc.h
@@ -42,7 +42,8 @@ struct mmc_command {
 #define MMC_RSP_R1B	(MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE|MMC_RSP_BUSY)
 #define MMC_RSP_R2	(MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC)
 #define MMC_RSP_R3	(MMC_RSP_PRESENT)
-#define MMC_RSP_R6	(MMC_RSP_PRESENT|MMC_RSP_CRC)
+#define MMC_RSP_R6	(MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
+#define MMC_RSP_R7	(MMC_RSP_PRESENT|MMC_RSP_CRC|MMC_RSP_OPCODE)
 
 #define mmc_resp_type(cmd)	((cmd)->flags & (MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC|MMC_RSP_BUSY|MMC_RSP_OPCODE))
 
diff -puN include/linux/mmc/protocol.h~mmc-add-support-for-sdhc-cards-take-2 include/linux/mmc/protocol.h
--- a/include/linux/mmc/protocol.h~mmc-add-support-for-sdhc-cards-take-2
+++ a/include/linux/mmc/protocol.h
@@ -79,9 +79,12 @@
 #define MMC_GEN_CMD              56   /* adtc [0] RD/WR          R1  */
 
 /* SD commands                           type  argument     response */
-  /* class 8 */
+  /* class 0 */
 /* This is basically the same command as for MMC with some quirks. */
 #define SD_SEND_RELATIVE_ADDR     3   /* bcr                     R6  */
+#define SD_SEND_IF_COND           8   /* bcr  [11:0] See below   R7  */
+
+  /* class 10 */
 #define SD_SWITCH                 6   /* adtc [31:0] See below   R1  */
 
   /* Application commands */
@@ -115,6 +118,14 @@
  */
 
 /*
+ * SD_SEND_IF_COND argument format:
+ *
+ *	[31:12] Reserved (0)
+ *	[11:8] Host Voltage Supply Flags
+ *	[7:0] Check Pattern (0xAA)
+ */
+
+/*
   MMC status in R1
   Type
   	e : error bit
_

Patches currently in -mm which might be from philipl@overt.org are

mmc-add-support-for-sdhc-cards-take-2.patch
