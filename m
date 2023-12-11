Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30B7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OD0MudVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF1BC433C7;
	Mon, 11 Dec 2023 01:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257766;
	bh=eCqBIIMsDdwGA4ZKbluY5ahJUDSn+btEaC1ggQxviKQ=;
	h=Date:To:From:Subject:From;
	b=OD0MudVeSHFvHbcW+NdC0+VvLOKzAyksxvcsRDpuRdHve15pXlissYjgrv0MrCgsT
	 LNLIx6cYAJivo66iixRK4VETi1dEPBhpQ2dLmcW/AIEZf1CNHTVrRUIMTQs0x0QbYu
	 uKJ0mRCR94a2Fy+HPNmgIjFT/utZidxpoVY0ZwZw=
Date: Sun, 10 Dec 2023 17:22:45 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012245.DEF1BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_mdt_write_page() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_mdt_write_page() to use a folio
Date: Tue, 14 Nov 2023 17:44:23 +0900

Convert the incoming page to a folio.  Replaces three calls to
compound_head() with one.

Link: https://lkml.kernel.org/r/20231114084436.2755-8-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio
+++ a/fs/nilfs2/mdt.c
@@ -399,7 +399,8 @@ int nilfs_mdt_fetch_dirty(struct inode *
 static int
 nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct folio *folio = page_folio(page);
+	struct inode *inode = folio->mapping->host;
 	struct super_block *sb;
 	int err = 0;
 
@@ -407,16 +408,16 @@ nilfs_mdt_write_page(struct page *page,
 		/*
 		 * It means that filesystem was remounted in read-only
 		 * mode because of error or metadata corruption. But we
-		 * have dirty pages that try to be flushed in background.
-		 * So, here we simply discard this dirty page.
+		 * have dirty folios that try to be flushed in background.
+		 * So, here we simply discard this dirty folio.
 		 */
 		nilfs_clear_dirty_page(page, false);
-		unlock_page(page);
+		folio_unlock(folio);
 		return -EROFS;
 	}
 
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
+	folio_redirty_for_writepage(wbc, folio);
+	folio_unlock(folio);
 
 	if (!inode)
 		return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

