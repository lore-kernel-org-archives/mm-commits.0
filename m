From: akpm@linux-foundation.org
Subject: [merged] mm-memory-failurec-move-comment.patch removed from -mm
 tree
Date: Thu, 05 Jun 2014 12:52:55 -0700
Message-ID: <5390ca97.QzEvSPXk5bKj3OsB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFETw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-memory-failurec-move-comment.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:55 -0700


The patch titled
     Subject: mm/memory-failure.c: move comment
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-move-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
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
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

