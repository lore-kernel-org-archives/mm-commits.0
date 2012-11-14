From: akpm@linux-foundation.org
Subject: + thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch added to -mm tree
Date: Wed, 14 Nov 2012 13:34:36 -0800
Message-ID: <20121114213437.4513F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58248 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423472Ab2KNVei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 16:34:38 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so95907qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 13:34:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED events
has been added to the -mm tree.  Its filename is
     thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

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
 
+hzp_alloc is incremented every time a huge zero page is successfully
+	allocated. It includes allocations which where dropped due
+	race with other allocation. Note, it doesn't count every map
+	of the huge zero page, only its allocation.
+
+hzp_alloc_failed is incremented if kernel fails to allocate huge zero
+	page and falls back to using small pages.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in /proc/vmstat to help
diff -puN include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/include/linux/vm_event_item.h
@@ -64,6 +64,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT,
+		HZP_ALLOC,
+		HZP_ALLOC_FAILED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
diff -puN mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events mm/huge_memory.c
--- a/mm/huge_memory.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/mm/huge_memory.c
@@ -185,8 +185,11 @@ retry:
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!zero_page)
+	if (!zero_page) {
+		count_vm_event(HZP_ALLOC_FAILED);
 		return 0;
+	}
+	count_vm_event(HZP_ALLOC);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_pfn, 0, page_to_pfn(zero_page))) {
 		preempt_enable();
diff -puN mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events mm/vmstat.c
--- a/mm/vmstat.c~thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events
+++ a/mm/vmstat.c
@@ -809,6 +809,8 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
 	"thp_split",
+	"hzp_alloc",
+	"hzp_alloc_failed",
 #endif
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch

