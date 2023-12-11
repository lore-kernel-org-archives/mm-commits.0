Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3218379DF
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfR3INw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8917C433C8;
	Mon, 11 Dec 2023 01:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257763;
	bh=Y1dyMnrJbJcC6abfKlsdrRBQeCGVvKPAxSa8jKljmPM=;
	h=Date:To:From:Subject:From;
	b=rfR3INw24OnoVlxiTsIpn0Ew1NQdAttfHHBY7hdHwJslhyo8etUiuYDJABkRBU14a
	 eU1I611Dw+QTKX4JgGyb28S+QLt1WGcxGGcmcQs8+2mHUSQLSnoOugVIG0/fmTR3aj
	 BKF3PsNLqdguAGVtGiNoH7RORgVOVQZ/fSYTFIME=
Date: Sun, 10 Dec 2023 17:22:42 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012242.E8917C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_forget_buffer to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_forget_buffer to use a folio
Date: Tue, 14 Nov 2023 17:44:20 +0900

Save two hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-5-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-convert-nilfs_forget_buffer-to-use-a-folio
+++ a/fs/nilfs2/page.c
@@ -73,7 +73,7 @@ struct buffer_head *nilfs_grab_buffer(st
  */
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
@@ -81,12 +81,12 @@ void nilfs_forget_buffer(struct buffer_h
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
-	if (nilfs_page_buffers_clean(page))
-		__nilfs_clear_page_dirty(page);
+	if (nilfs_page_buffers_clean(&folio->page))
+		__nilfs_clear_page_dirty(&folio->page);
 
 	bh->b_blocknr = -1;
-	ClearPageUptodate(page);
-	ClearPageMappedToDisk(page);
+	folio_clear_uptodate(folio);
+	folio_clear_mappedtodisk(folio);
 	unlock_buffer(bh);
 	brelse(bh);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

