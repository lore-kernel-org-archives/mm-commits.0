Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD7DC48BE5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1994613B3
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhFOXZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231261AbhFOXZ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEAA56128C;
        Tue, 15 Jun 2021 23:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623799401;
        bh=i0wuRSHBiDAF61oFGLFEDsshlkIS4RVbQ/2R+8JUjS0=;
        h=Date:From:To:Subject:From;
        b=FdqItytPxe2dofn/IVo+BB2Ml0Q9B6x43eNxqSYGld2vz0Tsjzncy1upXp1LQrDWL
         0AOGUR4/AUEPPJZGMbzoz9+sqMeBNz5l0DWbyZ82BW8X0eMEZ1b+m0mgYIfYdGvyOg
         6ZQwL9SKbHtkB6TUQzFCj4+do/pz6j2si48SKVj8=
Date:   Tue, 15 Jun 2021 16:23:20 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, gregkh@linuxfoundation.org, hch@lst.de,
        jack@suse.cz, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + iomap-use-__set_page_dirty_nobuffers.patch added to -mm
 tree
Message-ID: <20210615232320.RB6MpCYPv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use __set_page_dirty_nobuffers
has been added to the -mm tree.  Its filename is
     iomap-use-__set_page_dirty_nobuffers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/iomap-use-__set_page_dirty_nobuffers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/iomap-use-__set_page_dirty_nobuffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch

