From: akpm@linux-foundation.org
Subject: + hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:04 -0700
Message-ID: <200807111845.m6BIji8L030972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbYGKSq2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, agl@us.ibm.com, apw@shadowen.org


The patch titled
     hugetlb: fix a hugepage reservation check for MAP_SHARED
has been added to the -mm tree.  Its filename is
     hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Andy Whitcroft <apw@shadowen.org>
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

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

