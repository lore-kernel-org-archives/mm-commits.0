Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB29134BE
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="klujTP59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBACC433C8;
	Fri, 29 Dec 2023 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880003;
	bh=pIXAaYGG5AHDewD8m51NKd3+aZgNily5mLU2pn/HL8s=;
	h=Date:To:From:Subject:From;
	b=klujTP59aBtMqigBY2bkLNsXw3q7Ad7P7Vsmt2uUW+n96pbnRU9Lbzo/bj9ZQOgpN
	 wK4rkh9kWr4jDUDbsNiDsuZGvxGDpnYfdYufno5zT+rRfVUxNn6MK1whjhCyBd7pvN
	 TG4jKkGoeDEPXuaZFt8f+bNvkKA6k6y+efmJKoO0=
Date: Fri, 29 Dec 2023 12:00:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pass-a-folio-to-__swap_writepage.patch removed from -mm tree
Message-Id: <20231229200003.CDBACC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pass a folio to __swap_writepage()
has been removed from the -mm tree.  Its filename was
     mm-pass-a-folio-to-__swap_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -201,7 +201,7 @@ int swap_writepage(struct page *page, st
 		folio_end_writeback(folio);
 		return 0;
 	}
-	__swap_writepage(&folio->page, wbc);
+	__swap_writepage(folio, wbc);
 	return 0;
 }
 
@@ -368,22 +368,22 @@ static void swap_writepage_bdev_async(st
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
@@ -1446,7 +1446,7 @@ static int zswap_writeback_entry(struct
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&folio->page, &wbc);
+	__swap_writepage(folio, &wbc);
 	folio_put(folio);
 
 	return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

