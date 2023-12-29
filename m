Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1B2134C9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L6ccoOQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0897CC433C9;
	Fri, 29 Dec 2023 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880009;
	bh=ecQiiX7BSkeLNtTACHnjwgD7fldzsrIvcPSzG/n7yes=;
	h=Date:To:From:Subject:From;
	b=L6ccoOQziXO5gHcesOV+Z5PfTJsqRx/UgbAjlj5pDAjFqKw4ZrMOa0swg36b/kHbI
	 uoDOnsWK8wvlTps6eSf9CG+CFk/shfJVdyYk7Us8r0I4H0083i/Z0lVCdtFX4HzaSR
	 SacOAD1p1QnGDHPX1GtZp8EKVetTkwaEm+Z6RCP8=
Date: Fri, 29 Dec 2023 12:00:08 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_readpage_fs.patch removed from -mm tree
Message-Id: <20231229200009.0897CC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_readpage_fs()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_readpage_fs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_readpage_fs()
Date: Wed, 13 Dec 2023 21:58:35 +0000

Saves a call to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_readpage_fs
+++ a/mm/page_io.c
@@ -420,12 +420,11 @@ static void sio_read_complete(struct kio
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_readpage_fs(struct page *page,
-			     struct swap_iocb **plug)
+static void swap_readpage_fs(struct folio *folio, struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct swap_iocb *sio = NULL;
-	loff_t pos = page_file_offset(page);
+	loff_t pos = folio_file_pos(folio);
 
 	if (plug)
 		sio = *plug;
@@ -444,8 +443,8 @@ static void swap_readpage_fs(struct page
 		sio->pages = 0;
 		sio->len = 0;
 	}
-	bvec_set_page(&sio->bvec[sio->pages], page, thp_size(page), 0);
-	sio->len += thp_size(page);
+	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	sio->len += folio_size(folio);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
 		swap_read_unplug(sio);
@@ -515,7 +514,7 @@ void swap_readpage(struct page *page, bo
 		folio_mark_uptodate(folio);
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_readpage_fs(page, plug);
+		swap_readpage_fs(folio, plug);
 	} else if (synchronous || (sis->flags & SWP_SYNCHRONOUS_IO)) {
 		swap_readpage_bdev_sync(page, sis);
 	} else {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

