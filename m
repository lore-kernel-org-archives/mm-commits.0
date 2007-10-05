From: akpm@linux-foundation.org
Subject: + hugetlb-fix-pool-resizing-corner-case-v2.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:24:06 -0700
Message-ID: <200710052324.l95NO6aF030322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443AbXJEXYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     hugetlb: fix pool resizing corner case
has been added to the -mm tree.  Its filename is
     hugetlb-fix-pool-resizing-corner-case-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix pool resizing corner case
From: Adam Litke <agl@us.ibm.com>

When shrinking the size of the hugetlb pool via the nr_hugepages sysctl, we
are careful to keep enough pages around to satisfy reservations.  But the
calculation is flawed for the following scenario:

Action                          Pool Counters (Total, Free, Resv)
======                          =============
Set pool to 1 page              1 1 0
Map 1 page MAP_PRIVATE          1 1 0
Touch the page to fault it in   1 0 0
Set pool to 3 pages             3 2 0
Map 2 pages MAP_SHARED          3 2 2
Set pool to 2 pages             2 1 2 <-- Mistake, should be 3 2 2
Touch the 2 shared pages        2 0 1 <-- Program crashes here

The last touch above will terminate the process due to lack of huge pages.

This patch corrects the calculation so that it factors in pages being used
for private mappings.  Andrew, this is a standalone fix suitable for
mainline.  It is also now corrected in my latest dynamic pool resizing
patchset which I will send out soon.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Ken Chen <kenchen@google.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/hugetlb.c~hugetlb-fix-pool-resizing-corner-case-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-pool-resizing-corner-case-v2
+++ a/mm/hugetlb.c
@@ -403,14 +403,14 @@ static void try_to_free_low(unsigned lon
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
 		list_for_each_entry_safe(page, next, &hugepage_freelists[i], lru) {
+			if (count >= nr_huge_pages)
+				return;
 			if (PageHighMem(page))
 				continue;
 			list_del(&page->lru);
 			update_and_free_page(page);
 			free_huge_pages--;
 			free_huge_pages_node[page_to_nid(page)]--;
-			if (count >= nr_huge_pages)
-				return;
 		}
 	}
 }
@@ -450,8 +450,6 @@ static unsigned long set_max_huge_pages(
 			goto out;
 
 	}
-	if (count >= persistent_huge_pages)
-		goto out;
 
 	/*
 	 * Decrease the pool size
@@ -460,7 +458,8 @@ static unsigned long set_max_huge_pages(
 	 * pages into surplus state as needed so the pool will shrink
 	 * to the desired size as pages become free.
 	 */
-	min_count = max(count, resv_huge_pages);
+	min_count = resv_huge_pages + nr_huge_pages - free_huge_pages;
+	min_count = max(count, min_count);
 	try_to_free_low(min_count);
 	while (min_count < persistent_huge_pages) {
 		struct page *page = dequeue_huge_page(NULL, 0);
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
hugetlbfs-read-support-fix-2-fix.patch
hugetlb-fix-pool-resizing-corner-case-v2.patch
