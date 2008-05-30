From: akpm@linux-foundation.org
Subject: + hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch added to -mm tree
Date: Fri, 30 May 2008 13:31:20 -0700
Message-ID: <200805302031.m4UKVK3e010052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbYE3Umi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 16:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, agl@us.ibm.com, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, mtk.manpages@googlemail.com, wli@holomorphy.com


The patch titled
     huge page MAP_NORESERVE review cleanups
has been added to the -mm tree.  Its filename is
     hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch

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
Subject: huge page MAP_NORESERVE review cleanups
From: Andy Whitcroft <apw@shadowen.org>

Use the new encapsulated huge page offset helper.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups
+++ a/mm/hugetlb.c
@@ -734,8 +734,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -753,8 +752,7 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 	}
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
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
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
page-owner-tracking-leak-detector.patch

