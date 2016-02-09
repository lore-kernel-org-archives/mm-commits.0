From: akpm@linux-foundation.org
Subject: + thp-vmstats-count-deferred-split-events.patch added to -mm tree
Date: Tue, 09 Feb 2016 13:20:42 -0800
Message-ID: <56ba582a.UFbyuqckp+orGz61%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcBIVUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 16:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, vmstats: count deferred split events
has been added to the -mm tree.  Its filename is
     thp-vmstats-count-deferred-split-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-vmstats-count-deferred-split-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-vmstats-count-deferred-split-events.patch

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
Subject: thp, vmstats: count deferred split events

Counts how many times we put a THP in split queue. Currently, it happens
on partial unmap of a THP.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 +
 mm/huge_memory.c              |    1 +
 mm/vmstat.c                   |    1 +
 3 files changed, 3 insertions(+)

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
@@ -3452,6 +3452,7 @@ void deferred_split_huge_page(struct pag
 
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

mm-dax-check-for-pmd_none-after-split_huge_pmd.patch
ipc-shm-handle-removed-segments-gracefully-in-shm_mmap.patch
thp-cleanup-split_huge_page.patch
thp-vmstats-count-deferred-split-events.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

