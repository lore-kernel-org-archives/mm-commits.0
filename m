Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF07DC11F69
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB96661D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhF2Cil (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhF2Cij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C60561A2B;
        Tue, 29 Jun 2021 02:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934172;
        bh=t/wjrnuupgg1VifqZ5g1otKHYjYfV4mlIXUOVhOnh5g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vouUusoRZFumSE3chbPrClhL9QkyFGfHbx2PFgG2x+1f1Bb8tr+EbgFAITOEHpuHC
         uKbV4aCCycxkLCF1oji4ZTo0zV67RP0qOi9z03YSCPokWIfKu7k7Fbu0m32behxsyV
         J2nfN4IDeuUkTZ8eoCgxgpnJDH++UgQr1DAVmA0c=
Date:   Mon, 28 Jun 2021 19:36:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, code@tyhicks.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 056/192] mm: require ->set_page_dirty to be
 explicitly wired up
Message-ID: <20210629023612.bG25ne0yF%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: require ->set_page_dirty to be explicitly wired up

Remove the CONFIG_BLOCK default to __set_page_dirty_buffers and just wire
that method up for the missing instances.

[hch@lst.de: ecryptfs: add a ->set_page_dirty cludge]
  Link: https://lkml.kernel.org/r/20210624125250.536369-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210614061512.3966143-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c     |    1 +
 fs/affs/file.c      |    2 ++
 fs/bfs/file.c       |    1 +
 fs/block_dev.c      |    1 +
 fs/ecryptfs/mmap.c  |   13 +++++++++++++
 fs/exfat/inode.c    |    1 +
 fs/ext2/inode.c     |    2 ++
 fs/fat/inode.c      |    1 +
 fs/gfs2/meta_io.c   |    2 ++
 fs/hfs/inode.c      |    2 ++
 fs/hfsplus/inode.c  |    2 ++
 fs/hpfs/file.c      |    1 +
 fs/jfs/inode.c      |    1 +
 fs/minix/inode.c    |    1 +
 fs/nilfs2/mdt.c     |    1 +
 fs/ocfs2/aops.c     |    1 +
 fs/omfs/file.c      |    1 +
 fs/sysv/itree.c     |    1 +
 fs/udf/file.c       |    1 +
 fs/udf/inode.c      |    1 +
 fs/ufs/inode.c      |    1 +
 mm/page-writeback.c |   18 ++++--------------
 22 files changed, 42 insertions(+), 14 deletions(-)

--- a/fs/adfs/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/adfs/inode.c
@@ -73,6 +73,7 @@ static sector_t _adfs_bmap(struct addres
 }
 
 static const struct address_space_operations adfs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= adfs_readpage,
 	.writepage	= adfs_writepage,
 	.write_begin	= adfs_write_begin,
--- a/fs/affs/file.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/affs/file.c
@@ -453,6 +453,7 @@ static sector_t _affs_bmap(struct addres
 }
 
 const struct address_space_operations affs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage = affs_readpage,
 	.writepage = affs_writepage,
 	.write_begin = affs_write_begin,
@@ -833,6 +834,7 @@ err_bh:
 }
 
 const struct address_space_operations affs_aops_ofs = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage = affs_readpage_ofs,
 	//.writepage = affs_writepage_ofs,
 	.write_begin = affs_write_begin_ofs,
--- a/fs/bfs/file.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/bfs/file.c
@@ -188,6 +188,7 @@ static sector_t bfs_bmap(struct address_
 }
 
 const struct address_space_operations bfs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= bfs_readpage,
 	.writepage	= bfs_writepage,
 	.write_begin	= bfs_write_begin,
--- a/fs/block_dev.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/block_dev.c
@@ -1754,6 +1754,7 @@ static int blkdev_writepages(struct addr
 }
 
 static const struct address_space_operations def_blk_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= blkdev_readpage,
 	.readahead	= blkdev_readahead,
 	.writepage	= blkdev_writepage,
--- a/fs/ecryptfs/mmap.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/ecryptfs/mmap.c
@@ -533,7 +533,20 @@ static sector_t ecryptfs_bmap(struct add
 	return block;
 }
 
+#include <linux/buffer_head.h>
+
 const struct address_space_operations ecryptfs_aops = {
+	/*
+	 * XXX: This is pretty broken for multiple reasons: ecryptfs does not
+	 * actually use buffer_heads, and ecryptfs will crash without
+	 * CONFIG_BLOCK.  But it matches the behavior before the default for
+	 * address_space_operations without the ->set_page_dirty method was
+	 * cleaned up, so this is the best we can do without maintainer
+	 * feedback.
+	 */
+#ifdef CONFIG_BLOCK
+	.set_page_dirty = __set_page_dirty_buffers,
+#endif
 	.writepage = ecryptfs_writepage,
 	.readpage = ecryptfs_readpage,
 	.write_begin = ecryptfs_write_begin,
--- a/fs/exfat/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/exfat/inode.c
@@ -491,6 +491,7 @@ int exfat_block_truncate_page(struct ino
 }
 
 static const struct address_space_operations exfat_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= exfat_readpage,
 	.readahead	= exfat_readahead,
 	.writepage	= exfat_writepage,
--- a/fs/ext2/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/ext2/inode.c
@@ -961,6 +961,7 @@ ext2_dax_writepages(struct address_space
 }
 
 const struct address_space_operations ext2_aops = {
+	.set_page_dirty		= __set_page_dirty_buffers,
 	.readpage		= ext2_readpage,
 	.readahead		= ext2_readahead,
 	.writepage		= ext2_writepage,
@@ -975,6 +976,7 @@ const struct address_space_operations ex
 };
 
 const struct address_space_operations ext2_nobh_aops = {
+	.set_page_dirty		= __set_page_dirty_buffers,
 	.readpage		= ext2_readpage,
 	.readahead		= ext2_readahead,
 	.writepage		= ext2_nobh_writepage,
--- a/fs/fat/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/fat/inode.c
@@ -342,6 +342,7 @@ int fat_block_truncate_page(struct inode
 }
 
 static const struct address_space_operations fat_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= fat_readpage,
 	.readahead	= fat_readahead,
 	.writepage	= fat_writepage,
--- a/fs/gfs2/meta_io.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/gfs2/meta_io.c
@@ -89,11 +89,13 @@ static int gfs2_aspace_writepage(struct
 }
 
 const struct address_space_operations gfs2_meta_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.writepage = gfs2_aspace_writepage,
 	.releasepage = gfs2_releasepage,
 };
 
 const struct address_space_operations gfs2_rgrp_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.writepage = gfs2_aspace_writepage,
 	.releasepage = gfs2_releasepage,
 };
--- a/fs/hfs/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/hfs/inode.c
@@ -159,6 +159,7 @@ static int hfs_writepages(struct address
 }
 
 const struct address_space_operations hfs_btree_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
 	.write_begin	= hfs_write_begin,
@@ -168,6 +169,7 @@ const struct address_space_operations hf
 };
 
 const struct address_space_operations hfs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
 	.write_begin	= hfs_write_begin,
--- a/fs/hfsplus/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/hfsplus/inode.c
@@ -156,6 +156,7 @@ static int hfsplus_writepages(struct add
 }
 
 const struct address_space_operations hfsplus_btree_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
 	.write_begin	= hfsplus_write_begin,
@@ -165,6 +166,7 @@ const struct address_space_operations hf
 };
 
 const struct address_space_operations hfsplus_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
 	.write_begin	= hfsplus_write_begin,
--- a/fs/hpfs/file.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/hpfs/file.c
@@ -196,6 +196,7 @@ static int hpfs_fiemap(struct inode *ino
 }
 
 const struct address_space_operations hpfs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage = hpfs_readpage,
 	.writepage = hpfs_writepage,
 	.readahead = hpfs_readahead,
--- a/fs/jfs/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/jfs/inode.c
@@ -356,6 +356,7 @@ static ssize_t jfs_direct_IO(struct kioc
 }
 
 const struct address_space_operations jfs_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= jfs_readpage,
 	.readahead	= jfs_readahead,
 	.writepage	= jfs_writepage,
--- a/fs/minix/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/minix/inode.c
@@ -442,6 +442,7 @@ static sector_t minix_bmap(struct addres
 }
 
 static const struct address_space_operations minix_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage = minix_readpage,
 	.writepage = minix_writepage,
 	.write_begin = minix_write_begin,
--- a/fs/nilfs2/mdt.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/nilfs2/mdt.c
@@ -434,6 +434,7 @@ nilfs_mdt_write_page(struct page *page,
 
 
 static const struct address_space_operations def_mdt_aops = {
+	.set_page_dirty		= __set_page_dirty_buffers,
 	.writepage		= nilfs_mdt_write_page,
 };
 
--- a/fs/ocfs2/aops.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/ocfs2/aops.c
@@ -2453,6 +2453,7 @@ static ssize_t ocfs2_direct_IO(struct ki
 }
 
 const struct address_space_operations ocfs2_aops = {
+	.set_page_dirty		= __set_page_dirty_buffers,
 	.readpage		= ocfs2_readpage,
 	.readahead		= ocfs2_readahead,
 	.writepage		= ocfs2_writepage,
--- a/fs/omfs/file.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/omfs/file.c
@@ -372,6 +372,7 @@ const struct inode_operations omfs_file_
 };
 
 const struct address_space_operations omfs_aops = {
+	.set_page_dirty = __set_page_dirty_buffers,
 	.readpage = omfs_readpage,
 	.readahead = omfs_readahead,
 	.writepage = omfs_writepage,
--- a/fs/sysv/itree.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/sysv/itree.c
@@ -495,6 +495,7 @@ static sector_t sysv_bmap(struct address
 }
 
 const struct address_space_operations sysv_aops = {
+	.set_page_dirty = __set_page_dirty_buffers,
 	.readpage = sysv_readpage,
 	.writepage = sysv_writepage,
 	.write_begin = sysv_write_begin,
--- a/fs/udf/file.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/udf/file.c
@@ -125,6 +125,7 @@ static int udf_adinicb_write_end(struct
 }
 
 const struct address_space_operations udf_adinicb_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
 	.write_begin	= udf_adinicb_write_begin,
--- a/fs/udf/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/udf/inode.c
@@ -235,6 +235,7 @@ static sector_t udf_bmap(struct address_
 }
 
 const struct address_space_operations udf_aops = {
+	.set_page_dirty	= __set_page_dirty_buffers,
 	.readpage	= udf_readpage,
 	.readahead	= udf_readahead,
 	.writepage	= udf_writepage,
--- a/fs/ufs/inode.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/fs/ufs/inode.c
@@ -526,6 +526,7 @@ static sector_t ufs_bmap(struct address_
 }
 
 const struct address_space_operations ufs_aops = {
+	.set_page_dirty = __set_page_dirty_buffers,
 	.readpage = ufs_readpage,
 	.writepage = ufs_writepage,
 	.write_begin = ufs_write_begin,
--- a/mm/page-writeback.c~mm-require-set_page_dirty-to-be-explicitly-wire-up
+++ a/mm/page-writeback.c
@@ -32,7 +32,6 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
-#include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
@@ -2555,13 +2554,9 @@ EXPORT_SYMBOL(redirty_page_for_writepage
 /*
  * Dirty a page.
  *
- * For pages with a mapping this should be done under the page lock
- * for the benefit of asynchronous memory errors who prefer a consistent
- * dirty state. This rule can be broken in some special cases,
- * but should be better not to.
- *
- * If the mapping doesn't provide a set_page_dirty a_op, then
- * just fall through and assume that it wants buffer_heads.
+ * For pages with a mapping this should be done under the page lock for the
+ * benefit of asynchronous memory errors who prefer a consistent dirty state.
+ * This rule can be broken in some special cases, but should be better not to.
  */
 int set_page_dirty(struct page *page)
 {
@@ -2569,7 +2564,6 @@ int set_page_dirty(struct page *page)
 
 	page = compound_head(page);
 	if (likely(mapping)) {
-		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 		/*
 		 * readahead/lru_deactivate_page could remain
 		 * PG_readahead/PG_reclaim due to race with end_page_writeback
@@ -2582,11 +2576,7 @@ int set_page_dirty(struct page *page)
 		 */
 		if (PageReclaim(page))
 			ClearPageReclaim(page);
-#ifdef CONFIG_BLOCK
-		if (!spd)
-			spd = __set_page_dirty_buffers;
-#endif
-		return (*spd)(page);
+		return mapping->a_ops->set_page_dirty(page);
 	}
 	if (!PageDirty(page)) {
 		if (!TestSetPageDirty(page))
_
