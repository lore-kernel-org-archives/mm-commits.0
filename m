From: akpm@linux-foundation.org
Subject: + mmc-sd-card-fix.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:45:41 -0700
Message-ID: <200807221045.m6MAjfS6024176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbYGVKqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marek.vasut@gmail.com, drzeus@drzeus.cx


The patch titled
     mmc: SD card fix
has been added to the -mm tree.  Its filename is
     mmc-sd-card-fix.patch

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
Subject: mmc: SD card fix
From: Marek Vasut <marek.vasut@gmail.com>

While I was tinkering with palmtx and preparing it for mainline, I
noticed, that certain SD cards doesnt work (both Kingston - made by
Toshiba).

I came across this
http://kerneltrap.org/mailarchive/linux-kernel/2007/9/28/325179
The person there had the same problem.

This patch fixed it for me, but this solution isn't definitely correct. 
Though it should point out what's the actual problem very well.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmc/card.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmc/card.h~mmc-sd-card-fix include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-sd-card-fix
+++ a/include/linux/mmc/card.h
@@ -85,7 +85,6 @@ struct mmc_card {
 	struct mmc_host		*host;		/* the host this device belongs to */
 	struct device		dev;		/* the device */
 	unsigned int		rca;		/* relative card address of device */
-	unsigned int		type;		/* card type */
 #define MMC_TYPE_MMC		0		/* MMC card */
 #define MMC_TYPE_SD		1		/* SD card */
 #define MMC_TYPE_SDIO		2		/* SDIO card */
@@ -98,6 +97,7 @@ struct mmc_card {
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
 	u32			raw_scr[2];	/* raw card SCR */
+	unsigned int		type;		/* card type */
 	struct mmc_cid		cid;		/* card identification */
 	struct mmc_csd		csd;		/* card specific */
 	struct mmc_ext_csd	ext_csd;	/* mmc v4 extended card specific */
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

linux-next.patch
mmc-sd-card-fix.patch

