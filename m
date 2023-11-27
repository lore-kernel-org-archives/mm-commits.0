Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B13C07E98
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjK0RIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbjK0RID (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:08:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6868310D2
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:08:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FFBC433C7;
        Mon, 27 Nov 2023 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104889;
        bh=EJI06RPIIcFMQN3OLjCzWMTfa/1p32LbUW0TGlDIXV8=;
        h=Date:To:From:Subject:From;
        b=rtxeL8B7ENqlF//W+DYg+sR4lerrD6YLYMDK5qe/6C9OguxGXlttqX4x5NTu+WJ0i
         dPBPxMMfbI5o9ThcR+ac4Xy70htNO6Vba8yGlDbBnHqip1peyl4g+XbaSZ+nYIvK2k
         beU/41s93Zwm2ykJlJzIjbgjM2/zw7ywMI7oISw8=
Date:   Mon, 27 Nov 2023 09:08:08 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_add_link-to-use-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170809.05FFBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_add_link() to use a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_add_link-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_add_link-to-use-a-folio.patch

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
Subject: nilfs2: convert nilfs_add_link() to use a folio
Date: Mon, 27 Nov 2023 23:30:32 +0900

Remove six calls to compound_head() by using the folio API.

Link: https://lkml.kernel.org/r/20231127143036.2425-14-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_add_link-to-use-a-folio
+++ a/fs/nilfs2/dir.c
@@ -439,30 +439,28 @@ int nilfs_add_link(struct dentry *dentry
 	unsigned int chunk_size = nilfs_chunk_size(dir);
 	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct nilfs_dir_entry *de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
-	char *kaddr;
-	unsigned int from, to;
+	size_t from, to;
 	int err;
 
 	/*
 	 * We take care of directory expansion in the same loop.
-	 * This code plays outside i_size, so it locks the page
+	 * This code plays outside i_size, so it locks the folio
 	 * to protect that region.
 	 */
 	for (n = 0; n <= npages; n++) {
+		char *kaddr = nilfs_get_folio(dir, n, &folio);
 		char *dir_end;
 
-		kaddr = nilfs_get_page(dir, n, &page);
-		err = PTR_ERR(kaddr);
 		if (IS_ERR(kaddr))
-			goto out;
-		lock_page(page);
+			return PTR_ERR(kaddr);
+		folio_lock(folio);
 		dir_end = kaddr + nilfs_last_byte(dir, n);
 		de = (struct nilfs_dir_entry *)kaddr;
-		kaddr += PAGE_SIZE - reclen;
+		kaddr += folio_size(folio) - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
@@ -489,16 +487,16 @@ int nilfs_add_link(struct dentry *dentry
 				goto got_it;
 			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
 		}
-		unlock_page(page);
-		unmap_and_put_page(page, kaddr);
+		folio_unlock(folio);
+		folio_release_kmap(folio, kaddr);
 	}
 	BUG();
 	return -EINVAL;
 
 got_it:
-	from = offset_in_page(de);
+	from = offset_in_folio(folio, de);
 	to = from + rec_len;
-	err = nilfs_prepare_chunk(page, from, to);
+	err = nilfs_prepare_chunk(&folio->page, from, to);
 	if (err)
 		goto out_unlock;
 	if (de->inode) {
@@ -513,16 +511,15 @@ got_it:
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	nilfs_commit_chunk(page, page->mapping, from, to);
+	nilfs_commit_chunk(&folio->page, folio->mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	unmap_and_put_page(page, de);
-out:
+	folio_release_kmap(folio, de);
 	return err;
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 	goto out_put;
 }
 
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
memory-failure-use-a-folio-in-me_pagecache_clean.patch
memory-failure-use-a-folio-in-me_pagecache_dirty.patch
memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch
memory-failure-use-a-folio-in-me_huge_page.patch
memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch
fs-convert-error_remove_page-to-error_remove_folio.patch
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
nilfs2-remove-page_address-from-nilfs_set_link.patch
nilfs2-remove-page_address-from-nilfs_add_link.patch
nilfs2-remove-page_address-from-nilfs_delete_entry.patch
nilfs2-return-the-mapped-address-from-nilfs_get_page.patch
nilfs2-pass-the-mapped-address-to-nilfs_check_page.patch
nilfs2-switch-to-kmap_local-for-directory-handling.patch
nilfs2-add-nilfs_get_folio.patch
nilfs2-convert-nilfs_readdir-to-use-a-folio.patch
nilfs2-convert-nilfs_find_entry-to-use-a-folio.patch
nilfs2-convert-nilfs_rename-to-use-folios.patch
nilfs2-convert-nilfs_add_link-to-use-a-folio.patch
nilfs2-convert-nilfs_empty_dir-to-use-a-folio.patch
nilfs2-convert-nilfs_make_empty-to-use-a-folio.patch
nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch
nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

