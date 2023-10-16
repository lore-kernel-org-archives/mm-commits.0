Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F898CDB482
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjJPWLQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjJPWLJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:11:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C0FD9
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:11:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BC1C433C9;
        Mon, 16 Oct 2023 22:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494266;
        bh=Vq9wAg1rQEYHBH26sK7Q7uhjnvVy8h/hP5XPf644T7A=;
        h=Date:To:From:Subject:From;
        b=A16Ddebluflg1kU7PWmsrXpOflN0JDcT5SSOGlgS5XZk7L++YJhXckSbg6EQtkGpi
         18lzxrXL8gk3s+cPLvB3NUBTdRN4xFgKNSHEywQgqwPi4oIUvoxpJjP6YSF3gvNXMd
         /wsL5WCD3Fmn/MN+ldMGcZmNaUTO7fhlG5OOaN4M=
Date:   Mon, 16 Oct 2023 15:11:05 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch added to mm-unstable branch
Message-Id: <20231016221105.E1BC1C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_copy_page() to nilfs_copy_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch

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
Subject: nilfs2: convert nilfs_copy_page() to nilfs_copy_folio()
Date: Mon, 16 Oct 2023 21:10:59 +0100

Both callers already have a folio, so pass it in and use it directly. 
Removes a lot of hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231016201114.1928083-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   50 +++++++++++++++++++++++----------------------
 mm/util.c        |    1 
 2 files changed, 27 insertions(+), 24 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio
+++ a/fs/nilfs2/page.c
@@ -184,30 +184,32 @@ void nilfs_page_bug(struct page *page)
 }
 
 /**
- * nilfs_copy_page -- copy the page with buffers
- * @dst: destination page
- * @src: source page
- * @copy_dirty: flag whether to copy dirty states on the page's buffer heads.
+ * nilfs_copy_folio -- copy the folio with buffers
+ * @dst: destination folio
+ * @src: source folio
+ * @copy_dirty: flag whether to copy dirty states on the folio's buffer heads.
  *
- * This function is for both data pages and btnode pages.  The dirty flag
- * should be treated by caller.  The page must not be under i/o.
- * Both src and dst page must be locked
+ * This function is for both data folios and btnode folios.  The dirty flag
+ * should be treated by caller.  The folio must not be under i/o.
+ * Both src and dst folio must be locked
  */
-static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
+static void nilfs_copy_folio(struct folio *dst, struct folio *src,
+		bool copy_dirty)
 {
 	struct buffer_head *dbh, *dbufs, *sbh;
 	unsigned long mask = NILFS_BUFFER_INHERENT_BITS;
 
-	BUG_ON(PageWriteback(dst));
+	BUG_ON(folio_test_writeback(dst));
 
-	sbh = page_buffers(src);
-	if (!page_has_buffers(dst))
-		create_empty_buffers(dst, sbh->b_size, 0);
+	sbh = folio_buffers(src);
+	dbh = folio_buffers(dst);
+	if (!dbh)
+		dbh = folio_create_empty_buffers(dst, sbh->b_size, 0);
 
 	if (copy_dirty)
 		mask |= BIT(BH_Dirty);
 
-	dbh = dbufs = page_buffers(dst);
+	dbufs = dbh;
 	do {
 		lock_buffer(sbh);
 		lock_buffer(dbh);
@@ -218,16 +220,16 @@ static void nilfs_copy_page(struct page
 		dbh = dbh->b_this_page;
 	} while (dbh != dbufs);
 
-	copy_highpage(dst, src);
+	folio_copy(dst, src);
 
-	if (PageUptodate(src) && !PageUptodate(dst))
-		SetPageUptodate(dst);
-	else if (!PageUptodate(src) && PageUptodate(dst))
-		ClearPageUptodate(dst);
-	if (PageMappedToDisk(src) && !PageMappedToDisk(dst))
-		SetPageMappedToDisk(dst);
-	else if (!PageMappedToDisk(src) && PageMappedToDisk(dst))
-		ClearPageMappedToDisk(dst);
+	if (folio_test_uptodate(src) && !folio_test_uptodate(dst))
+		folio_mark_uptodate(dst);
+	else if (!folio_test_uptodate(src) && folio_test_uptodate(dst))
+		folio_clear_uptodate(dst);
+	if (folio_test_mappedtodisk(src) && !folio_test_mappedtodisk(dst))
+		folio_set_mappedtodisk(dst);
+	else if (!folio_test_mappedtodisk(src) && folio_test_mappedtodisk(dst))
+		folio_clear_mappedtodisk(dst);
 
 	do {
 		unlock_buffer(sbh);
@@ -269,7 +271,7 @@ repeat:
 			NILFS_PAGE_BUG(&folio->page,
 				       "found empty page in dat page cache");
 
-		nilfs_copy_page(&dfolio->page, &folio->page, 1);
+		nilfs_copy_folio(dfolio, folio, true);
 		filemap_dirty_folio(folio_mapping(dfolio), dfolio);
 
 		folio_unlock(dfolio);
@@ -314,7 +316,7 @@ repeat:
 		if (!IS_ERR(dfolio)) {
 			/* overwrite existing folio in the destination cache */
 			WARN_ON(folio_test_dirty(dfolio));
-			nilfs_copy_page(&dfolio->page, &folio->page, 0);
+			nilfs_copy_folio(dfolio, folio, false);
 			folio_unlock(dfolio);
 			folio_put(dfolio);
 			/* Do we not need to remove folio from smap here? */
--- a/mm/util.c~nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio
+++ a/mm/util.c
@@ -799,6 +799,7 @@ void folio_copy(struct folio *dst, struc
 		cond_resched();
 	}
 }
+EXPORT_SYMBOL(folio_copy);
 
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 int sysctl_overcommit_ratio __read_mostly = 50;
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

