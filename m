From: akpm@linux-foundation.org
Subject: + cleanup-get-rid-of-ifdef-config_migration.patch added to -mm tree
Date: Tue, 11 Nov 2008 15:57:15 -0800
Message-ID: <200811112357.mABNvFw2029085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYKKX52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 18:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, mel@csn.ul.ie


The patch titled
     mm: ccleanup: remove #ifdef CONFIG_MIGRATION
has been added to the -mm tree.  Its filename is
     cleanup-get-rid-of-ifdef-config_migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: ccleanup: remove #ifdef CONFIG_MIGRATION
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

mm-remove-lru_add_drain_all-from-the-munlock-path.patch
linux-next.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch

