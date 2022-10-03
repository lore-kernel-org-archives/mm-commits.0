Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C12FC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJCVFc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJCVEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5551A443
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E715CE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD74C433D6;
        Mon,  3 Oct 2022 21:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831083;
        bh=DOxmLH8QEnraKJassw9xc6pvknUJZiZVhOoRpNKmTfY=;
        h=Date:To:From:Subject:From;
        b=vXUAE5SmpLe/P3K+6M2YmuPOWjGlG8K1aUCwIWl6ngZLMXEEMVICXjVgTcHdowvLn
         AEvsUCogKrOwbdWjwBoBQ2oPNDXzR3FtEQMGVAG7DqTHlc+kKlFfPdoGR93VgxWxJr
         g3v1K88IKr5rpSnBx2PIau8ZtkjV3MA4IeuzGn5k=
Date:   Mon, 03 Oct 2022 14:04:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch removed from -mm tree
Message-Id: <20221003210442.EBD74C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_writepage() to use a folio throughout
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_writepage-to-use-a-folio-throughout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_writepage() to use a folio throughout
Date: Fri, 2 Sep 2022 20:46:02 +0100

Even though we will split any large folio that comes in, write the code to
handle large folios so as to not leave a trap for whoever tries to handle
large folios in the swap cache.

Link: https://lkml.kernel.org/r/20220902194653.1739778-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_writepage-to-use-a-folio-throughout
+++ a/mm/shmem.c
@@ -1328,17 +1328,18 @@ static int shmem_writepage(struct page *
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
 	 */
-	if (PageTransCompound(page)) {
+	if (folio_test_large(folio)) {
 		/* Ensure the subpages are still dirty */
-		SetPageDirty(page);
+		folio_test_set_dirty(folio);
 		if (split_huge_page(page) < 0)
 			goto redirty;
-		ClearPageDirty(page);
+		folio = page_folio(page);
+		folio_clear_dirty(folio);
 	}
 
-	BUG_ON(!PageLocked(page));
-	mapping = page->mapping;
-	index = page->index;
+	BUG_ON(!folio_test_locked(folio));
+	mapping = folio->mapping;
+	index = folio->index;
 	inode = mapping->host;
 	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
@@ -1361,15 +1362,15 @@ static int shmem_writepage(struct page *
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
 	 * value into swapfile.c, the only way we can correctly account for a
-	 * fallocated page arriving here is now to initialize it and write it.
+	 * fallocated folio arriving here is now to initialize it and write it.
 	 *
-	 * That's okay for a page already fallocated earlier, but if we have
+	 * That's okay for a folio already fallocated earlier, but if we have
 	 * not yet completed the fallocation, then (a) we want to keep track
-	 * of this page in case we have to undo it, and (b) it may not be a
+	 * of this folio in case we have to undo it, and (b) it may not be a
 	 * good idea to continue anyway, once we're pushing into swap.  So
-	 * reactivate the page, and let shmem_fallocate() quit when too many.
+	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		if (inode->i_private) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
@@ -1385,9 +1386,9 @@ static int shmem_writepage(struct page *
 			if (shmem_falloc)
 				goto redirty;
 		}
-		clear_highpage(page);
-		flush_dcache_page(page);
-		SetPageUptodate(page);
+		folio_zero_range(folio, 0, folio_size(folio));
+		flush_dcache_folio(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	swap = folio_alloc_swap(folio);
@@ -1396,7 +1397,7 @@ static int shmem_writepage(struct page *
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-	 * if it's not already there.  Do it now before the page is
+	 * if it's not already there.  Do it now before the folio is
 	 * moved to swap cache, when its pagelock no longer protects
 	 * the inode from eviction.  But don't unlock the mutex until
 	 * we've incremented swapped, because shmem_unuse_inode() will
@@ -1406,7 +1407,7 @@ static int shmem_writepage(struct page *
 	if (list_empty(&info->swaplist))
 		list_add(&info->swaplist, &shmem_swaplist);
 
-	if (add_to_swap_cache(page, swap,
+	if (add_to_swap_cache(&folio->page, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
 		spin_lock_irq(&info->lock);
@@ -1415,21 +1416,21 @@ static int shmem_writepage(struct page *
 		spin_unlock_irq(&info->lock);
 
 		swap_shmem_alloc(swap);
-		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
+		shmem_delete_from_page_cache(&folio->page, swp_to_radix_entry(swap));
 
 		mutex_unlock(&shmem_swaplist_mutex);
-		BUG_ON(page_mapped(page));
-		swap_writepage(page, wbc);
+		BUG_ON(folio_mapped(folio));
+		swap_writepage(&folio->page, wbc);
 		return 0;
 	}
 
 	mutex_unlock(&shmem_swaplist_mutex);
-	put_swap_page(page, swap);
+	put_swap_page(&folio->page, swap);
 redirty:
-	set_page_dirty(page);
+	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
-	unlock_page(page);
+		return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
+	folio_unlock(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


