From: akpm@linux-foundation.org
Subject: [merged]
 mm-change-deactivate_page-with-deactivate_file_page.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:51:39 -0700
Message-ID: <552fe89b.CeRp5qth20ft2xx3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbDPQqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, Yalin.Wang@sonymobile.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename deactivate_page to deactivate_file_page
has been removed from the -mm tree.  Its filename was
     mm-change-deactivate_page-with-deactivate_file_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: rename deactivate_page to deactivate_file_page

"deactivate_page" was created for file invalidation so it has too specific
logic for file-backed pages.  So, let's change the name of the function
and date to a file-specific one and yield the generic name.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wang, Yalin <Yalin.Wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap.c            |   24 ++++++++++++------------
 mm/truncate.c        |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/swap.h~mm-change-deactivate_page-with-deactivate_file_page include/linux/swap.h
--- a/include/linux/swap.h~mm-change-deactivate_page-with-deactivate_file_page
+++ a/include/linux/swap.h
@@ -307,7 +307,7 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
-extern void deactivate_page(struct page *page);
+extern void deactivate_file_page(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN mm/swap.c~mm-change-deactivate_page-with-deactivate_file_page mm/swap.c
--- a/mm/swap.c~mm-change-deactivate_page-with-deactivate_file_page
+++ a/mm/swap.c
@@ -42,7 +42,7 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvec);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
-static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_deactivate_file_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -743,7 +743,7 @@ void lru_cache_add_active_or_unevictable
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
+static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 			      void *arg)
 {
 	int lru, file;
@@ -811,36 +811,36 @@ void lru_add_drain_cpu(int cpu)
 		local_irq_restore(flags);
 	}
 
-	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
+	pvec = &per_cpu(lru_deactivate_file_pvecs, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
 
 	activate_page_drain(cpu);
 }
 
 /**
- * deactivate_page - forcefully deactivate a page
+ * deactivate_file_page - forcefully deactivate a file page
  * @page: page to deactivate
  *
  * This function hints the VM that @page is a good reclaim candidate,
  * for example if its invalidation fails due to the page being dirty
  * or under writeback.
  */
-void deactivate_page(struct page *page)
+void deactivate_file_page(struct page *page)
 {
 	/*
-	 * In a workload with many unevictable page such as mprotect, unevictable
-	 * page deactivation for accelerating reclaim is pointless.
+	 * In a workload with many unevictable page such as mprotect,
+	 * unevictable page deactivation for accelerating reclaim is pointless.
 	 */
 	if (PageUnevictable(page))
 		return;
 
 	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
+		struct pagevec *pvec = &get_cpu_var(lru_deactivate_file_pvecs);
 
 		if (!pagevec_add(pvec, page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_cpu_var(lru_deactivate_pvecs);
+			pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
+		put_cpu_var(lru_deactivate_file_pvecs);
 	}
 }
 
@@ -872,7 +872,7 @@ void lru_add_drain_all(void)
 
 		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
 		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
-		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
+		    pagevec_count(&per_cpu(lru_deactivate_file_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			schedule_work_on(cpu, work);
diff -puN mm/truncate.c~mm-change-deactivate_page-with-deactivate_file_page mm/truncate.c
--- a/mm/truncate.c~mm-change-deactivate_page-with-deactivate_file_page
+++ a/mm/truncate.c
@@ -490,7 +490,7 @@ unsigned long invalidate_mapping_pages(s
 			 * of interest and try to speed up its reclaim.
 			 */
 			if (!ret)
-				deactivate_page(page);
+				deactivate_file_page(page);
 			count += ret;
 		}
 		pagevec_remove_exceptionals(&pvec);
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

