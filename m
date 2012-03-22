From: akpm@linux-foundation.org
Subject: [merged] mm-replace-page_migration-with-is_enabledconfig_migration.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:10 -0700
Message-ID: <20120322201810.5CFA2A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab2CVUSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:11 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)
has been removed from the -mm tree.  Its filename was
     mm-replace-page_migration-with-is_enabledconfig_migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: replace PAGE_MIGRATION with IS_ENABLED(CONFIG_MIGRATION)

Since 2a11c8e ("kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and
IS_MODULE()") there is a generic grep-friendly method for checking config
options in C expressions.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 --
 mm/mprotect.c           |    2 +-
 mm/rmap.c               |    7 ++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/migrate.h~mm-replace-page_migration-with-is_enabledconfig_migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-replace-page_migration-with-is_enabledconfig_migration
+++ a/include/linux/migrate.h
@@ -8,7 +8,6 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
-#define PAGE_MIGRATION 1
 
 extern void putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -32,7 +31,6 @@ extern void migrate_page_copy(struct pag
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 #else
-#define PAGE_MIGRATION 0
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
diff -puN mm/mprotect.c~mm-replace-page_migration-with-is_enabledconfig_migration mm/mprotect.c
--- a/mm/mprotect.c~mm-replace-page_migration-with-is_enabledconfig_migration
+++ a/mm/mprotect.c
@@ -60,7 +60,7 @@ static void change_pte_range(struct mm_s
 				ptent = pte_mkwrite(ptent);
 
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
-		} else if (PAGE_MIGRATION && !pte_file(oldpte)) {
+		} else if (IS_ENABLED(CONFIG_MIGRATION) && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
diff -puN mm/rmap.c~mm-replace-page_migration-with-is_enabledconfig_migration mm/rmap.c
--- a/mm/rmap.c~mm-replace-page_migration-with-is_enabledconfig_migration
+++ a/mm/rmap.c
@@ -1282,7 +1282,7 @@ int try_to_unmap_one(struct page *page, 
 			}
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
-		} else if (PAGE_MIGRATION) {
+		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -1293,7 +1293,8 @@ int try_to_unmap_one(struct page *page, 
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
+	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
+		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
@@ -1499,7 +1500,7 @@ static int try_to_unmap_anon(struct page
 		 * locking requirements of exec(), migration skips
 		 * temporary VMAs until after exec() completes.
 		 */
-		if (PAGE_MIGRATION && (flags & TTU_MIGRATION) &&
+		if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
 				is_vma_temporary_stack(vma))
 			continue;
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch

