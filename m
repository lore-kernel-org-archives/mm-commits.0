From: akpm@linux-foundation.org
Subject: +
 mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch
 added to -mm tree
Date: Wed, 20 Jul 2016 14:09:13 -0700
Message-ID: <578fe879.7o6Nq/HTwHUK79rs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbcGTVJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 17:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, gorcunov@openvz.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: convert from optimistic swapin collapsing to conservative
has been added to the -mm tree.  Its filename is
     mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: convert from optimistic swapin collapsing to conservative

To detect whether khugepaged swapin is worthwhile, this patch checks the
amount of young pages.  There should be at least half of HPAGE_PMD_NR to
swapin.

Link: http://lkml.kernel.org/r/1468109451-1615-1-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   19 +++++++------
 mm/khugepaged.c                    |   38 ++++++++++++++++-----------
 2 files changed, 34 insertions(+), 23 deletions(-)

diff -puN include/trace/events/huge_memory.h~mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative include/trace/events/huge_memory.h
--- a/include/trace/events/huge_memory.h~mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative
+++ a/include/trace/events/huge_memory.h
@@ -13,7 +13,7 @@
 	EM( SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
 	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
 	EM( SCAN_PAGE_RO,		"no_writable_page")		\
-	EM( SCAN_NO_REFERENCED_PAGE,	"no_referenced_page")		\
+	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
 	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
 	EM( SCAN_PAGE_COUNT,		"not_suitable_page_count")	\
@@ -47,7 +47,7 @@ SCAN_STATUS
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_PROTO(struct mm_struct *mm, struct page *page, bool writable,
-		 bool referenced, int none_or_zero, int status, int unmapped),
+		 int referenced, int none_or_zero, int status, int unmapped),
 
 	TP_ARGS(mm, page, writable, referenced, none_or_zero, status, unmapped),
 
@@ -55,7 +55,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, pfn)
 		__field(bool, writable)
-		__field(bool, referenced)
+		__field(int, referenced)
 		__field(int, none_or_zero)
 		__field(int, status)
 		__field(int, unmapped)
@@ -108,14 +108,14 @@ TRACE_EVENT(mm_collapse_huge_page,
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct page *page, int none_or_zero,
-		 bool referenced, bool  writable, int status),
+		 int referenced, bool  writable, int status),
 
 	TP_ARGS(page, none_or_zero, referenced, writable, status),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(int, none_or_zero)
-		__field(bool, referenced)
+		__field(int, referenced)
 		__field(bool, writable)
 		__field(int, status)
 	),
@@ -138,25 +138,28 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 
 TRACE_EVENT(mm_collapse_huge_page_swapin,
 
-	TP_PROTO(struct mm_struct *mm, int swapped_in, int ret),
+	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret),
 
-	TP_ARGS(mm, swapped_in, ret),
+	TP_ARGS(mm, swapped_in, referenced, ret),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(int, swapped_in)
+		__field(int, referenced)
 		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->swapped_in = swapped_in;
+		__entry->referenced = referenced;
 		__entry->ret = ret;
 	),
 
-	TP_printk("mm=%p, swapped_in=%d, ret=%d",
+	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d",
 		__entry->mm,
 		__entry->swapped_in,
+		__entry->referenced,
 		__entry->ret)
 );
 
diff -puN mm/khugepaged.c~mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative
+++ a/mm/khugepaged.c
@@ -27,7 +27,7 @@ enum scan_result {
 	SCAN_EXCEED_NONE_PTE,
 	SCAN_PTE_NON_PRESENT,
 	SCAN_PAGE_RO,
-	SCAN_NO_REFERENCED_PAGE,
+	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
 	SCAN_SCAN_ABORT,
 	SCAN_PAGE_COUNT,
@@ -500,8 +500,8 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page = NULL;
 	pte_t *_pte;
-	int none_or_zero = 0, result = 0;
-	bool referenced = false, writable = false;
+	int none_or_zero = 0, result = 0, referenced = 0;
+	bool writable = false;
 
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
@@ -580,11 +580,11 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 
-		/* If there is no mapped pte young don't collapse the page */
+		/* There should be enough young pte to collapse the page */
 		if (pte_young(pteval) ||
 		    page_is_young(page) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
-			referenced = true;
+			referenced++;
 	}
 	if (likely(writable)) {
 		if (likely(referenced)) {
@@ -869,7 +869,8 @@ static int hugepage_vma_revalidate(struc
 
 static bool __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmd)
+					unsigned long address, pmd_t *pmd,
+					int referenced)
 {
 	pte_t pteval;
 	int swapped_in = 0, ret = 0;
@@ -887,12 +888,19 @@ static bool __collapse_huge_page_swapin(
 		if (!is_swap_pte(pteval))
 			continue;
 		swapped_in++;
+		/* we only decide to swapin, if there is enough young ptes */
+		if (referenced < HPAGE_PMD_NR/2) {
+			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
+			return false;
+		}
 		ret = do_swap_page(&fe, pteval);
+
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
 			if (hugepage_vma_revalidate(mm, address)) {
 				/* vma is no longer available, don't continue to swapin */
+				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 				return false;
 			}
 			/* check if the pmd is still valid */
@@ -900,7 +908,7 @@ static bool __collapse_huge_page_swapin(
 				return false;
 		}
 		if (ret & VM_FAULT_ERROR) {
-			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
+			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 			return false;
 		}
 		/* pte is unmapped now, we need to map it */
@@ -908,7 +916,7 @@ static bool __collapse_huge_page_swapin(
 	}
 	fe.pte--;
 	pte_unmap(fe.pte);
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, 1);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 1);
 	return true;
 }
 
@@ -916,7 +924,7 @@ static void collapse_huge_page(struct mm
 				   unsigned long address,
 				   struct page **hpage,
 				   struct vm_area_struct *vma,
-				   int node)
+				   int node, int referenced)
 {
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
@@ -973,7 +981,7 @@ static void collapse_huge_page(struct mm
 	 * If it fails, we release mmap_sem and jump out_nolock.
 	 * Continuing to collapse causes inconsistency.
 	 */
-	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+	if (!__collapse_huge_page_swapin(mm, vma, address, pmd, referenced)) {
 		mem_cgroup_cancel_charge(new_page, memcg, true);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
@@ -1084,12 +1092,12 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int ret = 0, none_or_zero = 0, result = 0;
+	int ret = 0, none_or_zero = 0, result = 0, referenced = 0;
 	struct page *page = NULL;
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
-	bool writable = false, referenced = false;
+	bool writable = false;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -1177,14 +1185,14 @@ static int khugepaged_scan_pmd(struct mm
 		if (pte_young(pteval) ||
 		    page_is_young(page) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
-			referenced = true;
+			referenced++;
 	}
 	if (writable) {
 		if (referenced) {
 			result = SCAN_SUCCEED;
 			ret = 1;
 		} else {
-			result = SCAN_NO_REFERENCED_PAGE;
+			result = SCAN_LACK_REFERENCED_PAGE;
 		}
 	} else {
 		result = SCAN_PAGE_RO;
@@ -1194,7 +1202,7 @@ out_unmap:
 	if (ret) {
 		node = khugepaged_find_target_node();
 		/* collapse_huge_page will return with the mmap_sem released */
-		collapse_huge_page(mm, address, hpage, vma, node);
+		collapse_huge_page(mm, address, hpage, vma, node, referenced);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch
mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch
mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch

