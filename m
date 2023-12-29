Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6D134B7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efMP3eB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14102C433C8;
	Fri, 29 Dec 2023 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880005;
	bh=ZceLWJ78EA8V1hf2zIZB/FNKBIoyQefd0iIEzZtnZ7k=;
	h=Date:To:From:Subject:From;
	b=efMP3eB271tZhrbWHHQ2EEP+G5NqI6TkqO6XfuyoL7aW636apaTbT+H37/WYgkjYe
	 r5AaTnIw7XC1Bzq/Oi5aeU7MA05V/Oy983aDRFW7vh5i1UHn/Np0oSFrKuxTt9mzHO
	 +f3dBXWFRcBi3KDHwP7zYyogaG2h0uv+ji4Zfsx0=
Date: Fri, 29 Dec 2023 12:00:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-swap_writepage_fs.patch removed from -mm tree
Message-Id: <20231229200005.14102C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to swap_writepage_fs()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-swap_writepage_fs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: pass a folio to swap_writepage_fs()
Date: Wed, 13 Dec 2023 21:58:32 +0000

Saves several calls to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-swap_writepage_fs
+++ a/mm/page_io.c
@@ -288,16 +288,16 @@ static void sio_write_complete(struct ki
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
+static void swap_writepage_fs(struct folio *folio, struct writeback_control *wbc)
 {
 	struct swap_iocb *sio = NULL;
-	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
-	loff_t pos = page_file_offset(page);
+	loff_t pos = folio_file_pos(folio);
 
-	count_swpout_vm_event(page_folio(page));
-	set_page_writeback(page);
-	unlock_page(page);
+	count_swpout_vm_event(folio);
+	folio_start_writeback(folio);
+	folio_unlock(folio);
 	if (wbc->swap_plug)
 		sio = *wbc->swap_plug;
 	if (sio) {
@@ -315,8 +315,8 @@ static void swap_writepage_fs(struct pag
 		sio->pages = 0;
 		sio->len = 0;
 	}
-	bvec_set_page(&sio->bvec[sio->pages], page, thp_size(page), 0);
-	sio->len += thp_size(page);
+	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	sio->len += folio_size(folio);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
 		swap_write_unplug(sio);
@@ -379,7 +379,7 @@ void __swap_writepage(struct folio *foli
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(&folio->page, wbc);
+		swap_writepage_fs(folio, wbc);
 	else if (sis->flags & SWP_SYNCHRONOUS_IO)
 		swap_writepage_bdev_sync(&folio->page, wbc, sis);
 	else
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

