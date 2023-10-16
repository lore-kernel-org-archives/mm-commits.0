Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B86CDB482
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbjJPWLU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjJPWLQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:11:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361BFFC
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:11:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C915EC433C7;
        Mon, 16 Oct 2023 22:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494274;
        bh=l/z2TFV4GOEiyb8aKyGcgWwUa3Jhi0jMgV9kSzD6McY=;
        h=Date:To:From:Subject:From;
        b=K6j71a4ffIacYS4l6pvQWQ5Z2052gXjJCCqSwAlRVWBxWx8C9Vj+77d69XqfsomG4
         Ce3e+Wtt9iKOfKAsAa+9BMYPMFWvikqMqJpG0XZvc0Phd4OhZEJStW7SGi4SJChr2O
         IouS5gF5Mme99gTn+ZRpsNi0KVdpdF7OfDqypj4E=
Date:   Mon, 16 Oct 2023 15:11:14 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs-convert-ntfs_read_block-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231016221114.C915EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: convert ntfs_read_block() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs-convert-ntfs_read_block-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs-convert-ntfs_read_block-to-use-a-folio.patch

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
Subject: ntfs: convert ntfs_read_block() to use a folio
Date: Mon, 16 Oct 2023 21:11:04 +0100

The caller already has the folio, so pass it in and use the folio API
throughout saving five hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/aops.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/fs/ntfs/aops.c~ntfs-convert-ntfs_read_block-to-use-a-folio
+++ a/fs/ntfs/aops.c
@@ -145,13 +145,12 @@ still_busy:
 }
 
 /**
- * ntfs_read_block - fill a @page of an address space with data
- * @page:	page cache page to fill with data
+ * ntfs_read_block - fill a @folio of an address space with data
+ * @folio:	page cache folio to fill with data
  *
- * Fill the page @page of the address space belonging to the @page->host inode.
  * We read each buffer asynchronously and when all buffers are read in, our io
  * completion handler ntfs_end_buffer_read_async(), if required, automatically
- * applies the mst fixups to the page before finally marking it uptodate and
+ * applies the mst fixups to the folio before finally marking it uptodate and
  * unlocking it.
  *
  * We only enforce allocated_size limit because i_size is checked for in
@@ -161,7 +160,7 @@ still_busy:
  *
  * Contains an adapted version of fs/buffer.c::block_read_full_folio().
  */
-static int ntfs_read_block(struct page *page)
+static int ntfs_read_block(struct folio *folio)
 {
 	loff_t i_size;
 	VCN vcn;
@@ -178,7 +177,7 @@ static int ntfs_read_block(struct page *
 	int i, nr;
 	unsigned char blocksize_bits;
 
-	vi = page->mapping->host;
+	vi = folio->mapping->host;
 	ni = NTFS_I(vi);
 	vol = ni->vol;
 
@@ -188,15 +187,10 @@ static int ntfs_read_block(struct page *
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
 
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, blocksize, 0);
-		if (unlikely(!page_has_buffers(page))) {
-			unlock_page(page);
-			return -ENOMEM;
-		}
-	}
-	bh = head = page_buffers(page);
-	BUG_ON(!bh);
+	head = folio_buffers(folio);
+	if (!head)
+		head = folio_create_empty_buffers(folio, blocksize, 0);
+	bh = head;
 
 	/*
 	 * We may be racing with truncate.  To avoid some of the problems we
@@ -205,11 +199,11 @@ static int ntfs_read_block(struct page *
 	 * may leave some buffers unmapped which are now allocated.  This is
 	 * not a problem since these buffers will just get mapped when a write
 	 * occurs.  In case of a shrinking truncate, we will detect this later
-	 * on due to the runlist being incomplete and if the page is being
+	 * on due to the runlist being incomplete and if the folio is being
 	 * fully truncated, truncate will throw it away as soon as we unlock
 	 * it so no need to worry what we do with it.
 	 */
-	iblock = (s64)page->index << (PAGE_SHIFT - blocksize_bits);
+	iblock = (s64)folio->index << (PAGE_SHIFT - blocksize_bits);
 	read_lock_irqsave(&ni->size_lock, flags);
 	lblock = (ni->allocated_size + blocksize - 1) >> blocksize_bits;
 	init_size = ni->initialized_size;
@@ -221,7 +215,7 @@ static int ntfs_read_block(struct page *
 	}
 	zblock = (init_size + blocksize - 1) >> blocksize_bits;
 
-	/* Loop through all the buffers in the page. */
+	/* Loop through all the buffers in the folio. */
 	rl = NULL;
 	nr = i = 0;
 	do {
@@ -299,7 +293,7 @@ lock_retry_remap:
 			if (!err)
 				err = -EIO;
 			bh->b_blocknr = -1;
-			SetPageError(page);
+			folio_set_error(folio);
 			ntfs_error(vol->sb, "Failed to read from inode 0x%lx, "
 					"attribute type 0x%x, vcn 0x%llx, "
 					"offset 0x%x because its location on "
@@ -312,13 +306,13 @@ lock_retry_remap:
 		/*
 		 * Either iblock was outside lblock limits or
 		 * ntfs_rl_vcn_to_lcn() returned error.  Just zero that portion
-		 * of the page and set the buffer uptodate.
+		 * of the folio and set the buffer uptodate.
 		 */
 handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		zero_user(page, i * blocksize, blocksize);
+		folio_zero_range(folio, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -349,11 +343,11 @@ handle_zblock:
 		return 0;
 	}
 	/* No i/o was scheduled on any of the buffers. */
-	if (likely(!PageError(page)))
-		SetPageUptodate(page);
+	if (likely(!folio_test_error(folio)))
+		folio_mark_uptodate(folio);
 	else /* Signal synchronous i/o error. */
 		nr = -EIO;
-	unlock_page(page);
+	folio_unlock(folio);
 	return nr;
 }
 
@@ -433,7 +427,7 @@ retry_readpage:
 	/* NInoNonResident() == NInoIndexAllocPresent() */
 	if (NInoNonResident(ni)) {
 		/* Normal, non-resident data stream. */
-		return ntfs_read_block(page);
+		return ntfs_read_block(folio);
 	}
 	/*
 	 * Attribute is resident, implying it is not compressed or encrypted.
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

