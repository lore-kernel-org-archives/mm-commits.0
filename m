From: akpm@linux-foundation.org
Subject: + mmc-recognize-csd-structure.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:36:21 -0700
Message-ID: <201006042236.o54MaLod022299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033Ab0FDWgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kmpark@infradead.org, adrian.hunter@nokia.com, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: recognize CSD structure
has been added to the -mm tree.  Its filename is
     mmc-recognize-csd-structure.patch

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
Subject: mmc: recognize CSD structure
From: Kyungmin Park <kmpark@infradead.org>

The eMMC spec 4.4 and 4.3 + additional feature chips has CSD structure
version 3 and version 3 have to check the CSD_STRUCTURE byte in the
EXT_CSD register.

Also fix EXT_CSD revision message.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c   |   26 +++++++++++++++++++-------
 include/linux/mmc/card.h |    1 +
 include/linux/mmc/mmc.h  |    1 +
 3 files changed, 21 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/core/mmc.c~mmc-recognize-csd-structure drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-recognize-csd-structure
+++ a/drivers/mmc/core/mmc.c
@@ -114,17 +114,18 @@ static int mmc_decode_cid(struct mmc_car
 static int mmc_decode_csd(struct mmc_card *card)
 {
 	struct mmc_csd *csd = &card->csd;
-	unsigned int e, m, csd_struct;
+	unsigned int e, m;
 	u32 *resp = card->raw_csd;
 
 	/*
 	 * We only understand CSD structure v1.1 and v1.2.
 	 * v1.2 has extra information in bits 15, 11 and 10.
+	 * also support the for eMMC v4.4 & v4.41.
 	 */
-	csd_struct = UNSTUFF_BITS(resp, 126, 2);
-	if (csd_struct != 1 && csd_struct != 2) {
+	csd->structure = UNSTUFF_BITS(resp, 126, 2);
+	if (csd->structure == 0) {
 		printk(KERN_ERR "%s: unrecognised CSD structure version %d\n",
-			mmc_hostname(card->host), csd_struct);
+			mmc_hostname(card->host), csd->structure);
 		return -EINVAL;
 	}
 
@@ -207,11 +208,22 @@ static int mmc_read_ext_csd(struct mmc_c
 		goto out;
 	}
 
+	/* Version is coded in the CSD_STRUCTURE byte in the EXT_CSD register */
+	if (card->csd.structure == 3) {
+		int ext_csd_struct = ext_csd[EXT_CSD_STRUCTURE];
+		if (ext_csd_struct > 2) {
+			printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
+				"version %d\n", mmc_hostname(card->host),
+					ext_csd_struct);
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
 	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
 	if (card->ext_csd.rev > 5) {
-		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
-			"version %d\n", mmc_hostname(card->host),
-			card->ext_csd.rev);
+		printk(KERN_ERR "%s: unrecognised EXT_CSD revision %d\n",
+			mmc_hostname(card->host), card->ext_csd.rev);
 		err = -EINVAL;
 		goto out;
 	}
diff -puN include/linux/mmc/card.h~mmc-recognize-csd-structure include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-recognize-csd-structure
+++ a/include/linux/mmc/card.h
@@ -24,6 +24,7 @@ struct mmc_cid {
 };
 
 struct mmc_csd {
+	unsigned char		structure;
 	unsigned char		mmca_vsn;
 	unsigned short		cmdclass;
 	unsigned short		tacc_clks;
diff -puN include/linux/mmc/mmc.h~mmc-recognize-csd-structure include/linux/mmc/mmc.h
--- a/include/linux/mmc/mmc.h~mmc-recognize-csd-structure
+++ a/include/linux/mmc/mmc.h
@@ -254,6 +254,7 @@ struct _mmc_csd {
 #define EXT_CSD_BUS_WIDTH	183	/* R/W */
 #define EXT_CSD_HS_TIMING	185	/* R/W */
 #define EXT_CSD_CARD_TYPE	196	/* RO */
+#define EXT_CSD_STRUCTURE	194	/* RO */
 #define EXT_CSD_REV		192	/* RO */
 #define EXT_CSD_SEC_CNT		212	/* RO, 4 bytes */
 #define EXT_CSD_S_A_TIMEOUT	217
_

Patches currently in -mm which might be from kmpark@infradead.org are

mmc-recognize-csd-structure.patch

