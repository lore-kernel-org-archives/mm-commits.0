Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037927493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8kOt73B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C240BC433C9;
	Mon, 11 Dec 2023 01:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257766;
	bh=px6AxikZYMqNKj4KkbXiUKRia3txQPJp+I6FhDMccxk=;
	h=Date:To:From:Subject:From;
	b=r8kOt73BbGqdLQ+HikPYUx2nefIJwFjR4m4LMo7Zhe/ym9oEAWFEPA9NdguvmAm2A
	 0nAV/R70O6ZActhv9u+xfN2hZpZ5JKUqRWl05O3GfwnEKRMYuei0eWoz39HWOnE84J
	 HR3Wxl0Za5qTYcus9AglhqYSGXDlkJcIZ9qPsDF0=
Date: Sun, 10 Dec 2023 17:22:46 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-to-nilfs_clear_folio_dirty.patch removed from -mm tree
Message-Id: <20231211012246.C240BC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert to nilfs_clear_folio_dirty()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-to-nilfs_clear_folio_dirty.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert to nilfs_clear_folio_dirty()
Date: Tue, 14 Nov 2023 17:44:24 +0900

All callers of nilfs_clear_dirty_page() now have a folio, so rename the
function and pass in the folio.  Saves three hidden calls to
compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-9-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    2 +-
 fs/nilfs2/mdt.c   |    2 +-
 fs/nilfs2/page.c  |   27 ++++++++++++++-------------
 fs/nilfs2/page.h  |    2 +-
 4 files changed, 17 insertions(+), 16 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/inode.c
@@ -186,7 +186,7 @@ static int nilfs_writepage(struct page *
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_folio_dirty(folio, false);
 		folio_unlock(folio);
 		return -EROFS;
 	}
--- a/fs/nilfs2/mdt.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/mdt.c
@@ -411,7 +411,7 @@ nilfs_mdt_write_page(struct page *page,
 		 * have dirty folios that try to be flushed in background.
 		 * So, here we simply discard this dirty folio.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_folio_dirty(folio, false);
 		folio_unlock(folio);
 		return -EROFS;
 	}
--- a/fs/nilfs2/page.c~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.c
@@ -379,7 +379,7 @@ void nilfs_clear_dirty_pages(struct addr
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(folio->mapping == mapping))
-				nilfs_clear_dirty_page(&folio->page, silent);
+				nilfs_clear_folio_dirty(folio, silent);
 
 			folio_unlock(folio);
 		}
@@ -389,32 +389,33 @@ void nilfs_clear_dirty_pages(struct addr
 }
 
 /**
- * nilfs_clear_dirty_page - discard dirty page
- * @page: dirty page that will be discarded
+ * nilfs_clear_folio_dirty - discard dirty folio
+ * @folio: dirty folio that will be discarded
  * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_page(struct page *page, bool silent)
+void nilfs_clear_folio_dirty(struct folio *folio, bool silent)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb = inode->i_sb;
+	struct buffer_head *bh, *head;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!folio_test_locked(folio));
 
 	if (!silent)
 		nilfs_warn(sb, "discard dirty page: offset=%lld, ino=%lu",
-			   page_offset(page), inode->i_ino);
+			   folio_pos(folio), inode->i_ino);
 
-	ClearPageUptodate(page);
-	ClearPageMappedToDisk(page);
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh, *head;
+	head = folio_buffers(folio);
+	if (head) {
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
 			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
 
-		bh = head = page_buffers(page);
+		bh = head;
 		do {
 			lock_buffer(bh);
 			if (!silent)
@@ -427,7 +428,7 @@ void nilfs_clear_dirty_page(struct page
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
-	__nilfs_clear_page_dirty(page);
+	__nilfs_clear_page_dirty(&folio->page);
 }
 
 unsigned int nilfs_page_count_clean_buffers(struct page *page,
--- a/fs/nilfs2/page.h~nilfs2-convert-to-nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.h
@@ -41,7 +41,7 @@ void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_page(struct page *, bool);
+void nilfs_clear_folio_dirty(struct folio *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

