From: akpm@linux-foundation.org
Subject: + thp-transparent-hugepage-config-choice.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:51 -0800
Message-ID: <201012152357.oBFNvpsu013647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755893Ab0LOX6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: transparent hugepage config choice
has been added to the -mm tree.  Its filename is
     thp-transparent-hugepage-config-choice.patch

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
Subject: thp: transparent hugepage config choice
From: Andrea Arcangeli <aarcange@redhat.com>

Allow to choose between the always|madvise default for page faults and
khugepaged at config time.  madvise guarantees zero risk of higher memory
footprint for applications (applications using madvise(MADV_HUGEPAGE)
won't risk to use any more memory by backing their virtual regions with
hugepages).

Initially set the default to N and don't depend on EMBEDDED.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig       |   27 +++++++++++++++++++++++++--
 mm/huge_memory.c |    5 +++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff -puN mm/Kconfig~thp-transparent-hugepage-config-choice mm/Kconfig
--- a/mm/Kconfig~thp-transparent-hugepage-config-choice
+++ a/mm/Kconfig
@@ -303,9 +303,8 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  See Documentation/nommu-mmap.txt for more information.
 
 config TRANSPARENT_HUGEPAGE
-	bool "Transparent Hugepage Support" if EMBEDDED
+	bool "Transparent Hugepage Support"
 	depends on X86 && MMU
-	default y
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
 	  huge tlb transparently to the applications whenever possible.
@@ -316,6 +315,30 @@ config TRANSPARENT_HUGEPAGE
 
 	  If memory constrained on embedded, you may want to say N.
 
+choice
+	prompt "Transparent Hugepage Support sysfs defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_ALWAYS
+	help
+	  Selects the sysfs defaults for Transparent Hugepage Support.
+
+	config TRANSPARENT_HUGEPAGE_ALWAYS
+		bool "always"
+	help
+	  Enabling Transparent Hugepage always, can increase the
+	  memory footprint of applications without a guaranteed
+	  benefit but it will work automatically for all applications.
+
+	config TRANSPARENT_HUGEPAGE_MADVISE
+		bool "madvise"
+	help
+	  Enabling Transparent Hugepage madvise, will only provide a
+	  performance improvement benefit to the applications using
+	  madvise(MADV_HUGEPAGE) but it won't risk to increase the
+	  memory footprint of applications without a guaranteed
+	  benefit.
+endchoice
+
 #
 # UP and nommu archs use km based percpu allocator
 #
diff -puN mm/huge_memory.c~thp-transparent-hugepage-config-choice mm/huge_memory.c
--- a/mm/huge_memory.c~thp-transparent-hugepage-config-choice
+++ a/mm/huge_memory.c
@@ -27,7 +27,12 @@
  * allocations.
  */
 unsigned long transparent_hugepage_flags __read_mostly =
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
 	(1<<TRANSPARENT_HUGEPAGE_FLAG)|
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
+	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
+#endif
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 
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

