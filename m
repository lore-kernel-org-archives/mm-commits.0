From: akpm@linux-foundation.org
Subject: [patch 085/127] mm/hugetlb: fix memory offline with hugepage size > memory block size
Date: Fri, 07 Oct 2016 17:01:07 -0700
Message-ID: <57f83743.A6SMFg7rAUqI2/lW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39407 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbcJHABI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gerald.schaefer@de.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rui.teng@linux.vnet.ibm.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, vbabka@suse.cz

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: fix memory offline with hugepage size > memory block size

Patch series "mm/hugetlb: memory offline issues with hugepages", v4.

This addresses several issues with hugepages and memory offline. While
the first patch fixes a panic, and is therefore rather important, the
last patch is just a performance optimization.

The second patch fixes a theoretical issue with reserved hugepages,
while still leaving some ugly usability issue, see description.


This patch (of 3):

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
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
