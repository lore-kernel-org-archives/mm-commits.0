Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F337C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3906F61D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2Ciu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231889AbhF2Cit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95A7561D07;
        Tue, 29 Jun 2021 02:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934181;
        bh=W/1d72ZNpNeqa4y/X3gySA4Yyd+3J/K+J8O8faRHIsM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CRFGWCwjZW2HxcJzABM/aerpHmMalCo460m/aCfUX1V1nAwNU2etXYtbAs6Hqgsvf
         mv9ary88K0rz/sj04Icvx4Hnd4AfHnSxQ8lraASMWOFx2hXPROeVnBO526yuISMk+U
         D1zvY3S2tYmIV3jvVY1a3I4Pc5fJXM0lmfkCyL3M=
Date:   Mon, 28 Jun 2021 19:36:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 059/192] iomap: use __set_page_dirty_nobuffers
Message-ID: <20210629023621.qNahGiQNo%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: iomap: use __set_page_dirty_nobuffers

The only difference between iomap_set_page_dirty() and
__set_page_dirty_nobuffers() is that the latter includes a debugging check
that a !Uptodate page has private data.

Link: https://lkml.kernel.org/r/20210615162342.1669332-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c         |    2 +-
 fs/iomap/buffered-io.c |   27 +--------------------------
 fs/xfs/xfs_aops.c      |    2 +-
 fs/zonefs/super.c      |    2 +-
 include/linux/iomap.h  |    1 -
 5 files changed, 4 insertions(+), 30 deletions(-)

--- a/fs/gfs2/aops.c~iomap-use-__set_page_dirty_nobuffers
+++ a/fs/gfs2/aops.c
@@ -784,7 +784,7 @@ static const struct address_space_operat
 	.writepages = gfs2_writepages,
 	.readpage = gfs2_readpage,
 	.readahead = gfs2_readahead,
-	.set_page_dirty = iomap_set_page_dirty,
+	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = iomap_releasepage,
 	.invalidatepage = iomap_invalidatepage,
 	.bmap = gfs2_bmap,
--- a/fs/iomap/buffered-io.c~iomap-use-__set_page_dirty_nobuffers
+++ a/fs/iomap/buffered-io.c
@@ -640,31 +640,6 @@ out_no_page:
 	return status;
 }
 
-int
-iomap_set_page_dirty(struct page *page)
-{
-	struct address_space *mapping = page_mapping(page);
-	int newly_dirty;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
-
-	/*
-	 * Lock out page's memcg migration to keep PageDirty
-	 * synchronized with per-memcg dirty page counters.
-	 */
-	lock_page_memcg(page);
-	newly_dirty = !TestSetPageDirty(page);
-	if (newly_dirty)
-		__set_page_dirty(page, mapping, 0);
-	unlock_page_memcg(page);
-
-	if (newly_dirty)
-		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	return newly_dirty;
-}
-EXPORT_SYMBOL_GPL(iomap_set_page_dirty);
-
 static size_t __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 		size_t copied, struct page *page)
 {
@@ -684,7 +659,7 @@ static size_t __iomap_write_end(struct i
 	if (unlikely(copied < len && !PageUptodate(page)))
 		return 0;
 	iomap_set_range_uptodate(page, offset_in_page(pos), len);
-	iomap_set_page_dirty(page);
+	__set_page_dirty_nobuffers(page);
 	return copied;
 }
 
--- a/fs/xfs/xfs_aops.c~iomap-use-__set_page_dirty_nobuffers
+++ a/fs/xfs/xfs_aops.c
@@ -561,7 +561,7 @@ const struct address_space_operations xf
 	.readahead		= xfs_vm_readahead,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
-	.set_page_dirty		= iomap_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_nobuffers,
 	.releasepage		= iomap_releasepage,
 	.invalidatepage		= iomap_invalidatepage,
 	.bmap			= xfs_vm_bmap,
--- a/fs/zonefs/super.c~iomap-use-__set_page_dirty_nobuffers
+++ a/fs/zonefs/super.c
@@ -185,7 +185,7 @@ static const struct address_space_operat
 	.readahead		= zonefs_readahead,
 	.writepage		= zonefs_writepage,
 	.writepages		= zonefs_writepages,
-	.set_page_dirty		= iomap_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_nobuffers,
 	.releasepage		= iomap_releasepage,
 	.invalidatepage		= iomap_invalidatepage,
 	.migratepage		= iomap_migrate_page,
--- a/include/linux/iomap.h~iomap-use-__set_page_dirty_nobuffers
+++ a/include/linux/iomap.h
@@ -159,7 +159,6 @@ ssize_t iomap_file_buffered_write(struct
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
-int iomap_set_page_dirty(struct page *page);
 int iomap_is_partially_uptodate(struct page *page, unsigned long from,
 		unsigned long count);
 int iomap_releasepage(struct page *page, gfp_t gfp_mask);
_
