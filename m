Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA99C07D5B
	for <mm-commits@archiver.kernel.org>; Mon, 27 Nov 2023 17:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbjK0RID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Nov 2023 12:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbjK0RIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2023 12:08:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D36B10F7
        for <mm-commits@vger.kernel.org>; Mon, 27 Nov 2023 09:08:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6B7C433C7;
        Mon, 27 Nov 2023 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701104886;
        bh=JJGOZLLWF+dumt1RyQQRoFkBJSKWszx3YDmtf1fCR58=;
        h=Date:To:From:Subject:From;
        b=ywfv9dwiTqABnHbNqq9OLbehQmaUC1ISUXYkCpswATOMP04gFSMwyi3/Z0nWE8nAe
         OcVN7+tboS+8Z5X6LBb0tT+AWzMqaOZ2UbmFGj02XBBNgPJlKX2vS9BExxgUMrvnfh
         olTAgGvNFbb5/7mCOwf8eBtleENAZQ7nPozd0U1w=
Date:   Mon, 27 Nov 2023 09:08:06 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-nilfs_rename-to-use-folios.patch added to mm-nonmm-unstable branch
Message-Id: <20231127170806.9C6B7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: convert nilfs_rename() to use folios
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-nilfs_rename-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-nilfs_rename-to-use-folios.patch

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
Subject: nilfs2: convert nilfs_rename() to use folios
Date: Mon, 27 Nov 2023 23:30:31 +0900

This involves converting nilfs_find_entry(), nilfs_dotdot(),
nilfs_set_link(), nilfs_delete_entry() and nilfs_do_unlink() to use folios
as well.

[konishi.ryusuke: followed the change of page release helper call sites]
Link: https://lkml.kernel.org/r/20231127143036.2425-13-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c   |   68 ++++++++++++++++++++------------------------
 fs/nilfs2/namei.c |   36 +++++++++++------------
 fs/nilfs2/nilfs.h |   20 ++++++------
 3 files changed, 60 insertions(+), 64 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_rename-to-use-folios
+++ a/fs/nilfs2/dir.c
@@ -323,38 +323,35 @@ static int nilfs_readdir(struct file *fi
 }
 
 /*
- *	nilfs_find_entry()
+ * nilfs_find_entry()
  *
- * finds an entry in the specified directory with the wanted name. It
- * returns the page in which the entry was found, and the entry itself
- * (as a parameter - res_dir). Page is returned mapped and unlocked.
- * Entry is guaranteed to be valid.
+ * Finds an entry in the specified directory with the wanted name. It
+ * returns the folio in which the entry was found, and the entry itself.
+ * The folio is mapped and unlocked.  When the caller is finished with
+ * the entry, it should call folio_release_kmap().
+ *
+ * On failure, returns NULL and the caller should ignore foliop.
  */
-struct nilfs_dir_entry *
-nilfs_find_entry(struct inode *dir, const struct qstr *qstr,
-		 struct page **res_page)
+struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
+		const struct qstr *qstr, struct folio **foliop)
 {
 	const unsigned char *name = qstr->name;
 	int namelen = qstr->len;
 	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = dir_pages(dir);
-	struct folio *folio = NULL;
 	struct nilfs_inode_info *ei = NILFS_I(dir);
 	struct nilfs_dir_entry *de;
 
 	if (npages == 0)
 		goto out;
 
-	/* OFFSET_CACHE */
-	*res_page = NULL;
-
 	start = ei->i_dir_start_lookup;
 	if (start >= npages)
 		start = 0;
 	n = start;
 	do {
-		char *kaddr = nilfs_get_folio(dir, n, &folio);
+		char *kaddr = nilfs_get_folio(dir, n, foliop);
 
 		if (!IS_ERR(kaddr)) {
 			de = (struct nilfs_dir_entry *)kaddr;
@@ -363,14 +360,14 @@ nilfs_find_entry(struct inode *dir, cons
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					folio_release_kmap(folio, kaddr);
+					folio_release_kmap(*foliop, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			folio_release_kmap(folio, kaddr);
+			folio_release_kmap(*foliop, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
@@ -387,14 +384,13 @@ out:
 	return NULL;
 
 found:
-	*res_page = &folio->page;
 	ei->i_dir_start_lookup = n;
 	return de;
 }
 
-struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct page **p)
+struct nilfs_dir_entry *nilfs_dotdot(struct inode *dir, struct folio **foliop)
 {
-	struct nilfs_dir_entry *de = nilfs_get_page(dir, 0, p);
+	struct nilfs_dir_entry *de = nilfs_get_folio(dir, 0, foliop);
 
 	if (IS_ERR(de))
 		return NULL;
@@ -405,30 +401,30 @@ ino_t nilfs_inode_by_name(struct inode *
 {
 	ino_t res = 0;
 	struct nilfs_dir_entry *de;
-	struct page *page;
+	struct folio *folio;
 
-	de = nilfs_find_entry(dir, qstr, &page);
+	de = nilfs_find_entry(dir, qstr, &folio);
 	if (de) {
 		res = le64_to_cpu(de->inode);
-		unmap_and_put_page(page, de);
+		folio_release_kmap(folio, de);
 	}
 	return res;
 }
 
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
-		    struct page *page, struct inode *inode)
+		    struct folio *folio, struct inode *inode)
 {
-	unsigned int from = offset_in_page(de);
-	unsigned int to = from + nilfs_rec_len_from_disk(de->rec_len);
-	struct address_space *mapping = page->mapping;
+	size_t from = offset_in_folio(folio, de);
+	size_t to = from + nilfs_rec_len_from_disk(de->rec_len);
+	struct address_space *mapping = folio->mapping;
 	int err;
 
-	lock_page(page);
-	err = nilfs_prepare_chunk(page, from, to);
+	folio_lock(folio);
+	err = nilfs_prepare_chunk(&folio->page, from, to);
 	BUG_ON(err);
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
-	nilfs_commit_chunk(page, mapping, from, to);
+	nilfs_commit_chunk(&folio->page, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
 
@@ -532,14 +528,14 @@ out_unlock:
 
 /*
  * nilfs_delete_entry deletes a directory entry by merging it with the
- * previous entry. Page is up-to-date.
+ * previous entry. Folio is up-to-date.
  */
-int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
+int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct folio *folio)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
-	char *kaddr = (char *)((unsigned long)dir & PAGE_MASK);
-	unsigned int from, to;
+	char *kaddr = (char *)((unsigned long)dir & ~(folio_size(folio) - 1));
+	size_t from, to;
 	struct nilfs_dir_entry *de, *pde = NULL;
 	int err;
 
@@ -559,13 +555,13 @@ int nilfs_delete_entry(struct nilfs_dir_
 	}
 	if (pde)
 		from = (char *)pde - kaddr;
-	lock_page(page);
-	err = nilfs_prepare_chunk(page, from, to);
+	folio_lock(folio);
+	err = nilfs_prepare_chunk(&folio->page, from, to);
 	BUG_ON(err);
 	if (pde)
 		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
-	nilfs_commit_chunk(page, mapping, from, to);
+	nilfs_commit_chunk(&folio->page, mapping, from, to);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 out:
 	return err;
--- a/fs/nilfs2/namei.c~nilfs2-convert-nilfs_rename-to-use-folios
+++ a/fs/nilfs2/namei.c
@@ -260,11 +260,11 @@ static int nilfs_do_unlink(struct inode
 {
 	struct inode *inode;
 	struct nilfs_dir_entry *de;
-	struct page *page;
+	struct folio *folio;
 	int err;
 
 	err = -ENOENT;
-	de = nilfs_find_entry(dir, &dentry->d_name, &page);
+	de = nilfs_find_entry(dir, &dentry->d_name, &folio);
 	if (!de)
 		goto out;
 
@@ -279,8 +279,8 @@ static int nilfs_do_unlink(struct inode
 			   inode->i_ino, inode->i_nlink);
 		set_nlink(inode, 1);
 	}
-	err = nilfs_delete_entry(de, page);
-	unmap_and_put_page(page, de);
+	err = nilfs_delete_entry(de, folio);
+	folio_release_kmap(folio, de);
 	if (err)
 		goto out;
 
@@ -348,9 +348,9 @@ static int nilfs_rename(struct mnt_idmap
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
-	struct page *dir_page = NULL;
+	struct folio *dir_folio = NULL;
 	struct nilfs_dir_entry *dir_de = NULL;
-	struct page *old_page;
+	struct folio *old_folio;
 	struct nilfs_dir_entry *old_de;
 	struct nilfs_transaction_info ti;
 	int err;
@@ -363,19 +363,19 @@ static int nilfs_rename(struct mnt_idmap
 		return err;
 
 	err = -ENOENT;
-	old_de = nilfs_find_entry(old_dir, &old_dentry->d_name, &old_page);
+	old_de = nilfs_find_entry(old_dir, &old_dentry->d_name, &old_folio);
 	if (!old_de)
 		goto out;
 
 	if (S_ISDIR(old_inode->i_mode)) {
 		err = -EIO;
-		dir_de = nilfs_dotdot(old_inode, &dir_page);
+		dir_de = nilfs_dotdot(old_inode, &dir_folio);
 		if (!dir_de)
 			goto out_old;
 	}
 
 	if (new_inode) {
-		struct page *new_page;
+		struct folio *new_folio;
 		struct nilfs_dir_entry *new_de;
 
 		err = -ENOTEMPTY;
@@ -383,11 +383,11 @@ static int nilfs_rename(struct mnt_idmap
 			goto out_dir;
 
 		err = -ENOENT;
-		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name, &new_page);
+		new_de = nilfs_find_entry(new_dir, &new_dentry->d_name, &new_folio);
 		if (!new_de)
 			goto out_dir;
-		nilfs_set_link(new_dir, new_de, new_page, old_inode);
-		unmap_and_put_page(new_page, new_de);
+		nilfs_set_link(new_dir, new_de, new_folio, old_inode);
+		folio_release_kmap(new_folio, new_de);
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -410,14 +410,14 @@ static int nilfs_rename(struct mnt_idmap
 	 */
 	inode_set_ctime_current(old_inode);
 
-	nilfs_delete_entry(old_de, old_page);
+	nilfs_delete_entry(old_de, old_folio);
 
 	if (dir_de) {
-		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
-		unmap_and_put_page(dir_page, dir_de);
+		nilfs_set_link(old_inode, dir_de, dir_folio, new_dir);
+		folio_release_kmap(dir_folio, dir_de);
 		drop_nlink(old_dir);
 	}
-	unmap_and_put_page(old_page, old_de);
+	folio_release_kmap(old_folio, old_de);
 
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
@@ -427,9 +427,9 @@ static int nilfs_rename(struct mnt_idmap
 
 out_dir:
 	if (dir_de)
-		unmap_and_put_page(dir_page, dir_de);
+		folio_release_kmap(dir_folio, dir_de);
 out_old:
-	unmap_and_put_page(old_page, old_de);
+	folio_release_kmap(old_folio, old_de);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
--- a/fs/nilfs2/nilfs.h~nilfs2-convert-nilfs_rename-to-use-folios
+++ a/fs/nilfs2/nilfs.h
@@ -226,16 +226,16 @@ static inline __u32 nilfs_mask_flags(umo
 }
 
 /* dir.c */
-extern int nilfs_add_link(struct dentry *, struct inode *);
-extern ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
-extern int nilfs_make_empty(struct inode *, struct inode *);
-extern struct nilfs_dir_entry *
-nilfs_find_entry(struct inode *, const struct qstr *, struct page **);
-extern int nilfs_delete_entry(struct nilfs_dir_entry *, struct page *);
-extern int nilfs_empty_dir(struct inode *);
-extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
-extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
-			   struct page *, struct inode *);
+int nilfs_add_link(struct dentry *, struct inode *);
+ino_t nilfs_inode_by_name(struct inode *, const struct qstr *);
+int nilfs_make_empty(struct inode *, struct inode *);
+struct nilfs_dir_entry *nilfs_find_entry(struct inode *, const struct qstr *,
+		struct folio **);
+int nilfs_delete_entry(struct nilfs_dir_entry *, struct folio *);
+int nilfs_empty_dir(struct inode *);
+struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct folio **);
+void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
+			   struct folio *, struct inode *);
 
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

