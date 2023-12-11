Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CCE79DF
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cv8GkXvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AF4C433C8;
	Mon, 11 Dec 2023 01:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257764;
	bh=pm3iBG9JbLfb2NJjqKMbUedrbhLaWinO6XaJluhLWwQ=;
	h=Date:To:From:Subject:From;
	b=cv8GkXvsKqIm0ihE8efZ0I9ijg9qHTag/hWVRog9e3pkTCac0CyPKIaaApsbNRRAM
	 C7iei/1OCyciTYn82RSOdPTThkOYoFCURsKbVWFrJUJgoWRig7ePwWOyooTs/4VqOe
	 3nnoxrWKFiTPwla1gYy4PuO/t3U+iKIIfkhpDTaU=
Date: Sun, 10 Dec 2023 17:22:43 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-to-nilfs_folio_buffers_clean.patch removed from -mm tree
Message-Id: <20231211012243.E0AF4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert to nilfs_folio_buffers_clean()
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-to-nilfs_folio_buffers_clean.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert to nilfs_folio_buffers_clean()
Date: Tue, 14 Nov 2023 17:44:21 +0900

All callers of nilfs_page_buffers_clean() now have a folio, so convert it
to take a folio.  While I'm at it, make it return a bool.

Link: https://lkml.kernel.org/r/20231114084436.2755-6-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c    |   18 +++++++++---------
 fs/nilfs2/page.h    |    2 +-
 fs/nilfs2/segment.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-to-nilfs_folio_buffers_clean
+++ a/fs/nilfs2/page.c
@@ -81,7 +81,7 @@ void nilfs_forget_buffer(struct buffer_h
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
-	if (nilfs_page_buffers_clean(&folio->page))
+	if (nilfs_folio_buffers_clean(folio))
 		__nilfs_clear_page_dirty(&folio->page);
 
 	bh->b_blocknr = -1;
@@ -131,23 +131,23 @@ void nilfs_copy_buffer(struct buffer_hea
 }
 
 /**
- * nilfs_page_buffers_clean - check if a page has dirty buffers or not.
- * @page: page to be checked
+ * nilfs_folio_buffers_clean - Check if a folio has dirty buffers or not.
+ * @folio: Folio to be checked.
  *
- * nilfs_page_buffers_clean() returns zero if the page has dirty buffers.
- * Otherwise, it returns non-zero value.
+ * nilfs_folio_buffers_clean() returns false if the folio has dirty buffers.
+ * Otherwise, it returns true.
  */
-int nilfs_page_buffers_clean(struct page *page)
+bool nilfs_folio_buffers_clean(struct folio *folio)
 {
 	struct buffer_head *bh, *head;
 
-	bh = head = page_buffers(page);
+	bh = head = folio_buffers(folio);
 	do {
 		if (buffer_dirty(bh))
-			return 0;
+			return false;
 		bh = bh->b_this_page;
 	} while (bh != head);
-	return 1;
+	return true;
 }
 
 void nilfs_page_bug(struct page *page)
--- a/fs/nilfs2/page.h~nilfs2-convert-to-nilfs_folio_buffers_clean
+++ a/fs/nilfs2/page.h
@@ -36,7 +36,7 @@ struct buffer_head *nilfs_grab_buffer(st
 				      unsigned long, unsigned long);
 void nilfs_forget_buffer(struct buffer_head *);
 void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
-int nilfs_page_buffers_clean(struct page *);
+bool nilfs_folio_buffers_clean(struct folio *);
 void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
--- a/fs/nilfs2/segment.c~nilfs2-convert-to-nilfs_folio_buffers_clean
+++ a/fs/nilfs2/segment.c
@@ -1759,7 +1759,7 @@ static void nilfs_end_folio_io(struct fo
 			 * all the buffers get cleaned later.
 			 */
 			folio_lock(folio);
-			if (nilfs_page_buffers_clean(&folio->page))
+			if (nilfs_folio_buffers_clean(folio))
 				__nilfs_clear_page_dirty(&folio->page);
 			folio_unlock(folio);
 		}
@@ -1767,7 +1767,7 @@ static void nilfs_end_folio_io(struct fo
 	}
 
 	if (!err) {
-		if (!nilfs_page_buffers_clean(&folio->page))
+		if (!nilfs_folio_buffers_clean(folio))
 			filemap_dirty_folio(folio->mapping, folio);
 		folio_clear_error(folio);
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

