Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EC0134C9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKH6+OHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B8CC433C8;
	Fri, 29 Dec 2023 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880007;
	bh=t2oRjBEau04A53LQzRb70s2abk9vrHOviTQA4YU61Fs=;
	h=Date:To:From:Subject:From;
	b=DKH6+OHFBuww/QVYnHE98ZTx4DcmmcOBdPCIeZJsq7zonk3QLdjW0E8ds9k/mdo8T
	 FW4zDUG89C7Xl1tuit7BO9FNb8nIwIhxsoNwyjt2+d31BQmKaIkpUO6X3TtWhOz6L9
	 K4s/AQvE0cdgume7L6h+GKkIY4Ul95Uuxp8NqJhk=
Date: Fri, 29 Dec 2023 12:00:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_writepage_bdev_async.patch removed from -mm tree
Message-Id: <20231229200007.B2B8CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_writepage_bdev_async()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_writepage_bdev_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_writepage_bdev_async()
Date: Wed, 13 Dec 2023 21:58:34 +0000

Saves a call to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_writepage_bdev_async
+++ a/mm/page_io.c
@@ -347,18 +347,17 @@ static void swap_writepage_bdev_sync(str
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct page *page,
+static void swap_writepage_bdev_async(struct folio *folio,
 		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	struct folio *folio = page_folio(page);
 
 	bio = bio_alloc(sis->bdev, 1,
 			REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc),
 			GFP_NOIO);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_iter.bi_sector = swap_page_sector(&folio->page);
 	bio->bi_end_io = end_swap_bio_write;
-	__bio_add_page(bio, page, thp_size(page), 0);
+	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(bio, folio);
 	count_swpout_vm_event(folio);
@@ -382,7 +381,7 @@ void __swap_writepage(struct folio *foli
 	else if (sis->flags & SWP_SYNCHRONOUS_IO)
 		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
-		swap_writepage_bdev_async(&folio->page, wbc, sis);
+		swap_writepage_bdev_async(folio, wbc, sis);
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

