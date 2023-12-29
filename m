Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455A813ADB
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UH77K/0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1300CC433C9;
	Fri, 29 Dec 2023 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880027;
	bh=Fm2+0IuWdUsiWdEYyEi7TaidkCy3ZLuafxLPCngIrdA=;
	h=Date:To:From:Subject:From;
	b=UH77K/0lUreJqaigTYWnRR5fvHNCMKHzInfSqGe8eQDsCyJ2cb8LaCBWAwjgsemIk
	 y6IUUbUCe70CcYeZveaqThMRiupEDj4wy05sBg3rkP6K1S5TLBKB0DSmN1UzBwZECi
	 cyf5Zzwm9KnaE7AnapMP6IaR8FsYLtCOWLuRHLLw=
Date: Fri, 29 Dec 2023 12:00:26 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hfsplus-really-remove-hfsplus_writepage.patch removed from -mm tree
Message-Id: <20231229200027.1300CC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hfsplus: really remove hfsplus_writepage
has been removed from the -mm tree.  Its filename was
     hfsplus-really-remove-hfsplus_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hfsplus: really remove hfsplus_writepage
Date: Fri, 15 Dec 2023 20:02:39 +0000

The earlier commit to remove hfsplus_writepage only removed it from one of
the aops.  Remove it from the btree_aops as well.

Link: https://lkml.kernel.org/r/20231215200245.748418-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/hfsplus/inode.c~hfsplus-really-remove-hfsplus_writepage
+++ a/fs/hfsplus/inode.c
@@ -28,11 +28,6 @@ static int hfsplus_read_folio(struct fil
 	return block_read_full_folio(folio, hfsplus_get_block);
 }
 
-static int hfsplus_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, hfsplus_get_block, wbc);
-}
-
 static void hfsplus_write_failed(struct address_space *mapping, loff_t to)
 {
 	struct inode *inode = mapping->host;
@@ -159,9 +154,10 @@ const struct address_space_operations hf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= hfsplus_read_folio,
-	.writepage	= hfsplus_writepage,
+	.writepages	= hfsplus_writepages,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
+	.migrate_folio	= buffer_migrate_folio,
 	.bmap		= hfsplus_bmap,
 	.release_folio	= hfsplus_release_folio,
 };
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

