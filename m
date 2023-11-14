Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E77C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbjKNXXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbjKNXXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:23:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3341CDC
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:23:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F92C433C8;
        Tue, 14 Nov 2023 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004185;
        bh=Pw1PT23ZUuYvxWUsYLnu1hdnyLbODmuwx0Qaxn/oH34=;
        h=Date:To:From:Subject:From;
        b=iTUunqKdv3GW6QoffHrzgYJ59WfSCeYi+NKkxhZBCn6W8FZXQUusASb87sYTbIy3o
         WZXtjxXrQOTJsYTjbkq9/76sREHjOmh/+m2mPnT+O6BRMk5f3FMI3oBtCseKq5NnOk
         9wqjyDoqN58JfRWPUzOq9Dki8ESN+88lCIFwKJSk=
Date:   Tue, 14 Nov 2023 15:23:05 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-to-__nilfs_clear_folio_dirty.patch added to mm-nonmm-unstable branch
Message-Id: <20231114232305.C3F92C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert to __nilfs_clear_folio_dirty()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-to-__nilfs_clear_folio_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-to-__nilfs_clear_folio_dirty.patch

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
Subject: nilfs2: convert to __nilfs_clear_folio_dirty()
Date: Tue, 14 Nov 2023 17:44:25 +0900

All callers now have a folio, so convert to pass a folio.  No caller uses
the return value, so make it return void.  Removes a couple of hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-10-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c    |   19 ++++++++++---------
 fs/nilfs2/page.h    |    2 +-
 fs/nilfs2/segment.c |    2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.c
@@ -82,7 +82,7 @@ void nilfs_forget_buffer(struct buffer_h
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
 	if (nilfs_folio_buffers_clean(folio))
-		__nilfs_clear_page_dirty(&folio->page);
+		__nilfs_clear_folio_dirty(folio);
 
 	bh->b_blocknr = -1;
 	folio_clear_uptodate(folio);
@@ -428,7 +428,7 @@ void nilfs_clear_folio_dirty(struct foli
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
-	__nilfs_clear_page_dirty(&folio->page);
+	__nilfs_clear_folio_dirty(folio);
 }
 
 unsigned int nilfs_page_count_clean_buffers(struct page *page,
@@ -458,22 +458,23 @@ unsigned int nilfs_page_count_clean_buff
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
  */
-int __nilfs_clear_page_dirty(struct page *page)
+void __nilfs_clear_folio_dirty(struct folio *folio)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 
 	if (mapping) {
 		xa_lock_irq(&mapping->i_pages);
-		if (test_bit(PG_dirty, &page->flags)) {
-			__xa_clear_mark(&mapping->i_pages, page_index(page),
+		if (folio_test_dirty(folio)) {
+			__xa_clear_mark(&mapping->i_pages, folio->index,
 					     PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&mapping->i_pages);
-			return clear_page_dirty_for_io(page);
+			folio_clear_dirty_for_io(folio);
+			return;
 		}
 		xa_unlock_irq(&mapping->i_pages);
-		return 0;
+		return;
 	}
-	return TestClearPageDirty(page);
+	folio_clear_dirty(folio);
 }
 
 /**
--- a/fs/nilfs2/page.h~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.h
@@ -30,7 +30,7 @@ BUFFER_FNS(NILFS_Checked, nilfs_checked)
 BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
 
 
-int __nilfs_clear_page_dirty(struct page *);
+void __nilfs_clear_folio_dirty(struct folio *);
 
 struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 				      unsigned long, unsigned long);
--- a/fs/nilfs2/segment.c~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/segment.c
@@ -1760,7 +1760,7 @@ static void nilfs_end_folio_io(struct fo
 			 */
 			folio_lock(folio);
 			if (nilfs_folio_buffers_clean(folio))
-				__nilfs_clear_page_dirty(&folio->page);
+				__nilfs_clear_folio_dirty(folio);
 			folio_unlock(folio);
 		}
 		return;
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

