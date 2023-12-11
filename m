Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269BD7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pnXIQG4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAD6C433C7;
	Mon, 11 Dec 2023 01:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257762;
	bh=2VofUjz4pXNec5zwl8IPLaMZ+LWMI3BVbefLHp+M3zA=;
	h=Date:To:From:Subject:From;
	b=pnXIQG4IcejyhX/Iz3sB/z+uCfvlbR4SSbbHceFunUDhqP5k4vxmZ8cEqkYo+Tzcu
	 Lm9b5EbmGjEbK+ePgiGDJD/XrqCn0BneR6/J4Juxg1heHtJXCKvgr4G1y7gzUlhsVr
	 cc3o3qYMz4l9BpZdjNoFwBMrjcRM+i1UuHymZfaE=
Date: Sun, 10 Dec 2023 17:22:41 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch removed from -mm tree
Message-Id: <20231211012241.DCAD6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_segctor_complete_write to use folios
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_segctor_complete_write to use folios
Date: Tue, 14 Nov 2023 17:44:19 +0900

Use the new folio APIs, saving five calls to compound_head().  This
includes the last callers of nilfs_end_page_io(), so remove that too.

Link: https://lkml.kernel.org/r/20231114084436.2755-4-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-convert-nilfs_segctor_complete_write-to-use-folios
+++ a/fs/nilfs2/segment.c
@@ -1778,13 +1778,6 @@ static void nilfs_end_folio_io(struct fo
 	folio_end_writeback(folio);
 }
 
-static void nilfs_end_page_io(struct page *page, int err)
-{
-	if (!page)
-		return;
-	nilfs_end_folio_io(page_folio(page), err);
-}
-
 static void nilfs_abort_logs(struct list_head *logs, int err)
 {
 	struct nilfs_segment_buffer *segbuf;
@@ -1867,7 +1860,7 @@ static void nilfs_set_next_segment(struc
 static void nilfs_segctor_complete_write(struct nilfs_sc_info *sci)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int update_sr = false;
 
@@ -1878,21 +1871,21 @@ static void nilfs_segctor_complete_write
 				    b_assoc_buffers) {
 			set_buffer_uptodate(bh);
 			clear_buffer_dirty(bh);
-			if (bh->b_page != bd_page) {
-				if (bd_page)
-					end_page_writeback(bd_page);
-				bd_page = bh->b_page;
+			if (bh->b_folio != bd_folio) {
+				if (bd_folio)
+					folio_end_writeback(bd_folio);
+				bd_folio = bh->b_folio;
 			}
 		}
 		/*
-		 * We assume that the buffers which belong to the same page
+		 * We assume that the buffers which belong to the same folio
 		 * continue over the buffer list.
-		 * Under this assumption, the last BHs of pages is
-		 * identifiable by the discontinuity of bh->b_page
-		 * (page != fs_page).
+		 * Under this assumption, the last BHs of folios is
+		 * identifiable by the discontinuity of bh->b_folio
+		 * (folio != fs_folio).
 		 *
 		 * For B-tree node blocks, however, this assumption is not
-		 * guaranteed.  The cleanup code of B-tree node pages needs
+		 * guaranteed.  The cleanup code of B-tree node folios needs
 		 * special care.
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
@@ -1905,16 +1898,16 @@ static void nilfs_segctor_complete_write
 
 			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
-				if (bh->b_page != bd_page) {
-					end_page_writeback(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_end_writeback(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				update_sr = true;
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_end_page_io(fs_page, 0);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_end_folio_io(fs_folio, 0);
+				fs_folio = bh->b_folio;
 			}
 		}
 
@@ -1928,13 +1921,13 @@ static void nilfs_segctor_complete_write
 		}
 	}
 	/*
-	 * Since pages may continue over multiple segment buffers,
-	 * end of the last page must be checked outside of the loop.
+	 * Since folios may continue over multiple segment buffers,
+	 * end of the last folio must be checked outside of the loop.
 	 */
-	if (bd_page)
-		end_page_writeback(bd_page);
+	if (bd_folio)
+		folio_end_writeback(bd_folio);
 
-	nilfs_end_page_io(fs_page, 0);
+	nilfs_end_folio_io(fs_folio, 0);
 
 	nilfs_drop_collected_inodes(&sci->sc_dirty_files);
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

