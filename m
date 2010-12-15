From: akpm@linux-foundation.org
Subject: + thp-compound_trans_order.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:21 -0800
Message-ID: <201012152358.oBFNwLn7013706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906Ab0LOX6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: compound_trans_order
has been added to the -mm tree.  Its filename is
     thp-compound_trans_order.patch

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
Subject: thp: compound_trans_order
From: Andrea Arcangeli <aarcange@redhat.com>

Read compound_trans_order safe. Noop for CONFIG_TRANSPARENT_HUGEPAGE=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   14 ++++++++++++++
 mm/memcontrol.c     |    6 +++---
 mm/memory-failure.c |   12 ++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

diff -puN include/linux/mm.h~thp-compound_trans_order include/linux/mm.h
--- a/include/linux/mm.h~thp-compound_trans_order
+++ a/include/linux/mm.h
@@ -451,6 +451,20 @@ static inline int compound_order(struct 
 	return (unsigned long)page[1].lru.prev;
 }
 
+static inline int compound_trans_order(struct page *page)
+{
+	int order;
+	unsigned long flags;
+
+	if (!PageHead(page))
+		return 0;
+
+	flags = compound_lock_irqsave(page);
+	order = compound_order(page);
+	compound_unlock_irqrestore(page, flags);
+	return order;
+}
+
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
 	page[1].lru.prev = (void *)order;
diff -puN mm/memcontrol.c~thp-compound_trans_order mm/memcontrol.c
--- a/mm/memcontrol.c~thp-compound_trans_order
+++ a/mm/memcontrol.c
@@ -1030,7 +1030,7 @@ mem_cgroup_get_reclaim_stat_from_page(st
 	int page_size = PAGE_SIZE;
 
 	if (PageTransHuge(page))
-		page_size <<= compound_order(page);
+		page_size <<= compound_trans_order(page);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2288,7 +2288,7 @@ static int mem_cgroup_charge_common(stru
 	int page_size = PAGE_SIZE;
 
 	if (PageTransHuge(page))
-		page_size <<= compound_order(page);
+		page_size <<= compound_trans_order(page);
 
 	pc = lookup_page_cgroup(page);
 	/* can happen at boot */
@@ -2560,7 +2560,7 @@ __mem_cgroup_uncharge_common(struct page
 		return NULL;
 
 	if (PageTransHuge(page))
-		page_size <<= compound_order(page);
+		page_size <<= compound_trans_order(page);
 
 	count = page_size >> PAGE_SHIFT;
 	/*
diff -puN mm/memory-failure.c~thp-compound_trans_order mm/memory-failure.c
--- a/mm/memory-failure.c~thp-compound_trans_order
+++ a/mm/memory-failure.c
@@ -203,7 +203,7 @@ static int kill_proc_ao(struct task_stru
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = compound_order(compound_head(page)) + PAGE_SHIFT;
+	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
 	/*
 	 * Don't use force here, it's convenient if the signal
 	 * can be temporarily blocked.
@@ -930,7 +930,7 @@ static int hwpoison_user_mappings(struct
 static void set_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_order(hpage);
+	int nr_pages = 1 << compound_trans_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		SetPageHWPoison(hpage + i);
 }
@@ -938,7 +938,7 @@ static void set_page_hwpoison_huge_page(
 static void clear_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
-	int nr_pages = 1 << compound_order(hpage);
+	int nr_pages = 1 << compound_trans_order(hpage);
 	for (i = 0; i < nr_pages; i++)
 		ClearPageHWPoison(hpage + i);
 }
@@ -968,7 +968,7 @@ int __memory_failure(unsigned long pfn, 
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(hpage);
+	nr_pages = 1 << compound_trans_order(hpage);
 	atomic_long_add(nr_pages, &mce_bad_pages);
 
 	/*
@@ -1166,7 +1166,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_order(page);
+	nr_pages = 1 << compound_trans_order(page);
 
 	if (!get_page_unless_zero(page)) {
 		/*
@@ -1304,7 +1304,7 @@ static int soft_offline_huge_page(struct
 	}
 done:
 	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_order(hpage), &mce_bad_pages);
+		atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
 	/* keep elevated page count for bad page */
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

