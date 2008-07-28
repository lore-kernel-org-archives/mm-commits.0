From: akpm@linux-foundation.org
Subject: - mtdpart-cleanup-and-document-the-erase-region-handling.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:31 -0700
Message-ID: <200807282111.m6SLBVcC027684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760440AbYG1VMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     mtdpart: cleanup and document the erase region handling
has been removed from the -mm tree.  Its filename was
     mtdpart-cleanup-and-document-the-erase-region-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtdpart: cleanup and document the erase region handling
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Mostly simplifying the loops.  Now everything fits into 80 columns, is
easier to read and the finer details have extra comments.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdpart.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/mtdpart.c~mtdpart-cleanup-and-document-the-erase-region-handling drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~mtdpart-cleanup-and-document-the-erase-region-handling
+++ a/drivers/mtd/mtdpart.c
@@ -424,18 +424,24 @@ static struct mtd_part *add_one_partitio
 	}
 	if (master->numeraseregions > 1) {
 		/* Deal with variable erase size stuff */
-		int i;
+		int i, max = master->numeraseregions;
+		u32 end = slave->offset + slave->mtd.size;
 		struct mtd_erase_region_info *regions = master->eraseregions;
 
-		/* Find the first erase regions which is part of this partition. */
-		for (i = 0; i < master->numeraseregions && regions[i].offset <= slave->offset; i++)
+		/* Find the first erase regions which is part of this
+		 * partition. */
+		for (i = 0; i < max && regions[i].offset <= slave->offset; i++)
 			;
+		/* The loop searched for the region _behind_ the first one */
+		i--;
 
-		for (i--; i < master->numeraseregions && regions[i].offset < slave->offset + slave->mtd.size; i++) {
+		/* Pick biggest erasesize */
+		for (; i < max && regions[i].offset < end; i++) {
 			if (slave->mtd.erasesize < regions[i].erasesize) {
 				slave->mtd.erasesize = regions[i].erasesize;
 			}
 		}
+		BUG_ON(slave->mtd.erasesize == 0);
 	} else {
 		/* Single erase size */
 		slave->mtd.erasesize = master->erasesize;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
gpio-fix-build-on-config_gpio_sysfs=n.patch
linux-next.patch
mtdpart-handle-remaining-checkpatch-findings.patch

