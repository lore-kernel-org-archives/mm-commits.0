Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B44C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiEJEVy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439C32AD762
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4D726176D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25542C385C2;
        Tue, 10 May 2022 04:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156118;
        bh=zULtjfmYuRcFJFusxS1V961ue3PtyZ5K9HvkSecRQx4=;
        h=Date:To:From:Subject:From;
        b=alF3MK5Mmf15vyVhTghBeR6abkC1LUFpp4BHnU6YJEr8Il8uAW1Kh0MsaZuFuColm
         itdsyxCJ9lY8d8opUQT2meONdQrY2IHMno7xZW/ghFn1QSxVsSmblQO/BQBkUsgYm+
         LzJNrp21hOkMnn1V3l+OoSY+K1+BALbRjaGsg0DU=
Date:   Mon, 09 May 2022 21:15:17 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch removed from -mm tree
Message-Id: <20220510041518.25542C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: submit multipage write for SWP_FS_OPS swap-space
has been removed from the -mm tree.  Its filename was
     mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: submit multipage write for SWP_FS_OPS swap-space

swap_writepage() is given one page at a time, but may be called repeatedly
in succession.

For block-device swapspace, the blk_plug functionality allows the multiple
pages to be combined together at lower layers.  That cannot be used for
SWP_FS_OPS as blk_plug may not exist - it is only active when
CONFIG_BLOCK=y.  Consequently all swap reads over NFS are single page
reads.

With this patch we pass a pointer-to-pointer via the wbc.  swap_writepage
can store state between calls - much like the pointer passed explicitly to
swap_readpage.  After calling swap_writepage() some number of times, the
state will be passed to swap_write_unplug() which can submit the combined
request.

Link: https://lkml.kernel.org/r/164859778128.29473.5191868522654408537.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    7 +++
 mm/page_io.c              |   78 +++++++++++++++++++++++++-----------
 mm/swap.h                 |    4 +
 mm/vmscan.c               |    9 +++-
 4 files changed, 74 insertions(+), 24 deletions(-)

--- a/include/linux/writeback.h~mm-submit-multipage-write-for-swp_fs_ops-swap-space
+++ a/include/linux/writeback.h
@@ -80,6 +80,13 @@ struct writeback_control {
 
 	unsigned punt_to_cgroup:1;	/* cgrp punting, see __REQ_CGROUP_PUNT */
 
+	/* To enable batching of swap writes to non-block-device backends,
+	 * "plug" can be set point to a 'struct swap_iocb *'.  When all swap
+	 * writes have been submitted, if with swap_iocb is not NULL,
+	 * swap_write_unplug() should be called.
+	 */
+	struct swap_iocb **swap_plug;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct bdi_writeback *wb;	/* wb this writeback is issued under */
 	struct inode *inode;		/* inode being written out */
--- a/mm/page_io.c~mm-submit-multipage-write-for-swp_fs_ops-swap-space
+++ a/mm/page_io.c
@@ -259,8 +259,9 @@ static void sio_write_complete(struct ki
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
 	struct page *page = sio->bvec[0].bv_page;
+	int p;
 
-	if (ret != PAGE_SIZE) {
+	if (ret != PAGE_SIZE * sio->pages) {
 		/*
 		 * In the case of swap-over-nfs, this can be a
 		 * temporary failure if the system has limited
@@ -271,43 +272,63 @@ static void sio_write_complete(struct ki
 		 * the normal direct-to-bio case as it could
 		 * be temporary.
 		 */
-		set_page_dirty(page);
-		ClearPageReclaim(page);
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret, page_file_offset(page));
+		for (p = 0; p < sio->pages; p++) {
+			page = sio->bvec[p].bv_page;
+			set_page_dirty(page);
+			ClearPageReclaim(page);
+		}
 	} else
-		count_vm_event(PSWPOUT);
-	end_page_writeback(page);
+		count_vm_events(PSWPOUT, sio->pages);
+
+	for (p = 0; p < sio->pages; p++)
+		end_page_writeback(sio->bvec[p].bv_page);
+
 	mempool_free(sio, sio_pool);
 }
 
 static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 {
-	struct swap_iocb *sio;
+	struct swap_iocb *sio = NULL;
 	struct swap_info_struct *sis = page_swap_info(page);
 	struct file *swap_file = sis->swap_file;
-	struct address_space *mapping = swap_file->f_mapping;
-	struct iov_iter from;
-	int ret;
+	loff_t pos = page_file_offset(page);
 
 	set_page_writeback(page);
 	unlock_page(page);
-	sio = mempool_alloc(sio_pool, GFP_NOIO);
-	init_sync_kiocb(&sio->iocb, swap_file);
-	sio->iocb.ki_complete = sio_write_complete;
-	sio->iocb.ki_pos = page_file_offset(page);
-	sio->bvec[0].bv_page = page;
-	sio->bvec[0].bv_len = PAGE_SIZE;
-	sio->bvec[0].bv_offset = 0;
-	iov_iter_bvec(&from, WRITE, &sio->bvec[0], 1, PAGE_SIZE);
-	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
-	if (ret != -EIOCBQUEUED)
-		sio_write_complete(&sio->iocb, ret);
-	return ret;
+	if (wbc->swap_plug)
+		sio = *wbc->swap_plug;
+	if (sio) {
+		if (sio->iocb.ki_filp != swap_file ||
+		    sio->iocb.ki_pos + sio->pages * PAGE_SIZE != pos) {
+			swap_write_unplug(sio);
+			sio = NULL;
+		}
+	}
+	if (!sio) {
+		sio = mempool_alloc(sio_pool, GFP_NOIO);
+		init_sync_kiocb(&sio->iocb, swap_file);
+		sio->iocb.ki_complete = sio_write_complete;
+		sio->iocb.ki_pos = pos;
+		sio->pages = 0;
+	}
+	sio->bvec[sio->pages].bv_page = page;
+	sio->bvec[sio->pages].bv_len = PAGE_SIZE;
+	sio->bvec[sio->pages].bv_offset = 0;
+	sio->pages += 1;
+	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
+		swap_write_unplug(sio);
+		sio = NULL;
+	}
+	if (wbc->swap_plug)
+		*wbc->swap_plug = sio;
+
+	return 0;
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
-		bio_end_io_t end_write_func)
+		     bio_end_io_t end_write_func)
 {
 	struct bio *bio;
 	int ret;
@@ -344,6 +365,19 @@ int __swap_writepage(struct page *page,
 	return 0;
 }
 
+void swap_write_unplug(struct swap_iocb *sio)
+{
+	struct iov_iter from;
+	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
+	int ret;
+
+	iov_iter_bvec(&from, WRITE, sio->bvec, sio->pages,
+		      PAGE_SIZE * sio->pages);
+	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	if (ret != -EIOCBQUEUED)
+		sio_write_complete(&sio->iocb, ret);
+}
+
 static void sio_read_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
--- a/mm/swap.h~mm-submit-multipage-write-for-swp_fs_ops-swap-space
+++ a/mm/swap.h
@@ -16,6 +16,7 @@ static inline void swap_read_unplug(stru
 	if (unlikely(plug))
 		__swap_read_unplug(plug);
 }
+void swap_write_unplug(struct swap_iocb *sio);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
 void end_swap_bio_write(struct bio *bio);
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
@@ -71,6 +72,9 @@ static inline int swap_readpage(struct p
 {
 	return 0;
 }
+static inline void swap_write_unplug(struct swap_iocb *sio)
+{
+}
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
--- a/mm/vmscan.c~mm-submit-multipage-write-for-swp_fs_ops-swap-space
+++ a/mm/vmscan.c
@@ -1156,7 +1156,8 @@ typedef enum {
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
  */
-static pageout_t pageout(struct folio *folio, struct address_space *mapping)
+static pageout_t pageout(struct folio *folio, struct address_space *mapping,
+			 struct swap_iocb **plug)
 {
 	/*
 	 * If the folio is dirty, only perform writeback if that write
@@ -1201,6 +1202,7 @@ static pageout_t pageout(struct folio *f
 			.range_start = 0,
 			.range_end = LLONG_MAX,
 			.for_reclaim = 1,
+			.swap_plug = plug,
 		};
 
 		folio_set_reclaim(folio);
@@ -1533,6 +1535,7 @@ static unsigned int shrink_page_list(str
 	unsigned int nr_reclaimed = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
+	struct swap_iocb *plug = NULL;
 
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
@@ -1814,7 +1817,7 @@ retry:
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(folio, mapping)) {
+			switch (pageout(folio, mapping, &plug)) {
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -1968,6 +1971,8 @@ keep:
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 
+	if (plug)
+		swap_write_unplug(plug);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

