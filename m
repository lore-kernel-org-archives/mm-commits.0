From: akpm@osdl.org
Subject: - mmc-add-support-for-sdhc-cards.patch removed from -mm tree
Date: Tue, 02 Jan 2007 14:48:18 -0800
Message-ID: <200701022248.l02MmKWc032508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964990AbXABWtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipl@overt.org, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: Add support for SDHC cards
has been removed from the -mm tree.  Its filename was
     mmc-add-support-for-sdhc-cards.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mmc: Add support for SDHC cards
From: Philip Langdale <philipl@overt.org>

Thanks to the generous donation of an SDHC card by John Gilmore, and the
surprisingly enlightened decision by the SD Card Association to publish
useful specs, I've been able to bash out support for SDHC.  The changes are
not too profound:

i) Add a card flag indicating the card uses block level addressing and
   check it in the block driver.  As we never took advantage of byte-level
   addressing, this simply involves skipping the block -> byte translation
   when sending commands.

ii) The layout of the CSD is changed - a set of fields are discarded to
    make space for a larger C_SIZE.  We did not reference any of the
    discarded fields except those related to the C_SIZE.

iii) Read and write timeouts are fixed values and not calculated from
     CSD values.

iv) Before invoking SEND_APP_OP_COND, we must invoke the new
    SEND_IF_COND to inform the card we support SDHC.

I've done some basic read and write tests and everything seems to work fine
but one should obviously use caution in case it eats your data.

Addendum: Similar spec changes were introduced by the MMC Association in
version 4.2 to switch to block addressing.  We do not have access to the
4.2 spec or even a change summary as we did for 3 -> 4.  My guess as to
what's changed looks something like the following:

i) A new field is added to the ext_csd to store the capacity that cannot
   be described using existing csd fields.

ii) A new field is added to the ext_csd to indicate the need for block
    addressing.

iii) A new write-only field is added to the ext_csd which has to be
     toggled to tell the card that the host supports block-addressing.  But
     perhaps compatibility requires that a new command be used like for
     SDHC...

If someone has access to the spec and can shed some light on the subject in
a legal way, please let us know.  Of course, I don't think there are any
MMC HC cards on the market yet, but one was announced last month.

Signed-off-by: Philipl Langdale <philipl@overt.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/mmc.c            |   40 ++++++++++++++++++++++++++++-----
 drivers/mmc/mmc_block.c      |    4 ++-
 include/linux/mmc/card.h     |    3 ++
 include/linux/mmc/mmc.h      |    1 
 include/linux/mmc/protocol.h |   13 +++++++++-
 5 files changed, 54 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/mmc_block.c~mmc-add-support-for-sdhc-cards drivers/mmc/mmc_block.c
--- a/drivers/mmc/mmc_block.c~mmc-add-support-for-sdhc-cards
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
diff -puN drivers/mmc/mmc.c~mmc-add-support-for-sdhc-cards drivers/mmc/mmc.c
--- a/drivers/mmc/mmc.c~mmc-add-support-for-sdhc-cards
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
@@ -593,12 +596,15 @@ static void mmc_decode_csd(struct mmc_ca
 
 	if (mmc_card_sd(card)) {
 		csd_struct = UNSTUFF_BITS(resp, 126, 2);
-		if (csd_struct != 0) {
+		if (csd_struct != 0 && csd_struct != 1) {
 			printk("%s: unrecognised CSD structure version %d\n",
 				mmc_hostname(card->host), csd_struct);
 			mmc_card_set_bad(card);
 			return;
 		}
+		if (csd_struct == 1) {
+			mmc_card_set_blockaddr(card);
+		}
 
 		m = UNSTUFF_BITS(resp, 115, 4);
 		e = UNSTUFF_BITS(resp, 112, 3);
@@ -610,9 +616,14 @@ static void mmc_decode_csd(struct mmc_ca
 		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
 		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
 
-		e = UNSTUFF_BITS(resp, 47, 3);
-		m = UNSTUFF_BITS(resp, 62, 12);
-		csd->capacity	  = (1 + m) << (e + 2);
+		if (csd_struct == 0) {
+			e = UNSTUFF_BITS(resp, 47, 3);
+			m = UNSTUFF_BITS(resp, 62, 12);
+			csd->capacity	  = (1 + m) << (e + 2);
+		} else if (csd_struct == 1) {
+			m = UNSTUFF_BITS(resp, 48, 22);
+			csd->capacity     = (1 + m) << 10;
+		}
 
 		csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
 		csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
@@ -829,6 +840,25 @@ static int mmc_send_app_op_cond(struct m
 {
 	struct mmc_command cmd;
 	int i, err = 0;
+	static const u8 test_pattern = 0xAA;
+
+	/*
+	 * To support SD 2.0 cards, we must always invoke SD_SEND_IF_COND
+	 * before SD_APP_OP_COND. This command will harmlessly fail for
+	 * SD 1.0 and MMC cards (fortunately including MMC 4 cards).
+	 */
+	cmd.opcode = SD_SEND_IF_COND;
+	cmd.arg = ((host->ocr_avail & 0xFF8000) != 0) << 8 | test_pattern;
+	cmd.flags = MMC_RSP_R7 | MMC_CMD_BCR;
+
+	err = mmc_wait_for_cmd(host, &cmd, 0);
+	if (err == MMC_ERR_NONE) {
+		if ((cmd.resp[0] & 0xFF) != test_pattern) {
+			return MMC_ERR_FAILED;
+		} else if (ocr != 0) {
+			ocr |= 1 << 30;
+		}
+	}
 
 	cmd.opcode = SD_APP_OP_COND;
 	cmd.arg = ocr;
diff -puN include/linux/mmc/card.h~mmc-add-support-for-sdhc-cards include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-add-support-for-sdhc-cards
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
diff -puN include/linux/mmc/mmc.h~mmc-add-support-for-sdhc-cards include/linux/mmc/mmc.h
--- a/include/linux/mmc/mmc.h~mmc-add-support-for-sdhc-cards
+++ a/include/linux/mmc/mmc.h
@@ -43,6 +43,7 @@ struct mmc_command {
 #define MMC_RSP_R2	(MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC)
 #define MMC_RSP_R3	(MMC_RSP_PRESENT)
 #define MMC_RSP_R6	(MMC_RSP_PRESENT|MMC_RSP_CRC)
+#define MMC_RSP_R7	(MMC_RSP_PRESENT|MMC_RSP_CRC)
 
 #define mmc_resp_type(cmd)	((cmd)->flags & (MMC_RSP_PRESENT|MMC_RSP_136|MMC_RSP_CRC|MMC_RSP_BUSY|MMC_RSP_OPCODE))
 
diff -puN include/linux/mmc/protocol.h~mmc-add-support-for-sdhc-cards include/linux/mmc/protocol.h
--- a/include/linux/mmc/protocol.h~mmc-add-support-for-sdhc-cards
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

mmc-add-support-for-sdhc-cards.patch
mmc-add-support-for-sdhc-cards-take-2.patch
