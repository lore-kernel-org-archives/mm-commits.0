From: akpm@linux-foundation.org
Subject: + aoe-prevent-cache-aliases.patch added to -mm tree
Date: Tue, 03 Nov 2009 16:39:23 -0800
Message-ID: <200911040039.nA40dOck007913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbZKDAj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 19:39:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phorton@bitbox.co.uk, ecashin@coraid.com, zero@colonel-panic.org


The patch titled
     aoe: prevent cache aliases
has been added to the -mm tree.  Its filename is
     aoe-prevent-cache-aliases.patch

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

aoe-prevent-cache-aliases.patch

