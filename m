Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0B134C8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mHPhGb3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B17CC433C8;
	Fri, 29 Dec 2023 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880006;
	bh=bGSQNhqzq0T1j4Rg3WW8tBo3GJe6k1FY61iTTgjMXm8=;
	h=Date:To:From:Subject:From;
	b=mHPhGb3oGtFCjWQXg8dp6ELVRIBNuunmiPV4ZaztGtJCIyo5nSy+UaH5pHH67cAuW
	 oyFPG8HJC+/Q46CYSgv2S0fSxWkm4GeZwiY1DufpWyX8RSdkDL7bQmcGCQiIuKj0+H
	 wemKkiFINhxvHk4Jmqbyaqkr94dq8BE80MQ+VZGw=
Date: Fri, 29 Dec 2023 12:00:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_writepage_bdev_sync.patch removed from -mm tree
Message-Id: <20231229200006.5B17CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_writepage_bdev_sync()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_writepage_bdev_sync.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_writepage_bdev_sync()
Date: Wed, 13 Dec 2023 21:58:33 +0000

Saves a call to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_writepage_bdev_sync
+++ a/mm/page_io.c
@@ -326,17 +326,16 @@ static void swap_writepage_fs(struct fol
 		*wbc->swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct page *page,
+static void swap_writepage_bdev_sync(struct folio *folio,
 		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio_vec bv;
 	struct bio bio;
-	struct folio *folio = page_folio(page);
 
 	bio_init(&bio, sis->bdev, &bv, 1,
 		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
-	bio.bi_iter.bi_sector = swap_page_sector(page);
-	__bio_add_page(&bio, page, thp_size(page), 0);
+	bio.bi_iter.bi_sector = swap_page_sector(&folio->page);
+	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
 
 	bio_associate_blkg_from_page(&bio, folio);
 	count_swpout_vm_event(folio);
@@ -381,7 +380,7 @@ void __swap_writepage(struct folio *foli
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, wbc);
 	else if (sis->flags & SWP_SYNCHRONOUS_IO)
-		swap_writepage_bdev_sync(&folio->page, wbc, sis);
+		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
 		swap_writepage_bdev_async(&folio->page, wbc, sis);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

