Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BC2C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiEFBhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387992AbiEFBhN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929BA62A15
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233BC61957
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768D0C385A4;
        Fri,  6 May 2022 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800810;
        bh=pAXChZzPbnvpuE5PT6tBrY9JyzQBrEzwFXGSDBJGRiI=;
        h=Date:To:From:Subject:From;
        b=1+AdBYJxd4fEB+8bQYHAfoTb/4lJ5yybILgZV+ugl5V/hNA5XdWrYiQANiSb4Zte9
         zTE7K7x+zdwBIeSJE7jgeqRmrjLGH3GYneN6oh8+wuJBtWn1tlxWX6F4iE7aGyNe8E
         ZLlnVNrDTgk4sKJXk485MNF9OnmoXnJbITx9xVY4=
Date:   Thu, 05 May 2022 18:33:29 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch added to mm-unstable branch
Message-Id: <20220506013330.768D0C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: convert move_to_new_page() into move_to_new_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

This patch should soon appear in the mm-unstable branch at
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
Subject: mm/migrate: convert move_to_new_page() into move_to_new_folio()

Pass in the folios that we already have in each caller.  Saves a
lot of calls to compound_head().

Link: https://lkml.kernel.org/r/20220504182857.4013401-27-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   58 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- a/mm/migrate.c~mm-migrate-convert-move_to_new_page-into-move_to_new_folio
+++ a/mm/migrate.c
@@ -858,21 +858,21 @@ static int fallback_migrate_page(struct
  *   < 0 - error code
  *  MIGRATEPAGE_SUCCESS - success
  */
-static int move_to_new_page(struct page *newpage, struct page *page,
+static int move_to_new_folio(struct folio *dst, struct folio *src,
 				enum migrate_mode mode)
 {
 	struct address_space *mapping;
 	int rc = -EAGAIN;
-	bool is_lru = !__PageMovable(page);
+	bool is_lru = !__PageMovable(&src->page);
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
+	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
+	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
 
-	mapping = page_mapping(page);
+	mapping = folio_mapping(src);
 
 	if (likely(is_lru)) {
 		if (!mapping)
-			rc = migrate_page(mapping, newpage, page, mode);
+			rc = migrate_page(mapping, &dst->page, &src->page, mode);
 		else if (mapping->a_ops->migratepage)
 			/*
 			 * Most pages have a mapping and most filesystems
@@ -881,54 +881,54 @@ static int move_to_new_page(struct page
 			 * migratepage callback. This is the most common path
 			 * for page migration.
 			 */
-			rc = mapping->a_ops->migratepage(mapping, newpage,
-							page, mode);
+			rc = mapping->a_ops->migratepage(mapping, &dst->page,
+							&src->page, mode);
 		else
-			rc = fallback_migrate_page(mapping, newpage,
-							page, mode);
+			rc = fallback_migrate_page(mapping, &dst->page,
+							&src->page, mode);
 	} else {
 		/*
 		 * In case of non-lru page, it could be released after
 		 * isolation step. In that case, we shouldn't try migration.
 		 */
-		VM_BUG_ON_PAGE(!PageIsolated(page), page);
-		if (!PageMovable(page)) {
+		VM_BUG_ON_FOLIO(!folio_test_isolated(src), src);
+		if (!folio_test_movable(src)) {
 			rc = MIGRATEPAGE_SUCCESS;
-			ClearPageIsolated(page);
+			folio_clear_isolated(src);
 			goto out;
 		}
 
-		rc = mapping->a_ops->migratepage(mapping, newpage,
-						page, mode);
+		rc = mapping->a_ops->migratepage(mapping, &dst->page,
+						&src->page, mode);
 		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
-			!PageIsolated(page));
+				!folio_test_isolated(src));
 	}
 
 	/*
-	 * When successful, old pagecache page->mapping must be cleared before
-	 * page is freed; but stats require that PageAnon be left as PageAnon.
+	 * When successful, old pagecache src->mapping must be cleared before
+	 * src is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (__PageMovable(page)) {
-			VM_BUG_ON_PAGE(!PageIsolated(page), page);
+		if (__PageMovable(&src->page)) {
+			VM_BUG_ON_FOLIO(!folio_test_isolated(src), src);
 
 			/*
 			 * We clear PG_movable under page_lock so any compactor
 			 * cannot try to migrate this page.
 			 */
-			ClearPageIsolated(page);
+			folio_clear_isolated(src);
 		}
 
 		/*
-		 * Anonymous and movable page->mapping will be cleared by
+		 * Anonymous and movable src->mapping will be cleared by
 		 * free_pages_prepare so don't reset it here for keeping
 		 * the type to work PageAnon, for example.
 		 */
-		if (!PageMappingFlags(page))
-			page->mapping = NULL;
+		if (!folio_mapping_flags(src))
+			src->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_folio(page_folio(newpage));
+		if (likely(!folio_is_zone_device(dst)))
+			flush_dcache_folio(dst);
 	}
 out:
 	return rc;
@@ -1016,7 +1016,7 @@ static int __unmap_and_move(struct page
 		goto out_unlock;
 
 	if (unlikely(!is_lru)) {
-		rc = move_to_new_page(newpage, page, mode);
+		rc = move_to_new_folio(dst, folio, mode);
 		goto out_unlock_both;
 	}
 
@@ -1047,7 +1047,7 @@ static int __unmap_and_move(struct page
 	}
 
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, mode);
+		rc = move_to_new_folio(dst, folio, mode);
 
 	/*
 	 * When successful, push newpage to LRU immediately: so that if it
@@ -1272,7 +1272,7 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, mode);
+		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
 		remove_migration_ptes(src,
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

