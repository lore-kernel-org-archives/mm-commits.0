Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D74F7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WhK1lzz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5CC433C7;
	Mon, 11 Dec 2023 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257777;
	bh=eXV1Hhff9dAOSePBD79bud8Px1HRukfjef5RBXfOGSc=;
	h=Date:To:From:Subject:From;
	b=WhK1lzz3zS9sKc61TnwJkmUHGfSFb7+7VHBgTQXq2kkLsm1s5xOtcz47LxG8r79hb
	 z5VAkkBzIIMYPubNOoDSDveXbkwvwJJKCz0ZSjp98cJ+M0YFUYVY/udDxRXxooUQNO
	 GLy5MmTPt/mfFiVKprYJ0eS0A2Mxm2IWYeROQimQ=
Date: Sun, 10 Dec 2023 17:22:56 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012257.1AE5CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_commit_change_key to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_commit_change_key to use a folio
Date: Tue, 14 Nov 2023 17:44:35 +0900

Saves one call to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-20-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -238,15 +238,15 @@ void nilfs_btnode_commit_change_key(stru
 {
 	struct buffer_head *obh = ctxt->bh, *nbh = ctxt->newbh;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
-	struct page *opage;
+	struct folio *ofolio;
 
 	if (oldkey == newkey)
 		return;
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
-		opage = obh->b_page;
-		if (unlikely(oldkey != opage->index))
-			NILFS_PAGE_BUG(opage,
+		ofolio = obh->b_folio;
+		if (unlikely(oldkey != ofolio->index))
+			NILFS_PAGE_BUG(&ofolio->page,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
@@ -257,8 +257,8 @@ void nilfs_btnode_commit_change_key(stru
 		__xa_set_mark(&btnc->i_pages, newkey, PAGECACHE_TAG_DIRTY);
 		xa_unlock_irq(&btnc->i_pages);
 
-		opage->index = obh->b_blocknr = newkey;
-		unlock_page(opage);
+		ofolio->index = obh->b_blocknr = newkey;
+		folio_unlock(ofolio);
 	} else {
 		nilfs_copy_buffer(nbh, obh);
 		mark_buffer_dirty(nbh);
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

