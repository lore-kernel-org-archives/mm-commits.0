From: akpm@linux-foundation.org
Subject: [merged] thp-vmstats-count-deferred-split-events.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:02 -0700
Message-ID: <56f03fc6.yU9ncW7Mabf3OhAA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbcCUT4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, vmstats: count deferred split events
has been removed from the -mm tree.  Its filename was
     thp-vmstats-count-deferred-split-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, vmstats: count deferred split events

Count how many times we put a THP in split queue.  Currently, it happens
on partial unmap of a THP.

Rapidly growing value can indicate that an application behaves unfriendly
wrt THP: often fault in huge page and then unmap part of it.  This leads
to unnecessary memory fragmentation and the application may require
tuning.

The event also can help with debugging kernel [mis-]behaviour.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    5 +++++
 include/linux/vm_event_item.h  |    1 +
 mm/huge_memory.c               |    1 +
 mm/vmstat.c                    |    1 +
 4 files changed, 8 insertions(+)

diff -puN Documentation/vm/transhuge.txt~thp-vmstats-count-deferred-split-events Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-vmstats-count-deferred-split-events
+++ a/Documentation/vm/transhuge.txt
@@ -229,6 +229,11 @@ thp_split_page is incremented every time
 thp_split_page_failed is is incremented if kernel fails to split huge
 	page. This can happen if the page was pinned by somebody.
 
+thp_deferred_split_page is incremented when a huge page is put onto split
+	queue. This happens when a huge page is partially unmapped and
+	splitting it would free up some memory. Pages on split queue are
+	going to be split under memory pressure.
+
 thp_split_pmd is incremented every time a PMD split into table of PTEs.
 	This can happen, for instance, when application calls mprotect() or
 	munmap() on part of huge page. It doesn't split huge page, only
diff -puN include/linux/vm_event_item.h~thp-vmstats-count-deferred-split-events include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~thp-vmstats-count-deferred-split-events
+++ a/include/linux/vm_event_item.h
@@ -72,6 +72,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_COLLAPSE_ALLOC_FAILED,
 		THP_SPLIT_PAGE,
 		THP_SPLIT_PAGE_FAILED,
+		THP_DEFERRED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
diff -puN mm/huge_memory.c~thp-vmstats-count-deferred-split-events mm/huge_memory.c
--- a/mm/huge_memory.c~thp-vmstats-count-deferred-split-events
+++ a/mm/huge_memory.c
@@ -3455,6 +3455,7 @@ void deferred_split_huge_page(struct pag
 
 	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
+		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		list_add_tail(page_deferred_list(page), &pgdata->split_queue);
 		pgdata->split_queue_len++;
 	}
diff -puN mm/vmstat.c~thp-vmstats-count-deferred-split-events mm/vmstat.c
--- a/mm/vmstat.c~thp-vmstats-count-deferred-split-events
+++ a/mm/vmstat.c
@@ -848,6 +848,7 @@ const char * const vmstat_text[] = {
 	"thp_collapse_alloc_failed",
 	"thp_split_page",
 	"thp_split_page_failed",
+	"thp_deferred_split_page",
 	"thp_split_pmd",
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

