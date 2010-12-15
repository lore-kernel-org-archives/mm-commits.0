From: akpm@linux-foundation.org
Subject: + thp-compound_lock.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:56:11 -0800
Message-ID: <201012152356.oBFNuB4C013387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab0LOX4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: compound_lock
has been added to the -mm tree.  Its filename is
     thp-compound_lock.patch

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
Subject: thp: compound_lock
From: Andrea Arcangeli <aarcange@redhat.com>

Add a new compound_lock() needed to serialize put_page against
__split_huge_page_refcount().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   34 ++++++++++++++++++++++++++++++++++
 include/linux/page-flags.h |   12 +++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~thp-compound_lock include/linux/mm.h
--- a/include/linux/mm.h~thp-compound_lock
+++ a/include/linux/mm.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
+#include <linux/bit_spinlock.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -306,6 +307,39 @@ static inline int is_vmalloc_or_module_a
 }
 #endif
 
+static inline void compound_lock(struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bit_spin_lock(PG_compound_lock, &page->flags);
+#endif
+}
+
+static inline void compound_unlock(struct page *page)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bit_spin_unlock(PG_compound_lock, &page->flags);
+#endif
+}
+
+static inline unsigned long compound_lock_irqsave(struct page *page)
+{
+	unsigned long uninitialized_var(flags);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	local_irq_save(flags);
+	compound_lock(page);
+#endif
+	return flags;
+}
+
+static inline void compound_unlock_irqrestore(struct page *page,
+					      unsigned long flags)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	compound_unlock(page);
+	local_irq_restore(flags);
+#endif
+}
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
diff -puN include/linux/page-flags.h~thp-compound_lock include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-compound_lock
+++ a/include/linux/page-flags.h
@@ -108,6 +108,9 @@ enum pageflags {
 #ifdef CONFIG_MEMORY_FAILURE
 	PG_hwpoison,		/* hardware poisoned page. Don't touch */
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	PG_compound_lock,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -397,6 +400,12 @@ static inline void __ClearPageTail(struc
 #define __PG_MLOCKED		0
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define __PG_COMPOUND_LOCK		(1 << PG_compound_lock)
+#else
+#define __PG_COMPOUND_LOCK		0
+#endif
+
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
  * these flags set.  It they are, there is a problem.
@@ -406,7 +415,8 @@ static inline void __ClearPageTail(struc
 	 1 << PG_private | 1 << PG_private_2 | \
 	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON)
+	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
+	 __PG_COMPOUND_LOCK)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
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

