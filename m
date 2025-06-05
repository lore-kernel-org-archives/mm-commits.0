Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF964C83
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 00:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082834; cv=none; b=g+CL8wNOwmYKYQQTw9QHz+PpM0xr1w1rwYiYm/UBa++GPGUFdmpQ9rnQ4kGUCMQ0ukhNWV4yyuaN8871V2Ko0kPQWxbe+Kr8zc+KOerJWLSU79myXPTCvHfGcGc4Gz6efxKP3QW0RX5fe1kk1Lf0DC7XNrqa6KTABwzi68pRAfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082834; c=relaxed/simple;
	bh=5VBVJqOXo7uwV5UqN9D5Iuw7RveFSFtyyhYxHBwi1E4=;
	h=Date:To:From:Subject:Message-Id; b=VI3TFmx+aPlTkMyhFQIxp8dMebueeANivWGyUNkqtThLspQPm1Xf01ROpbmN9uJu/t7y9cL3qEG+KdsNnTXXTkE0S3HG/Yyq+iiVDTsW+Agl/Q5EjQCcrTTRAni77uACTwc/elOROiAqnMWLgnZOmH0zJGQYqsAbxykXGkwyfNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdmL5t19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdmL5t19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CB3C4CEE4;
	Thu,  5 Jun 2025 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749082834;
	bh=5VBVJqOXo7uwV5UqN9D5Iuw7RveFSFtyyhYxHBwi1E4=;
	h=Date:To:From:Subject:From;
	b=MdmL5t19fi2s5XdFL6eNWz2BhwWlQNMGT6h6LUp7+E/oqBgT6tSFpfPA39QKC3bHL
	 zyCv0UQP1YFqg2RAVJ50zKNaeVZrVnpexdFIvkI+f4pl14tY9LWl/ahGHjmEZaxY3p
	 AvpmX0ZyFST6F/csgGknRVZSGSXCZSf6A81sd3HM=
Date: Wed, 04 Jun 2025 17:20:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hughd@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch added to mm-new branch
Message-Id: <20250605002034.68CB3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: stop passing a writeback_control structure to __swap_writepage
has been added to the -mm mm-new branch.  Its filename is
     mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: stop passing a writeback_control structure to __swap_writepage
Date: Fri, 16 May 2025 09:40:38 +0200

__swap_writepage only needs the swap_iocb cookie from the
writeback_control structure, so pass it explicitly and remove the now
unused swap_iocb member from struct writeback_control.

Link: https://lkml.kernel.org/r/20250516074146.178314-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-split-out-a-writeout-helper-from-pageout.patch
mm-stop-passing-a-writeback_control-structure-to-shmem_writeout.patch
mm-tidy-up-swap_writeout.patch
mm-stop-passing-a-writeback_control-structure-to-__swap_writepage.patch
mm-stop-passing-a-writeback_control-structure-to-swap_writeout.patch

