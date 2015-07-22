From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch added to -mm tree
Date: Wed, 22 Jul 2015 15:07:16 -0700
Message-ID: <55b01414.L900nl9JVAQF7dhW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbbGVWHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add region_del() to delete a specific range of entries
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch

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
Subject: mm/hugetlb: add region_del() to delete a specific range of entries

fallocate hole punch will want to remove a specific range of pages.  The
existing region_truncate() routine deletes all region/reserve map entries
after a specified offset.  region_del() will provide this same
functionality if the end of region is specified as LONG_MAX.  Hence,
region_del() can replace region_truncate().

Unlike region_truncate(), region_del() can return an error in the rare
case where it can not allocate memory for a region descriptor.  This ONLY
happens in the case where an existing region must be split.  Current
callers passing LONG_MAX as end of range will never experience this error
and do not need to deal with error handling.  Future callers of
region_del() (such as fallocate hole punch) will need to handle this
error.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  122 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 37 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries
+++ a/mm/hugetlb.c
@@ -460,43 +460,90 @@ static void region_abort(struct resv_map
 }
 
 /*
- * Truncate the reserve map at index 'end'.  Modify/truncate any
- * region which contains end.  Delete any regions past end.
- * Return the number of huge pages removed from the map.
+ * Delete the specified range [f, t) from the reserve map.  If the
+ * t parameter is LONG_MAX, this indicates that ALL regions after f
+ * should be deleted.  Locate the regions which intersect [f, t)
+ * and either trim, delete or split the existing regions.
+ *
+ * Returns the number of huge pages deleted from the reserve map.
+ * In the normal case, the return value is zero or more.  In the
+ * case where a region must be split, a new region descriptor must
+ * be allocated.  If the allocation fails, -ENOMEM will be returned.
+ * NOTE: If the parameter t == LONG_MAX, then we will never split
+ * a region and possibly return -ENOMEM.  Callers specifying
+ * t == LONG_MAX do not need to check for -ENOMEM error.
  */
-static long region_truncate(struct resv_map *resv, long end)
+static long region_del(struct resv_map *resv, long f, long t)
 {
 	struct list_head *head = &resv->regions;
 	struct file_region *rg, *trg;
-	long chg = 0;
+	struct file_region *nrg = NULL;
+	long del = 0;
 
+retry:
 	spin_lock(&resv->lock);
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (end <= rg->to)
+	list_for_each_entry_safe(rg, trg, head, link) {
+		if (rg->to <= f)
+			continue;
+		if (rg->from >= t)
 			break;
-	if (&rg->link == head)
-		goto out;
 
-	/* If we are in the middle of a region then adjust it. */
-	if (end > rg->from) {
-		chg = rg->to - end;
-		rg->to = end;
-		rg = list_entry(rg->link.next, typeof(*rg), link);
-	}
+		if (f > rg->from && t < rg->to) { /* Must split region */
+			/*
+			 * Check for an entry in the cache before dropping
+			 * lock and attempting allocation.
+			 */
+			if (!nrg &&
+			    resv->region_cache_count > resv->adds_in_progress) {
+				nrg = list_first_entry(&resv->region_cache,
+							struct file_region,
+							link);
+				list_del(&nrg->link);
+				resv->region_cache_count--;
+			}
+
+			if (!nrg) {
+				spin_unlock(&resv->lock);
+				nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
+				if (!nrg)
+					return -ENOMEM;
+				goto retry;
+			}
 
-	/* Drop any remaining regions. */
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
+			del += t - f;
+
+			/* New entry for end of split region */
+			nrg->from = t;
+			nrg->to = rg->to;
+			INIT_LIST_HEAD(&nrg->link);
+
+			/* Original entry is trimmed */
+			rg->to = f;
+
+			list_add(&nrg->link, &rg->link);
+			nrg = NULL;
 			break;
-		chg += rg->to - rg->from;
-		list_del(&rg->link);
-		kfree(rg);
+		}
+
+		if (f <= rg->from && t >= rg->to) { /* Remove entire region */
+			del += rg->to - rg->from;
+			list_del(&rg->link);
+			kfree(rg);
+			continue;
+		}
+
+		if (f <= rg->from) {	/* Trim beginning of region */
+			del += t - rg->from;
+			rg->from = t;
+		} else {		/* Trim end of region */
+			del += rg->to - f;
+			rg->to = f;
+		}
 	}
 
-out:
 	spin_unlock(&resv->lock);
-	return chg;
+	kfree(nrg);
+	return del;
 }
 
 /*
@@ -647,7 +694,7 @@ void resv_map_release(struct kref *ref)
 	struct file_region *rg, *trg;
 
 	/* Clear out any active regions before we release the map. */
-	region_truncate(resv_map, 0);
+	region_del(resv_map, 0, LONG_MAX);
 
 	/* ... and any entries left in the cache */
 	list_for_each_entry_safe(rg, trg, head, link) {
@@ -1572,7 +1619,7 @@ static void return_unused_surplus_pages(
 
 
 /*
- * vma_needs_reservation, vma_commit_reservation and vma_abort_reservation
+ * vma_needs_reservation, vma_commit_reservation and vma_end_reservation
  * are used by the huge page allocation routines to manage reservations.
  *
  * vma_needs_reservation is called to determine if the huge page at addr
@@ -1580,8 +1627,9 @@ static void return_unused_surplus_pages(
  * needed, the value 1 is returned.  The caller is then responsible for
  * managing the global reservation and subpool usage counts.  After
  * the huge page has been allocated, vma_commit_reservation is called
- * to add the page to the reservation map.  If the reservation must be
- * aborted instead of committed, vma_abort_reservation is called.
+ * to add the page to the reservation map.  If the page allocation fails,
+ * the reservation must be ended instead of committed.  vma_end_reservation
+ * is called in such cases.
  *
  * In the normal case, vma_commit_reservation returns the same value
  * as the preceding vma_needs_reservation call.  The only time this
@@ -1592,7 +1640,7 @@ static void return_unused_surplus_pages(
 enum vma_resv_mode {
 	VMA_NEEDS_RESV,
 	VMA_COMMIT_RESV,
-	VMA_ABORT_RESV,
+	VMA_END_RESV,
 };
 static long __vma_reservation_common(struct hstate *h,
 				struct vm_area_struct *vma, unsigned long addr,
@@ -1614,7 +1662,7 @@ static long __vma_reservation_common(str
 	case VMA_COMMIT_RESV:
 		ret = region_add(resv, idx, idx + 1);
 		break;
-	case VMA_ABORT_RESV:
+	case VMA_END_RESV:
 		region_abort(resv, idx, idx + 1);
 		ret = 0;
 		break;
@@ -1640,10 +1688,10 @@ static long vma_commit_reservation(struc
 	return __vma_reservation_common(h, vma, addr, VMA_COMMIT_RESV);
 }
 
-static void vma_abort_reservation(struct hstate *h,
+static void vma_end_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	(void)__vma_reservation_common(h, vma, addr, VMA_ABORT_RESV);
+	(void)__vma_reservation_common(h, vma, addr, VMA_END_RESV);
 }
 
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
@@ -1670,7 +1718,7 @@ static struct page *alloc_huge_page(stru
 		return ERR_PTR(-ENOMEM);
 	if (chg || avoid_reserve)
 		if (hugepage_subpool_get_pages(spool, 1) < 0) {
-			vma_abort_reservation(h, vma, addr);
+			vma_end_reservation(h, vma, addr);
 			return ERR_PTR(-ENOSPC);
 		}
 
@@ -1718,7 +1766,7 @@ out_uncharge_cgroup:
 out_subpool_put:
 	if (chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
-	vma_abort_reservation(h, vma, addr);
+	vma_end_reservation(h, vma, addr);
 	return ERR_PTR(-ENOSPC);
 }
 
@@ -3365,7 +3413,7 @@ retry:
 			goto backout_unlocked;
 		}
 		/* Just decrements count, does not deallocate */
-		vma_abort_reservation(h, vma, address);
+		vma_end_reservation(h, vma, address);
 	}
 
 	ptl = huge_pte_lockptr(h, mm, ptep);
@@ -3514,7 +3562,7 @@ int hugetlb_fault(struct mm_struct *mm,
 			goto out_mutex;
 		}
 		/* Just decrements count, does not deallocate */
-		vma_abort_reservation(h, vma, address);
+		vma_end_reservation(h, vma, address);
 
 		if (!(vma->vm_flags & VM_MAYSHARE))
 			pagecache_page = hugetlbfs_pagecache_page(h,
@@ -3870,7 +3918,7 @@ void hugetlb_unreserve_pages(struct inod
 	long gbl_reserve;
 
 	if (resv_map)
-		chg = region_truncate(resv_map, offset);
+		chg = region_del(resv_map, offset, LONG_MAX);
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch

