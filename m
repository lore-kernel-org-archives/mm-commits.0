Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EACC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383824AbiEMTY7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383859AbiEMTXP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D23DA51
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC4BEB83196
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA67C34113;
        Fri, 13 May 2022 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469726;
        bh=bYlma3h0rKYso2nhNwqNKK6FzFam52BWb5tJ9az+ao8=;
        h=Date:To:From:Subject:From;
        b=qnqSgW3HZ/LrkX62pkN9k/sE3Tzu8a2ka75s6PXAPOLzrhdl6Ae3rGSxyfCyURWwX
         Gt2qep7eAKHV3uXuZJDAQOu6ZA8K/JoqKoxLIKxqRhI/B8PemmxYi4Gh3IC+jBdqSi
         qIffBkiXBhH7fAWZMbfK2C4u8Z/seZIGYPLmLnZE=
Date:   Fri, 13 May 2022 12:22:06 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch removed from -mm tree
Message-Id: <20220513192206.9FA67C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: convert move_to_new_page() into move_to_new_folio()
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -843,21 +843,21 @@ static int fallback_migrate_page(struct
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
@@ -866,54 +866,54 @@ static int move_to_new_page(struct page
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
@@ -1001,7 +1001,7 @@ static int __unmap_and_move(struct page
 		goto out_unlock;
 
 	if (unlikely(!is_lru)) {
-		rc = move_to_new_page(newpage, page, mode);
+		rc = move_to_new_folio(dst, folio, mode);
 		goto out_unlock_both;
 	}
 
@@ -1032,7 +1032,7 @@ static int __unmap_and_move(struct page
 	}
 
 	if (!page_mapped(page))
-		rc = move_to_new_page(newpage, page, mode);
+		rc = move_to_new_folio(dst, folio, mode);
 
 	/*
 	 * When successful, push newpage to LRU immediately: so that if it
@@ -1261,7 +1261,7 @@ static int unmap_and_move_huge_page(new_
 	}
 
 	if (!page_mapped(hpage))
-		rc = move_to_new_page(new_hpage, hpage, mode);
+		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
 		remove_migration_ptes(src,
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

