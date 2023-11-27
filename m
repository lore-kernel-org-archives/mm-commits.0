Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7DAC0755A
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjK0RJM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbjK0RI7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:08:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34A192
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:08:14 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CDFC433C9;
        Mon, 27 Nov 2023 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104894;
        bh=KPKgAa0yllNDNtEenZvNHltVK3matIhuwYwTBKnJ8dM=;
        h=Date:To:From:Subject:From;
        b=OkiYyKIE34eZI1p7CuLEdn1ODOlkZ2TujbXaS5EOPDXQvv8NVONWiU4nEZ681W7QB
         k6ku0DSEwYN8DB2dqd7gfVOyh7g04yR3G0tdfRzC5QyLaBKDOnLgAisZ7pe0QyNLLP
         s8unRNrTKYx94hYoLpQKuyI6f5VP1MTIt7uo3jnc=
Date:   Mon, 27 Nov 2023 09:08:13 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170814.28CDFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_prepare_chunk() and nilfs_commit_chunk() to folios
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch

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
Subject: nilfs2: convert nilfs_prepare_chunk() and nilfs_commit_chunk() to folios
Date: Mon, 27 Nov 2023 23:30:35 +0900

All callers now have a folio, so convert these two functions.
Saves one call to compound_head() in unlock_page().

[konishi.ryusuke: resolved conflicts in nilfs_{set_link,delete_entry}]
Link: https://lkml.kernel.org/r/20231127143036.2425-17-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios
+++ a/fs/nilfs2/dir.c
@@ -78,33 +78,32 @@ static unsigned int nilfs_last_byte(stru
 	return last_byte;
 }
 
-static int nilfs_prepare_chunk(struct page *page, unsigned int from,
+static int nilfs_prepare_chunk(struct folio *folio, unsigned int from,
 			       unsigned int to)
 {
-	loff_t pos = page_offset(page) + from;
+	loff_t pos = folio_pos(folio) + from;
 
-	return __block_write_begin(page, pos, to - from, nilfs_get_block);
+	return __block_write_begin(&folio->page, pos, to - from, nilfs_get_block);
 }
 
-static void nilfs_commit_chunk(struct page *page,
-			       struct address_space *mapping,
-			       unsigned int from, unsigned int to)
+static void nilfs_commit_chunk(struct folio *folio,
+		struct address_space *mapping, size_t from, size_t to)
 {
 	struct inode *dir = mapping->host;
-	loff_t pos = page_offset(page) + from;
-	unsigned int len = to - from;
-	unsigned int nr_dirty, copied;
+	loff_t pos = folio_pos(folio) + from;
+	size_t copied, len = to - from;
+	unsigned int nr_dirty;
 	int err;
 
-	nr_dirty = nilfs_page_count_clean_buffers(page, from, to);
-	copied = block_write_end(NULL, mapping, pos, len, len, page, NULL);
+	nr_dirty = nilfs_page_count_clean_buffers(&folio->page, from, to);
+	copied = block_write_end(NULL, mapping, pos, len, len, &folio->page, NULL);
 	if (pos + copied > dir->i_size)
 		i_size_write(dir, pos + copied);
 	if (IS_DIRSYNC(dir))
 		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	err = nilfs_set_file_dirty(dir, nr_dirty);
 	WARN_ON(err); /* do not happen */
-	unlock_page(page);
+	folio_unlock(folio);
 }
 
 static bool nilfs_check_folio(struct folio *folio, char *kaddr)
@@ -409,11 +408,11 @@ void nilfs_set_link(struct inode *dir, s
 	int err;
 
 	folio_lock(folio);
-	err = nilfs_prepare_chunk(&folio->page, from, to);
+	err = nilfs_prepare_chunk(folio, from, to);
 	BUG_ON(err);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	nilfs_commit_chunk(&folio->page, mapping, from, to);
+	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
 
@@ -485,7 +484,7 @@ int nilfs_add_link(struct dentry *dentry
 got_it:
 	from = offset_in_folio(folio, de);
 	to = from + rec_len;
-	err = nilfs_prepare_chunk(&folio->page, from, to);
+	err = nilfs_prepare_chunk(folio, from, to);
 	if (err)
 		goto out_unlock;
 	if (de->inode) {
@@ -500,7 +499,7 @@ got_it:
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	nilfs_commit_chunk(&folio->page, folio->mapping, from, to);
+	nilfs_commit_chunk(folio, folio->mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
@@ -542,12 +541,12 @@ int nilfs_delete_entry(struct nilfs_dir_
 	if (pde)
 		from = (char *)pde - kaddr;
 	folio_lock(folio);
-	err = nilfs_prepare_chunk(&folio->page, from, to);
+	err = nilfs_prepare_chunk(folio, from, to);
 	BUG_ON(err);
 	if (pde)
 		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
-	nilfs_commit_chunk(&folio->page, mapping, from, to);
+	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 out:
 	return err;
@@ -568,7 +567,7 @@ int nilfs_make_empty(struct inode *inode
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	err = nilfs_prepare_chunk(&folio->page, 0, chunk_size);
+	err = nilfs_prepare_chunk(folio, 0, chunk_size);
 	if (unlikely(err)) {
 		folio_unlock(folio);
 		goto fail;
@@ -589,7 +588,7 @@ int nilfs_make_empty(struct inode *inode
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
 	kunmap_local(kaddr);
-	nilfs_commit_chunk(&folio->page, mapping, 0, chunk_size);
+	nilfs_commit_chunk(folio, mapping, 0, chunk_size);
 fail:
 	folio_put(folio);
 	return err;
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

