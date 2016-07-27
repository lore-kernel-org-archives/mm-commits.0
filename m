From: akpm@linux-foundation.org
Subject: [merged] mm-make-optimistic-check-for-swapin-readahead.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:01:56 -0700
Message-ID: <57990524.6n6mxNKO5ve4ifXc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sfr@canb.auug.org.au, vbabka@suse.cz, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make optimistic check for swapin readahead
has been removed from the -mm tree.  Its filename was
     mm-make-optimistic-check-for-swapin-readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm: make optimistic check for swapin readahead

Introduce a new sysfs integer knob
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_swap which makes
optimistic check for swapin readahead to increase thp collapse rate. 
Before getting swapped out pages to memory, checks them and allows up to a
certain number.  It also prints out using tracepoints amount of unmapped
ptes.

[vdavydov@parallels.com: fix scan not aborted on SCAN_EXCEED_SWAP_PTE]
[sfr@canb.auug.org.au: build fix]
  Link: http://lkml.kernel.org/r/20160616154503.65806e12@canb.auug.org.au
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   14 +++++---
 mm/huge_memory.c                   |   45 +++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 8 deletions(-)

diff -puN include/trace/events/huge_memory.h~mm-make-optimistic-check-for-swapin-readahead include/trace/events/huge_memory.h
--- a/include/trace/events/huge_memory.h~mm-make-optimistic-check-for-swapin-readahead
+++ a/include/trace/events/huge_memory.h
@@ -28,7 +28,8 @@
 	EM( SCAN_SWAP_CACHE_PAGE,	"page_swap_cache")		\
 	EM( SCAN_DEL_PAGE_LRU,		"could_not_delete_page_from_lru")\
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
-	EMe( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")
+	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
+	EMe( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")
 
 #undef EM
 #undef EMe
@@ -45,9 +46,9 @@ SCAN_STATUS
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_PROTO(struct mm_struct *mm, struct page *page, bool writable,
-		 bool referenced, int none_or_zero, int status),
+		 bool referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, page, writable, referenced, none_or_zero, status),
+	TP_ARGS(mm, page, writable, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -56,6 +57,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 		__field(bool, referenced)
 		__field(int, none_or_zero)
 		__field(int, status)
+		__field(int, unmapped)
 	),
 
 	TP_fast_assign(
@@ -65,15 +67,17 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
+		__entry->unmapped = unmapped;
 	),
 
-	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s",
+	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
 		__entry->mm,
 		__entry->pfn,
 		__entry->writable,
 		__entry->referenced,
 		__entry->none_or_zero,
-		__print_symbolic(__entry->status, SCAN_STATUS))
+		__print_symbolic(__entry->status, SCAN_STATUS),
+		__entry->unmapped)
 );
 
 TRACE_EVENT(mm_collapse_huge_page,
diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead
+++ a/mm/huge_memory.c
@@ -57,7 +57,8 @@ enum scan_result {
 	SCAN_SWAP_CACHE_PAGE,
 	SCAN_DEL_PAGE_LRU,
 	SCAN_ALLOC_HUGE_PAGE_FAIL,
-	SCAN_CGROUP_CHARGE_FAIL
+	SCAN_CGROUP_CHARGE_FAIL,
+	SCAN_EXCEED_SWAP_PTE
 };
 
 #define CREATE_TRACE_POINTS
@@ -100,6 +101,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepage
  * fault.
  */
 static unsigned int khugepaged_max_ptes_none __read_mostly;
+static unsigned int khugepaged_max_ptes_swap __read_mostly;
 
 static int khugepaged(void *none);
 static int khugepaged_slab_init(void);
@@ -598,6 +600,33 @@ static struct kobj_attribute khugepaged_
 	__ATTR(max_ptes_none, 0644, khugepaged_max_ptes_none_show,
 	       khugepaged_max_ptes_none_store);
 
+static ssize_t khugepaged_max_ptes_swap_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     char *buf)
+{
+	return sprintf(buf, "%u\n", khugepaged_max_ptes_swap);
+}
+
+static ssize_t khugepaged_max_ptes_swap_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int err;
+	unsigned long max_ptes_swap;
+
+	err  = kstrtoul(buf, 10, &max_ptes_swap);
+	if (err || max_ptes_swap > HPAGE_PMD_NR-1)
+		return -EINVAL;
+
+	khugepaged_max_ptes_swap = max_ptes_swap;
+
+	return count;
+}
+
+static struct kobj_attribute khugepaged_max_ptes_swap_attr =
+	__ATTR(max_ptes_swap, 0644, khugepaged_max_ptes_swap_show,
+	       khugepaged_max_ptes_swap_store);
+
 static struct attribute *khugepaged_attr[] = {
 	&khugepaged_defrag_attr.attr,
 	&khugepaged_max_ptes_none_attr.attr,
@@ -606,6 +635,7 @@ static struct attribute *khugepaged_attr
 	&full_scans_attr.attr,
 	&scan_sleep_millisecs_attr.attr,
 	&alloc_sleep_millisecs_attr.attr,
+	&khugepaged_max_ptes_swap_attr.attr,
 	NULL,
 };
 
@@ -674,6 +704,7 @@ static int __init hugepage_init(void)
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
 	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
@@ -2507,7 +2538,7 @@ static int khugepaged_scan_pmd(struct mm
 	struct page *page = NULL;
 	unsigned long _address;
 	spinlock_t *ptl;
-	int node = NUMA_NO_NODE;
+	int node = NUMA_NO_NODE, unmapped = 0;
 	bool writable = false, referenced = false;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
@@ -2523,6 +2554,14 @@ static int khugepaged_scan_pmd(struct mm
 	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
+		if (is_swap_pte(pteval)) {
+			if (++unmapped <= khugepaged_max_ptes_swap) {
+				continue;
+			} else {
+				result = SCAN_EXCEED_SWAP_PTE;
+				goto out_unmap;
+			}
+		}
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			if (!userfaultfd_armed(vma) &&
 			    ++none_or_zero <= khugepaged_max_ptes_none) {
@@ -2609,7 +2648,7 @@ out_unmap:
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
-				     none_or_zero, result);
+				     none_or_zero, result, unmapped);
 	return ret;
 }
 
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are


