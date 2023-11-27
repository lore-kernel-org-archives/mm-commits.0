Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BE0C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjK0RIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjK0RHy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:07:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B068010D2
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:07:59 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51842C433C7;
        Mon, 27 Nov 2023 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104879;
        bh=UOiHcZLdLZFdfSHZyWyIFs3Gbj6mgrNqMzTxIvjfggc=;
        h=Date:To:From:Subject:From;
        b=1oQT6B9jJf9rbrzVDMOwhjPbduURPmKzlFR2u60tYgaXTsSCBy+wRDrfuYkhyDazE
         oOy3l/19jRT3QKXvodhabesoXO2UP/hDrItjOw9BC02M/E1c+iOmKatSNatWEgiEeT
         FS6cLC3W/epIued1LB809TB3sQAARUacnVq1MyE4=
Date:   Mon, 27 Nov 2023 09:07:58 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-switch-to-kmap_local-for-directory-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170759.51842C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: switch to kmap_local for directory handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-switch-to-kmap_local-for-directory-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-switch-to-kmap_local-for-directory-handling.patch

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
Subject: nilfs2: switch to kmap_local for directory handling
Date: Mon, 27 Nov 2023 23:30:27 +0900

Match ext2 by using kmap_local() instead of kmap().  This is more
efficient.  Also use unmap_and_put_page() instead of duplicating it as a
nilfs function.

[konishi.ryusuke: followed the change of page release helper call sites]
Link: https://lkml.kernel.org/r/20231127143036.2425-9-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   27 +++++++++++++--------------
 fs/nilfs2/namei.c |   12 ++++++------
 fs/nilfs2/nilfs.h |    6 ------
 3 files changed, 19 insertions(+), 26 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/dir.c
@@ -189,7 +189,7 @@ static void *nilfs_get_page(struct inode
 	if (IS_ERR(page))
 		return page;
 
-	kaddr = kmap(page);
+	kaddr = kmap_local_page(page);
 	if (unlikely(!PageChecked(page))) {
 		if (!nilfs_check_page(page, kaddr))
 			goto fail;
@@ -199,7 +199,7 @@ static void *nilfs_get_page(struct inode
 	return kaddr;
 
 fail:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return ERR_PTR(-EIO);
 }
 
@@ -287,7 +287,7 @@ static int nilfs_readdir(struct file *fi
 		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
 			if (de->rec_len == 0) {
 				nilfs_error(sb, "zero-length directory entry");
-				nilfs_put_page(page);
+				unmap_and_put_page(page, kaddr);
 				return -EIO;
 			}
 			if (de->inode) {
@@ -300,13 +300,13 @@ static int nilfs_readdir(struct file *fi
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					return 0;
 				}
 			}
 			ctx->pos += nilfs_rec_len_from_disk(de->rec_len);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 0;
 }
@@ -352,14 +352,14 @@ nilfs_find_entry(struct inode *dir, cons
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					nilfs_put_page(page);
+					unmap_and_put_page(page, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			nilfs_put_page(page);
+			unmap_and_put_page(page, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -399,8 +399,7 @@ ino_t nilfs_inode_by_name(struct inode *
 	de = nilfs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le64_to_cpu(de->inode);
-		kunmap(page);
-		put_page(page);
+		unmap_and_put_page(page, de);
 	}
 	return res;
 }
@@ -484,7 +483,7 @@ int nilfs_add_link(struct dentry *dentry
 			de = (struct nilfs_dir_entry *)((char *)de + rec_len);
 		}
 		unlock_page(page);
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	BUG();
 	return -EINVAL;
@@ -512,7 +511,7 @@ got_it:
 	nilfs_mark_inode_dirty(dir);
 	/* OFFSET_CACHE */
 out_put:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 out:
 	return err;
 out_unlock:
@@ -609,10 +608,10 @@ fail:
 int nilfs_empty_dir(struct inode *inode)
 {
 	struct page *page = NULL;
+	char *kaddr;
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
-		char *kaddr;
 		struct nilfs_dir_entry *de;
 
 		kaddr = nilfs_get_page(inode, i, &page);
@@ -644,12 +643,12 @@ int nilfs_empty_dir(struct inode *inode)
 			}
 			de = nilfs_next_entry(de);
 		}
-		nilfs_put_page(page);
+		unmap_and_put_page(page, kaddr);
 	}
 	return 1;
 
 not_empty:
-	nilfs_put_page(page);
+	unmap_and_put_page(page, kaddr);
 	return 0;
 }
 
--- a/fs/nilfs2/namei.c~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/namei.c
@@ -280,7 +280,7 @@ static int nilfs_do_unlink(struct inode
 		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
-	nilfs_put_page(page);
+	unmap_and_put_page(page, de);
 	if (err)
 		goto out;
 
@@ -387,7 +387,7 @@ static int nilfs_rename(struct mnt_idmap
 		if (!new_de)
 			goto out_dir;
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
-		nilfs_put_page(new_page);
+		unmap_and_put_page(new_page, new_de);
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -414,10 +414,10 @@ static int nilfs_rename(struct mnt_idmap
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
-		nilfs_put_page(dir_page);
+		unmap_and_put_page(dir_page, dir_de);
 		drop_nlink(old_dir);
 	}
-	nilfs_put_page(old_page);
+	unmap_and_put_page(old_page, old_de);
 
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
@@ -427,9 +427,9 @@ static int nilfs_rename(struct mnt_idmap
 
 out_dir:
 	if (dir_de)
-		nilfs_put_page(dir_page);
+		unmap_and_put_page(dir_page, dir_de);
 out_old:
-	nilfs_put_page(old_page);
+	unmap_and_put_page(old_page, old_de);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
--- a/fs/nilfs2/nilfs.h~nilfs2-switch-to-kmap_local-for-directory-handling
+++ a/fs/nilfs2/nilfs.h
@@ -237,12 +237,6 @@ extern struct nilfs_dir_entry *nilfs_dot
 extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
-static inline void nilfs_put_page(struct page *page)
-{
-	kunmap(page);
-	put_page(page);
-}
-
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
 
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

