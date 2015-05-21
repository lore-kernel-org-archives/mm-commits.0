From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
 added to -mm tree
Date: Thu, 21 May 2015 16:36:39 -0700
Message-ID: <555e6c07.thJvniIB26EYEQvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbbEUXgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 19:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: compute/return the number of regions added by region_add()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: compute/return the number of regions added by region_add()

Modify region_add() to keep track of regions(pages) added to the reserve
map and return this value.  The return value can be compared to the return
value of region_chg() to determine if the map was modified between calls. 
Make vma_commit_reservation() also pass along the return value of
region_add().  The special case return values of vma_needs_reservation()
should also be taken into account when determining the return value of
vma_commit_reservation().

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add
+++ a/mm/hugetlb.c
@@ -230,6 +230,7 @@ static long region_add(struct resv_map *
 {
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
+	long chg = 0;
 
 	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
@@ -255,14 +256,17 @@ static long region_add(struct resv_map *
 		if (rg->to > t)
 			t = rg->to;
 		if (rg != nrg) {
+			chg -= (rg->to - rg->from);
 			list_del(&rg->link);
 			kfree(rg);
 		}
 	}
+	chg += (nrg->from - f);
 	nrg->from = f;
+	chg += t - nrg->to;
 	nrg->to = t;
 	spin_unlock(&resv->lock);
-	return 0;
+	return chg;
 }
 
 static long region_chg(struct resv_map *resv, long f, long t)
@@ -1450,18 +1454,25 @@ static long vma_needs_reservation(struct
 	else
 		return chg < 0 ? chg : 0;
 }
-static void vma_commit_reservation(struct hstate *h,
+
+static long vma_commit_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct resv_map *resv;
 	pgoff_t idx;
+	long add;
 
 	resv = vma_resv_map(vma);
 	if (!resv)
-		return;
+		return 1;
 
 	idx = vma_hugecache_offset(h, vma, addr);
-	region_add(resv, idx, idx + 1);
+	add = region_add(resv, idx, idx + 1);
+
+	if (vma->vm_flags & VM_MAYSHARE)
+		return add;
+	else
+		return 0;
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-fix.patch

