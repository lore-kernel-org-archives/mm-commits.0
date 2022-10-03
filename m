Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C0CC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJCVID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCVGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B7C399C5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38753610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88878C433D6;
        Mon,  3 Oct 2022 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831133;
        bh=r4xPmbg9ZATZMNxLSILYSp0RmAZlCIl1h5OyDF0GPC0=;
        h=Date:To:From:Subject:From;
        b=I4g/AwoTgbetDV8p3xcGGMtYmdx4bGZryaV8RrN3JQ6gmpVjF/HdMrgqkNI/3aQiN
         6PSvAYrst5I4nlDBR6Jv59mr7YFSrYxIF56bVGnNie0IjtnM9gj9wFCUfkgYUOhuMt
         b1ldZ9QSWRh9uOGS2W2GWrGEvZ/xV+uzgarqxKL8=
Date:   Mon, 03 Oct 2022 14:05:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-convert-__unmap_and_move-to-use-folios.patch removed from -mm tree
Message-Id: <20221003210533.88878C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate: convert __unmap_and_move() to use folios
has been removed from the -mm tree.  Its filename was
     migrate-convert-__unmap_and_move-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: convert __unmap_and_move() to use folios
Date: Fri, 2 Sep 2022 20:46:46 +0100

Removes a lot of calls to compound_head().  Also remove a VM_BUG_ON that
can never trigger as the PageAnon bit is the bottom bit of page->mapping.

Link: https://lkml.kernel.org/r/20220902194653.1739778-51-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   75 ++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

--- a/mm/migrate.c~migrate-convert-__unmap_and_move-to-use-folios
+++ a/mm/migrate.c
@@ -993,17 +993,15 @@ out:
 	return rc;
 }
 
-static int __unmap_and_move(struct page *page, struct page *newpage,
+static int __unmap_and_move(struct folio *src, struct folio *dst,
 				int force, enum migrate_mode mode)
 {
-	struct folio *folio = page_folio(page);
-	struct folio *dst = page_folio(newpage);
 	int rc = -EAGAIN;
 	bool page_was_mapped = false;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__PageMovable(page);
+	bool is_lru = !__PageMovable(&src->page);
 
-	if (!trylock_page(page)) {
+	if (!folio_trylock(src)) {
 		if (!force || mode == MIGRATE_ASYNC)
 			goto out;
 
@@ -1023,10 +1021,10 @@ static int __unmap_and_move(struct page
 		if (current->flags & PF_MEMALLOC)
 			goto out;
 
-		lock_page(page);
+		folio_lock(src);
 	}
 
-	if (PageWriteback(page)) {
+	if (folio_test_writeback(src)) {
 		/*
 		 * Only in the case of a full synchronous migration is it
 		 * necessary to wait for PageWriteback. In the async case,
@@ -1043,12 +1041,12 @@ static int __unmap_and_move(struct page
 		}
 		if (!force)
 			goto out_unlock;
-		wait_on_page_writeback(page);
+		folio_wait_writeback(src);
 	}
 
 	/*
-	 * By try_to_migrate(), page->mapcount goes down to 0 here. In this case,
-	 * we cannot notice that anon_vma is freed while we migrates a page.
+	 * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
+	 * we cannot notice that anon_vma is freed while we migrate a page.
 	 * This get_anon_vma() delays freeing anon_vma pointer until the end
 	 * of migration. File cache pages are no problem because of page_lock()
 	 * File Caches may use write_page() or lock_page() in migration, then,
@@ -1060,22 +1058,22 @@ static int __unmap_and_move(struct page
 	 * because that implies that the anon page is no longer mapped
 	 * (and cannot be remapped so long as we hold the page lock).
 	 */
-	if (PageAnon(page) && !PageKsm(page))
-		anon_vma = page_get_anon_vma(page);
+	if (folio_test_anon(src) && !folio_test_ksm(src))
+		anon_vma = page_get_anon_vma(&src->page);
 
 	/*
 	 * Block others from accessing the new page when we get around to
 	 * establishing additional references. We are usually the only one
-	 * holding a reference to newpage at this point. We used to have a BUG
-	 * here if trylock_page(newpage) fails, but would like to allow for
-	 * cases where there might be a race with the previous use of newpage.
+	 * holding a reference to dst at this point. We used to have a BUG
+	 * here if folio_trylock(dst) fails, but would like to allow for
+	 * cases where there might be a race with the previous use of dst.
 	 * This is much like races on refcount of oldpage: just don't BUG().
 	 */
-	if (unlikely(!trylock_page(newpage)))
+	if (unlikely(!folio_trylock(dst)))
 		goto out_unlock;
 
 	if (unlikely(!is_lru)) {
-		rc = move_to_new_folio(dst, folio, mode);
+		rc = move_to_new_folio(dst, src, mode);
 		goto out_unlock_both;
 	}
 
@@ -1083,7 +1081,7 @@ static int __unmap_and_move(struct page
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
 	 * and treated as swapcache but it has no rmap yet.
-	 * Calling try_to_unmap() against a page->mapping==NULL page will
+	 * Calling try_to_unmap() against a src->mapping==NULL page will
 	 * trigger a BUG.  So handle it here.
 	 * 2. An orphaned page (see truncate_cleanup_page) might have
 	 * fs-private metadata. The page can be picked up due to memory
@@ -1091,57 +1089,56 @@ static int __unmap_and_move(struct page
 	 * invisible to the vm, so the page can not be migrated.  So try to
 	 * free the metadata, so the page can be freed.
 	 */
-	if (!page->mapping) {
-		VM_BUG_ON_PAGE(PageAnon(page), page);
-		if (page_has_private(page)) {
-			try_to_free_buffers(folio);
+	if (!src->mapping) {
+		if (folio_test_private(src)) {
+			try_to_free_buffers(src);
 			goto out_unlock_both;
 		}
-	} else if (page_mapped(page)) {
+	} else if (folio_mapped(src)) {
 		/* Establish migration ptes */
-		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
-				page);
-		try_to_migrate(folio, 0);
+		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
+			       !folio_test_ksm(src) && !anon_vma, src);
+		try_to_migrate(src, 0);
 		page_was_mapped = true;
 	}
 
-	if (!page_mapped(page))
-		rc = move_to_new_folio(dst, folio, mode);
+	if (!folio_mapped(src))
+		rc = move_to_new_folio(dst, src, mode);
 
 	/*
-	 * When successful, push newpage to LRU immediately: so that if it
+	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
-	 * automatically build up the correct newpage->mlock_count for it.
+	 * automatically build up the correct dst->mlock_count for it.
 	 *
 	 * We would like to do something similar for the old page, when
 	 * unsuccessful, and other cases when a page has been temporarily
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		lru_cache_add(newpage);
+		folio_add_lru(dst);
 		if (page_was_mapped)
 			lru_add_drain();
 	}
 
 	if (page_was_mapped)
-		remove_migration_ptes(folio,
-			rc == MIGRATEPAGE_SUCCESS ? dst : folio, false);
+		remove_migration_ptes(src,
+			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
 
 out_unlock_both:
-	unlock_page(newpage);
+	folio_unlock(dst);
 out_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-	unlock_page(page);
+	folio_unlock(src);
 out:
 	/*
-	 * If migration is successful, decrease refcount of the newpage,
+	 * If migration is successful, decrease refcount of dst,
 	 * which will not free the page because new page owner increased
 	 * refcounter.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS)
-		put_page(newpage);
+		folio_put(dst);
 
 	return rc;
 }
@@ -1157,6 +1154,7 @@ static int unmap_and_move(new_page_t get
 				   enum migrate_reason reason,
 				   struct list_head *ret)
 {
+	struct folio *dst, *src = page_folio(page);
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage = NULL;
 
@@ -1174,9 +1172,10 @@ static int unmap_and_move(new_page_t get
 	newpage = get_new_page(page, private);
 	if (!newpage)
 		return -ENOMEM;
+	dst = page_folio(newpage);
 
 	newpage->private = 0;
-	rc = __unmap_and_move(page, newpage, force, mode);
+	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(newpage, reason);
 
_

Patches currently in -mm which might be from willy@infradead.org are


