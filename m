Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4EA7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rrt7m/Hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7304C433C9;
	Mon, 11 Dec 2023 01:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257768;
	bh=Qiirj7uUDzmiJKqLAyNYd0jd+n1uzw2YpUdYZD2H4f4=;
	h=Date:To:From:Subject:From;
	b=rrt7m/HfFUv9hggrMuG7TzMrUhkkhwsV+FRNzavwX83A3ujZX750Cv2oJhk/F8Bjm
	 PJxHEGtd4pwn/oUEQuoACD9l3Xnwaj7qOk2Or1jfwMarC5De6e/sI4wGmGl54fQmcI
	 5ATzXgP5ywGazohDMmntACRBckeDPDh96P+jnBkI=
Date: Sun, 10 Dec 2023 17:22:48 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch removed from -mm tree
Message-Id: <20231211012248.A7304C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_segctor_prepare_write to use folios
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_segctor_prepare_write to use folios
Date: Tue, 14 Nov 2023 17:44:26 +0900

Use the new folio APIs, saving 17 hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-11-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   58 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios
+++ a/fs/nilfs2/segment.c
@@ -1665,39 +1665,39 @@ static int nilfs_segctor_assign(struct n
 	return 0;
 }
 
-static void nilfs_begin_page_io(struct page *page)
+static void nilfs_begin_folio_io(struct folio *folio)
 {
-	if (!page || PageWriteback(page))
+	if (!folio || folio_test_writeback(folio))
 		/*
 		 * For split b-tree node pages, this function may be called
 		 * twice.  We ignore the 2nd or later calls by this check.
 		 */
 		return;
 
-	lock_page(page);
-	clear_page_dirty_for_io(page);
-	set_page_writeback(page);
-	unlock_page(page);
+	folio_lock(folio);
+	folio_clear_dirty_for_io(folio);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 }
 
 static void nilfs_segctor_prepare_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 
 	list_for_each_entry(segbuf, &sci->sc_segbufs, sb_list) {
 		struct buffer_head *bh;
 
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
-			if (bh->b_page != bd_page) {
-				if (bd_page) {
-					lock_page(bd_page);
-					clear_page_dirty_for_io(bd_page);
-					set_page_writeback(bd_page);
-					unlock_page(bd_page);
+			if (bh->b_folio != bd_folio) {
+				if (bd_folio) {
+					folio_lock(bd_folio);
+					folio_clear_dirty_for_io(bd_folio);
+					folio_start_writeback(bd_folio);
+					folio_unlock(bd_folio);
 				}
-				bd_page = bh->b_page;
+				bd_folio = bh->b_folio;
 			}
 		}
 
@@ -1705,28 +1705,28 @@ static void nilfs_segctor_prepare_write(
 				    b_assoc_buffers) {
 			set_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
-				if (bh->b_page != bd_page) {
-					lock_page(bd_page);
-					clear_page_dirty_for_io(bd_page);
-					set_page_writeback(bd_page);
-					unlock_page(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_lock(bd_folio);
+					folio_clear_dirty_for_io(bd_folio);
+					folio_start_writeback(bd_folio);
+					folio_unlock(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_begin_page_io(fs_page);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_begin_folio_io(fs_folio);
+				fs_folio = bh->b_folio;
 			}
 		}
 	}
-	if (bd_page) {
-		lock_page(bd_page);
-		clear_page_dirty_for_io(bd_page);
-		set_page_writeback(bd_page);
-		unlock_page(bd_page);
+	if (bd_folio) {
+		folio_lock(bd_folio);
+		folio_clear_dirty_for_io(bd_folio);
+		folio_start_writeback(bd_folio);
+		folio_unlock(bd_folio);
 	}
-	nilfs_begin_page_io(fs_page);
+	nilfs_begin_folio_io(fs_folio);
 }
 
 static int nilfs_segctor_write(struct nilfs_sc_info *sci,
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

