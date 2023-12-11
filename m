Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A5C7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZzKbIlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F404C433C8;
	Mon, 11 Dec 2023 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257775;
	bh=7QVEkzEHKq0LJDKGXeOl+jhk40Ee4aS0R1yfwcBJFAc=;
	h=Date:To:From:Subject:From;
	b=CZzKbIlrESidNiXvSeNp3Lp+JtzSs6xx6f/jx1bBss1u2b7lyfFUzCf2z5fZqxAhK
	 QXqoe5XgdkSXJNrbz9EeA/lMuSQZtqn96K6JSZq+Pn3fn16KDcCk1ppMAVKlDkoDsI
	 kvK4jY5GJ7u2BZjYBvibDU55x9F7eQOgQY7W1Hps=
Date: Sun, 10 Dec 2023 17:22:54 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012255.3F404C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_delete to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_delete to use a folio
Date: Tue, 14 Nov 2023 17:44:33 +0900

Saves six calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-18-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_delete-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -145,19 +145,19 @@ out_locked:
 void nilfs_btnode_delete(struct buffer_head *bh)
 {
 	struct address_space *mapping;
-	struct page *page = bh->b_page;
-	pgoff_t index = page_index(page);
+	struct folio *folio = bh->b_folio;
+	pgoff_t index = folio->index;
 	int still_dirty;
 
-	get_page(page);
-	lock_page(page);
-	wait_on_page_writeback(page);
+	folio_get(folio);
+	folio_lock(folio);
+	folio_wait_writeback(folio);
 
 	nilfs_forget_buffer(bh);
-	still_dirty = PageDirty(page);
-	mapping = page->mapping;
-	unlock_page(page);
-	put_page(page);
+	still_dirty = folio_test_dirty(folio);
+	mapping = folio->mapping;
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (!still_dirty && mapping)
 		invalidate_inode_pages2_range(mapping, index, index);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

