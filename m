From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2.patch added to -mm tree
Date: Tue, 26 May 2015 15:23:19 -0700
Message-ID: <5564f257.xvQ917H4V3Kb4ua1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbbEZWXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 May 2015 18:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: compute/return the number of regions added by region_add()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2.patch

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

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  129 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 93 insertions(+), 36 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2
+++ a/mm/hugetlb.c
@@ -217,8 +217,16 @@ static inline struct hugepage_subpool *s
  * Region tracking -- allows tracking of reservations and instantiated pages
  *                    across the pages in a mapping.
  *
- * The region data structures are embedded into a resv_map and
- * protected by a resv_map's lock
+ * The region data structures are embedded into a resv_map and protected
+ * by a resv_map's lock.  The set of regions within the resv_map represent
+ * reservations for huge pages, or huge pages that have already been
+ * instantiated within the map.  The from and to elements are huge page
+ * indicies into the associated mapping.  from indicates the starting index
+ * of the region.  to represents the first index past the end of  the region.
+ * For example, a file region structure with from == 0 and to == 4 represents
+ * four huge pages in a mapping.  It is important to note that the to element
+ * represents the first element past the end of the region. This is used in
+ * arithmetic as 4(to) - 0(from) = 4 huge pages in the region.
  */
 struct file_region {
 	struct list_head link;
@@ -226,11 +234,23 @@ struct file_region {
 	long to;
 };
 
+/*
+ * Add the huge page range represented by indicies f (from)
+ * and t (to) to the reserve map.  Existing regions will be
+ * expanded to accommodate the specified range.  We know only
+ * existing regions need to be expanded, because region_add
+ * is only called after region_chg(with the same range).  If
+ * a new file_region structure must be allocated, it is done
+ * in region_chg.
+ *
+ * Return the number of new huge pages added to the map.  This
+ * number is greater than or equal to zero.
+ */
 static long region_add(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
-	long chg = 0;
+	long add = 0;
 
 	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
@@ -256,19 +276,44 @@ static long region_add(struct resv_map *
 		if (rg->to > t)
 			t = rg->to;
 		if (rg != nrg) {
-			chg -= (rg->to - rg->from);
+			/* Decrement return value by the deleted range.
+			 * Another range will span this area so that by
+			 * end of routine add will be >= zero
+			 */
+			add -= (rg->to - rg->from);
 			list_del(&rg->link);
 			kfree(rg);
 		}
 	}
-	chg += (nrg->from - f);
+
+	add += (nrg->from - f);		/* Added to beginning of region */
 	nrg->from = f;
-	chg += t - nrg->to;
+	add += t - nrg->to;		/* Added to end of region */
 	nrg->to = t;
+
 	spin_unlock(&resv->lock);
-	return chg;
+	return add;
 }
 
+/*
+ * Examine the existing reserve map and determine how many
+ * huge pages in the specified range (f, t) are NOT currently
+ * represented.  This routine is called before a subsequent
+ * call to region_add that will actually modify the reserve
+ * map to add the specified range (f, t).  region_chg does
+ * not change the number of huge pages represented by the
+ * map.  However, if the existing regions in the map can not
+ * be expanded to represent the new range, a new file_region
+ * structure is added to the map as a placeholder.  This is
+ * so that the subsequent region_add call will have all
+ * regions it needs and will not fail.
+ *
+ * Returns the number of huge pages that need to be added
+ * to the existing reservation map for the range (f, t).
+ * This number is greater or equal to zero.  -ENOMEM is
+ * returned if a new  file_region structure can not be
+ * allocated.
+ */
 static long region_chg(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
@@ -335,6 +380,11 @@ out_nrg:
 	return chg;
 }
 
+/*
+ * Truncate the reserve map at index 'end'.  Modify/truncate any
+ * region which contains end.  Delete any regions past end.
+ * Return the number of huge pages removed from the map.
+ */
 static long region_truncate(struct resv_map *resv, long end)
 {
 	struct list_head *head = &resv->regions;
@@ -370,6 +420,10 @@ out:
 	return chg;
 }
 
+/*
+ * Count and return the number of huge pages in the reserve map
+ * that intersect with the range (f, t).
+ */
 static long region_count(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
@@ -1426,53 +1480,56 @@ static void return_unused_surplus_pages(
 }
 
 /*
- * Determine if the huge page at addr within the vma has an associated
- * reservation.  Where it does not we will need to logically increase
- * reservation and actually increase subpool usage before an allocation
- * can occur.  Where any new reservation would be required the
- * reservation change is prepared, but not committed.  Once the page
- * has been allocated from the subpool and instantiated the change should
- * be committed via vma_commit_reservation.  No action is required on
- * failure.
+ * vma_needs_reservation and vma_commit_reservation are used by the huge
+ * page allocation routines to manage reservations.
+ *
+ * vma_needs_reservation is called to determine if the huge page at addr
+ * within the vma has an associated reservation.  If a reservation is
+ * needed, the value 1 is returned.  The caller is then responsible for
+ * managing the global reservation and subpool usage counts.  After
+ * the huge page has been allocated, vma_commit_reservation is called
+ * to add the page to the reservation map.
+ *
+ * In the normal case, vma_commit_reservation should return the same value
+ * as the preceding vma_needs_reservation call.  The only time this is
+ * not the case is if a reserve map was changed between calls.  It is the
+ * responsibility of the caller to notice the difference and take appropriate
+ * action.
  */
-static long vma_needs_reservation(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long addr)
+static long __vma_reservation_common(struct hstate *h,
+				struct vm_area_struct *vma, unsigned long addr,
+				bool needs)
 {
 	struct resv_map *resv;
 	pgoff_t idx;
-	long chg;
+	long ret;
 
 	resv = vma_resv_map(vma);
 	if (!resv)
 		return 1;
 
 	idx = vma_hugecache_offset(h, vma, addr);
-	chg = region_chg(resv, idx, idx + 1);
+	if (needs)
+		ret = region_chg(resv, idx, idx + 1);
+	else
+		ret = region_add(resv, idx, idx + 1);
 
 	if (vma->vm_flags & VM_MAYSHARE)
-		return chg;
+		return ret;
 	else
-		return chg < 0 ? chg : 0;
+		return ret < 0 ? ret : 0;
 }
 
-static long vma_commit_reservation(struct hstate *h,
+static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	struct resv_map *resv;
-	pgoff_t idx;
-	long add;
-
-	resv = vma_resv_map(vma);
-	if (!resv)
-		return 1;
-
-	idx = vma_hugecache_offset(h, vma, addr);
-	add = region_add(resv, idx, idx + 1);
+	return __vma_reservation_common(h, vma, addr, (bool)1);
+}
 
-	if (vma->vm_flags & VM_MAYSHARE)
-		return add;
-	else
-		return 0;
+static long vma_commit_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	return __vma_reservation_common(h, vma, addr, (bool)0);
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add-v2.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v2.patch

