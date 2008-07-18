From: akpm@linux-foundation.org
Subject: + mtdpart-cleanup-and-document-the-erase-region-handling.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:42:28 -0700
Message-ID: <200807182142.m6ILgS7B032327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327AbYGRVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, joern@logfs.org


The patch titled
     mtdpart: cleanup and document the erase region handling
has been added to the -mm tree.  Its filename is
     mtdpart-cleanup-and-document-the-erase-region-handling.patch

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
fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch
linux-next.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
mtdpart-separate-main-loop-from-per-partition-code-in-add_mtd_partition.patch
mtdpart-handle-most-checkpatch-findings.patch
mtdpart-cleanup-and-document-the-erase-region-handling.patch
mtdpart-fix-a-division-by-zero-bug.patch
mtdpart-handle-remaining-checkpatch-findings.patch

