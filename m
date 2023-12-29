Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB1134D5
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9siyJTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD84C433C7;
	Fri, 29 Dec 2023 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880011;
	bh=3K+PMKc6IrJEu+wb0gVu86LN2L9ha+sKGz1MZie0dEw=;
	h=Date:To:From:Subject:From;
	b=W9siyJTREXdxHJr2Cq8Upr3jumAfj6aEQECVhmA0AQhXn7aAZ/o3KXM0S9e4SEg0F
	 my6+DeYJSZP96zr/6MQ9AH1JSkUN7J69Wdc1nUDzEt7Il/A9Tr6MTek3MGbUYE+Ry/
	 E1r0UbTMiF9d0xZdmrEfl7G4yI6uY7/On1Iafa3o=
Date: Fri, 29 Dec 2023 12:00:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_readpage_bdev_async.patch removed from -mm tree
Message-Id: <20231229200011.9AD84C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_readpage_bdev_async()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_readpage_bdev_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_readpage_bdev_async()
Date: Wed, 13 Dec 2023 21:58:37 +0000

Make it plain that this takes the head page (which before this point
was just an assumption, but is now enforced by the compiler).

Link: https://lkml.kernel.org/r/20231213215842.671461-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_readpage_bdev_async
+++ a/mm/page_io.c
@@ -474,15 +474,15 @@ static void swap_readpage_bdev_sync(stru
 	put_task_struct(current);
 }
 
-static void swap_readpage_bdev_async(struct page *page,
+static void swap_readpage_bdev_async(struct folio *folio,
 		struct swap_info_struct *sis)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
 	bio->bi_end_io = end_swap_bio_read;
-	__bio_add_page(bio, page, thp_size(page), 0);
+	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 }
@@ -518,7 +518,7 @@ void swap_readpage(struct page *page, bo
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
 		swap_readpage_bdev_sync(folio, sis);
 	} else {
-		swap_readpage_bdev_async(page, sis);
+		swap_readpage_bdev_async(folio, sis);
 	}
 
 	if (workingset) {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

