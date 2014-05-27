From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison.patch removed from -mm tree
Date: Tue, 27 May 2014 13:22:23 -0700
Message-ID: <5384f3ff.bPzZKrL1ER6USSt6%akpm__46452.3808136166$1401222156$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaE0UWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:23 -0700


The patch titled
     Subject: mm/memory-failure.c: fix memory leak by race between poison and unpoison
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: fix memory leak by race between poison and unpoison

When a memory error happens on an in-use page or (free and in-use)
hugepage, the victim page is isolated with its refcount set to one.  When
you try to unpoison it later, unpoison_memory() calls put_page() for it
twice in order to bring the page back to free page pool (buddy or free
hugepage list.) However, if another memory error occurs on the page which
we are unpoisoning, memory_failure() returns without releasing the
refcount which was incremented in the same call at first, which results in
memory leak and unconsistent num_poisoned_pages statistics.  This patch
fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: <stable@vger.kernel.org>    [2.6.32+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-memory-leak-by-race-between-poison-and-unpoison
+++ a/mm/memory-failure.c
@@ -1153,6 +1153,8 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (!PageHWPoison(p)) {
 		printk(KERN_ERR "MCE %#lx: just unpoisoned\n", pfn);
+		atomic_long_sub(nr_pages, &num_poisoned_pages);
+		put_page(hpage);
 		res = 0;
 		goto out;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
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
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

