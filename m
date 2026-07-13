Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C4357D13
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973811; cv=none; b=pqm3tAsogPRWlsihTbc2ir0/A/hpNL3CZqPDJAFqNLmHLHA1UFE0gqAjolU/Xnsemi8+4xnZX7AkkRATRVhNws78R7njdhnfXRlRBb1zP6c5qUyqZHyHFY8EGtR4TbAtRbsZD4Gy27VUfnll8Wgz+1jH/W4hMsOjMD17nGys3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973811; c=relaxed/simple;
	bh=pMN8DFp0z0quU1sadCLjUc9yp1PogePNrCipP1AkcWo=;
	h=Date:To:From:Subject:Message-Id; b=Ko2p9/HvYNJvrfoq3qc22pZVuLEb/pGis0iuZJzZT9Ofm4OxYYgwtZSJF3X/8GJVzqfeEvnwUVZ7uv27xEOn31of039MzT+gOkZ3agmUaPDQtP7edMdJMCaueTtPnco4lftCmrCM/qoUX107wyCQzQ6w0Xh8pkUhk0p5OY3LrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRkiadWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRkiadWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068231F000E9;
	Mon, 13 Jul 2026 20:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973809;
	bh=MqsA61tiH5HiFIRND4LuD0bUMLa7OHhLzr6SsnbB77A=;
	h=Date:To:From:Subject;
	b=WRkiadWh9Air6qz9Y45FMydqC2aP6eppizwPYiNtc+94hv5QV+Z4udh0mmIugLQ6W
	 H9omcckrY4NlhTY5gGlu//Ix8cedBGBXe9LWu6X2ylWiQRVObl7lfpiigOkSXkR3Xa
	 0oVxEsc3/4j6SfkV7x4uW5NucRx5+vDbKjaO1+vw=
Date: Mon, 13 Jul 2026 13:16:48 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch added to mm-new branch
Message-Id: <20260713201649.068231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: also use struct swap_iocb for block I/O
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: also use struct swap_iocb for block I/O
Date: Mon, 13 Jul 2026 11:33:40 +0200

Block I/O benefits from batching just as much as remote file systems. 
Extend struct swap_iocb to support building a bio on the fly as well, and
rewrite the block based swap code for it.  This especially benefits
submit_bio based drivers that do not have the block plugging available,
but also saves allocating extra bios for blk-mq drivers.

Add a pre-allocated bio to struct swap_iocb in a union with kiocb used for
file system based swap so that struct swap_iocb can be used for all swap
I/O, and initialize the pool for it unconditionally.

Various low-level bdev and fs functions are now replaced with a unified
can_merge/add/submit scheme.

Note that the block based swap code now uses the same memcg-based check
previously added for file system based swap as well.

Link: https://lore.kernel.org/20260713093350.2154226-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c  |  526 ++++++++++++++++++++++--------------------------
 mm/swap.h     |    1 
 mm/swapfile.c |    9 
 3 files changed, 254 insertions(+), 282 deletions(-)

--- a/mm/page_io.c~mm-swap-also-use-struct-swap_iocb-for-block-i-o
+++ a/mm/page_io.c
@@ -28,54 +28,6 @@
 #include "swap.h"
 #include "swap_table.h"
 
-static void __end_swap_bio_write(struct bio *bio)
-{
-	struct folio *folio = bio_first_folio_all(bio);
-
-	if (bio->bi_status) {
-		/*
-		 * We failed to write the page out to swap-space.
-		 * Re-dirty the page in order to avoid it being reclaimed.
-		 * Also print a dire warning that things will go BAD (tm)
-		 * very quickly.
-		 *
-		 * Also clear PG_reclaim to avoid folio_rotate_reclaimable()
-		 */
-		folio_mark_dirty(folio);
-		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
-				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-				     (unsigned long long)bio->bi_iter.bi_sector);
-		folio_clear_reclaim(folio);
-	}
-	folio_end_writeback(folio);
-}
-
-static void end_swap_bio_write(struct bio *bio)
-{
-	__end_swap_bio_write(bio);
-	bio_put(bio);
-}
-
-static void __end_swap_bio_read(struct bio *bio)
-{
-	struct folio *folio = bio_first_folio_all(bio);
-
-	if (bio->bi_status) {
-		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
-				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
-				     (unsigned long long)bio->bi_iter.bi_sector);
-	} else {
-		folio_mark_uptodate(folio);
-	}
-	folio_unlock(folio);
-}
-
-static void end_swap_bio_read(struct bio *bio)
-{
-	__end_swap_bio_read(bio);
-	bio_put(bio);
-}
-
 int generic_swapfile_activate(struct swap_info_struct *sis,
 				struct file *swap_file,
 				sector_t *span)
@@ -316,18 +268,36 @@ static inline void count_swpout_vm_event
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+{
+	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
+}
+
+static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+{
+	bool can_merge = true;
+
+	if (folio_memcg_charged(folio) != folio_memcg_charged(prev_folio))
+		return false;
+	if (folio_memcg_charged(folio)) {
+		rcu_read_lock();
+		if (folio_memcg_blkg_css(folio) !=
+		    folio_memcg_blkg_css(prev_folio))
+			can_merge = false;
+		rcu_read_unlock();
+	}
+	return can_merge;
+}
+
 static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
 
 	if (!folio_memcg_charged(folio))
 		return;
-
 	rcu_read_lock();
-	memcg = folio_memcg(folio);
-	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	if (!css || !css_tryget(css))
+	css = folio_memcg_blkg_css(folio);
+	if (css && !css_tryget(css))
 		css = NULL;
 	rcu_read_unlock();
 
@@ -336,11 +306,18 @@ static void bio_associate_blkg_from_page
 		css_put(css);
 }
 #else
+static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+{
+	return true;
+}
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
-	struct kiocb		iocb;
+	union {
+		struct kiocb	iocb;
+		struct bio	bio;
+	};
 	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
 	int			nr_bvecs;
 	int			len;
@@ -360,171 +337,70 @@ int sio_pool_init(void)
 	return 0;
 }
 
-static void sio_write_complete(struct kiocb *iocb, long ret)
+static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
+		int rw)
 {
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvecs[0].bv_page;
-	int p;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
+	struct folio *prev_folio = bvec_folio(last_bv);
+	size_t prev_folio_size = folio_size(prev_folio);
 
-	if (ret != sio->len) {
-		/*
-		 * In the case of swap-over-nfs, this can be a
-		 * temporary failure if the system has limited
-		 * memory for allocating transmit buffers.
-		 * Mark the page dirty and avoid
-		 * folio_rotate_reclaimable but rate-limit the
-		 * messages.
-		 */
-		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			page = sio->bvecs[p].bv_page;
-			set_page_dirty(page);
-			ClearPageReclaim(page);
-		}
-	}
+	if (ctx->sis != sis)
+		return false;
 
-	for (p = 0; p < sio->nr_bvecs; p++)
-		end_page_writeback(sio->bvecs[p].bv_page);
+	if (sis->flags & SWP_FS_OPS) {
+		if (swap_dev_pos(folio->swap) !=
+		    swap_dev_pos(prev_folio->swap) + prev_folio_size)
+			return false;
+	} else {
+		if (swap_folio_sector(folio) !=
+		    swap_folio_sector(prev_folio) +
+		    (prev_folio_size >> SECTOR_SHIFT))
+			return false;
+		if (rw == WRITE && !folio_blkg_can_merge(folio, prev_folio))
+			return false;
+	}
 
-	mempool_free(sio, sio_pool);
+	return true;
 }
 
-static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *folio)
+static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 {
-	struct swap_iocb *sio = ctx->sio;
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct file *swap_file = sis->swap_file;
-	loff_t pos = swap_dev_pos(folio->swap);
+	struct swap_iocb *sio = ctx->sio;
 
-	count_swpout_vm_event(folio);
-	folio_start_writeback(folio);
-	folio_unlock(folio);
-	if (sio) {
-		if (sio->iocb.ki_filp != swap_file ||
-		    sio->iocb.ki_pos + sio->len != pos) {
+	if (sio && !swap_can_merge(ctx, folio, rw)) {
+		if (rw == WRITE)
 			swap_write_submit(ctx);
-			sio = NULL;
-		}
+		else
+			swap_read_submit(ctx);
+		sio = ctx->sio;
 	}
+
 	if (!sio) {
-		sio = mempool_alloc(sio_pool, GFP_NOIO);
-		init_sync_kiocb(&sio->iocb, swap_file);
-		sio->iocb.ki_complete = sio_write_complete;
-		sio->iocb.ki_pos = pos;
+		ctx->sis = sis;
+		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
 		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
-		swap_write_submit(ctx);
-		sio = NULL;
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+		if (rw == WRITE)
+			swap_write_submit(ctx);
+		else
+			swap_read_submit(ctx);
 	}
-	ctx->sio = sio;
 }
 
-static void swap_writepage_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio_vec bv;
-	struct bio bio;
-
-	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_WRITE | REQ_SWAP);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
-	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
-
-	bio_associate_blkg_from_page(&bio, folio);
-	count_swpout_vm_event(folio);
-
-	folio_start_writeback(folio);
-	folio_unlock(folio);
-
-	submit_bio_wait(&bio);
-	__end_swap_bio_write(&bio);
-}
-
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
-	struct bio *bio;
-
-	bio = bio_alloc(sis->bdev, 1, REQ_OP_WRITE | REQ_SWAP, GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_folio_sector(folio);
-	bio->bi_end_io = end_swap_bio_write;
-	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
 	folio_unlock(folio);
-	submit_bio(bio);
-}
-
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-
-	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(ctx, folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
-	 * is safe.
-	 */
-	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, sis);
-	else
-		swap_writepage_bdev_async(folio, sis);
-}
-
-void swap_write_submit(struct swap_io_ctx *ctx)
-{
-	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter from;
-	int ret;
-
-	if (!sio)
-		return;
-
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
-	if (ret != -EIOCBQUEUED)
-		sio_write_complete(&sio->iocb, ret);
-	ctx->sio = NULL;
-}
-
-static void sio_read_complete(struct kiocb *iocb, long ret)
-{
-	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	int p;
-
-	if (ret == sio->len) {
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			struct folio *folio = bvec_folio(&sio->bvecs[p]);
-
-			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-			folio_mark_uptodate(folio);
-			folio_unlock(folio);
-		}
-		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
-	} else {
-		for (p = 0; p < sio->nr_bvecs; p++) {
-			struct folio *folio = bvec_folio(&sio->bvecs[p]);
-
-			folio_unlock(folio);
-		}
-		pr_alert_ratelimited("Read-error on swap-device\n");
-	}
-	mempool_free(sio, sio_pool);
+	swap_add_folio(ctx, folio, WRITE);
 }
 
 /*
@@ -590,74 +466,6 @@ static bool swap_read_folio_zeromap(stru
 	return true;
 }
 
-static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *folio)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct swap_iocb *sio = ctx->sio;
-	loff_t pos = swap_dev_pos(folio->swap);
-
-	if (sio) {
-		if (sio->iocb.ki_filp != sis->swap_file ||
-		    sio->iocb.ki_pos + sio->len != pos) {
-			swap_read_submit(ctx);
-			sio = NULL;
-		}
-	}
-	if (!sio) {
-		sio = mempool_alloc(sio_pool, GFP_KERNEL);
-		init_sync_kiocb(&sio->iocb, sis->swap_file);
-		sio->iocb.ki_pos = pos;
-		sio->iocb.ki_complete = sio_read_complete;
-		sio->nr_bvecs = 0;
-		sio->len = 0;
-	}
-	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
-	sio->len += folio_size(folio);
-	sio->nr_bvecs += 1;
-	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
-		swap_read_submit(ctx);
-		sio = NULL;
-	}
-	ctx->sio = sio;
-}
-
-static void swap_read_folio_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio_vec bv;
-	struct bio bio;
-
-	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
-	bio.bi_iter.bi_sector = swap_folio_sector(folio);
-	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
-	/*
-	 * Keep this task valid during swap readpage because the oom killer may
-	 * attempt to access it in the page fault retry time check.
-	 */
-	get_task_struct(current);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-	count_vm_events(PSWPIN, folio_nr_pages(folio));
-	submit_bio_wait(&bio);
-	__end_swap_bio_read(&bio);
-	put_task_struct(current);
-}
-
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
-{
-	struct bio *bio;
-
-	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_folio_sector(folio);
-	bio->bi_end_io = end_swap_bio_read;
-	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
-	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
-	count_vm_events(PSWPIN, folio_nr_pages(folio));
-	submit_bio(bio);
-}
-
 void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -691,14 +499,7 @@ void swap_read_folio(struct swap_io_ctx
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(ctx, folio);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
-	} else {
-		swap_read_folio_bdev_async(folio, sis);
-	}
+	swap_add_folio(ctx, folio, READ);
 
 finish:
 	if (workingset) {
@@ -708,18 +509,189 @@ finish:
 	delayacct_swapin_end();
 }
 
-void swap_read_submit(struct swap_io_ctx *ctx)
+static void swap_write_end(struct swap_iocb *sio, bool failed)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_bvecs; p++) {
+		struct page *page = sio->bvecs[p].bv_page;
+
+		if (failed) {
+			set_page_dirty(page);
+			ClearPageReclaim(page);
+		}
+		end_page_writeback(page);
+	}
+	mempool_free(sio, sio_pool);
+}
+
+static void swap_fs_write_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	bool failed = ret != sio->len;
+
+	if (failed) {
+		struct page *page = sio->bvecs[0].bv_page;
+
+		/*
+		 * In the case of swap-over-nfs, this can be a temporary failure
+		 * if the system has limited memory for allocating transmit
+		 * buffers.  Mark the page dirty and avoid
+		 * folio_rotate_reclaimable but rate-limit the messages.
+		 */
+		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
+				   ret, swap_dev_pos(page_swap_entry(page)));
+	}
+
+	swap_write_end(sio, failed);
+}
+
+static void end_swap_bio_write(struct bio *bio)
+{
+	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
+	bool failed = !!bio->bi_status;
+
+	if (failed)
+		pr_alert_ratelimited("Write-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
+	bio_uninit(bio);
+	swap_write_end(sio, failed);
+}
+
+static void swap_read_end(struct swap_iocb *sio, bool failed)
+{
+	int p;
+
+	for (p = 0; p < sio->nr_bvecs; p++) {
+		struct folio *folio = bvec_folio(&sio->bvecs[p]);
+
+		if (!failed) {
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
+			count_memcg_folio_events(folio, PSWPIN,
+					folio_nr_pages(folio));
+			folio_mark_uptodate(folio);
+		}
+		folio_unlock(folio);
+	}
+
+	if (!failed)
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
+
+	mempool_free(sio, sio_pool);
+}
+
+static void swap_fs_read_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	bool failed = ret != sio->len;
+
+	if (failed)
+		pr_alert_ratelimited("Read-error on swap-device\n");
+	swap_read_end(sio, failed);
+}
+
+static void swap_bio_read_end_io(struct bio *bio)
+{
+	struct swap_iocb *sio = container_of(bio, struct swap_iocb, bio);
+	bool failed = !!bio->bi_status;
+
+	if (failed)
+		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
+				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
+				     (unsigned long long)bio->bi_iter.bi_sector);
+	bio_uninit(bio);
+	swap_read_end(sio, failed);
+}
+
+static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct bio *bio = &sio->bio;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
+			REQ_OP_WRITE | REQ_SWAP);
+	bio->bi_iter.bi_size = sio->len;
+	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+
+	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
+		submit_bio_wait(bio);
+		end_swap_bio_write(bio);
+	} else {
+		bio->bi_end_io = end_swap_bio_write;
+		submit_bio(bio);
+	}
+}
+
+static void swap_bdev_submit_read(struct swap_io_ctx *ctx)
 {
 	struct swap_iocb *sio = ctx->sio;
-	struct iov_iter from;
+	struct bio *bio = &sio->bio;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
+			REQ_OP_READ);
+	bio->bi_iter.bi_size = sio->len;
+	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
+
+	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
+		/*
+		 * Keep this task valid during swap readpage because the oom
+		 * killer may attempt to access it in the page fault retry
+		 * time check.
+		 */
+		get_task_struct(current);
+		submit_bio_wait(bio);
+		swap_bio_read_end_io(bio);
+		put_task_struct(current);
+	} else {
+		bio->bi_end_io = swap_bio_read_end_io;
+		submit_bio(bio);
+	}
+}
+
+static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
+{
+	struct swap_iocb *sio = ctx->sio;
+	struct iov_iter iter;
 	int ret;
 
-	if (!sio)
-		return;
+	init_sync_kiocb(&sio->iocb, ctx->sis->swap_file);
+	sio->iocb.ki_pos = swap_dev_pos(bvec_folio(&sio->bvecs[0])->swap);
+	if (rw == WRITE)
+		sio->iocb.ki_complete = swap_fs_write_complete;
+	else
+		sio->iocb.ki_complete = swap_fs_read_complete;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
-	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &from);
+	iov_iter_bvec(&iter, rw == WRITE ? ITER_SOURCE : ITER_DEST,
+			sio->bvecs, sio->nr_bvecs, sio->len);
+	ret = sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, &iter);
 	if (ret != -EIOCBQUEUED)
-		sio_read_complete(&sio->iocb, ret);
+		sio->iocb.ki_complete(&sio->iocb, ret);
+}
+
+void swap_write_submit(struct swap_io_ctx *ctx)
+{
+	if (!ctx->sio)
+		return;
+
+	if (ctx->sis->flags & SWP_FS_OPS)
+		swap_fs_submit(ctx, WRITE);
+	else
+		swap_bdev_submit_write(ctx);
+	ctx->sio = NULL;
+	ctx->sis = NULL;
+}
+
+void swap_read_submit(struct swap_io_ctx *ctx)
+{
+	if (!ctx->sio)
+		return;
+
+	if (ctx->sis->flags & SWP_FS_OPS)
+		swap_fs_submit(ctx, READ);
+	else
+		swap_bdev_submit_read(ctx);
 	ctx->sio = NULL;
+	ctx->sis = NULL;
 }
--- a/mm/swapfile.c~mm-swap-also-use-struct-swap_iocb-for-block-i-o
+++ a/mm/swapfile.c
@@ -2946,6 +2946,10 @@ static int setup_swap_extents(struct swa
 	struct inode *inode = mapping->host;
 	int ret;
 
+	ret = sio_pool_init();
+	if (ret)
+		return ret;
+
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
@@ -2957,11 +2961,6 @@ static int setup_swap_extents(struct swa
 		if (ret < 0)
 			return ret;
 		sis->flags |= SWP_ACTIVATED;
-		if ((sis->flags & SWP_FS_OPS) &&
-		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis, swap_file);
-			return -ENOMEM;
-		}
 		return ret;
 	}
 
--- a/mm/swap.h~mm-swap-also-use-struct-swap_iocb-for-block-i-o
+++ a/mm/swap.h
@@ -79,6 +79,7 @@ enum swap_cluster_flags {
 
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
 };
 
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

