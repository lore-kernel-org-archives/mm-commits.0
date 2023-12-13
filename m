Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646F8183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wg+tXs7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBD2C433C8;
	Wed, 13 Dec 2023 23:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509117;
	bh=deK0+uqDTUB56BHKUgznKoOjLNqqw+P/vxi3ybTuBLk=;
	h=Date:To:From:Subject:From;
	b=Wg+tXs7LMgozr7YILh9x/VAD+K9btyfi5/T5d4OJ2qgrsN8Dmhr8uhRU1JGdVhr92
	 ompfXWsNOOqiE4gaO/V/NHBqdc9Yteak1k8VqLyXTuQ2q+tcn2wuKPnRBISWDOzWP+
	 PqLSNns3BLyqF+Oir6z3y2UL3fx1jwKfMMyTXbI4=
Date: Wed, 13 Dec 2023 15:11:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-a-folio-to-__swap_writepage.patch added to mm-unstable branch
Message-Id: <20231213231157.6CBD2C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pass a folio to __swap_writepage()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-a-folio-to-__swap_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-a-folio-to-__swap_writepage.patch

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
Subject: mm: pass a folio to __swap_writepage()
Date: Wed, 13 Dec 2023 21:58:31 +0000

Both callers now have a folio, so pass that in instead of the page. 
Removes a few hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   14 +++++++-------
 mm/swap.h    |    2 +-
 mm/zswap.c   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_io.c~mm-pass-a-folio-to-__swap_writepage
+++ a/mm/page_io.c
@@ -207,7 +207,7 @@ int swap_writepage(struct page *page, st
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
-	__swap_writepage(&folio->page, wbc);
+	__swap_writepage(folio, wbc);
 	return 0;
 }
 
@@ -374,22 +374,22 @@ static void swap_writepage_bdev_async(st
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct page *page, struct writeback_control *wbc)
+void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
 {
-	struct swap_info_struct *sis = page_swap_info(page);
+	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
 	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(page, wbc);
+		swap_writepage_fs(&folio->page, wbc);
 	else if (sis->flags & SWP_SYNCHRONOUS_IO)
-		swap_writepage_bdev_sync(page, wbc, sis);
+		swap_writepage_bdev_sync(&folio->page, wbc, sis);
 	else
-		swap_writepage_bdev_async(page, wbc, sis);
+		swap_writepage_bdev_async(&folio->page, wbc, sis);
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
--- a/mm/swap.h~mm-pass-a-folio-to-__swap_writepage
+++ a/mm/swap.h
@@ -19,7 +19,7 @@ static inline void swap_read_unplug(stru
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
-void __swap_writepage(struct page *page, struct writeback_control *wbc);
+void __swap_writepage(struct folio *folio, struct writeback_control *wbc);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
--- a/mm/zswap.c~mm-pass-a-folio-to-__swap_writepage
+++ a/mm/zswap.c
@@ -1490,7 +1490,7 @@ static int zswap_writeback_entry(struct
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&folio->page, &wbc);
+	__swap_writepage(folio, &wbc);
 	folio_put(folio);
 
 	return 0;
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

