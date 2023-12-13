Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE0A8183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dcEGWmvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2CAC433C8;
	Wed, 13 Dec 2023 23:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509119;
	bh=AmK9XKQR9uw0rImReDjSnOZSGID93ntl776IDrpRTsE=;
	h=Date:To:From:Subject:From;
	b=dcEGWmvkQ69N+umqhKm84t84ltA3Ftek8o8Lq2P+xhtE1gIdyt3Afis0ZwR7mMLtf
	 CRUb7RQ4YNcGRB4yBSji6DGrq+0ZTx9Y0aEBJJbu5nZPlUFSmGeweFbGkZxE2AtzPu
	 MQSUsIsk3Dbn09Va/AYt0ydgSiJIU5nlm4Zbt8aE=
Date: Wed, 13 Dec 2023 15:11:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-a-folio-to-swap_writepage_fs.patch added to mm-unstable branch
Message-Id: <20231213231159.8B2CAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pass a folio to swap_writepage_fs()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-a-folio-to-swap_writepage_fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-a-folio-to-swap_writepage_fs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -294,16 +294,16 @@ static void sio_write_complete(struct ki
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
@@ -321,8 +321,8 @@ static void swap_writepage_fs(struct pag
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
@@ -385,7 +385,7 @@ void __swap_writepage(struct folio *foli
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

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

