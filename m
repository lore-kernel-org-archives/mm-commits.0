From: akpm@linux-foundation.org
Subject: + mm-hugetlb-introduce-pagehugeactive-flag-fix.patch added to -mm tree
Date: Tue, 31 Mar 2015 14:08:33 -0700
Message-ID: <551b0cd1.axDsGND6hN05JBpI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbCaVIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-pagehugeactive-flag-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-introduce-pagehugeactive-flag-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-introduce-pagehugeactive-flag-fix.patch

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
Subject: mm-hugetlb-introduce-pagehugeactive-flag-fix

s/PageHugeActive/page_huge_active/, make it return bool

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-pagehugeactive-flag-fix
+++ a/mm/hugetlb.c
@@ -925,25 +925,25 @@ struct hstate *size_to_hstate(unsigned l
 }
 
 /*
- * Page flag to show that the hugepage is "active/in-use" (i.e. being linked to
- * hstate->hugepage_activelist.)
+ * Test to determine whether the hugepage is "active/in-use" (i.e. being linked
+ * to hstate->hugepage_activelist.)
  *
  * This function can be called for tail pages, but never returns true for them.
  */
-int PageHugeActive(struct page *page)
+bool page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
 	return PageHead(page) && PagePrivate(&page[1]);
 }
 
 /* never called for tail page */
-void SetPageHugeActive(struct page *page)
+void set_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	SetPagePrivate(&page[1]);
 }
 
-void ClearPageHugeActive(struct page *page)
+void clear_page_huge_active(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
 	ClearPagePrivate(&page[1]);
@@ -977,7 +977,7 @@ void free_huge_page(struct page *page)
 		restore_reserve = true;
 
 	spin_lock(&hugetlb_lock);
-	ClearPageHugeActive(page);
+	clear_page_huge_active(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	if (restore_reserve)
@@ -2998,7 +2998,7 @@ retry_avoidcopy:
 	copy_user_huge_page(new_page, old_page, address, vma,
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
-	SetPageHugeActive(new_page);
+	set_page_huge_active(new_page);
 
 	mmun_start = address & huge_page_mask(h);
 	mmun_end = mmun_start + huge_page_size(h);
@@ -3111,7 +3111,7 @@ retry:
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
-		SetPageHugeActive(page);
+		set_page_huge_active(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err;
@@ -3946,11 +3946,11 @@ bool isolate_huge_page(struct page *page
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	if (!PageHugeActive(page) || !get_page_unless_zero(page)) {
+	if (!page_huge_active(page) || !get_page_unless_zero(page)) {
 		ret = false;
 		goto unlock;
 	}
-	ClearPageHugeActive(page);
+	clear_page_huge_active(page);
 	list_move_tail(&page->lru, list);
 unlock:
 	spin_unlock(&hugetlb_lock);
@@ -3961,7 +3961,7 @@ void putback_active_hugepage(struct page
 {
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
-	SetPageHugeActive(page);
+	set_page_huge_active(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
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

