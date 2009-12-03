From: akpm@linux-foundation.org
Subject: [merged] aoe-prevent-cache-aliases.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:36:00 -0800
Message-ID: <200912032036.nB3Ka0K1011157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424AbZLCUgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phorton@bitbox.co.uk, ecashin@coraid.com, zero@colonel-panic.org, mm-commits@vger.kernel.org


The patch titled
     aoe: prevent cache aliases
has been removed from the -mm tree.  Its filename was
     aoe-prevent-cache-aliases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: prevent cache aliases
From: Peter Horton <phorton@bitbox.co.uk>

Prevent the AoE block driver from creating cache aliases of page cache
pages on machines with virtually indexed caches.

Building kernels on an AT91SAM9G20 board without this patch fails with
segmentation faults after a couple of passes.

Signed-off-by: Peter Horton <zero@colonel-panic.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoecmd.c~aoe-prevent-cache-aliases drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-prevent-cache-aliases
+++ a/drivers/block/aoe/aoecmd.c
@@ -735,6 +735,21 @@ diskstats(struct gendisk *disk, struct b
 	part_stat_unlock();
 }
 
+/*
+ * Ensure we don't create aliases in VI caches
+ */
+static inline void
+killalias(struct bio *bio)
+{
+	struct bio_vec *bv;
+	int i;
+
+	if (bio_data_dir(bio) == READ)
+		__bio_for_each_segment(bv, bio, i, 0) {
+			flush_dcache_page(bv->bv_page);
+		}
+}
+
 void
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
@@ -853,8 +868,12 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
 		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
-		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
-		bio_endio(buf->bio, n);
+		if (buf->flags & BUFFL_FAIL)
+			bio_endio(buf->bio, -EIO);
+		else {
+			killalias(buf->bio);
+			bio_endio(buf->bio, 0);
+		}
 		mempool_free(buf, d->bufpool);
 	}
 
_

Patches currently in -mm which might be from phorton@bitbox.co.uk are

linux-next.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch

