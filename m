From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-resv_map-leak-in-error-path.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:17 -0700
Message-ID: <20120531191617.84405A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37109 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952Ab2EaTQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:19 -0400
Received: by wibhn6 with SMTP id hn6so76973wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, aarcange@redhat.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix resv_map leak in error path
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-resv_map-leak-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: hugetlb: fix resv_map leak in error path

When called for anonymous (non-shared) mappings, hugetlb_reserve_pages()
does a resv_map_alloc().  It depends on code in hugetlbfs's
vm_ops->close() to release that allocation.

However, in the mmap() failure path, we do a plain unmap_region() without
the remove_vma() which actually calls vm_ops->close().

This is a decent fix.  This leak could get reintroduced if new code (say,
after hugetlb_reserve_pages() in hugetlbfs_file_mmap()) decides to return
an error.  But, I think it would have to unroll the reservation anyway.

Christoph's test case:

	http://marc.info/?l=linux-mm&m=133728900729735

This patch applies to 3.4 and later.  A version for earlier kernels is at
https://lkml.org/lkml/2012/5/22/418.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Christoph Lameter <cl@linux.com>
Tested-by: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>	[2.6.32+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-resv_map-leak-in-error-path mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-resv_map-leak-in-error-path
+++ a/mm/hugetlb.c
@@ -2157,6 +2157,15 @@ static void hugetlb_vm_op_open(struct vm
 		kref_get(&reservations->refs);
 }
 
+static void resv_map_put(struct vm_area_struct *vma)
+{
+	struct resv_map *reservations = vma_resv_map(vma);
+
+	if (!reservations)
+		return;
+	kref_put(&reservations->refs, resv_map_release);
+}
+
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 {
 	struct hstate *h = hstate_vma(vma);
@@ -2173,7 +2182,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
 
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -2991,12 +3000,16 @@ int hugetlb_reserve_pages(struct inode *
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
-		return chg;
+	if (chg < 0) {
+		ret = chg;
+		goto out_err;
+	}
 
 	/* There must be enough pages in the subpool for the mapping */
-	if (hugepage_subpool_get_pages(spool, chg))
-		return -ENOSPC;
+	if (hugepage_subpool_get_pages(spool, chg)) {
+		ret = -ENOSPC;
+		goto out_err;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
@@ -3005,7 +3018,7 @@ int hugetlb_reserve_pages(struct inode *
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugepage_subpool_put_pages(spool, chg);
-		return ret;
+		goto out_err;
 	}
 
 	/*
@@ -3022,6 +3035,9 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	resv_map_put(vma);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch

