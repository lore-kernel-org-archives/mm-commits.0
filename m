From: akpm@linux-foundation.org
Subject: + mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch added to
 -mm tree
Date: Mon, 28 Dec 2015 15:19:05 -0800
Message-ID: <5681c369.NUC7dyHWDtPkGXzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbL1XTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 18:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dan.j.williams@intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()

This patch fixes regression caused by patch
 "mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd"

The patch makes pmd_trans_huge() check and "page = pmd_page(*pmd)" after
__split_huge_pmd_locked(). It can never succeed, since the pmd already
points to a page table. As result the page is never get munlocked.

It causes crashes like this:
 http://lkml.kernel.org/r/5661FBB6.6050307@oracle.com

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
@@ -2979,16 +2979,15 @@ void __split_huge_pmd(struct vm_area_str
 
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
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch

