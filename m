Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389157493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FAZS5Dg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BFFC433C8;
	Mon, 11 Dec 2023 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257778;
	bh=bwZ5iQk8tOp83O6EKBUahGoM98vSs7ddyVMruAIm6Yg=;
	h=Date:To:From:Subject:From;
	b=FAZS5Dg0dDguZYS8FHmhcuq3yDyVLf4/IITloxXeSHigWG2gnhFXeyUdIu7MIItyM
	 IgWQU7nVg4gbRM4aUmFfdk1lk/yhPjm/f8C/UTXvAmbFffkx9zBCKc0eNOao5Ltghe
	 Aj+zNAyJxnAoB0HAZ0VOIldfCsZ9F5HwjY7mLWhA=
Date: Sun, 10 Dec 2023 17:22:57 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012258.03BFFC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_btnode_abort_change_key to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_btnode_abort_change_key to use a folio
Date: Tue, 14 Nov 2023 17:44:36 +0900

Saves one call to compound_head().

Link: https://lkml.kernel.org/r/20231114084436.2755-21-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/btnode.c~nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio
+++ a/fs/nilfs2/btnode.c
@@ -284,7 +284,7 @@ void nilfs_btnode_abort_change_key(struc
 
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		xa_erase_irq(&btnc->i_pages, newkey);
-		unlock_page(ctxt->bh->b_page);
+		folio_unlock(ctxt->bh->b_folio);
 	} else {
 		/*
 		 * When canceling a buffer that a prepare operation has
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

