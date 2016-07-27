From: akpm@linux-foundation.org
Subject: [merged] thp-vmstats-add-counters-for-huge-file-pages.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:02:22 -0700
Message-ID: <5799053e.K1zr3MiafBv7aDq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbcG0TCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, vmstats: add counters for huge file pages
has been removed from the -mm tree.  Its filename was
     thp-vmstats-add-counters-for-huge-file-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, vmstats: add counters for huge file pages

THP_FILE_ALLOC: how many times huge page was allocated and put page
cache.

THP_FILE_MAPPED: how many times file huge page was mapped.

Link: http://lkml.kernel.org/r/1466021202-61880-13-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    7 +++++++
 mm/memory.c                   |    1 +
 mm/vmstat.c                   |    2 ++
 3 files changed, 10 insertions(+)

diff -puN include/linux/vm_event_item.h~thp-vmstats-add-counters-for-huge-file-pages include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~thp-vmstats-add-counters-for-huge-file-pages
+++ a/include/linux/vm_event_item.h
@@ -70,6 +70,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_FAULT_FALLBACK,
 		THP_COLLAPSE_ALLOC,
 		THP_COLLAPSE_ALLOC_FAILED,
+		THP_FILE_ALLOC,
+		THP_FILE_MAPPED,
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
 		THP_DEFERRED_SPLIT_PAGE,
@@ -100,4 +102,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NR_VM_EVENT_ITEMS
 };
 
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#define THP_FILE_ALLOC ({ BUILD_BUG(); 0; })
+#define THP_FILE_MAPPED ({ BUILD_BUG(); 0; })
+#endif
+
 #endif		/* VM_EVENT_ITEM_H_INCLUDED */
diff -puN mm/memory.c~thp-vmstats-add-counters-for-huge-file-pages mm/memory.c
--- a/mm/memory.c~thp-vmstats-add-counters-for-huge-file-pages
+++ a/mm/memory.c
@@ -2968,6 +2968,7 @@ static int do_set_pmd(struct fault_env *
 
 	/* fault is handled */
 	ret = 0;
+	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(fe->ptl);
 	return ret;
diff -puN mm/vmstat.c~thp-vmstats-add-counters-for-huge-file-pages mm/vmstat.c
--- a/mm/vmstat.c~thp-vmstats-add-counters-for-huge-file-pages
+++ a/mm/vmstat.c
@@ -817,6 +817,8 @@ const char * const vmstat_text[] = {
 	"thp_fault_fallback",
 	"thp_collapse_alloc",
 	"thp_collapse_alloc_failed",
+	"thp_file_alloc",
+	"thp_file_mapped",
 	"thp_split_page",
 	"thp_split_page_failed",
 	"thp_deferred_split_page",
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


