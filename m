From: akpm@linux-foundation.org
Subject: [merged] hugetlb-chg-cannot-become-less-than-0.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:22 -0700
Message-ID: <200904011838.n31IcMb1008238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933548AbZDASnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, agl@us.ibm.com, apw@shadowen.org, hannes@saeurebad.de, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     hugetlb: chg cannot become less than 0
has been removed from the -mm tree.  Its filename was
     hugetlb-chg-cannot-become-less-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: chg cannot become less than 0
From: Roel Kluin <roel.kluin@gmail.com>

chg is unsigned, so it cannot be less than 0.

Also, since region_chg returns long, let vma_needs_reservation() forward
this to alloc_huge_page().  Store it as long as well.  all callers cast it
to long anyway.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-chg-cannot-become-less-than-0 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-chg-cannot-become-less-than-0
+++ a/mm/hugetlb.c
@@ -918,7 +918,7 @@ static void return_unused_surplus_pages(
  * an instantiated the change should be committed via vma_commit_reservation.
  * No action is required on failure.
  */
-static int vma_needs_reservation(struct hstate *h,
+static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -933,7 +933,7 @@ static int vma_needs_reservation(struct 
 		return 1;
 
 	} else  {
-		int err;
+		long err;
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
@@ -969,7 +969,7 @@ static struct page *alloc_huge_page(stru
 	struct page *page;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned int chg;
+	long chg;
 
 	/*
 	 * Processes that did not create the mapping will have no reserves and
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

