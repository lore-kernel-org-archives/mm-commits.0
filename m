From: akpm@linux-foundation.org
Subject: + mmc-mmc-44-ddr-support.patch added to -mm tree
Date: Mon, 23 Aug 2010 14:28:33 -0700
Message-ID: <201008232128.o7NLSXrd015715__49101.2870953002$1282598935$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770Ab0HWV2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 17:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hanumath.prasad@stericsson.com, cjb@laptop.org, linus.walleij@stericsson.com, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     mmc: MMC 4.4 DDR support
has been added to the -mm tree.  Its filename is
     mmc-mmc-44-ddr-support.patch

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
Subject: mmc: MMC 4.4 DDR support
From: Hanumath Prasad <hanumath.prasad@stericsson.com>

Add support for Dual Data Rate MMC cards as defined in the 4.4
specification.

Signed-off-by: Hanumath Prasad <hanumath.prasad@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |   10 +++++++---
 drivers/mmc/core/mmc.c   |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/mmc/card.h |    5 +++++
 include/linux/mmc/core.h |    1 +
 include/linux/mmc/host.h |    4 ++++
 include/linux/mmc/mmc.h  |   11 +++++++++--
 6 files changed, 61 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/card/block.c~mmc-mmc-44-ddr-support drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~mmc-mmc-44-ddr-support
+++ a/drivers/mmc/card/block.c
@@ -388,7 +388,8 @@ static int mmc_blk_issue_rw_rq(struct mm
 			readcmd = MMC_READ_SINGLE_BLOCK;
 			writecmd = MMC_WRITE_BLOCK;
 		}
-
+		if (mmc_card_ddr_mode(card))
+			brq.data.flags |= MMC_DDR_MODE;
 		if (rq_data_dir(req) == READ) {
 			brq.cmd.opcode = readcmd;
 			brq.data.flags |= MMC_DATA_READ;
@@ -669,8 +670,11 @@ mmc_blk_set_blksize(struct mmc_blk_data 
 	struct mmc_command cmd;
 	int err;
 
-	/* Block-addressed cards ignore MMC_SET_BLOCKLEN. */
-	if (mmc_card_blockaddr(card))
+	/*
+	 * Block-addressed and ddr mode supported cards
+	 * ignore MMC_SET_BLOCKLEN.
+	 */
+	if (mmc_card_blockaddr(card) || mmc_card_ddr_mode(card))
 		return 0;
 
 	mmc_claim_host(card->host);
diff -puN drivers/mmc/core/mmc.c~mmc-mmc-44-ddr-support drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-mmc-44-ddr-support
+++ a/drivers/mmc/core/mmc.c
@@ -258,6 +258,21 @@ static int mmc_read_ext_csd(struct mmc_c
 	}
 
 	switch (ext_csd[EXT_CSD_CARD_TYPE] & EXT_CSD_CARD_TYPE_MASK) {
+	case EXT_CSD_CARD_TYPE_DDR_52 | EXT_CSD_CARD_TYPE_52 |
+	     EXT_CSD_CARD_TYPE_26:
+		card->ext_csd.hs_max_dtr = 52000000;
+		card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_52;
+		break;
+	case EXT_CSD_CARD_TYPE_DDR_1_2V | EXT_CSD_CARD_TYPE_52 |
+	     EXT_CSD_CARD_TYPE_26:
+		card->ext_csd.hs_max_dtr = 52000000;
+		card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_1_2V;
+		break;
+	case EXT_CSD_CARD_TYPE_DDR_1_8V | EXT_CSD_CARD_TYPE_52 |
+	     EXT_CSD_CARD_TYPE_26:
+		card->ext_csd.hs_max_dtr = 52000000;
+		card->ext_csd.card_type = EXT_CSD_CARD_TYPE_DDR_1_8V;
+		break;
 	case EXT_CSD_CARD_TYPE_52 | EXT_CSD_CARD_TYPE_26:
 		card->ext_csd.hs_max_dtr = 52000000;
 		break;
@@ -503,6 +518,18 @@ static int mmc_init_card(struct mmc_host
 	mmc_set_clock(host, max_dtr);
 
 	/*
+	 * Activate DDR50 mode (if supported).
+	 */
+	if (mmc_card_highspeed(card)) {
+		if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_8V)
+			&& (host->caps & (MMC_CAP_1_8V_DDR)))
+				mmc_card_set_ddr_mode(card);
+		else if ((card->ext_csd.card_type & EXT_CSD_CARD_TYPE_DDR_1_2V)
+			&& (host->caps & (MMC_CAP_1_2V_DDR)))
+				mmc_card_set_ddr_mode(card);
+	}
+
+	/*
 	 * Activate wide bus (if supported).
 	 */
 	if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
@@ -510,10 +537,16 @@ static int mmc_init_card(struct mmc_host
 		unsigned ext_csd_bit, bus_width;
 
 		if (host->caps & MMC_CAP_8_BIT_DATA) {
-			ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
+			if (mmc_card_ddr_mode(card))
+				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_8;
+			else
+				ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
 			bus_width = MMC_BUS_WIDTH_8;
 		} else {
-			ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
+			if (mmc_card_ddr_mode(card))
+				ext_csd_bit = EXT_CSD_DDR_BUS_WIDTH_4;
+			else
+				ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
 			bus_width = MMC_BUS_WIDTH_4;
 		}
 
diff -puN include/linux/mmc/card.h~mmc-mmc-44-ddr-support include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-mmc-44-ddr-support
+++ a/include/linux/mmc/card.h
@@ -48,6 +48,7 @@ struct mmc_ext_csd {
 	unsigned int		sa_timeout;		/* Units: 100ns */
 	unsigned int		hs_max_dtr;
 	unsigned int		sectors;
+	unsigned int            card_type;
 	unsigned int		hc_erase_size;		/* In sectors */
 	unsigned int		hc_erase_timeout;	/* In milliseconds */
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
@@ -113,6 +114,8 @@ struct mmc_card {
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
 #define MMC_STATE_HIGHSPEED	(1<<2)		/* card is in high speed mode */
 #define MMC_STATE_BLOCKADDR	(1<<3)		/* card uses block-addressing */
+#define MMC_STATE_HIGHSPEED_DDR (1<<4)          /* card is in high speed */
+						/* dual data rate mode */
 	unsigned int		quirks; 	/* card quirks */
 #define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
 #define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)	/* use func->cur_blksize */
@@ -153,11 +156,13 @@ struct mmc_card {
 #define mmc_card_present(c)	((c)->state & MMC_STATE_PRESENT)
 #define mmc_card_readonly(c)	((c)->state & MMC_STATE_READONLY)
 #define mmc_card_highspeed(c)	((c)->state & MMC_STATE_HIGHSPEED)
+#define mmc_card_ddr_mode(c)   ((c)->state & MMC_STATE_HIGHSPEED_DDR)
 #define mmc_card_blockaddr(c)	((c)->state & MMC_STATE_BLOCKADDR)
 
 #define mmc_card_set_present(c)	((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
+#define mmc_card_set_ddr_mode(c) ((c)->state |= MMC_STATE_HIGHSPEED_DDR)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 
 static inline int mmc_card_lenient_fn0(const struct mmc_card *c)
diff -puN include/linux/mmc/core.h~mmc-mmc-44-ddr-support include/linux/mmc/core.h
--- a/include/linux/mmc/core.h~mmc-mmc-44-ddr-support
+++ a/include/linux/mmc/core.h
@@ -109,6 +109,7 @@ struct mmc_data {
 #define MMC_DATA_WRITE	(1 << 8)
 #define MMC_DATA_READ	(1 << 9)
 #define MMC_DATA_STREAM	(1 << 10)
+#define MMC_DDR_MODE    (1 << 11)
 
 	unsigned int		bytes_xfered;
 
diff -puN include/linux/mmc/host.h~mmc-mmc-44-ddr-support include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-mmc-44-ddr-support
+++ a/include/linux/mmc/host.h
@@ -157,6 +157,10 @@ struct mmc_host {
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
 #define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
 #define MMC_CAP_ERASE		(1 << 10)	/* Allow erase/trim commands */
+#define MMC_CAP_1_8V_DDR	(1 << 10)	/* can support */
+						/* DDR mode at 1.8V */
+#define MMC_CAP_1_2V_DDR	(1 << 11)	/* can support */
+						/* DDR mode at 1.2V */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
diff -puN include/linux/mmc/mmc.h~mmc-mmc-44-ddr-support include/linux/mmc/mmc.h
--- a/include/linux/mmc/mmc.h~mmc-mmc-44-ddr-support
+++ a/include/linux/mmc/mmc.h
@@ -277,11 +277,18 @@ struct _mmc_csd {
 
 #define EXT_CSD_CARD_TYPE_26	(1<<0)	/* Card can run at 26MHz */
 #define EXT_CSD_CARD_TYPE_52	(1<<1)	/* Card can run at 52MHz */
-#define EXT_CSD_CARD_TYPE_MASK	0x3	/* Mask out reserved and DDR bits */
+#define EXT_CSD_CARD_TYPE_MASK	0xF     /* Mask out reserved bits */
+#define EXT_CSD_CARD_TYPE_DDR_1_8V  (1<<2)   /* Card can run at 52MHz */
+					     /* DDR mode @1.8V or 3V I/O */
+#define EXT_CSD_CARD_TYPE_DDR_1_2V  (1<<3)   /* Card can run at 52MHz */
+					     /* DDR mode @1.2V I/O */
+#define EXT_CSD_CARD_TYPE_DDR_52       (EXT_CSD_CARD_TYPE_DDR_1_8V  \
+					| EXT_CSD_CARD_TYPE_DDR_1_2V)
 
-#define EXT_CSD_BUS_WIDTH_1	0	/* Card is in 1 bit mode */
 #define EXT_CSD_BUS_WIDTH_4	1	/* Card is in 4 bit mode */
 #define EXT_CSD_BUS_WIDTH_8	2	/* Card is in 8 bit mode */
+#define EXT_CSD_DDR_BUS_WIDTH_4    5    /* Card is in 4 bit DDR mode */
+#define EXT_CSD_DDR_BUS_WIDTH_8    6    /* Card is in 8 bit DDR mode */
 
 #define EXT_CSD_SEC_ER_EN	BIT(0)
 #define EXT_CSD_SEC_BD_BLK_EN	BIT(2)
_

Patches currently in -mm which might be from hanumath.prasad@stericsson.com are

mmc-mmc-44-ddr-support.patch

