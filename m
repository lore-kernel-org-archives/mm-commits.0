Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9227C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiCaEXm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiCaEXd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:23:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC61A9487
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3672B81EA0
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E2AC340EC;
        Thu, 31 Mar 2022 02:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695385;
        bh=nYCLVh1inDygAsNiuFnkcOJDRHRLAm8ryeNkgEk2gXA=;
        h=Date:To:From:Subject:From;
        b=0MvpLd2eznZUqk8G6XfYnAxTeuoaIzpU5tjK0sq5xcKG3kF0VDTG9rKxtne885EpA
         hnLdsdeFF8NjShqu7JKBTQeuUfZU+9PDe96MyZElP+zkB3EdgYoHd+dU9DwzMZZPzg
         7hkJ5v8K8BUkLycCWW9SR88Vp5z2qXhIs3gyc2Xk=
Date:   Wed, 30 Mar 2022 19:56:25 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch added to -mm tree
Message-Id: <20220331025625.A1E2AC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: submit multipage reads for SWP_FS_OPS swap-space
has been added to the -mm tree.  Its filename is
     mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: submit multipage reads for SWP_FS_OPS swap-space

swap_readpage() is given one page at a time, but may be called repeatedly
in succession.

For block-device swap-space, the blk_plug functionality allows the
multiple pages to be combined together at lower layers.  That cannot be
used for SWP_FS_OPS as blk_plug may not exist - it is only active when
CONFIG_BLOCK=y.  Consequently all swap reads over NFS are single page
reads.

With this patch we pass in a pointer-to-pointer when swap_readpage can
store state between calls - much like the effect of blk_plug.  After
calling swap_readpage() some number of times, the state will be passed to
swap_read_unplug() which can submit the combined request.

Link: https://lkml.kernel.org/r/164859778127.29473.14059420492644907783.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c    |    8 ++-
 mm/memory.c     |    2 
 mm/page_io.c    |  104 ++++++++++++++++++++++++++++++----------------
 mm/swap.h       |   17 ++++++-
 mm/swap_state.c |   20 ++++++--
 5 files changed, 104 insertions(+), 47 deletions(-)

--- a/mm/madvise.c~mm-submit-multipage-reads-for-swp_fs_ops-swap-space
+++ a/mm/madvise.c
@@ -198,6 +198,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 	pte_t *orig_pte;
 	struct vm_area_struct *vma = walk->private;
 	unsigned long index;
+	struct swap_iocb *splug = NULL;
 
 	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 		return 0;
@@ -219,10 +220,11 @@ static int swapin_walk_pmd_entry(pmd_t *
 			continue;
 
 		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-							vma, index, false);
+					     vma, index, false, &splug);
 		if (page)
 			put_page(page);
 	}
+	swap_read_unplug(splug);
 
 	return 0;
 }
@@ -238,6 +240,7 @@ static void force_shm_swapin_readahead(s
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
 	pgoff_t end_index = linear_page_index(vma, end + PAGE_SIZE - 1);
 	struct page *page;
+	struct swap_iocb *splug = NULL;
 
 	rcu_read_lock();
 	xas_for_each(&xas, page, end_index) {
@@ -250,13 +253,14 @@ static void force_shm_swapin_readahead(s
 
 		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
-							NULL, 0, false);
+					     NULL, 0, false, &splug);
 		if (page)
 			put_page(page);
 
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
+	swap_read_unplug(splug);
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 }
--- a/mm/memory.c~mm-submit-multipage-reads-for-swp_fs_ops-swap-space
+++ a/mm/memory.c
@@ -3586,7 +3586,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 				/* To provide entry to swap_readpage() */
 				set_page_private(page, entry.val);
-				swap_readpage(page, true);
+				swap_readpage(page, true, NULL);
 				set_page_private(page, 0);
 			}
 		} else {
--- a/mm/page_io.c~mm-submit-multipage-reads-for-swp_fs_ops-swap-space
+++ a/mm/page_io.c
@@ -237,7 +237,8 @@ static void bio_associate_blkg_from_page
 
 struct swap_iocb {
 	struct kiocb		iocb;
-	struct bio_vec		bvec;
+	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
+	int			pages;
 };
 static mempool_t *sio_pool;
 
@@ -257,7 +258,7 @@ int sio_pool_init(void)
 static void sio_write_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec.bv_page;
+	struct page *page = sio->bvec[0].bv_page;
 
 	if (ret != PAGE_SIZE) {
 		/*
@@ -295,10 +296,10 @@ static int swap_writepage_fs(struct page
 	init_sync_kiocb(&sio->iocb, swap_file);
 	sio->iocb.ki_complete = sio_write_complete;
 	sio->iocb.ki_pos = page_file_offset(page);
-	sio->bvec.bv_page = page;
-	sio->bvec.bv_len = PAGE_SIZE;
-	sio->bvec.bv_offset = 0;
-	iov_iter_bvec(&from, WRITE, &sio->bvec, 1, PAGE_SIZE);
+	sio->bvec[0].bv_page = page;
+	sio->bvec[0].bv_len = PAGE_SIZE;
+	sio->bvec[0].bv_offset = 0;
+	iov_iter_bvec(&from, WRITE, &sio->bvec[0], 1, PAGE_SIZE);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -346,46 +347,66 @@ int __swap_writepage(struct page *page,
 static void sio_read_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec.bv_page;
+	int p;
 
-	if (ret != 0 && ret != PAGE_SIZE) {
-		SetPageError(page);
-		ClearPageUptodate(page);
-		pr_alert_ratelimited("Read-error on swap-device\n");
+	if (ret == PAGE_SIZE * sio->pages) {
+		for (p = 0; p < sio->pages; p++) {
+			struct page *page = sio->bvec[p].bv_page;
+
+			SetPageUptodate(page);
+			unlock_page(page);
+		}
+		count_vm_events(PSWPIN, sio->pages);
 	} else {
-		SetPageUptodate(page);
-		count_vm_event(PSWPIN);
+		for (p = 0; p < sio->pages; p++) {
+			struct page *page = sio->bvec[p].bv_page;
+
+			SetPageError(page);
+			ClearPageUptodate(page);
+			unlock_page(page);
+		}
+		pr_alert_ratelimited("Read-error on swap-device\n");
 	}
-	unlock_page(page);
 	mempool_free(sio, sio_pool);
 }
 
-static int swap_readpage_fs(struct page *page)
+static void swap_readpage_fs(struct page *page,
+			     struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = page_swap_info(page);
-	struct file *swap_file = sis->swap_file;
-	struct address_space *mapping = swap_file->f_mapping;
-	struct iov_iter from;
-	struct swap_iocb *sio;
+	struct swap_iocb *sio = NULL;
 	loff_t pos = page_file_offset(page);
-	int ret;
-
-	sio = mempool_alloc(sio_pool, GFP_KERNEL);
-	init_sync_kiocb(&sio->iocb, swap_file);
-	sio->iocb.ki_pos = pos;
-	sio->iocb.ki_complete = sio_read_complete;
-	sio->bvec.bv_page = page;
-	sio->bvec.bv_len = PAGE_SIZE;
-	sio->bvec.bv_offset = 0;
 
-	iov_iter_bvec(&from, READ, &sio->bvec, 1, PAGE_SIZE);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
-	if (ret != -EIOCBQUEUED)
-		sio_read_complete(&sio->iocb, ret);
-	return ret;
+	if (plug)
+		sio = *plug;
+	if (sio) {
+		if (sio->iocb.ki_filp != sis->swap_file ||
+		    sio->iocb.ki_pos + sio->pages * PAGE_SIZE != pos) {
+			swap_read_unplug(sio);
+			sio = NULL;
+		}
+	}
+	if (!sio) {
+		sio = mempool_alloc(sio_pool, GFP_KERNEL);
+		init_sync_kiocb(&sio->iocb, sis->swap_file);
+		sio->iocb.ki_pos = pos;
+		sio->iocb.ki_complete = sio_read_complete;
+		sio->pages = 0;
+	}
+	sio->bvec[sio->pages].bv_page = page;
+	sio->bvec[sio->pages].bv_len = PAGE_SIZE;
+	sio->bvec[sio->pages].bv_offset = 0;
+	sio->pages += 1;
+	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
+		swap_read_unplug(sio);
+		sio = NULL;
+	}
+	if (plug)
+		*plug = sio;
 }
 
-int swap_readpage(struct page *page, bool synchronous)
+int swap_readpage(struct page *page, bool synchronous,
+		  struct swap_iocb **plug)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -413,7 +434,7 @@ int swap_readpage(struct page *page, boo
 	}
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
-		ret = swap_readpage_fs(page);
+		swap_readpage_fs(page, plug);
 		goto out;
 	}
 
@@ -459,3 +480,16 @@ out:
 	delayacct_swapin_end();
 	return ret;
 }
+
+void __swap_read_unplug(struct swap_iocb *sio)
+{
+	struct iov_iter from;
+	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
+	int ret;
+
+	iov_iter_bvec(&from, READ, sio->bvec, sio->pages,
+		      PAGE_SIZE * sio->pages);
+	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	if (ret != -EIOCBQUEUED)
+		sio_read_complete(&sio->iocb, ret);
+}
--- a/mm/swap.h~mm-submit-multipage-reads-for-swp_fs_ops-swap-space
+++ a/mm/swap.h
@@ -7,7 +7,15 @@
 
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
-int swap_readpage(struct page *page, bool do_poll);
+struct swap_iocb;
+int swap_readpage(struct page *page, bool do_poll,
+		  struct swap_iocb **plug);
+void __swap_read_unplug(struct swap_iocb *plug);
+static inline void swap_read_unplug(struct swap_iocb *plug)
+{
+	if (unlikely(plug))
+		__swap_read_unplug(plug);
+}
 int swap_writepage(struct page *page, struct writeback_control *wbc);
 void end_swap_bio_write(struct bio *bio);
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
@@ -41,7 +49,8 @@ struct page *find_get_incore_page(struct
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				   struct vm_area_struct *vma,
 				   unsigned long addr,
-				   bool do_poll);
+				   bool do_poll,
+				   struct swap_iocb **plug);
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 				     struct vm_area_struct *vma,
 				     unsigned long addr,
@@ -56,7 +65,9 @@ static inline unsigned int page_swap_fla
 	return page_swap_info(page)->flags;
 }
 #else /* CONFIG_SWAP */
-static inline int swap_readpage(struct page *page, bool do_poll)
+struct swap_iocb;
+static inline int swap_readpage(struct page *page, bool do_poll,
+				struct swap_iocb **plug)
 {
 	return 0;
 }
--- a/mm/swap_state.c~mm-submit-multipage-reads-for-swp_fs_ops-swap-space
+++ a/mm/swap_state.c
@@ -520,14 +520,16 @@ fail_unlock:
  * the swap entry is no longer in use.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-		struct vm_area_struct *vma, unsigned long addr, bool do_poll)
+				   struct vm_area_struct *vma,
+				   unsigned long addr, bool do_poll,
+				   struct swap_iocb **plug)
 {
 	bool page_was_allocated;
 	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
 			vma, addr, &page_was_allocated);
 
 	if (page_was_allocated)
-		swap_readpage(retpage, do_poll);
+		swap_readpage(retpage, do_poll, plug);
 
 	return retpage;
 }
@@ -621,6 +623,7 @@ struct page *swap_cluster_readahead(swp_
 	unsigned long mask;
 	struct swap_info_struct *si = swp_swap_info(entry);
 	struct blk_plug plug;
+	struct swap_iocb *splug = NULL;
 	bool do_poll = true, page_allocated;
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address;
@@ -647,7 +650,7 @@ struct page *swap_cluster_readahead(swp_
 		if (!page)
 			continue;
 		if (page_allocated) {
-			swap_readpage(page, false);
+			swap_readpage(page, false, &splug);
 			if (offset != entry_offset) {
 				SetPageReadahead(page);
 				count_vm_event(SWAP_RA);
@@ -656,10 +659,12 @@ struct page *swap_cluster_readahead(swp_
 		put_page(page);
 	}
 	blk_finish_plug(&plug);
+	swap_read_unplug(splug);
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
-	return read_swap_cache_async(entry, gfp_mask, vma, addr, do_poll);
+	/* The page was likely read above, so no need for plugging here */
+	return read_swap_cache_async(entry, gfp_mask, vma, addr, do_poll, NULL);
 }
 
 int init_swap_address_space(unsigned int type, unsigned long nr_pages)
@@ -790,6 +795,7 @@ static struct page *swap_vma_readahead(s
 				       struct vm_fault *vmf)
 {
 	struct blk_plug plug;
+	struct swap_iocb *splug = NULL;
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
 	pte_t *pte, pentry;
@@ -820,7 +826,7 @@ static struct page *swap_vma_readahead(s
 		if (!page)
 			continue;
 		if (page_allocated) {
-			swap_readpage(page, false);
+			swap_readpage(page, false, &splug);
 			if (i != ra_info.offset) {
 				SetPageReadahead(page);
 				count_vm_event(SWAP_RA);
@@ -829,10 +835,12 @@ static struct page *swap_vma_readahead(s
 		put_page(page);
 	}
 	blk_finish_plug(&plug);
+	swap_read_unplug(splug);
 	lru_add_drain();
 skip:
+	/* The page was likely read above, so no need for plugging here */
 	return read_swap_cache_async(fentry, gfp_mask, vma, vmf->address,
-				     ra_info.win == 1);
+				     ra_info.win == 1, NULL);
 }
 
 /**
_

Patches currently in -mm which might be from neilb@suse.de are

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

