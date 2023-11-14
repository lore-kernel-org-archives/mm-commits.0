Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E7CC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 14 Nov 2023 23:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbjKNXXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjKNXXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2023 18:23:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129BDE4
        for <mm-commits@vger.kernel.org>; Tue, 14 Nov 2023 15:23:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DADEC433C7;
        Tue, 14 Nov 2023 23:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700004189;
        bh=CA8eCI4/xeT3XhmzC8jd6QjalaDczt2x/WLo0XO40Jw=;
        h=Date:To:From:Subject:From;
        b=r+WUU7/nOL5T+jIUn1wslLJ9wmqZUlEByggXirq5tEPGdMlzLa5hxZcFU5Ni4zsjb
         2ATd8j7ybYLvHku+UKvlREFgnIM67EPbg97yqTxdOC8jgVUwJ+2L31BoZ9e+BkU5Us
         y069Fj5djvvqVc3lciCsTNkCYrfe9ZZ5tRpdk+3c=
Date:   Tue, 14 Nov 2023 15:23:09 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20231114232309.9DADEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_page_mkwrite() to use a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch

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
Subject: nilfs2: convert nilfs_page_mkwrite() to use a folio
Date: Tue, 14 Nov 2023 17:44:27 +0900

Using the new folio APIs saves seven hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-12-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/fs/nilfs2/file.c~nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio
+++ a/fs/nilfs2/file.c
@@ -45,34 +45,36 @@ int nilfs_sync_file(struct file *file, l
 static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct inode *inode = file_inode(vma->vm_file);
 	struct nilfs_transaction_info ti;
+	struct buffer_head *bh, *head;
 	int ret = 0;
 
 	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
 		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
 	sb_start_pagefault(inode->i_sb);
-	lock_page(page);
-	if (page->mapping != inode->i_mapping ||
-	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
-		unlock_page(page);
+	folio_lock(folio);
+	if (folio->mapping != inode->i_mapping ||
+	    folio_pos(folio) >= i_size_read(inode) ||
+	    !folio_test_uptodate(folio)) {
+		folio_unlock(folio);
 		ret = -EFAULT;	/* make the VM retry the fault */
 		goto out;
 	}
 
 	/*
-	 * check to see if the page is mapped already (no holes)
+	 * check to see if the folio is mapped already (no holes)
 	 */
-	if (PageMappedToDisk(page))
+	if (folio_test_mappedtodisk(folio))
 		goto mapped;
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh, *head;
+	head = folio_buffers(folio);
+	if (head) {
 		int fully_mapped = 1;
 
-		bh = head = page_buffers(page);
+		bh = head;
 		do {
 			if (!buffer_mapped(bh)) {
 				fully_mapped = 0;
@@ -81,11 +83,11 @@ static vm_fault_t nilfs_page_mkwrite(str
 		} while (bh = bh->b_this_page, bh != head);
 
 		if (fully_mapped) {
-			SetPageMappedToDisk(page);
+			folio_set_mappedtodisk(folio);
 			goto mapped;
 		}
 	}
-	unlock_page(page);
+	folio_unlock(folio);
 
 	/*
 	 * fill hole blocks
@@ -105,7 +107,7 @@ static vm_fault_t nilfs_page_mkwrite(str
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	wait_for_stable_page(page);
+	folio_wait_stable(folio);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return vmf_fs_error(ret);
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

