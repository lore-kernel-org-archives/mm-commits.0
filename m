Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFF47493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="heA39dYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F73C433C7;
	Mon, 11 Dec 2023 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257760;
	bh=OddZtIPEWw1cEYP8QeDlgTf6n3bXihAS3r6ldGw48vs=;
	h=Date:To:From:Subject:From;
	b=heA39dYcJTXA64TnMIrYfu+U8Rx3LlLXnt8wBhA1QpOgPpsbocHhY0RJhwGpfzGgw
	 nJkILTBb2ULLx4LNFzgAmHDGHhsbGzzbz/yEYlq6TzP7ECfqnYTTLwTA69gHQNfjXT
	 pep1iGm/LPf336UKc4QN1EktGLv7UTuJoU2DaarY=
Date: Sun, 10 Dec 2023 17:22:40 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_abort_logs-to-use-folios.patch removed from -mm tree
Message-Id: <20231211012240.D4F73C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_abort_logs to use folios
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_abort_logs-to-use-folios.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_abort_logs to use folios
Date: Tue, 14 Nov 2023 17:44:18 +0900

Use the new folio APIs, saving five hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-3-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-convert-nilfs_abort_logs-to-use-folios
+++ a/fs/nilfs2/segment.c
@@ -1788,7 +1788,7 @@ static void nilfs_end_page_io(struct pag
 static void nilfs_abort_logs(struct list_head *logs, int err)
 {
 	struct nilfs_segment_buffer *segbuf;
-	struct page *bd_page = NULL, *fs_page = NULL;
+	struct folio *bd_folio = NULL, *fs_folio = NULL;
 	struct buffer_head *bh;
 
 	if (list_empty(logs))
@@ -1798,10 +1798,10 @@ static void nilfs_abort_logs(struct list
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
 			clear_buffer_uptodate(bh);
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
 
@@ -1810,22 +1810,22 @@ static void nilfs_abort_logs(struct list
 			clear_buffer_async_write(bh);
 			if (bh == segbuf->sb_super_root) {
 				clear_buffer_uptodate(bh);
-				if (bh->b_page != bd_page) {
-					end_page_writeback(bd_page);
-					bd_page = bh->b_page;
+				if (bh->b_folio != bd_folio) {
+					folio_end_writeback(bd_folio);
+					bd_folio = bh->b_folio;
 				}
 				break;
 			}
-			if (bh->b_page != fs_page) {
-				nilfs_end_page_io(fs_page, err);
-				fs_page = bh->b_page;
+			if (bh->b_folio != fs_folio) {
+				nilfs_end_folio_io(fs_folio, err);
+				fs_folio = bh->b_folio;
 			}
 		}
 	}
-	if (bd_page)
-		end_page_writeback(bd_page);
+	if (bd_folio)
+		folio_end_writeback(bd_folio);
 
-	nilfs_end_page_io(fs_page, err);
+	nilfs_end_folio_io(fs_folio, err);
 }
 
 static void nilfs_segctor_abort_construction(struct nilfs_sc_info *sci,
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

