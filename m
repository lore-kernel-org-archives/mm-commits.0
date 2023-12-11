Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541397493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sSRCJqL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207BFC433CA;
	Mon, 11 Dec 2023 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257776;
	bh=31yqp9Jw9TFPg6cJFGzUe4PkF4IE5/KPMSEh41LPng4=;
	h=Date:To:From:Subject:From;
	b=sSRCJqL2iokqosCLPmBK7h2q+2uoM/7UjOXeNui1ZdKLgs65V6J18GaJfNkpBuNPR
	 +cbr4XwWKJQzzTY4bI7a25SQU30bwxnUaPqICRZtwzEH3pzD09+7oyP8iE7DONkn2I
	 XzObMgIr5nEvUA+z3Flw8RwMYqJDDrya3Zn0+zU8=
Date: Sun, 10 Dec 2023 17:22:55 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012256.207BFC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_prepare_change_key to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_prepare_change_key to use a folio
Date: Tue, 14 Nov 2023 17:44:34 +0900

Saves three calls to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-19-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -185,23 +185,23 @@ int nilfs_btnode_prepare_change_key(stru
 	ctxt->newbh = NULL;
 
 	if (inode->i_blkbits == PAGE_SHIFT) {
-		struct page *opage = obh->b_page;
-		lock_page(opage);
+		struct folio *ofolio = obh->b_folio;
+		folio_lock(ofolio);
 retry:
 		/* BUG_ON(oldkey != obh->b_folio->index); */
-		if (unlikely(oldkey != opage->index))
-			NILFS_PAGE_BUG(opage,
+		if (unlikely(oldkey != ofolio->index))
+			NILFS_PAGE_BUG(&ofolio->page,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
 
 		xa_lock_irq(&btnc->i_pages);
-		err = __xa_insert(&btnc->i_pages, newkey, opage, GFP_NOFS);
+		err = __xa_insert(&btnc->i_pages, newkey, ofolio, GFP_NOFS);
 		xa_unlock_irq(&btnc->i_pages);
 		/*
-		 * Note: page->index will not change to newkey until
+		 * Note: folio->index will not change to newkey until
 		 * nilfs_btnode_commit_change_key() will be called.
-		 * To protect the page in intermediate state, the page lock
+		 * To protect the folio in intermediate state, the folio lock
 		 * is held.
 		 */
 		if (!err)
@@ -213,7 +213,7 @@ retry:
 		if (!err)
 			goto retry;
 		/* fallback to copy mode */
-		unlock_page(opage);
+		folio_unlock(ofolio);
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
@@ -225,7 +225,7 @@ retry:
 	return 0;
 
  failed_unlock:
-	unlock_page(obh->b_page);
+	folio_unlock(obh->b_folio);
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

