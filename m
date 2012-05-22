From: akpm@linux-foundation.org
Subject: + hugetlb-fix-resv_map-leak-in-error-path.patch added to -mm tree
Date: Tue, 22 May 2012 13:46:24 -0700
Message-ID: <20120522204624.B8BDBA0280@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:49406 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759969Ab2EVUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2012 16:46:27 -0400
Received: by lagr15 with SMTP id r15so381122lag.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 13:46:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, aarcange@redhat.com, cl@linux.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: hugetlb: fix resv_map leak in error path
has been added to the -mm tree.  Its filename is
     hugetlb-fix-resv_map-leak-in-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Christoph Lameter <cl@linux.com>
Tested-by: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-resv_map-leak-in-error-path mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-resv_map-leak-in-error-path
+++ a/mm/hugetlb.c
@@ -2223,6 +2223,15 @@ static void hugetlb_vm_op_open(struct vm
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
@@ -2239,7 +2248,7 @@ static void hugetlb_vm_op_close(struct v
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
 
-		kref_put(&reservations->refs, resv_map_release);
+		resv_map_put(vma);
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
@@ -3075,12 +3084,16 @@ int hugetlb_reserve_pages(struct inode *
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
@@ -3089,7 +3102,7 @@ int hugetlb_reserve_pages(struct inode *
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugepage_subpool_put_pages(spool, chg);
-		return ret;
+		goto out_err;
 	}
 
 	/*
@@ -3106,6 +3119,9 @@ int hugetlb_reserve_pages(struct inode *
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
+out_err:
+	resv_map_put(vma);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
_
Subject: Subject: hugetlb: fix resv_map leak in error path

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

hugetlb-fix-resv_map-leak-in-error-path.patch

