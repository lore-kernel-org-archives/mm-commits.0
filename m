From: akpm@linux-foundation.org
Subject: + thp-set-recommended-min-free-kbytes.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:43 -0800
Message-ID: <201012152357.oBFNvhE8013635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891Ab0LOX5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: set recommended min free kbytes
has been added to the -mm tree.  Its filename is
     thp-set-recommended-min-free-kbytes.patch

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
Subject: thp: set recommended min free kbytes
From: Andrea Arcangeli <aarcange@redhat.com>

If transparent hugepage is enabled initialize min_free_kbytes to an
optimal value by default.  This moves the hugeadm algorithm in kernel.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff -puN mm/huge_memory.c~thp-set-recommended-min-free-kbytes mm/huge_memory.c
--- a/mm/huge_memory.c~thp-set-recommended-min-free-kbytes
+++ a/mm/huge_memory.c
@@ -85,6 +85,47 @@ struct khugepaged_scan {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+
+static int set_recommended_min_free_kbytes(void)
+{
+	struct zone *zone;
+	int nr_zones = 0;
+	unsigned long recommended_min;
+	extern int min_free_kbytes;
+
+	if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) &&
+	    !test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags))
+		return 0;
+
+	for_each_populated_zone(zone)
+		nr_zones++;
+
+	/* Make sure at least 2 hugepages are free for MIGRATE_RESERVE */
+	recommended_min = pageblock_nr_pages * nr_zones * 2;
+
+	/*
+	 * Make sure that on average at least two pageblocks are almost free
+	 * of another type, one for a migratetype to fall back to and a
+	 * second to avoid subsequent fallbacks of other types There are 3
+	 * MIGRATE_TYPES we care about.
+	 */
+	recommended_min += pageblock_nr_pages * nr_zones *
+			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
+
+	/* don't ever allow to reserve more than 5% of the lowmem */
+	recommended_min = min(recommended_min,
+			      (unsigned long) nr_free_buffer_pages() / 20);
+	recommended_min <<= (PAGE_SHIFT-10);
+
+	if (recommended_min > min_free_kbytes)
+		min_free_kbytes = recommended_min;
+	setup_per_zone_wmarks();
+	return 0;
+}
+late_initcall(set_recommended_min_free_kbytes);
+
 static int start_khugepaged(void)
 {
 	int err = 0;
@@ -108,6 +149,8 @@ static int start_khugepaged(void)
 		mutex_unlock(&khugepaged_mutex);
 		if (wakeup)
 			wake_up_interruptible(&khugepaged_wait);
+
+		set_recommended_min_free_kbytes();
 	} else
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
@@ -177,6 +220,13 @@ static ssize_t enabled_store(struct kobj
 			ret = err;
 	}
 
+	if (ret > 0 &&
+	    (test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) ||
+	     test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags)))
+		set_recommended_min_free_kbytes();
+
 	return ret;
 }
 static struct kobj_attribute enabled_attr =
@@ -464,6 +514,8 @@ static int __init hugepage_init(void)
 
 	start_khugepaged();
 
+	set_recommended_min_free_kbytes();
+
 out:
 	return err;
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

