From: akpm@linux-foundation.org
Subject: [folded-merged] thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:38:01 -0800
Message-ID: <20121212213801.8E2E882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:39789 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2LLViD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:38:03 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so130672ghb.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:38:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
has been removed from the -mm tree.  Its filename was
     thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch

This patch was dropped because it was folded into thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events

hzp_alloc is incremented every time a huge zero page is successfully
	allocated. It includes allocations which where dropped due
	race with other allocation. Note, it doesn't count every map
	of the huge zero page, only its allocation.

hzp_alloc_failed is incremented if kernel fails to allocate huge zero
	page and falls back to using small pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |   12 ++++++------
 include/linux/vm_event_item.h  |    4 ++--
 mm/huge_memory.c               |    4 ++--
 mm/vmstat.c                    |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN Documentation/vm/transhuge.txt~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6 Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6
+++ a/Documentation/vm/transhuge.txt
@@ -197,13 +197,13 @@ thp_split is incremented every time a hu
 	pages. This can happen for a variety of reasons but a common
 	reason is that a huge page is old and is being reclaimed.
 
-hzp_alloc is incremented every time a huge zero page is successfully
-	allocated. It includes allocations which where dropped due
-	race with other allocation. Note, it doesn't count every map
-	of the huge zero page, only its allocation.
+thp_zero_page_alloc is incremented every time a huge zero page is
+	successfully allocated. It includes allocations which where
+	dropped due race with other allocation. Note, it doesn't count
+	every map of the huge zero page, only its allocation.
 
-hzp_alloc_failed is incremented if kernel fails to allocate huge zero
-	page and falls back to using small pages.
+thp_zero_page_alloc_failed is incremented if kernel fails to allocate
+	huge zero page and falls back to using small pages.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
diff -puN include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6 include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6
+++ a/include/linux/vm_event_item.h
@@ -63,8 +63,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT,
-		HZP_ALLOC,
-		HZP_ALLOC_FAILED,
+		THP_ZERO_PAGE_ALLOC,
+		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6
+++ a/mm/huge_memory.c
@@ -186,10 +186,10 @@ retry:
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_page) {
-		count_vm_event(HZP_ALLOC_FAILED);
+		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return 0;
 	}
-	count_vm_event(HZP_ALLOC);
+	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
 		preempt_enable();
diff -puN mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6 mm/vmstat.c
--- a/mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6
+++ a/mm/vmstat.c
@@ -808,8 +808,8 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_split",
-	"hzp_alloc",
-	"hzp_alloc_failed",
+	"thp_zero_page_alloc",
+	"thp_zero_page_alloc_failed",
 #endif
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

