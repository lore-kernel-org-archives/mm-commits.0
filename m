From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:31:54 -0800
Message-ID: <56998f7a.cnAQuPHmL5J6xQOK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbcAPAbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dan.j.williams@intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch

This patch was dropped because it was folded into mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()

This patch fixes regression caused by patch
 "mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd"

The patch makes pmd_trans_huge() check and "page = pmd_page(*pmd)" after
__split_huge_pmd_locked(). It can never succeed, since the pmd already
points to a page table. As result the page is never get munlocked.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix
+++ a/mm/huge_memory.c
@@ -2980,16 +2980,15 @@ void __split_huge_pmd(struct vm_area_str
 
 	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PMD_SIZE);
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)))
+	if (pmd_trans_huge(*pmd)) {
+		page = pmd_page(*pmd);
+		if (PageMlocked(page))
+			get_page(page);
+		else
+			page = NULL;
+	} else if (!pmd_devmap(*pmd))
 		goto out;
 	__split_huge_pmd_locked(vma, pmd, haddr, false);
-
-	if (pmd_trans_huge(*pmd))
-		page = pmd_page(*pmd);
-	if (page && PageMlocked(page))
-		get_page(page);
-	else
-		page = NULL;
 out:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
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
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch

