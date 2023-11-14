Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4D9C07EB9
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbjKNXXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbjKNXXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:23:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BB5DE
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:23:03 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E4C433C9;
        Tue, 14 Nov 2023 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004183;
        bh=a6+neNbBMm6BlcfMDnDIh5nLFxKDBCqk2H6tGpdjjiY=;
        h=Date:To:From:Subject:From;
        b=fp9SfMRbhuWjx6Qdtlfyq2cZPvT6TLDQ+2OT8E+jEFLZe4Tm9IC+oAVeaNTS9IhKd
         7Dvn9NdqzI7hpFp61D2J2iMFB6DMwvF+N2FHR4D40kk3y4wu1nlpjgn/JyHNC8dwPS
         WjF8ygRuoM+fvf99NIRSbSeOWVnw8zgtegNlfq+Q=
Date:   Tue, 14 Nov 2023 15:23:02 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-to-nilfs_clear_folio_dirty.patch added to mm-nonmm-unstable branch
Message-Id: <20231114232303.444E4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert to nilfs_clear_folio_dirty()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-to-nilfs_clear_folio_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-to-nilfs_clear_folio_dirty.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: nilfs2: convert to nilfs_clear_folio_dirty()
Date: Tue, 14 Nov 2023 17:44:24 +0900

All callers of nilfs_clear_dirty_page() now have a folio, so rename the
function and pass in the folio.  Saves three hidden calls to
compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-9-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 +-
 fs/nilfs2/mdt.c   |    2 +-
 fs/nilfs2/page.c  |   27 ++++++++++++++-------------
 fs/nilfs2/page.h  |    2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/inode.c
@@ -186,7 +186,7 @@ static int nilfs_writepage(struct page *
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_folio_dirty(folio, false);
 		folio_unlock(folio);
 		return -EROFS;
 	}
--- a/fs/nilfs2/mdt.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/mdt.c
@@ -411,7 +411,7 @@ nilfs_mdt_write_page(struct page *page,
 		 * have dirty folios that try to be flushed in background.
 		 * So, here we simply discard this dirty folio.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_folio_dirty(folio, false);
 		folio_unlock(folio);
 		return -EROFS;
 	}
--- a/fs/nilfs2/page.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.c
@@ -379,7 +379,7 @@ void nilfs_clear_dirty_pages(struct addr
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_dirty_page(&folio->page, silent);
+				nilfs_clear_folio_dirty(folio, silent);
 
 			folio_unlock(folio);
 		}
@@ -389,32 +389,33 @@ void nilfs_clear_dirty_pages(struct addr
 }
 
 /**
- * nilfs_clear_dirty_page - discard dirty page
- * @page: dirty page that will be discarded
+ * nilfs_clear_folio_dirty - discard dirty folio
+ * @folio: dirty folio that will be discarded
  * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_page(struct page *page, bool silent)
+void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb = inode->i_sb;
+	struct buffer_head *bh, *head;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 
 	if (!silent)
 		nilfs_warn(sb, "discard dirty page: offset=%lld, ino=%lu",
-			   page_offset(page), inode->i_ino);
+			   folio_pos(folio), inode->i_ino);
 
-	ClearPageUptodate(page);
-	ClearPageMappedToDisk(page);
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh, *head;
+	head = folio_buffers(folio);
+	if (head) {
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
-		bh = head = page_buffers(page);
+		bh = head;
 		do {
 			lock_buffer(bh);
 			if (!silent)
@@ -427,7 +428,7 @@ void nilfs_clear_dirty_page(struct page
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
-	__nilfs_clear_page_dirty(page);
+	__nilfs_clear_page_dirty(&folio->page);
 }
 
 unsigned int nilfs_page_count_clean_buffers(struct page *page,
--- a/fs/nilfs2/page.h~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.h
@@ -41,7 +41,7 @@ void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_page(struct page *, bool);
+void nilfs_clear_folio_dirty(struct folio *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
gfp-include-__gfp_nowarn-in-gfp_nowait.patch
nilfs2-add-nilfs_end_folio_io.patch
nilfs2-convert-nilfs_abort_logs-to-use-folios.patch
nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch
nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch
nilfs2-convert-to-nilfs_folio_buffers_clean.patch
nilfs2-convert-nilfs_writepage-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch
nilfs2-convert-to-nilfs_clear_folio_dirty.patch
nilfs2-convert-to-__nilfs_clear_folio_dirty.patch
nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch
nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_gccache_submit_read_data-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch

