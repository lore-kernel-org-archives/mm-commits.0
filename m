From: akpm@linux-foundation.org
Subject: + thp-freeze-khugepaged-and-ksmd.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:03 -0800
Message-ID: <201012152358.oBFNw33a013673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922Ab0LOX6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: freeze khugepaged and ksmd
has been added to the -mm tree.  Its filename is
     thp-freeze-khugepaged-and-ksmd.patch

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
Subject: thp: freeze khugepaged and ksmd
From: Andrea Arcangeli <aarcange@redhat.com>

It's unclear why schedule friendly kernel threads can't be taken away by
the CPU through the scheduler itself.  It's safer to stop them as they can
trigger memory allocation, if kswapd also freezes itself to avoid
generating I/O they have too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++++++--
 mm/ksm.c         |    8 ++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-freeze-khugepaged-and-ksmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-freeze-khugepaged-and-ksmd
+++ a/mm/huge_memory.c
@@ -15,6 +15,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
+#include <linux/freezer.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -2085,6 +2086,9 @@ static void khugepaged_do_scan(struct pa
 			break;
 #endif
 
+		if (unlikely(kthread_should_stop() || freezing(current)))
+			break;
+
 		spin_lock(&khugepaged_mm_lock);
 		if (!khugepaged_scan.mm_slot)
 			pass_through_head++;
@@ -2147,6 +2151,9 @@ static void khugepaged_loop(void)
 		if (hpage)
 			put_page(hpage);
 #endif
+		try_to_freeze();
+		if (unlikely(kthread_should_stop()))
+			break;
 		if (khugepaged_has_work()) {
 			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
@@ -2157,8 +2164,8 @@ static void khugepaged_loop(void)
 					khugepaged_scan_sleep_millisecs));
 			remove_wait_queue(&khugepaged_wait, &wait);
 		} else if (khugepaged_enabled())
-			wait_event_interruptible(khugepaged_wait,
-						 khugepaged_wait_event());
+			wait_event_freezable(khugepaged_wait,
+					     khugepaged_wait_event());
 	}
 }
 
@@ -2166,6 +2173,7 @@ static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
 
+	set_freezable();
 	set_user_nice(current, 19);
 
 	/* serialize with start_khugepaged() */
@@ -2180,6 +2188,8 @@ static int khugepaged(void *none)
 		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_enabled())
 			break;
+		if (unlikely(kthread_should_stop()))
+			break;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
diff -puN mm/ksm.c~thp-freeze-khugepaged-and-ksmd mm/ksm.c
--- a/mm/ksm.c~thp-freeze-khugepaged-and-ksmd
+++ a/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/swap.h>
 #include <linux/ksm.h>
 #include <linux/hash.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1365,7 +1366,7 @@ static void ksm_do_scan(unsigned int sca
 	struct rmap_item *rmap_item;
 	struct page *uninitialized_var(page);
 
-	while (scan_npages--) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
@@ -1383,6 +1384,7 @@ static int ksmd_should_run(void)
 
 static int ksm_scan_thread(void *nothing)
 {
+	set_freezable();
 	set_user_nice(current, 5);
 
 	while (!kthread_should_stop()) {
@@ -1391,11 +1393,13 @@ static int ksm_scan_thread(void *nothing
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
 
+		try_to_freeze();
+
 		if (ksmd_should_run()) {
 			schedule_timeout_interruptible(
 				msecs_to_jiffies(ksm_thread_sleep_millisecs));
 		} else {
-			wait_event_interruptible(ksm_thread_wait,
+			wait_event_freezable(ksm_thread_wait,
 				ksmd_should_run() || kthread_should_stop());
 		}
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

