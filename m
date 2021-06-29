Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3E0C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08DAF61D09
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2Ciz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2Ciz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A576561D08;
        Tue, 29 Jun 2021 02:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934188;
        bh=iQHsHHgN1zacmhGiG075wYcIrh0lnjV2PdgWokyVZl8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zDahisvAXf8j4SReeTRKmOlR7kbbtQ2EumIm4dSWse1pQaVwj9b7vDrwsBM38f7eV
         9ihYl6VL+HRbnm/bEKUAmq7ko1l4EHHFnWmtgwyjlQEs+sgW4XubwN73Iz2EvfCDD3
         GE+xW9S6NdBUv6qLW2WI7er8jqZfs7SaDt+1yM30=
Date:   Mon, 28 Jun 2021 19:36:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 061/192] fs: remove noop_set_page_dirty()
Message-ID: <20210629023627.Bf7fBbTEJ%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove noop_set_page_dirty()

Use __set_page_dirty_no_writeback() instead.  This will set the dirty bit
on the page, which will be used to avoid calling set_page_dirty() in the
future.  It will have no effect on actually writing the page back, as the
pages are not on any LRU lists.

[akpm@linux-foundation.org: export __set_page_dirty_no_writeback() to modules]
Link: https://lkml.kernel.org/r/20210615162342.1669332-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 fs/ext2/inode.c      |    2 +-
 fs/ext4/inode.c      |    2 +-
 fs/fuse/dax.c        |    2 +-
 fs/libfs.c           |   16 ----------------
 fs/xfs/xfs_aops.c    |    2 +-
 include/linux/fs.h   |    1 -
 mm/page-writeback.c  |    1 +
 8 files changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/dax/device.c~fs-remove-noop_set_page_dirty
+++ a/drivers/dax/device.c
@@ -337,7 +337,7 @@ static unsigned long dax_get_unmapped_ar
 }
 
 static const struct address_space_operations dev_dax_aops = {
-	.set_page_dirty		= noop_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_no_writeback,
 	.invalidatepage		= noop_invalidatepage,
 };
 
--- a/fs/ext2/inode.c~fs-remove-noop_set_page_dirty
+++ a/fs/ext2/inode.c
@@ -992,7 +992,7 @@ const struct address_space_operations ex
 static const struct address_space_operations ext2_dax_aops = {
 	.writepages		= ext2_dax_writepages,
 	.direct_IO		= noop_direct_IO,
-	.set_page_dirty		= noop_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_no_writeback,
 	.invalidatepage		= noop_invalidatepage,
 };
 
--- a/fs/ext4/inode.c~fs-remove-noop_set_page_dirty
+++ a/fs/ext4/inode.c
@@ -3701,7 +3701,7 @@ static const struct address_space_operat
 static const struct address_space_operations ext4_dax_aops = {
 	.writepages		= ext4_dax_writepages,
 	.direct_IO		= noop_direct_IO,
-	.set_page_dirty		= noop_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_no_writeback,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= noop_invalidatepage,
 	.swap_activate		= ext4_iomap_swap_activate,
--- a/fs/fuse/dax.c~fs-remove-noop_set_page_dirty
+++ a/fs/fuse/dax.c
@@ -1329,7 +1329,7 @@ bool fuse_dax_inode_alloc(struct super_b
 static const struct address_space_operations fuse_dax_file_aops  = {
 	.writepages	= fuse_dax_writepages,
 	.direct_IO	= noop_direct_IO,
-	.set_page_dirty	= noop_set_page_dirty,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.invalidatepage	= noop_invalidatepage,
 };
 
--- a/fs/libfs.c~fs-remove-noop_set_page_dirty
+++ a/fs/libfs.c
@@ -1171,22 +1171,6 @@ int noop_fsync(struct file *file, loff_t
 }
 EXPORT_SYMBOL(noop_fsync);
 
-int noop_set_page_dirty(struct page *page)
-{
-	/*
-	 * Unlike __set_page_dirty_no_writeback that handles dirty page
-	 * tracking in the page object, dax does all dirty tracking in
-	 * the inode address_space in response to mkwrite faults. In the
-	 * dax case we only need to worry about potentially dirty CPU
-	 * caches, not dirty page cache pages to write back.
-	 *
-	 * This callback is defined to prevent fallback to
-	 * __set_page_dirty_buffers() in set_page_dirty().
-	 */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(noop_set_page_dirty);
-
 void noop_invalidatepage(struct page *page, unsigned int offset,
 		unsigned int length)
 {
--- a/fs/xfs/xfs_aops.c~fs-remove-noop_set_page_dirty
+++ a/fs/xfs/xfs_aops.c
@@ -575,7 +575,7 @@ const struct address_space_operations xf
 const struct address_space_operations xfs_dax_aops = {
 	.writepages		= xfs_dax_writepages,
 	.direct_IO		= noop_direct_IO,
-	.set_page_dirty		= noop_set_page_dirty,
+	.set_page_dirty		= __set_page_dirty_no_writeback,
 	.invalidatepage		= noop_invalidatepage,
 	.swap_activate		= xfs_iomap_swapfile_activate,
 };
--- a/include/linux/fs.h~fs-remove-noop_set_page_dirty
+++ a/include/linux/fs.h
@@ -3417,7 +3417,6 @@ extern int simple_rename(struct user_nam
 extern void simple_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
-extern int noop_set_page_dirty(struct page *page);
 extern void noop_invalidatepage(struct page *page, unsigned int offset,
 		unsigned int length);
 extern ssize_t noop_direct_IO(struct kiocb *iocb, struct iov_iter *iter);
--- a/mm/page-writeback.c~fs-remove-noop_set_page_dirty
+++ a/mm/page-writeback.c
@@ -2417,6 +2417,7 @@ int __set_page_dirty_no_writeback(struct
 		return !TestSetPageDirty(page);
 	return 0;
 }
+EXPORT_SYMBOL(__set_page_dirty_no_writeback);
 
 /*
  * Helper function for set_page_dirty family.
_
