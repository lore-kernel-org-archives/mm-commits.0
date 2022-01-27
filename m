Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF8EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbiA0Wmn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242688AbiA0Wmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:42:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAC3C061714
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:42:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4914A61C04
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D93C340E4;
        Thu, 27 Jan 2022 22:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323361;
        bh=hhyUUNN9WtM6MYxCY5udEC2Ha06Ttns5AiEIIfOoztA=;
        h=Date:From:To:Subject:From;
        b=lrIq1TLqcncgl5wmJZ3EBVDFo/AYqFKIfWtG0TSSUyS/om1IUkcU+ot61xEwcZ9ke
         CjsQ/8jZ6WlKf0erX3LmP11dFUxiJxh1ICzoiKtuYwKSWmR8OyQ6mMatE1IKBmiuXI
         4jHJYwv4qBvK9pqxf/Or9dHZ2MbWzkd3Xn/EyMvw=
Date:   Thu, 27 Jan 2022 14:42:40 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  + remove-inode_congested.patch added to -mm tree
Message-ID: <20220127224240.005gbfqvU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: remove inode_congested()
has been added to the -mm tree.  Its filename is
     remove-inode_congested.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remove-inode_congested.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remove-inode_congested.patch

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
Subject: mm/fs: remove inode_congested()

Patch series "Remove remaining parts of congestions tracking code".

Congestion hasn't been reliably tracked for quite some time.  Most MM uses
of it for guiding writeback decisions were removed in 5.16.  Some other
uses were removed in 17-rc1.

This series removes the remaining places that test for congestion, and the
few places which still set it.


This patch (of 9):

inode_congested() reports if the backing-device for the inode is
congested.  Few bdi report congestion any more, only ceph, fuse, and nfs. 
Having support just for those is unlikely to be useful.

The places which test inode_congested() or it variants like
inode_write_congested(), avoid initiating IO if congestion is present.  We
now have to rely on other places in the stack to back off, or abort
requests - we already do for everything except these 3 filesystems.

So remove inode_congested() and related functions, and remove the call
sites, assuming that inode_congested() always returns 'false'.

Link: https://lkml.kernel.org/r/164325106958.29787.4865219843242892726.stgit@noble.brown
Link: https://lkml.kernel.org/r/164325158954.29787.7856652136298668100.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   37 ----------------------------------
 include/linux/backing-dev.h |   22 --------------------
 mm/fadvise.c                |    5 +---
 mm/readahead.c              |    6 -----
 mm/vmscan.c                 |   17 ---------------
 5 files changed, 3 insertions(+), 84 deletions(-)

--- a/fs/fs-writeback.c~remove-inode_congested
+++ a/fs/fs-writeback.c
@@ -894,43 +894,6 @@ void wbc_account_cgroup_owner(struct wri
 EXPORT_SYMBOL_GPL(wbc_account_cgroup_owner);
 
 /**
- * inode_congested - test whether an inode is congested
- * @inode: inode to test for congestion (may be NULL)
- * @cong_bits: mask of WB_[a]sync_congested bits to test
- *
- * Tests whether @inode is congested.  @cong_bits is the mask of congestion
- * bits to test and the return value is the mask of set bits.
- *
- * If cgroup writeback is enabled for @inode, the congestion state is
- * determined by whether the cgwb (cgroup bdi_writeback) for the blkcg
- * associated with @inode is congested; otherwise, the root wb's congestion
- * state is used.
- *
- * @inode is allowed to be NULL as this function is often called on
- * mapping->host which is NULL for the swapper space.
- */
-int inode_congested(struct inode *inode, int cong_bits)
-{
-	/*
-	 * Once set, ->i_wb never becomes NULL while the inode is alive.
-	 * Start transaction iff ->i_wb is visible.
-	 */
-	if (inode && inode_to_wb_is_valid(inode)) {
-		struct bdi_writeback *wb;
-		struct wb_lock_cookie lock_cookie = {};
-		bool congested;
-
-		wb = unlocked_inode_to_wb_begin(inode, &lock_cookie);
-		congested = wb_congested(wb, cong_bits);
-		unlocked_inode_to_wb_end(inode, &lock_cookie);
-		return congested;
-	}
-
-	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
-}
-EXPORT_SYMBOL_GPL(inode_congested);
-
-/**
  * wb_split_bdi_pages - split nr_pages to write according to bandwidth
  * @wb: target bdi_writeback to split @nr_pages to
  * @nr_pages: number of pages to write for the whole bdi
--- a/include/linux/backing-dev.h~remove-inode_congested
+++ a/include/linux/backing-dev.h
@@ -162,7 +162,6 @@ struct bdi_writeback *wb_get_create(stru
 				    gfp_t gfp);
 void wb_memcg_offline(struct mem_cgroup *memcg);
 void wb_blkcg_offline(struct blkcg *blkcg);
-int inode_congested(struct inode *inode, int cong_bits);
 
 /**
  * inode_cgwb_enabled - test whether cgroup writeback is enabled on an inode
@@ -390,29 +389,8 @@ static inline void wb_blkcg_offline(stru
 {
 }
 
-static inline int inode_congested(struct inode *inode, int cong_bits)
-{
-	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
-}
-
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static inline int inode_read_congested(struct inode *inode)
-{
-	return inode_congested(inode, 1 << WB_sync_congested);
-}
-
-static inline int inode_write_congested(struct inode *inode)
-{
-	return inode_congested(inode, 1 << WB_async_congested);
-}
-
-static inline int inode_rw_congested(struct inode *inode)
-{
-	return inode_congested(inode, (1 << WB_sync_congested) |
-				      (1 << WB_async_congested));
-}
-
 static inline int bdi_congested(struct backing_dev_info *bdi, int cong_bits)
 {
 	return wb_congested(&bdi->wb, cong_bits);
--- a/mm/fadvise.c~remove-inode_congested
+++ a/mm/fadvise.c
@@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, l
 	case POSIX_FADV_NOREUSE:
 		break;
 	case POSIX_FADV_DONTNEED:
-		if (!inode_write_congested(mapping->host))
-			__filemap_fdatawrite_range(mapping, offset, endbyte,
-						   WB_SYNC_NONE);
+		__filemap_fdatawrite_range(mapping, offset, endbyte,
+					   WB_SYNC_NONE);
 
 		/*
 		 * First and last FULL page! Partial pages are deliberately
--- a/mm/readahead.c~remove-inode_congested
+++ a/mm/readahead.c
@@ -595,12 +595,6 @@ void page_cache_async_ra(struct readahea
 
 	folio_clear_readahead(folio);
 
-	/*
-	 * Defer asynchronous read-ahead on IO congestion.
-	 */
-	if (inode_read_congested(ractl->mapping->host))
-		return;
-
 	if (blk_cgroup_congested())
 		return;
 
--- a/mm/vmscan.c~remove-inode_congested
+++ a/mm/vmscan.c
@@ -989,17 +989,6 @@ static inline int is_page_cache_freeable
 	return page_count(page) - page_has_private(page) == 1 + page_cache_pins;
 }
 
-static int may_write_to_inode(struct inode *inode)
-{
-	if (current->flags & PF_SWAPWRITE)
-		return 1;
-	if (!inode_write_congested(inode))
-		return 1;
-	if (inode_to_bdi(inode) == current->backing_dev_info)
-		return 1;
-	return 0;
-}
-
 /*
  * We detected a synchronous write error writing a page out.  Probably
  * -ENOSPC.  We need to propagate that into the address_space for a subsequent
@@ -1199,8 +1188,6 @@ static pageout_t pageout(struct page *pa
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
-	if (!may_write_to_inode(mapping->host))
-		return PAGE_KEEP;
 
 	if (clear_page_dirty_for_io(page)) {
 		int res;
@@ -1576,9 +1563,7 @@ retry:
 		 * end of the LRU a second time.
 		 */
 		mapping = page_mapping(page);
-		if (((dirty || writeback) && mapping &&
-		     inode_write_congested(mapping->host)) ||
-		    (writeback && PageReclaim(page)))
+		if (writeback && PageReclaim(page))
 			stat->nr_congested++;
 
 		/*
_

Patches currently in -mm which might be from neilb@suse.de are

remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch
f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
cephfs-dont-set-clear-bdi_congestion.patch
fuse-dont-set-clear-bdi_congested.patch
nfs-remove-congestion-control.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

