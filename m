From: akpm@linux-foundation.org
Subject: [merged] thp-consolidate-assert-checks-in-__split_huge_page.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:49:15 -0700
Message-ID: <5390c9bb.y2huMGmsxteWiHPE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaFETtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-consolidate-assert-checks-in-__split_huge_page.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:15 -0700


The patch titled
     Subject: thp: consolidate assert checks in __split_huge_page()
has been removed from the -mm tree.  Its filename was
     thp-consolidate-assert-checks-in-__split_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: consolidate assert checks in __split_huge_page()

It doesn't make sense to have two assert checks for each invariant: one
for printing and one for BUG().

Let's trigger BUG() if we print error message.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-consolidate-assert-checks-in-__split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-consolidate-assert-checks-in-__split_huge_page
+++ a/mm/huge_memory.c
@@ -1830,10 +1830,11 @@ static void __split_huge_page(struct pag
 	 * the newly established pmd of the child later during the
 	 * walk, to be able to set it as pmd_trans_splitting too.
 	 */
-	if (mapcount != page_mapcount(page))
+	if (mapcount != page_mapcount(page)) {
 		printk(KERN_ERR "mapcount %d page_mapcount %d\n",
 		       mapcount, page_mapcount(page));
-	BUG_ON(mapcount != page_mapcount(page));
+		BUG();
+	}
 
 	__split_huge_page_refcount(page, list);
 
@@ -1844,10 +1845,11 @@ static void __split_huge_page(struct pag
 		BUG_ON(is_vma_temporary_stack(vma));
 		mapcount2 += __split_huge_page_map(page, vma, addr);
 	}
-	if (mapcount != mapcount2)
+	if (mapcount != mapcount2) {
 		printk(KERN_ERR "mapcount %d mapcount2 %d page_mapcount %d\n",
 		       mapcount, mapcount2, page_mapcount(page));
-	BUG_ON(mapcount != mapcount2);
+		BUG();
+	}
 }
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

