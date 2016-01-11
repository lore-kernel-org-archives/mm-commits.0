From: akpm@linux-foundation.org
Subject: [folded-merged] mm-oom-introduce-oom-reaper-fix-6.patch removed
 from -mm tree
Date: Mon, 11 Jan 2016 14:48:01 -0800
Message-ID: <56943121.eRkmJEEvLXHm306D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750AbcAKWsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:48:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: skip mlocked VMAs in __oom_reap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-fix-6.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, oom: skip mlocked VMAs in __oom_reap_vmas()

As far as I can see we explicitly munlock pages everywhere before unmap
them. The only case when we don't to that is OOM-reaper.

I don't think we should bother with munlocking in this case, we can just
skip the locked VMA.

I think this patch would fix this crash:
 http://lkml.kernel.org/r/5661FBB6.6050307@oracle.com

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-6 mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-fix-6
+++ a/mm/oom_kill.c
@@ -446,6 +446,13 @@ static bool __oom_reap_vmas(struct mm_st
 			continue;
 
 		/*
+		 * mlocked VMAs require explicit munlocking before unmap.
+		 * Let's keep it simple here and skip such VMAs.
+		 */
+		if (vma->vm_flags & VM_LOCKED)
+			continue;
+
+		/*
 		 * Only anonymous pages have a good chance to be dropped
 		 * without additional steps which we cannot afford as we
 		 * are OOM already.
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
thp-reintroduce-split_huge_page-fix-4.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
thp-introduce-deferred_split_huge_page-fix.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
thp-allow-mlocked-thp-again-fix.patch
thp-allow-mlocked-thp-again-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
memblock-fix-section-mismatch.patch
mm-oom-introduce-oom-reaper.patch
mm-fix-locking-order-in-mm_take_all_locks.patch

