From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:52 -0700
Message-ID: <5591acdc.9MWWHCqYup24eYDj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbbF2Uiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave@stgolabs.net, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: compute/return the number of regions added by region_add()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: compute/return the number of regions added by region_add()

Modify region_add() to keep track of regions(pages) added to the reserve
map and return this value.  The return value can be compared to the return
value of region_chg() to determine if the map was modified between calls.

Make vma_commit_reservation() also pass along the return value of
region_add().  In the normal case, we want vma_commit_reservation to
return the same value as the preceding call to vma_needs_reservation. 
Create a common __vma_reservation_common routine to help keep the special
case return values in sync

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   74 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add
+++ a/mm/hugetlb.c
@@ -245,11 +245,15 @@ struct file_region {
  * expanded, because region_add is only called after region_chg
  * with the same range.  If a new file_region structure must
  * be allocated, it is done in region_chg.
+ *
+ * Return the number of new huge pages added to the map.  This
+ * number is greater than or equal to zero.
  */
 static long region_add(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *nrg, *trg;
+	long add = 0;
 
 	spin_lock(&resv->lock);
 	/* Locate the region we are either in or before. */
@@ -275,14 +279,24 @@ static long region_add(struct resv_map *
 		if (rg->to > t)
 			t = rg->to;
 		if (rg != nrg) {
+			/* Decrement return value by the deleted range.
+			 * Another range will span this area so that by
+			 * end of routine add will be >= zero
+			 */
+			add -= (rg->to - rg->from);
 			list_del(&rg->link);
 			kfree(rg);
 		}
 	}
+
+	add += (nrg->from - f);		/* Added to beginning of region */
 	nrg->from = f;
+	add += t - nrg->to;		/* Added to end of region */
 	nrg->to = t;
+
 	spin_unlock(&resv->lock);
-	return 0;
+	VM_BUG_ON(add < 0);
+	return add;
 }
 
 /*
@@ -1470,46 +1484,56 @@ static void return_unused_surplus_pages(
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
- */
-static long vma_needs_reservation(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long addr)
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
+ * In the normal case, vma_commit_reservation returns the same value
+ * as the preceding vma_needs_reservation call.  The only time this
+ * is not the case is if a reserve map was changed between calls.  It
+ * is the responsibility of the caller to notice the difference and
+ * take appropriate action.
+ */
+static long __vma_reservation_common(struct hstate *h,
+				struct vm_area_struct *vma, unsigned long addr,
+				bool commit)
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
+	if (commit)
+		ret = region_add(resv, idx, idx + 1);
+	else
+		ret = region_chg(resv, idx, idx + 1);
 
 	if (vma->vm_flags & VM_MAYSHARE)
-		return chg;
+		return ret;
 	else
-		return chg < 0 ? chg : 0;
+		return ret < 0 ? ret : 0;
 }
-static void vma_commit_reservation(struct hstate *h,
+
+static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	struct resv_map *resv;
-	pgoff_t idx;
