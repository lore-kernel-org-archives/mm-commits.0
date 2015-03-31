From: akpm@linux-foundation.org
Subject: + mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch added to -mm tree
Date: Tue, 31 Mar 2015 14:08:37 -0700
Message-ID: <551b0cd5.5i0FFtnW+AOtiZKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbCaVIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-cleanup-using-pagehugeactive-flag-fix

s/PageHugeActive/page_huge_active/

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    7 -------
 include/linux/page-flags.h |    7 +++++++
 mm/hugetlb.c               |    4 ++--
 mm/memory_hotplug.c        |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/include/linux/hugetlb.h
@@ -44,8 +44,6 @@ extern int hugetlb_max_hstate __read_mos
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
-int PageHugeActive(struct page *page);
-
 struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 						long min_hpages);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
@@ -115,11 +113,6 @@ unsigned long hugetlb_change_protection(
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
-static inline int PageHugeActive(struct page *page)
-{
-	return 0;
-}
-
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
 {
 }
diff -puN include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/include/linux/page-flags.h
@@ -549,11 +549,18 @@ static inline void ClearPageCompound(str
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
 int PageHeadHuge(struct page *page);
+bool page_huge_active(struct page *page);
 #else
 TESTPAGEFLAG_FALSE(Huge)
 TESTPAGEFLAG_FALSE(HeadHuge)
+
+static inline bool page_huge_active(struct page *page)
+{
+	return 0;
+}
 #endif
 
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * PageHuge() only returns true for hugetlbfs pages, but not for
diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/mm/hugetlb.c
@@ -3909,10 +3909,10 @@ int dequeue_hwpoisoned_huge_page(struct
 
 	spin_lock(&hugetlb_lock);
 	/*
-	 * Just checking !PageHugeActive is not enough, because that could be
+	 * Just checking !page_huge_active is not enough, because that could be
 	 * an isolated/hwpoisoned hugepage (which have >0 refcount).
 	 */
-	if (!PageHugeActive(hpage) && !page_count(hpage)) {
+	if (!page_huge_active(hpage) && !page_count(hpage)) {
 		/*
 		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
 		 * but dangling hpage->lru can trigger list-debug warnings
diff -puN mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hugetlb-cleanup-using-pagehugeactive-flag-fix
+++ a/mm/memory_hotplug.c
@@ -1373,7 +1373,7 @@ static unsigned long scan_movable_pages(
 			if (PageLRU(page))
 				return pfn;
 			if (PageHuge(page)) {
-				if (PageHugeActive(page))
+				if (page_huge_active(page))
 					return pfn;
 				else
 					pfn = round_up(pfn + 1,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

