From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch
 added to -mm tree
Date: Mon, 26 Sep 2016 15:41:59 -0700
Message-ID: <57e9a437.uRCtc1NCwkraal6d%akpm__2484.24001406438$1474929737$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757713AbcIZWmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 18:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rui.teng@linux.vnet.ibm.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix memory offline with hugepage size > memory block size
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: fix memory offline with hugepage size > memory block size

dissolve_free_huge_pages() will either run into the VM_BUG_ON() or a list
corruption and addressing exception when trying to set a memory block
offline that is part (but not the first part) of a "gigantic" hugetlb page
with a size > memory block size.

When no other smaller hugetlb page sizes are present, the VM_BUG_ON() will
trigger directly.  In the other case we will run into an addressing
exception later, because dissolve_free_huge_page() will not work on the
head page of the compound hugetlb page which will result in a NULL hstate
from page_hstate().

To fix this, first remove the VM_BUG_ON() because it is wrong, and then
use the compound head page in dissolve_free_huge_page().  This means that
an unused pre-allocated gigantic page that has any part of itself inside
the memory block that is going offline will be dissolved completely. 
Losing an unused gigantic hugepage is preferable to failing the memory
offline, for example in the situation where a (possibly faulty) memory
DIMM needs to go offline.

Fixes: c8721bbb ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Link: http://lkml.kernel.org/r/20160926172811.94033-2-gerald.schaefer@de.ibm.com
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rui Teng <rui.teng@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size
+++ a/mm/hugetlb.c
@@ -1443,13 +1443,14 @@ static void dissolve_free_huge_page(stru
 {
 	spin_lock(&hugetlb_lock);
 	if (PageHuge(page) && !page_count(page)) {
-		struct hstate *h = page_hstate(page);
-		int nid = page_to_nid(page);
-		list_del(&page->lru);
+		struct page *head = compound_head(page);
+		struct hstate *h = page_hstate(head);
+		int nid = page_to_nid(head);
+		list_del(&head->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 		h->max_huge_pages--;
-		update_and_free_page(h, page);
+		update_and_free_page(h, head);
 	}
 	spin_unlock(&hugetlb_lock);
 }
@@ -1457,7 +1458,8 @@ static void dissolve_free_huge_page(stru
 /*
  * Dissolve free hugepages in a given pfn range. Used by memory hotplug to
  * make specified memory blocks removable from the system.
- * Note that start_pfn should aligned with (minimum) hugepage size.
+ * Note that this will dissolve a free gigantic hugepage completely, if any
+ * part of it lies within the given range.
  */
 void dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1466,7 +1468,6 @@ void dissolve_free_huge_pages(unsigned l
 	if (!hugepages_supported())
 		return;
 
-	VM_BUG_ON(!IS_ALIGNED(start_pfn, 1 << minimum_order));
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order)
 		dissolve_free_huge_page(pfn_to_page(pfn));
 }
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch
mm-hugetlb-check-for-reserved-hugepages-during-memory-offline.patch
mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch

