Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62D47493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ECwVbmtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908AEC433C8;
	Mon, 11 Dec 2023 01:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257769;
	bh=adH8+nEgo/BFM7hQL5FIk2OC+g1ZB++uURpfvvGJWUQ=;
	h=Date:To:From:Subject:From;
	b=ECwVbmtCzhdjdCN1fCb6AazR/4fpA5DJbQpJlEhDu2gwcjwVhladQrqwIQKw7rJ9N
	 T8X1FQmGFAbtHXD1KiovcIMqXzIceCfJH7FXQHMPzKyhaiFRwCXlIBY/amfekMOods
	 4rCNDdhor+ZQQZdS6CC2hXz1zViNaM7rzdZPvOFQ=
Date: Sun, 10 Dec 2023 17:22:49 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012249.908AEC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_page_mkwrite() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

