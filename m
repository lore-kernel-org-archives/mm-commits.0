Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9FEEDF
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PSsvQyju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ADAC433C7;
	Mon, 11 Dec 2023 01:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257850;
	bh=f56UZAHJzuqg0h4fq8ds0S49sE2oR0OZoYqeTyE6KdA=;
	h=Date:To:From:Subject:From;
	b=PSsvQyju7f/wDLlaU/CT7DoCD7xVtRzmUXklNh+Hi8Z4tVkgFDIhxPe2Cfh2W8eL7
	 8Wc5ZLzIpXosE9QVUBDdR0lTN2Uon2z7H+WEFrGPDAuv/CSUKHfaXyjv2uHNLKfoWO
	 GqMoeKlIrQV+O3yQhv9f7Hqo4otep8t6Wl5HFDjI=
Date: Sun, 10 Dec 2023 17:24:09 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-nilfs_get_folio.patch removed from -mm tree
Message-Id: <20231211012410.16ADAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add nilfs_get_folio()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-nilfs_get_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: add nilfs_get_folio()
Date: Mon, 27 Nov 2023 23:30:28 +0900

Convert nilfs_get_page() to be a wrapper.
Also convert nilfs_check_page() to nilfs_check_folio().

Link: https://lkml.kernel.org/r/20231127143036.2425-10-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   53 +++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-add-nilfs_get_folio
+++ a/fs/nilfs2/dir.c
@@ -107,18 +107,18 @@ static void nilfs_commit_chunk(struct pa
 	unlock_page(page);
 }
 
-static bool nilfs_check_page(struct page *page, char *kaddr)
+static bool nilfs_check_folio(struct folio *folio, char *kaddr)
 {
-	struct inode *dir = page->mapping->host;
+	struct inode *dir = folio->mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned int chunk_size = nilfs_chunk_size(dir);
-	unsigned int offs, rec_len;
-	unsigned int limit = PAGE_SIZE;
+	size_t offs, rec_len;
+	size_t limit = folio_size(folio);
 	struct nilfs_dir_entry *p;
 	char *error;
 
-	if ((dir->i_size >> PAGE_SHIFT) == page->index) {
-		limit = dir->i_size & ~PAGE_MASK;
+	if (dir->i_size < folio_pos(folio) + limit) {
+		limit = dir->i_size - folio_pos(folio);
 		if (limit & (chunk_size - 1))
 			goto Ebadsize;
 		if (!limit)
@@ -140,7 +140,7 @@ static bool nilfs_check_page(struct page
 	if (offs != limit)
 		goto Eend;
 out:
-	SetPageChecked(page);
+	folio_set_checked(folio);
 	return true;
 
 	/* Too bad, we had an error */
@@ -163,8 +163,8 @@ Espan:
 	error = "directory entry across blocks";
 bad_entry:
 	nilfs_error(sb,
-		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		    dir->i_ino, error, (page->index << PAGE_SHIFT) + offs,
+		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%zd, name_len=%d",
+		    dir->i_ino, error, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode),
 		    rec_len, p->name_len);
 	goto fail;
@@ -172,37 +172,48 @@ Eend:
 	p = (struct nilfs_dir_entry *)(kaddr + offs);
 	nilfs_error(sb,
 		    "entry in directory #%lu spans the page boundary offset=%lu, inode=%lu",
-		    dir->i_ino, (page->index << PAGE_SHIFT) + offs,
+		    dir->i_ino, (folio->index << PAGE_SHIFT) + offs,
 		    (unsigned long)le64_to_cpu(p->inode));
 fail:
-	SetPageError(page);
+	folio_set_error(folio);
 	return false;
 }
 
-static void *nilfs_get_page(struct inode *dir, unsigned long n,
-		struct page **pagep)
+static void *nilfs_get_folio(struct inode *dir, unsigned long n,
+		struct folio **foliop)
 {
 	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
+	struct folio *folio = read_mapping_folio(mapping, n, NULL);
 	void *kaddr;
 
-	if (IS_ERR(page))
-		return page;
+	if (IS_ERR(folio))
+		return folio;
 
-	kaddr = kmap_local_page(page);
-	if (unlikely(!PageChecked(page))) {
-		if (!nilfs_check_page(page, kaddr))
+	kaddr = kmap_local_folio(folio, 0);
+	if (unlikely(!folio_test_checked(folio))) {
+		if (!nilfs_check_folio(folio, kaddr))
 			goto fail;
 	}
 
-	*pagep = page;
+	*foliop = folio;
 	return kaddr;
 
 fail:
-	unmap_and_put_page(page, kaddr);
+	folio_release_kmap(folio, kaddr);
 	return ERR_PTR(-EIO);
 }
 
+static void *nilfs_get_page(struct inode *dir, unsigned long n,
+		struct page **pagep)
+{
+	struct folio *folio;
+	void *kaddr = nilfs_get_folio(dir, n, &folio);
+
+	if (!IS_ERR(kaddr))
+		*pagep = &folio->page;
+	return kaddr;
+}
+
 /*
  * NOTE! unlike strncmp, nilfs_match returns 1 for success, 0 for failure.
  *
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

