From: akpm@linux-foundation.org
Subject: [merged] thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:41 -0800
Message-ID: <20121214232742.4BECC200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43358 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2LNX1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:45 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so208112wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
has been removed from the -mm tree.  Its filename was
     thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 Documentation/vm/transhuge.txt |    8 ++++++++
 include/linux/vm_event_item.h  |    2 ++
 mm/huge_memory.c               |    5 ++++-
 mm/vmstat.c                    |    2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/transhuge.txt~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/Documentation/vm/transhuge.txt
@@ -197,6 +197,14 @@ thp_split is incremented every time a hu
 	pages. This can happen for a variety of reasons but a common
 	reason is that a huge page is old and is being reclaimed.
 
+thp_zero_page_alloc is incremented every time a huge zero page is
+	successfully allocated. It includes allocations which where
+	dropped due race with other allocation. Note, it doesn't count
+	every map of the huge zero page, only its allocation.
+
+thp_zero_page_alloc_failed is incremented if kernel fails to allocate
+	huge zero page and falls back to using small pages.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in /proc/vmstat to help
diff -puN include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/include/linux/vm_event_item.h
@@ -58,6 +58,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT,
+		THP_ZERO_PAGE_ALLOC,
+		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events mm/huge_memory.c
--- a/mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/mm/huge_memory.c
@@ -184,8 +184,11 @@ retry:
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!zero_page)
+	if (!zero_page) {
+		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return 0;
+	}
+	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
 		preempt_enable();
diff -puN mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events mm/vmstat.c
--- a/mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/mm/vmstat.c
@@ -801,6 +801,8 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_split",
+	"thp_zero_page_alloc",
+	"thp_zero_page_alloc_failed",
 #endif
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

