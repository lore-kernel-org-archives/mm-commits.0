From: akpm@linux-foundation.org
Subject: - hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:40 -0700
Message-ID: <200807242323.m6ONNeFw010700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbYGXXXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, agl@us.ibm.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix a hugepage reservation check for MAP_SHARED
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix a hugepage reservation check for MAP_SHARED
From: Mel Gorman <mel@csn.ul.ie>

When removing a huge page from the hugepage pool for a fault the system checks
to see if the mapping requires additional pages to be reserved, and if it does
whether there are any unreserved pages remaining.  If not, the allocation
fails without even attempting to get a page.  In order to determine whether to
apply this check we call vma_has_private_reserves() which tells us if this vma
is MAP_PRIVATE and is the owner.  This incorrectly triggers the remaining
reservation test for MAP_SHARED mappings which prevents allocation of the
final page in the pool even though it is reserved for this mapping.

In reality we only want to check this for MAP_PRIVATE mappings where the
process is not the original mapper.  Replace vma_has_private_reserves() with
vma_has_reserves() which indicates whether further reserves are required, and
update the caller.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-a-hugepage-reservation-check-for-map_shared mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-a-hugepage-reservation-check-for-map_shared
+++ a/mm/hugetlb.c
@@ -342,13 +342,13 @@ void reset_vma_resv_huge_pages(struct vm
 }
 
 /* Returns true if the VMA has associated reserve pages */
-static int vma_has_private_reserves(struct vm_area_struct *vma)
+static int vma_has_reserves(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_SHARED)
-		return 0;
-	if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER))
-		return 0;
-	return 1;
+		return 1;
+	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
+		return 1;
+	return 0;
 }
 
 static void clear_huge_page(struct page *page,
@@ -420,7 +420,7 @@ static struct page *dequeue_huge_page_vm
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_private_reserves(vma) &&
+	if (!vma_has_reserves(vma) &&
 			h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

