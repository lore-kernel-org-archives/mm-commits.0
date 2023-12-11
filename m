Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E87493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lyNvXEdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA481C433C9;
	Mon, 11 Dec 2023 01:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257767;
	bh=ePqFOq3KwYiMJMfyjTY3gJbedGdLDCjj4sIrCaG/PY8=;
	h=Date:To:From:Subject:From;
	b=lyNvXEdhENDQ5xi+BeKX410MGsslVwTqdFvJY6R0Y+FQ8PB3gQzZICNdSkdPp+hh9
	 kqZvqo+Hu+tJ4H3d+12RvMuwAnEbjFA/xOiNs5sTVeipjeMG9dzmlDY7rug6ER3i4X
	 GTwVakfMgZFJPp+HaezAWncYeezlcxeDVNQYAXoY=
Date: Sun, 10 Dec 2023 17:22:47 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-to-__nilfs_clear_folio_dirty.patch removed from -mm tree
Message-Id: <20231211012247.AA481C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert to __nilfs_clear_folio_dirty()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-to-__nilfs_clear_folio_dirty.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert to __nilfs_clear_folio_dirty()
Date: Tue, 14 Nov 2023 17:44:25 +0900

All callers now have a folio, so convert to pass a folio.  No caller uses
the return value, so make it return void.  Removes a couple of hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-10-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c    |   19 ++++++++++---------
 fs/nilfs2/page.h    |    2 +-
 fs/nilfs2/segment.c |    2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.c
@@ -82,7 +82,7 @@ void nilfs_forget_buffer(struct buffer_h
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
 	if (nilfs_folio_buffers_clean(folio))
-		__nilfs_clear_page_dirty(&folio->page);
+		__nilfs_clear_folio_dirty(folio);
 
 	bh->b_blocknr = -1;
 	folio_clear_uptodate(folio);
@@ -428,7 +428,7 @@ void nilfs_clear_folio_dirty(struct foli
 		} while (bh = bh->b_this_page, bh != head);
 	}
 
-	__nilfs_clear_page_dirty(&folio->page);
+	__nilfs_clear_folio_dirty(folio);
 }
 
 unsigned int nilfs_page_count_clean_buffers(struct page *page,
@@ -458,22 +458,23 @@ unsigned int nilfs_page_count_clean_buff
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
  */
-int __nilfs_clear_page_dirty(struct page *page)
+void __nilfs_clear_folio_dirty(struct folio *folio)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 
 	if (mapping) {
 		xa_lock_irq(&mapping->i_pages);
-		if (test_bit(PG_dirty, &page->flags)) {
-			__xa_clear_mark(&mapping->i_pages, page_index(page),
+		if (folio_test_dirty(folio)) {
+			__xa_clear_mark(&mapping->i_pages, folio->index,
 					     PAGECACHE_TAG_DIRTY);
 			xa_unlock_irq(&mapping->i_pages);
-			return clear_page_dirty_for_io(page);
+			folio_clear_dirty_for_io(folio);
+			return;
 		}
 		xa_unlock_irq(&mapping->i_pages);
-		return 0;
+		return;
 	}
-	return TestClearPageDirty(page);
+	folio_clear_dirty(folio);
 }
 
 /**
--- a/fs/nilfs2/page.h~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/page.h
@@ -30,7 +30,7 @@ BUFFER_FNS(NILFS_Checked, nilfs_checked)
 BUFFER_FNS(NILFS_Redirected, nilfs_redirected)	/* redirected to a copy */
 
 
-int __nilfs_clear_page_dirty(struct page *);
+void __nilfs_clear_folio_dirty(struct folio *);
 
 struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 				      unsigned long, unsigned long);
--- a/fs/nilfs2/segment.c~nilfs2-convert-to-__nilfs_clear_folio_dirty
+++ a/fs/nilfs2/segment.c
@@ -1760,7 +1760,7 @@ static void nilfs_end_folio_io(struct fo
 			 */
 			folio_lock(folio);
 			if (nilfs_folio_buffers_clean(folio))
-				__nilfs_clear_page_dirty(&folio->page);
+				__nilfs_clear_folio_dirty(folio);
 			folio_unlock(folio);
 		}
 		return;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

