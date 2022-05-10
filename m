Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF9BC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbiEJEVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19062AD74F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3B16176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E105CC385A6;
        Tue, 10 May 2022 04:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156115;
        bh=maom2tA9/lhX52i0hfKtUhWNKM+V3E55dgZr5FsjNUU=;
        h=Date:To:From:Subject:From;
        b=KSwVRzfeSG64LDcuQFAh2dmnDDmH6P3jPLpnNanaKJjpMblu0/WLCgDaeE/VS84pY
         YTDU8FIMG3R9zIOpkNpjg/GhAq/kIflaDnTn/dVkfmQaAioJam02EQ2H9AWwQ8ANR+
         GYpzXCF3weDBMbUN/66+rRl8Iyo7uuvy4gQrNBBo=
Date:   Mon, 09 May 2022 21:15:14 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch removed from -mm tree
Message-Id: <20220510041514.E105CC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: perform async writes to SWP_FS_OPS swap-space using ->swap_rw
has been removed from the -mm tree.  Its filename was
     mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: perform async writes to SWP_FS_OPS swap-space using ->swap_rw

This patch switches swap-out to SWP_FS_OPS swap-spaces to use ->swap_rw
and makes the writes asynchronous, like they are for other swap spaces.

To make it async we need to allocate the kiocb struct from a mempool. 
This may block, but won't block as long as waiting for the write to
complete.  At most it will wait for some previous swap IO to complete.

Link: https://lkml.kernel.org/r/164859778126.29473.12399585304843922231.stgit@noble.brown
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

 mm/page_io.c |   98 +++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 40 deletions(-)

--- a/mm/page_io.c~mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw
+++ a/mm/page_io.c
@@ -254,6 +254,57 @@ int sio_pool_init(void)
 	return 0;
 }
 
+static void sio_write_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	struct page *page = sio->bvec.bv_page;
+
+	if (ret != PAGE_SIZE) {
+		/*
+		 * In the case of swap-over-nfs, this can be a
+		 * temporary failure if the system has limited
+		 * memory for allocating transmit buffers.
+		 * Mark the page dirty and avoid
+		 * folio_rotate_reclaimable but rate-limit the
+		 * messages but do not flag PageError like
+		 * the normal direct-to-bio case as it could
+		 * be temporary.
+		 */
+		set_page_dirty(page);
+		ClearPageReclaim(page);
+		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
+				   ret, page_file_offset(page));
+	} else
+		count_vm_event(PSWPOUT);
+	end_page_writeback(page);
+	mempool_free(sio, sio_pool);
+}
+
+static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
+{
+	struct swap_iocb *sio;
+	struct swap_info_struct *sis = page_swap_info(page);
+	struct file *swap_file = sis->swap_file;
+	struct address_space *mapping = swap_file->f_mapping;
+	struct iov_iter from;
+	int ret;
+
+	set_page_writeback(page);
+	unlock_page(page);
+	sio = mempool_alloc(sio_pool, GFP_NOIO);
+	init_sync_kiocb(&sio->iocb, swap_file);
+	sio->iocb.ki_complete = sio_write_complete;
+	sio->iocb.ki_pos = page_file_offset(page);
+	sio->bvec.bv_page = page;
+	sio->bvec.bv_len = PAGE_SIZE;
+	sio->bvec.bv_offset = 0;
+	iov_iter_bvec(&from, WRITE, &sio->bvec, 1, PAGE_SIZE);
+	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	if (ret != -EIOCBQUEUED)
+		sio_write_complete(&sio->iocb, ret);
+	return ret;
+}
+
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
@@ -262,46 +313,13 @@ int __swap_writepage(struct page *page,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		struct kiocb kiocb;
-		struct file *swap_file = sis->swap_file;
-		struct address_space *mapping = swap_file->f_mapping;
-		struct bio_vec bv = {
-			.bv_page = page,
-			.bv_len  = PAGE_SIZE,
-			.bv_offset = 0
-		};
-		struct iov_iter from;
-
-		iov_iter_bvec(&from, WRITE, &bv, 1, PAGE_SIZE);
-		init_sync_kiocb(&kiocb, swap_file);
-		kiocb.ki_pos = page_file_offset(page);
-
-		set_page_writeback(page);
-		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(&kiocb, &from);
-		if (ret == PAGE_SIZE) {
-			count_vm_event(PSWPOUT);
-			ret = 0;
-		} else {
-			/*
-			 * In the case of swap-over-nfs, this can be a
-			 * temporary failure if the system has limited
-			 * memory for allocating transmit buffers.
-			 * Mark the page dirty and avoid
-			 * folio_rotate_reclaimable but rate-limit the
-			 * messages but do not flag PageError like
-			 * the normal direct-to-bio case as it could
-			 * be temporary.
-			 */
-			set_page_dirty(page);
-			ClearPageReclaim(page);
-			pr_err_ratelimited("Write error on dio swapfile (%llu)\n",
-					   page_file_offset(page));
-		}
-		end_page_writeback(page);
-		return ret;
-	}
+	/*
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_FS_OPS, so the data_race
+	 * is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		return swap_writepage_fs(page, wbc);
 
 	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
 	if (!ret) {
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

