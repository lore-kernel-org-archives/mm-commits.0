Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB083C41513
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjJPWLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbjJPWLn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:11:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579A3120
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:11:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E3C433C8;
        Mon, 16 Oct 2023 22:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494294;
        bh=rkgSDyNU7uHo0+i6wH7XfK237xG+QTXjV4+mYpKSqsk=;
        h=Date:To:From:Subject:From;
        b=r6ifJKgsPpsBhV5Nvm8l5L9nDVbDKVGtRWg2NfPQBzLtiz3IfnRSZiC2kvTFG6HsT
         p8yvukEw9LkAJDm6H38oEBO7P/qW+AVYfeOTmfxOmWnLyQ03lBfYoBP17F3adWHbjP
         CxMz8kfw/9GTfpkgUxnqfpKscVI340kr5SD/bdgs=
Date:   Mon, 16 Oct 2023 15:11:33 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-remove-folio_create_empty_buffers.patch added to mm-unstable branch
Message-Id: <20231016221133.E65E3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: remove folio_create_empty_buffers()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-remove-folio_create_empty_buffers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-remove-folio_create_empty_buffers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: remove folio_create_empty_buffers()
Date: Mon, 16 Oct 2023 21:11:14 +0100

With all users converted, remove the old create_empty_buffers() and rename
folio_create_empty_buffers() to create_empty_buffers().

Link: https://lkml.kernel.org/r/20231016201114.1928083-28-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   13 +++----------
 fs/ext4/inode.c             |    6 +++---
 fs/ext4/move_extent.c       |    4 ++--
 fs/gfs2/aops.c              |    2 +-
 fs/gfs2/bmap.c              |    2 +-
 fs/gfs2/meta_io.c           |    2 +-
 fs/gfs2/quota.c             |    2 +-
 fs/mpage.c                  |    2 +-
 fs/nilfs2/mdt.c             |    2 +-
 fs/nilfs2/page.c            |    4 ++--
 fs/nilfs2/segment.c         |    2 +-
 fs/ntfs/aops.c              |    4 ++--
 fs/ntfs/file.c              |    2 +-
 fs/ntfs3/file.c             |    2 +-
 fs/ocfs2/aops.c             |    2 +-
 fs/reiserfs/inode.c         |    2 +-
 fs/ufs/util.c               |    2 +-
 include/linux/buffer_head.h |    4 +---
 18 files changed, 25 insertions(+), 34 deletions(-)

--- a/fs/buffer.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/buffer.c
@@ -1646,7 +1646,7 @@ EXPORT_SYMBOL(block_invalidate_folio);
  * block_dirty_folio() via private_lock.  try_to_free_buffers
  * is already excluded via the folio lock.
  */
-struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
@@ -1677,13 +1677,6 @@ struct buffer_head *folio_create_empty_b
 
 	return head;
 }
-EXPORT_SYMBOL(folio_create_empty_buffers);
-
-void create_empty_buffers(struct page *page,
-			unsigned long blocksize, unsigned long b_state)
-{
-	folio_create_empty_buffers(page_folio(page), blocksize, b_state);
-}
 EXPORT_SYMBOL(create_empty_buffers);
 
 /**
@@ -1783,7 +1776,7 @@ static struct buffer_head *folio_create_
 
 	bh = folio_buffers(folio);
 	if (!bh)
-		bh = folio_create_empty_buffers(folio,
+		bh = create_empty_buffers(folio,
 				1 << READ_ONCE(inode->i_blkbits), b_state);
 	return bh;
 }
@@ -2686,7 +2679,7 @@ int block_truncate_page(struct address_s
 
 	bh = folio_buffers(folio);
 	if (!bh)
-		bh = folio_create_empty_buffers(folio, blocksize, 0);
+		bh = create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	offset = offset_in_folio(folio, from);
--- a/fs/ext4/inode.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ext4/inode.c
@@ -1021,7 +1021,7 @@ static int ext4_block_write_begin(struct
 
 	head = folio_buffers(folio);
 	if (!head)
-		head = folio_create_empty_buffers(folio, blocksize, 0);
+		head = create_empty_buffers(folio, blocksize, 0);
 	bbits = ilog2(blocksize);
 	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
 
@@ -1151,7 +1151,7 @@ retry_grab:
 	 * starting the handle.
 	 */
 	if (!folio_buffers(folio))
-		folio_create_empty_buffers(folio, inode->i_sb->s_blocksize, 0);
+		create_empty_buffers(folio, inode->i_sb->s_blocksize, 0);
 
 	folio_unlock(folio);
 
@@ -3642,7 +3642,7 @@ static int __ext4_block_zero_page_range(
 
 	bh = folio_buffers(folio);
 	if (!bh)
-		bh = folio_create_empty_buffers(folio, blocksize, 0);
+		bh = create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	pos = blocksize;
--- a/fs/ext4/move_extent.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ext4/move_extent.c
@@ -184,7 +184,7 @@ mext_page_mkuptodate(struct folio *folio
 	blocksize = i_blocksize(inode);
 	head = folio_buffers(folio);
 	if (!head)
-		head = folio_create_empty_buffers(folio, blocksize, 0);
+		head = create_empty_buffers(folio, blocksize, 0);
 
 	block = (sector_t)folio->index << (PAGE_SHIFT - inode->i_blkbits);
 	for (bh = head, block_start = 0; bh != head || !block_start;
@@ -380,7 +380,7 @@ data_copy:
 	 * but keeping in mind that i_size will not change */
 	bh = folio_buffers(folio[0]);
 	if (!bh)
-		bh = folio_create_empty_buffers(folio[0],
+		bh = create_empty_buffers(folio[0],
 				1 << orig_inode->i_blkbits, 0);
 	for (i = 0; i < data_offset_in_page; i++)
 		bh = bh->b_this_page;
--- a/fs/gfs2/aops.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/gfs2/aops.c
@@ -130,7 +130,7 @@ static int __gfs2_jdata_write_folio(stru
 	if (folio_test_checked(folio)) {
 		folio_clear_checked(folio);
 		if (!folio_buffers(folio)) {
-			folio_create_empty_buffers(folio,
+			create_empty_buffers(folio,
 					inode->i_sb->s_blocksize,
 					BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
--- a/fs/gfs2/bmap.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/gfs2/bmap.c
@@ -71,7 +71,7 @@ static int gfs2_unstuffer_folio(struct g
 		struct buffer_head *bh = folio_buffers(folio);
 
 		if (!bh)
-			bh = folio_create_empty_buffers(folio,
+			bh = create_empty_buffers(folio,
 				BIT(inode->i_blkbits), BIT(BH_Uptodate));
 
 		if (!buffer_mapped(bh))
--- a/fs/gfs2/meta_io.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/gfs2/meta_io.c
@@ -134,7 +134,7 @@ struct buffer_head *gfs2_getbuf(struct g
 				mapping_gfp_mask(mapping) | __GFP_NOFAIL);
 		bh = folio_buffers(folio);
 		if (!bh)
-			bh = folio_create_empty_buffers(folio,
+			bh = create_empty_buffers(folio,
 				sdp->sd_sb.sb_bsize, 0);
 	} else {
 		folio = __filemap_get_folio(mapping, index,
--- a/fs/gfs2/quota.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/gfs2/quota.c
@@ -763,7 +763,7 @@ static int gfs2_write_buf_to_page(struct
 		return PTR_ERR(folio);
 	bh = folio_buffers(folio);
 	if (!bh)
-		bh = folio_create_empty_buffers(folio, bsize, 0);
+		bh = create_empty_buffers(folio, bsize, 0);
 
 	for (;;) {
 		/* Find the beginning block within the folio */
--- a/fs/mpage.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/mpage.c
@@ -119,7 +119,7 @@ static void map_buffer_to_folio(struct f
 			folio_mark_uptodate(folio);
 			return;
 		}
-		head = folio_create_empty_buffers(folio, i_blocksize(inode), 0);
+		head = create_empty_buffers(folio, i_blocksize(inode), 0);
 	}
 
 	page_bh = head;
--- a/fs/nilfs2/mdt.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/nilfs2/mdt.c
@@ -568,7 +568,7 @@ int nilfs_mdt_freeze_buffer(struct inode
 
 	bh_frozen = folio_buffers(folio);
 	if (!bh_frozen)
-		bh_frozen = folio_create_empty_buffers(folio, 1 << blkbits, 0);
+		bh_frozen = create_empty_buffers(folio, 1 << blkbits, 0);
 
 	bh_frozen = get_nth_bh(bh_frozen, bh_offset(bh) >> blkbits);
 
--- a/fs/nilfs2/page.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/nilfs2/page.c
@@ -34,7 +34,7 @@ static struct buffer_head *__nilfs_get_f
 	struct buffer_head *bh = folio_buffers(folio);
 
 	if (!bh)
-		bh = folio_create_empty_buffers(folio, 1 << blkbits, b_state);
+		bh = create_empty_buffers(folio, 1 << blkbits, b_state);
 
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
 	bh = get_nth_bh(bh, block - first_block);
@@ -204,7 +204,7 @@ static void nilfs_copy_folio(struct foli
 	sbh = folio_buffers(src);
 	dbh = folio_buffers(dst);
 	if (!dbh)
-		dbh = folio_create_empty_buffers(dst, sbh->b_size, 0);
+		dbh = create_empty_buffers(dst, sbh->b_size, 0);
 
 	if (copy_dirty)
 		mask |= BIT(BH_Dirty);
--- a/fs/nilfs2/segment.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/nilfs2/segment.c
@@ -732,7 +732,7 @@ static size_t nilfs_lookup_dirty_data_bu
 		}
 		head = folio_buffers(folio);
 		if (!head)
-			head = folio_create_empty_buffers(folio,
+			head = create_empty_buffers(folio,
 					i_blocksize(inode), 0);
 		folio_unlock(folio);
 
--- a/fs/ntfs3/file.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ntfs3/file.c
@@ -203,7 +203,7 @@ static int ntfs_zero_range(struct inode
 
 		head = folio_buffers(folio);
 		if (!head)
-			head = folio_create_empty_buffers(folio, blocksize, 0);
+			head = create_empty_buffers(folio, blocksize, 0);
 
 		bh = head;
 		bh_off = 0;
--- a/fs/ntfs/aops.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ntfs/aops.c
@@ -189,7 +189,7 @@ static int ntfs_read_block(struct folio
 
 	head = folio_buffers(folio);
 	if (!head)
-		head = folio_create_empty_buffers(folio, blocksize, 0);
+		head = create_empty_buffers(folio, blocksize, 0);
 	bh = head;
 
 	/*
@@ -555,7 +555,7 @@ static int ntfs_write_block(struct folio
 	head = folio_buffers(folio);
 	if (!head) {
 		BUG_ON(!folio_test_uptodate(folio));
-		head = folio_create_empty_buffers(folio, blocksize,
+		head = create_empty_buffers(folio, blocksize,
 				(1 << BH_Uptodate) | (1 << BH_Dirty));
 	}
 	bh = head;
--- a/fs/ntfs/file.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ntfs/file.c
@@ -625,7 +625,7 @@ do_next_folio:
 		 * create_empty_buffers() will create uptodate/dirty
 		 * buffers if the folio is uptodate/dirty.
 		 */
-		head = folio_create_empty_buffers(folio, blocksize, 0);
+		head = create_empty_buffers(folio, blocksize, 0);
 	bh = head;
 	do {
 		VCN cdelta;
--- a/fs/ocfs2/aops.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ocfs2/aops.c
@@ -601,7 +601,7 @@ int ocfs2_map_page_blocks(struct page *p
 
 	head = folio_buffers(folio);
 	if (!head)
-		head = folio_create_empty_buffers(folio, bsize, 0);
+		head = create_empty_buffers(folio, bsize, 0);
 
 	for (bh = head, block_start = 0; bh != head || !block_start;
 	     bh = bh->b_this_page, block_start += bsize) {
--- a/fs/reiserfs/inode.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/reiserfs/inode.c
@@ -2539,7 +2539,7 @@ static int reiserfs_write_full_folio(str
 	 */
 	head = folio_buffers(folio);
 	if (!head)
-		head = folio_create_empty_buffers(folio, s->s_blocksize,
+		head = create_empty_buffers(folio, s->s_blocksize,
 				     (1 << BH_Dirty) | (1 << BH_Uptodate));
 
 	/*
--- a/fs/ufs/util.c~buffer-remove-folio_create_empty_buffers
+++ a/fs/ufs/util.c
@@ -264,6 +264,6 @@ struct folio *ufs_get_locked_folio(struc
 		}
 	}
 	if (!folio_buffers(folio))
-		folio_create_empty_buffers(folio, 1 << inode->i_blkbits, 0);
+		create_empty_buffers(folio, 1 << inode->i_blkbits, 0);
 	return folio;
 }
--- a/include/linux/buffer_head.h~buffer-remove-folio_create_empty_buffers
+++ a/include/linux/buffer_head.h
@@ -201,9 +201,7 @@ struct buffer_head *folio_alloc_buffers(
 					gfp_t gfp);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry);
-void create_empty_buffers(struct page *, unsigned long,
-			unsigned long b_state);
-struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

