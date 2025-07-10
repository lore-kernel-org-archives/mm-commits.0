Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4328467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126222; cv=none; b=CjzfaUOBz+zbc6CPBsv+o3gYFPOd7PI5d+SBrFe7ERjdTpcRzm6EqskKgdwCTc+R0gx0MHntRpbSHFJ0p5/2akIaW9OyLZp/LKj+3mzYPlQt/OlnGVPj0oAuSCLF8MD6mhdzkJXToKoqP6aylh7yDa1dyNGLPrl1X1goe8TkGWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126222; c=relaxed/simple;
	bh=o0mkZmWIOPz4y4iaSndKaSbK7DdH2X0yDDnv/Q/dJF0=;
	h=Date:To:From:Subject:Message-Id; b=mbBFp+I6pDALJytzqT6VWwMhuX9VMQ/vlxEeYl0o18P0RLWSG3h0NhmIdV9sNddEFzl7PCs/ClrimLAR92ltN/xpTIEf2IH2PygsDz/Ctmt4xgnBsyR5I2GnT5iuf2e68ONrelZBkvRQjdylbYFgHWA5fhfDbR/p8SclpeQQst4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmeNBDgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmeNBDgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EADC4CEE3;
	Thu, 10 Jul 2025 05:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126222;
	bh=o0mkZmWIOPz4y4iaSndKaSbK7DdH2X0yDDnv/Q/dJF0=;
	h=Date:To:From:Subject:From;
	b=zmeNBDgSiCazClkBkVxcj1gBmGzt4rhTnT2O+NdrWdqorOeHCOAvdeWF+dM7CRIus
	 mrLtlpnw2jLEisR1UF7aHLF/uflyyAbtf8ZYO+BWevKKpdWZprxGpV2LVZd4SVCI8r
	 n84vqxD2A3Z17Og0UUZqKYkIta/CSxTeZ1VWi8AQ=
Date: Wed, 09 Jul 2025 22:43:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch removed from -mm tree
Message-Id: <20250710054341.E7EADC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: stop passing a writeback_control structure to __swap_writepage
has been removed from the -mm tree.  Its filename was
     mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: stop passing a writeback_control structure to __swap_writepage
Date: Tue, 10 Jun 2025 07:49:40 +0200

__swap_writepage only needs the swap_iocb cookie from the
writeback_control structure, so pass it explicitly and remove the now
unused swap_iocb member from struct writeback_control.

Link: https://lkml.kernel.org/r/20250610054959.2057526-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   33 ++++++++++++++-------------------
 mm/swap.h    |    2 +-
 mm/zswap.c   |    5 +----
 3 files changed, 16 insertions(+), 24 deletions(-)

--- a/mm/page_io.c~mm-stop-passing-a-writeback_control-structure-to-__swap_writepage
+++ a/mm/page_io.c
@@ -281,7 +281,7 @@ int swap_writeout(struct folio *folio, s
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(folio, wbc);
+	__swap_writepage(folio, wbc->swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -371,9 +371,9 @@ static void sio_write_complete(struct ki
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct writeback_control *wbc)
+static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 {
-	struct swap_iocb *sio = NULL;
+	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
@@ -381,8 +381,6 @@ static void swap_writepage_fs(struct fol
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	if (wbc->swap_plug)
-		sio = *wbc->swap_plug;
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
 		    sio->iocb.ki_pos + sio->len != pos) {
@@ -401,22 +399,21 @@ static void swap_writepage_fs(struct fol
 	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
 	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
+	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
 		swap_write_unplug(sio);
 		sio = NULL;
 	}
-	if (wbc->swap_plug)
-		*wbc->swap_plug = sio;
+	if (swap_plug)
+		*swap_plug = sio;
 }
 
 static void swap_writepage_bdev_sync(struct folio *folio,
-		struct writeback_control *wbc, struct swap_info_struct *sis)
+		struct swap_info_struct *sis)
 {
 	struct bio_vec bv;
 	struct bio bio;
 
-	bio_init(&bio, sis->bdev, &bv, 1,
-		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
+	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
 	bio.bi_iter.bi_sector = swap_folio_sector(folio);
 	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
@@ -431,13 +428,11 @@ static void swap_writepage_bdev_sync(str
 }
 
 static void swap_writepage_bdev_async(struct folio *folio,
-		struct writeback_control *wbc, struct swap_info_struct *sis)
+		struct swap_info_struct *sis)
 {
 	struct bio *bio;
 
-	bio = bio_alloc(sis->bdev, 1,
-			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
-			GFP_NOIO);
+	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_write;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
@@ -449,7 +444,7 @@ static void swap_writepage_bdev_async(st
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
+void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 
@@ -460,16 +455,16 @@ void __swap_writepage(struct folio *foli
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, wbc);
+		swap_writepage_fs(folio, swap_plug);
 	/*
 	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
 	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, wbc, sis);
+		swap_writepage_bdev_sync(folio, sis);
 	else
-		swap_writepage_bdev_async(folio, wbc, sis);
+		swap_writepage_bdev_async(folio, sis);
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
--- a/mm/swap.h~mm-stop-passing-a-writeback_control-structure-to-__swap_writepage
+++ a/mm/swap.h
@@ -21,7 +21,7 @@ static inline void swap_read_unplug(stru
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct writeback_control *wbc);
-void __swap_writepage(struct folio *folio, struct writeback_control *wbc);
+void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
--- a/mm/zswap.c~mm-stop-passing-a-writeback_control-structure-to-__swap_writepage
+++ a/mm/zswap.c
@@ -1070,9 +1070,6 @@ static int zswap_writeback_entry(struct
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
 	struct swap_info_struct *si;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_NONE,
-	};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1134,7 +1131,7 @@ static int zswap_writeback_entry(struct
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, &wbc);
+	__swap_writepage(folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
_

Patches currently in -mm which might be from hch@lst.de are


