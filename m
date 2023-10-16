Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102A6CDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjJPWKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjJPWKt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:10:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF2B4
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:10:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E05C433C9;
        Mon, 16 Oct 2023 22:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494247;
        bh=NGyd/4KENkeMgDzj1+rzPXrOq7u+LrVkhE94zSaL0bM=;
        h=Date:To:From:Subject:From;
        b=k+diPZgj6mTA8DEQlb9hg1sNX5fie4WqeYh8ej/FUTyfa5ZlqqvJR9nzEiMouVlEJ
         7k2B/FQ+EtzgWzVVbCz65yrqzFk8iArOMgRzKS5exa37N/AuVtGdYxkAK4X2bCKKMr
         UxY+A2sGZBKP+658bVMUVo9AD/1d0Icirp3Pq9Ec=
Date:   Mon, 16 Oct 2023 15:10:46 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch added to mm-unstable branch
Message-Id: <20231016221046.E7E05C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: make folio_create_empty_buffers() return a buffer_head
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch

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
Subject: buffer: make folio_create_empty_buffers() return a buffer_head
Date: Mon, 16 Oct 2023 21:10:49 +0100

Almost all callers want to know the first BH that was allocated for this
folio.  We already have that handy, so return it.

Link: https://lkml.kernel.org/r/20231016201114.1928083-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   24 +++++++++++++-----------
 include/linux/buffer_head.h |    4 ++--
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/fs/buffer.c~buffer-make-folio_create_empty_buffers-return-a-buffer_head
+++ a/fs/buffer.c
@@ -1646,8 +1646,8 @@ EXPORT_SYMBOL(block_invalidate_folio);
  * block_dirty_folio() via private_lock.  try_to_free_buffers
  * is already excluded via the folio lock.
  */
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state)
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
 	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT | __GFP_NOFAIL;
@@ -1674,6 +1674,8 @@ void folio_create_empty_buffers(struct f
 	}
 	folio_attach_private(folio, head);
 	spin_unlock(&folio->mapping->private_lock);
+
+	return head;
 }
 EXPORT_SYMBOL(folio_create_empty_buffers);
 
@@ -1775,13 +1777,15 @@ static struct buffer_head *folio_create_
 						struct inode *inode,
 						unsigned int b_state)
 {
+	struct buffer_head *bh;
+
 	BUG_ON(!folio_test_locked(folio));
 
-	if (!folio_buffers(folio))
-		folio_create_empty_buffers(folio,
-					   1 << READ_ONCE(inode->i_blkbits),
-					   b_state);
-	return folio_buffers(folio);
+	bh = folio_buffers(folio);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio,
+				1 << READ_ONCE(inode->i_blkbits), b_state);
+	return bh;
 }
 
 /*
@@ -2681,10 +2685,8 @@ int block_truncate_page(struct address_s
 		return PTR_ERR(folio);
 
 	bh = folio_buffers(folio);
-	if (!bh) {
-		folio_create_empty_buffers(folio, blocksize, 0);
-		bh = folio_buffers(folio);
-	}
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	offset = offset_in_folio(folio, from);
--- a/include/linux/buffer_head.h~buffer-make-folio_create_empty_buffers-return-a-buffer_head
+++ a/include/linux/buffer_head.h
@@ -203,8 +203,8 @@ struct buffer_head *alloc_page_buffers(s
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state);
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
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

