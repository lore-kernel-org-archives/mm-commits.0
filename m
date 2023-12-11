Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DE979D8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPzciiv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9153C433C8;
	Mon, 11 Dec 2023 01:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257760;
	bh=pAGCYJD4j0yb1QPzVjkRm3dG8vitpKi241C60MBmVO4=;
	h=Date:To:From:Subject:From;
	b=bPzciiv4N4SZsovXL7Da8dfEi95KvTLYgPunZNwkMSdtgwro088zZuLHbnErzHsAZ
	 zceR31Ygm4jWfylZ58BfQkG87vRP4FLRgS/pTZDH/lcBCN8tF1JobOd1Kciiqufi++
	 OCElbNSKXTrQjsGi6ANRnatP+tIC7ICbeThyNJA0=
Date: Sun, 10 Dec 2023 17:22:39 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-nilfs_end_folio_io.patch removed from -mm tree
Message-Id: <20231211012239.E9153C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add nilfs_end_folio_io()
has been removed from the -mm tree.  Its filename was
     nilfs2-add-nilfs_end_folio_io.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: add nilfs_end_folio_io()
Date: Tue, 14 Nov 2023 17:44:17 +0900

Patch series "nilfs2: Folio conversions for file paths".

This series advances page->folio conversions for a wide range of nilfs2,
including its file operations, block routines, and the log writer's
writeback routines.  It doesn't cover large folios support, but it saves a
lot of hidden compound_head() calls while preserving the existing support
range behavior.

The original series in post [1] also covered directory-related page->folio
conversions, but that was put on hold because a regression was found in
testing, so this is an excerpt from the first half of the original post.

[1] https://lkml.kernel.org/r/20231106173903.1734114-1-willy@infradead.org

I tested this series in both 32-bit and 64-bit environments, switching
between normal and small block sizes.  I also reviewed all changes in all
patches to ensure they do not break existing behavior.  There were no
problems.


This patch (of 20):

This is the folio counterpart of the existing nilfs_end_page_io() which is
retained as a wrapper of nilfs_end_folio_io().  Replaces nine hidden calls
to compound_head() with one.

Link: https://lkml.kernel.org/r/20231114084436.2755-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20231114084436.2755-2-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-add-nilfs_end_folio_io
+++ a/fs/nilfs2/segment.c
@@ -1739,17 +1739,18 @@ static int nilfs_segctor_write(struct ni
 	return ret;
 }
 
-static void nilfs_end_page_io(struct page *page, int err)
+static void nilfs_end_folio_io(struct folio *folio, int err)
 {
-	if (!page)
+	if (!folio)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
+	if (buffer_nilfs_node(folio_buffers(folio)) &&
+			!folio_test_writeback(folio)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
 		 * or more because they might be split in a segment.
 		 */
-		if (PageDirty(page)) {
+		if (folio_test_dirty(folio)) {
 			/*
 			 * For pages holding split b-tree node buffers, dirty
 			 * flag on the buffers may be cleared discretely.
@@ -1757,24 +1758,31 @@ static void nilfs_end_page_io(struct pag
 			 * remaining buffers, and it must be cancelled if
 			 * all the buffers get cleaned later.
 			 */
-			lock_page(page);
-			if (nilfs_page_buffers_clean(page))
-				__nilfs_clear_page_dirty(page);
-			unlock_page(page);
+			folio_lock(folio);
+			if (nilfs_page_buffers_clean(&folio->page))
+				__nilfs_clear_page_dirty(&folio->page);
+			folio_unlock(folio);
 		}
 		return;
 	}
 
 	if (!err) {
-		if (!nilfs_page_buffers_clean(page))
-			__set_page_dirty_nobuffers(page);
-		ClearPageError(page);
+		if (!nilfs_page_buffers_clean(&folio->page))
+			filemap_dirty_folio(folio->mapping, folio);
+		folio_clear_error(folio);
 	} else {
-		__set_page_dirty_nobuffers(page);
-		SetPageError(page);
+		filemap_dirty_folio(folio->mapping, folio);
+		folio_set_error(folio);
 	}
 
-	end_page_writeback(page);
+	folio_end_writeback(folio);
+}
+
+static void nilfs_end_page_io(struct page *page, int err)
+{
+	if (!page)
+		return;
+	nilfs_end_folio_io(page_folio(page), err);
 }
 
 static void nilfs_abort_logs(struct list_head *logs, int err)
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

