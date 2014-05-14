From: akpm@linux-foundation.org
Subject: + mm-memory-failurec-move-comment.patch added to -mm tree
Date: Wed, 14 May 2014 16:56:56 -0700
Message-ID: <537402c8.jEskD9EZXS1g8sM6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaENX45 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 19:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: + mm-memory-failurec-move-comment.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 16:56:56 -0700


The patch titled
     Subject: mm/memory-failure.c: move comment
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-move-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-move-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-move-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: move comment

The comment about pages under writeback is far from the relevant code, so
let's move it to the right place.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-move-comment mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-move-comment
+++ a/mm/memory-failure.c
@@ -1132,11 +1132,6 @@ int memory_failure(unsigned long pfn, in
 		}
 	}
 
-	/*
-	 * Lock the page and wait for writeback to finish.
-	 * It's very difficult to mess with pages currently under IO
-	 * and in many cases impossible, so we just avoid it here.
-	 */
 	lock_page(hpage);
 
 	/*
@@ -1186,6 +1181,10 @@ int memory_failure(unsigned long pfn, in
 	if (PageHuge(p))
 		set_page_hwpoison_huge_page(hpage);
 
+	/*
+	 * It's very difficult to mess with pages currently under IO
+	 * and in many cases impossible, so we just avoid it here.
+	 */
 	wait_on_page_writeback(p);
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwposion-hugetlb-lock_page-unlock_page-does-not-match-for-handling-a-free-hugepage.patch
mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-memory-failurec-move-comment.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

