Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F13CDB482
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjJPWLY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjJPWLW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:11:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E30FD9
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:11:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF2C433CA;
        Mon, 16 Oct 2023 22:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494280;
        bh=yJMbVxBm8lCHpvPvTdlz6j6oXy1Cqv+ZXeJbFJ+9f2g=;
        h=Date:To:From:Subject:From;
        b=qUscTJTk0/ZT6zVwqVA0Vern2fkbCCnxVpfiIGB/NKo7oWbvbwHeGXsMlVYmQZmoE
         uuqPopBahvONIBNWAq+ovzUXqPSioBFBdnAl4rAHZhVGs/WLX42p4sFcvrY/M3Ebzb
         +qk3VRtum3x+ek5cy9QrdQOymnojfAOBv9+dUu00=
Date:   Mon, 16 Oct 2023 15:11:20 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231016221120.9BFF2C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs3: convert ntfs_zero_range() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch

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
Subject: ntfs3: convert ntfs_zero_range() to use a folio
Date: Mon, 16 Oct 2023 21:11:07 +0100

Use the folio API throughout, saving six hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/file.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/ntfs3/file.c~ntfs3-convert-ntfs_zero_range-to-use-a-folio
+++ a/fs/ntfs3/file.c
@@ -187,7 +187,7 @@ static int ntfs_zero_range(struct inode
 	struct buffer_head *head, *bh;
 	u32 bh_next, bh_off, to;
 	sector_t iblock;
-	struct page *page;
+	struct folio *folio;
 
 	for (; idx < idx_end; idx += 1, from = 0) {
 		page_off = (loff_t)idx << PAGE_SHIFT;
@@ -195,16 +195,17 @@ static int ntfs_zero_range(struct inode
 						       PAGE_SIZE;
 		iblock = page_off >> inode->i_blkbits;
 
-		page = find_or_create_page(mapping, idx,
-					   mapping_gfp_constraint(mapping,
-								  ~__GFP_FS));
-		if (!page)
-			return -ENOMEM;
+		folio = __filemap_get_folio(mapping, idx,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				mapping_gfp_constraint(mapping, ~__GFP_FS));
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+
+		head = folio_buffers(folio);
+		if (!head)
+			head = folio_create_empty_buffers(folio, blocksize, 0);
 
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, blocksize, 0);
-
-		bh = head = page_buffers(page);
+		bh = head;
 		bh_off = 0;
 		do {
 			bh_next = bh_off + blocksize;
@@ -220,14 +221,14 @@ static int ntfs_zero_range(struct inode
 			}
 
 			/* Ok, it's mapped. Make sure it's up-to-date. */
-			if (PageUptodate(page))
+			if (folio_test_uptodate(folio))
 				set_buffer_uptodate(bh);
 
 			if (!buffer_uptodate(bh)) {
 				err = bh_read(bh, 0);
 				if (err < 0) {
-					unlock_page(page);
-					put_page(page);
+					folio_unlock(folio);
+					folio_put(folio);
 					goto out;
 				}
 			}
@@ -237,10 +238,10 @@ static int ntfs_zero_range(struct inode
 		} while (bh_off = bh_next, iblock += 1,
 			 head != (bh = bh->b_this_page));
 
-		zero_user_segment(page, from, to);
+		folio_zero_segment(folio, from, to);
 
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		cond_resched();
 	}
 out:
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

