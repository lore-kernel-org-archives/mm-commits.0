From: akpm@linux-foundation.org
Subject: + thp-consolidate-assert-checks-in-__split_huge_page.patch added
 to -mm tree
Date: Wed, 16 Apr 2014 13:59:13 -0700
Message-ID: <534eef21.Xl80pA6l+CXd0BFL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaDPU7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 16:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-consolidate-assert-checks-in-__split_huge_page.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 13:59:13 -0700


The patch titled
     Subject: thp: consolidate assert checks in __split_huge_page()
has been added to the -mm tree.  Its filename is
     thp-consolidate-assert-checks-in-__split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-consolidate-assert-checks-in-__split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-consolidate-assert-checks-in-__split_huge_page.patch

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

thp-close-race-between-split-and-zap-huge-pages.patch
pagewalk-update-page-table-walker-core.patch
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
thp-consolidate-assert-checks-in-__split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

