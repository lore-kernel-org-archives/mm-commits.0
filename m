Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9095A7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HhqMQoBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A367C433C8;
	Mon, 11 Dec 2023 01:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257774;
	bh=T8G7ceybXixhQyVmXDBOXxWDFMdm+gSSbm0RNf8PTdU=;
	h=Date:To:From:Subject:From;
	b=HhqMQoBVRhRgITw0FDbGJZC8V9IPls06gW2TNZtwdX2o7vCXvHoNrBG2iA6AqY6Ix
	 26nm1jmMg9CER15kveuCm3CTXXqb8e/dHIGoFnWbYemZo4cPEAJHqkWANt0Fhtp3cp
	 K/EwudmHTUOwM0H7OjVWGb3g6s5qmmCVKk3Q/dG4=
Date: Sun, 10 Dec 2023 17:22:53 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012254.5A367C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_submit_block to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_submit_block to use a folio
Date: Tue, 14 Nov 2023 17:44:32 +0900

Saves two calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-17-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -75,7 +75,7 @@ int nilfs_btnode_submit_block(struct add
 {
 	struct buffer_head *bh;
 	struct inode *inode = btnc->host;
-	struct page *page;
+	struct folio *folio;
 	int err;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
@@ -83,7 +83,7 @@ int nilfs_btnode_submit_block(struct add
 		return -ENOMEM;
 
 	err = -EEXIST; /* internal code */
-	page = bh->b_page;
+	folio = bh->b_folio;
 
 	if (buffer_uptodate(bh) || buffer_dirty(bh))
 		goto found;
@@ -130,8 +130,8 @@ found:
 	*pbh = bh;
 
 out_locked:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	return err;
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

