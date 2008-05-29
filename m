From: akpm@linux-foundation.org
Subject: + hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch added to -mm tree
Date: Wed, 28 May 2008 18:43:35 -0700
Message-ID: <200805290143.m4T1hZ8N010532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbYE2Bo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 21:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, agl@us.ibm.com, apw@shadowen.org, hannes@saeurebad.de, hugh@veritas.com, wli@holomorphy.com


The patch titled
     hugetlb: fix prio tree lookup
has been added to the -mm tree.  Its filename is
     hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch

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
Subject: hugetlb: fix prio tree lookup
From: Mel Gorman <mel@csn.ul.ie>

I spoke too soon. This is a fix to patch 3/3.

If a child unmaps the start of the VMA, the start address is different and
that is perfectly legimite making the BUG_ON check bogus and should be
removed.  While page cache lookups are in HPAGE_SIZE, the vma->vm_pgoff is
in PAGE_SIZE units, not HPAGE_SIZE.  The offset calculation needs to be in
PAGE_SIZE units to find other VMAs that are mapping the same range of
pages.  This patch fixes the offset calculation and adds an explanation
comment as to why it is different from a page cache lookup.

Credit goes to Johannes Weiner for spotting the bogus BUG_ON on IRC which
led to the discovery of the faulty offset calculation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix
+++ a/mm/hugetlb.c
@@ -1035,14 +1035,18 @@ int unmap_ref_private(struct mm_struct *
 {
 	struct vm_area_struct *iter_vma;
 	struct address_space *mapping;
-	pgoff_t pgoff = ((address - vma->vm_start) >> HPAGE_SHIFT)
-		+ (vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
 	struct prio_tree_iter iter;
+	pgoff_t pgoff;
 
+	/*
+	 * vm_pgoff is in PAGE_SIZE units, hence the different calculation
+	 * from page cache lookup which is in HPAGE_SIZE units.
+	 */
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
+		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
-	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
-		BUG_ON(vma->vm_start != iter_vma->vm_start);
 
+	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
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
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

