Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125FBBE64
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/ixe4Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C4C433C8;
	Mon, 11 Dec 2023 01:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257853;
	bh=jOLoJMh6JsLuhqXfQuZvsGMp5jxWRM+g9jJ5XlD1MWI=;
	h=Date:To:From:Subject:From;
	b=H/ixe4UlPYnoe+1dElOtNyR0a+VM+Yr7JlkHQzRvovgjhbYN0oq8qjZFP97hzH+uH
	 9EKHJ3A5TU7WuVUB+wTbhsaVfbwmzjSZ4vvlOhEMycoG+lCqfIBfL9JmzF20ROOqaT
	 SwPw1jXwMYMwatXanLf621r5H6jqE3Ylfm6WtE70=
Date: Sun, 10 Dec 2023 17:24:13 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_add_link-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012413.D07C4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_add_link() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_add_link-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

