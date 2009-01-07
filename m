From: akpm@linux-foundation.org
Subject: - cleanup-get-rid-of-ifdef-config_migration.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:54 -0800
Message-ID: <200901072211.n07MBs37012178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbZAGWMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: cleanup: remove #ifdef CONFIG_MIGRATION
has been removed from the -mm tree.  Its filename was
     cleanup-get-rid-of-ifdef-config_migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: cleanup: remove #ifdef CONFIG_MIGRATION
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

#ifdef in *.c file decrease source readability a bit.  removing is better.

This patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++++
 mm/mprotect.c           |    6 ++----
 mm/rmap.c               |   10 +++-------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff -puN include/linux/migrate.h~cleanup-get-rid-of-ifdef-config_migration include/linux/migrate.h
--- a/include/linux/migrate.h~cleanup-get-rid-of-ifdef-config_migration
+++ a/include/linux/migrate.h
@@ -7,6 +7,8 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
+#define PAGE_MIGRATION 1
+
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -20,6 +22,8 @@ extern int migrate_vmas(struct mm_struct
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
 #else
+#define PAGE_MIGRATION 0
+
 static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
diff -puN mm/mprotect.c~cleanup-get-rid-of-ifdef-config_migration mm/mprotect.c
--- a/mm/mprotect.c~cleanup-get-rid-of-ifdef-config_migration
+++ a/mm/mprotect.c
@@ -22,6 +22,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -59,8 +60,7 @@ static void change_pte_range(struct mm_s
 				ptent = pte_mkwrite(ptent);
 
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
-#ifdef CONFIG_MIGRATION
-		} else if (!pte_file(oldpte)) {
+		} else if (PAGE_MIGRATION && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
@@ -72,9 +72,7 @@ static void change_pte_range(struct mm_s
 				set_pte_at(mm, addr, pte,
 					swp_entry_to_pte(entry));
 			}
-#endif
 		}
-
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
diff -puN mm/rmap.c~cleanup-get-rid-of-ifdef-config_migration mm/rmap.c
--- a/mm/rmap.c~cleanup-get-rid-of-ifdef-config_migration
+++ a/mm/rmap.c
@@ -50,6 +50,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 
 #include <asm/tlbflush.h>
 
@@ -818,8 +819,7 @@ static int try_to_unmap_one(struct page 
 				spin_unlock(&mmlist_lock);
 			}
 			dec_mm_counter(mm, anon_rss);
-#ifdef CONFIG_MIGRATION
-		} else {
+		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -827,19 +827,15 @@ static int try_to_unmap_one(struct page 
 			 */
 			BUG_ON(!migration);
 			entry = make_migration_entry(page, pte_write(pteval));
-#endif
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else
-#ifdef CONFIG_MIGRATION
-	if (migration) {
+	} else if (PAGE_MIGRATION && migration) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
-#endif
 		dec_mm_counter(mm, file_rss);
 
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

