From: akpm@linux-foundation.org
Subject: + hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:41:11 -0700
Message-ID: <200710032141.l93LfBC9010056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597AbXJCVmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, bill.irwin@oracle.com, dave.mccracken@oracle.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com


The patch titled
     hugetlb: Try to grow hugetlb pool for MAP_SHARED mappings
has been added to the -mm tree.  Its filename is
     hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: Try to grow hugetlb pool for MAP_SHARED mappings
From: Adam Litke <agl@us.ibm.com>

Shared mappings require special handling because the huge pages needed to
fully populate the VMA must be reserved at mmap time.  If not enough pages are
available when making the reservation, allocate all of the shortfall at once
from the buddy allocator and add the pages directly to the hugetlb pool.  If
they cannot be allocated, then fail the mapping.  The page surplus is
accounted for in the same way as for private mappings; faulted surplus pages
will be freed at unmap time.  Reserved, surplus pages that have not been used
must be freed separately when their reservation has been released.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Dave McCracken <dave.mccracken@oracle.com>
Cc: William Irwin <bill.irwin@oracle.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/hugetlb.c~hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings
+++ a/mm/hugetlb.c
@@ -87,6 +87,8 @@ static struct page *dequeue_huge_page(st
 			list_del(&page->lru);
 			free_huge_pages--;
 			free_huge_pages_node[nid]--;
+			if (vma && vma->vm_flags & VM_MAYSHARE)
+				resv_huge_pages--;
 			break;
 		}
 	}
@@ -214,15 +216,116 @@ static struct page *alloc_buddy_huge_pag
 	return page;
 }
 
+/*
+ * Increase the hugetlb pool such that it can accomodate a reservation
+ * of size 'delta'.
+ */
+static int gather_surplus_pages(int delta)
+{
+	struct list_head surplus_list;
+	struct page *page, *tmp;
+	int ret, i;
+	int needed, allocated;
+
+	needed = (resv_huge_pages + delta) - free_huge_pages;
+	if (needed <= 0)
+		return 0;
+
+	allocated = 0;
+	INIT_LIST_HEAD(&surplus_list);
+
+	ret = -ENOMEM;
+retry:
+	spin_unlock(&hugetlb_lock);
+	for (i = 0; i < needed; i++) {
+		page = alloc_buddy_huge_page(NULL, 0);
+		if (!page) {
+			/*
+			 * We were not able to allocate enough pages to
+			 * satisfy the entire reservation so we free what
+			 * we've allocated so far.
+			 */
+			spin_lock(&hugetlb_lock);
+			needed = 0;
+			goto free;
+		}
+
+		list_add(&page->lru, &surplus_list);
+	}
+	allocated += needed;
+
+	/*
+	 * After retaking hugetlb_lock, we need to recalculate 'needed'
+	 * because either resv_huge_pages or free_huge_pages may have changed.
+	 */
+	spin_lock(&hugetlb_lock);
+	needed = (resv_huge_pages + delta) - (free_huge_pages + allocated);
+	if (needed > 0)
+		goto retry;
+
+	/*
+	 * The surplus_list now contains _at_least_ the number of extra pages
+	 * needed to accomodate the reservation.  Add the appropriate number
+	 * of pages to the hugetlb pool and free the extras back to the buddy
+	 * allocator.
+	 */
+	needed += allocated;
+	ret = 0;
+free:
+	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		list_del(&page->lru);
+		if ((--needed) >= 0)
+			enqueue_huge_page(page);
+		else
+			update_and_free_page(page);
+	}
+
+	return ret;
+}
+
+/*
+ * When releasing a hugetlb pool reservation, any surplus pages that were
+ * allocated to satisfy the reservation must be explicitly freed if they were
+ * never used.
+ */
+void return_unused_surplus_pages(unsigned long unused_resv_pages)
+{
+	static int nid = -1;
+	struct page *page;
+	unsigned long nr_pages;
+
+	nr_pages = min(unused_resv_pages, surplus_huge_pages);
+
+	while (nr_pages) {
+		nid = next_node(nid, node_online_map);
+		if (nid == MAX_NUMNODES)
+			nid = first_node(node_online_map);
+
+		if (!surplus_huge_pages_node[nid])
+			continue;
+
+		if (!list_empty(&hugepage_freelists[nid])) {
+			page = list_entry(hugepage_freelists[nid].next,
+					  struct page, lru);
+			list_del(&page->lru);
+			update_and_free_page(page);
+			free_huge_pages--;
+			free_huge_pages_node[nid]--;
+			surplus_huge_pages--;
+			surplus_huge_pages_node[nid]--;
+			nr_pages--;
+		}
+	}
+}
+
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr)
 {
 	struct page *page = NULL;
+	int use_reserved_page = vma->vm_flags & VM_MAYSHARE;
 
 	spin_lock(&hugetlb_lock);
-	if (vma->vm_flags & VM_MAYSHARE)
-		resv_huge_pages--;
-	else if (free_huge_pages <= resv_huge_pages)
+	if (!use_reserved_page && (free_huge_pages <= resv_huge_pages))
 		goto fail;
 
 	page = dequeue_huge_page(vma, addr);
@@ -234,8 +337,6 @@ static struct page *alloc_huge_page(stru
 	return page;
 
 fail:
-	if (vma->vm_flags & VM_MAYSHARE)
-		resv_huge_pages++;
 	spin_unlock(&hugetlb_lock);
 
 	/*
@@ -243,7 +344,7 @@ fail:
 	 * may have failed due to an undersized hugetlb pool.  Try to grab a
 	 * surplus huge page from the buddy allocator.
 	 */
-	if (!(vma->vm_flags & VM_MAYSHARE))
+	if (!use_reserved_page)
 		page = alloc_buddy_huge_page(vma, addr);
 
 	return page;
@@ -952,21 +1053,6 @@ static int hugetlb_acct_memory(long delt
 	int ret = -ENOMEM;
 
 	spin_lock(&hugetlb_lock);
-	if ((delta + resv_huge_pages) <= free_huge_pages) {
-		resv_huge_pages += delta;
-		ret = 0;
-	}
-	spin_unlock(&hugetlb_lock);
-	return ret;
-}
-
-int hugetlb_reserve_pages(struct inode *inode, long from, long to)
-{
-	long ret, chg;
-
-	chg = region_chg(&inode->i_mapping->private_list, from, to);
-	if (chg < 0)
-		return chg;
 	/*
 	 * When cpuset is configured, it breaks the strict hugetlb page
 	 * reservation as the accounting is done on a global variable. Such
@@ -984,8 +1070,31 @@ int hugetlb_reserve_pages(struct inode *
 	 * a best attempt and hopefully to minimize the impact of changing
 	 * semantics that cpuset has.
 	 */
-	if (chg > cpuset_mems_nr(free_huge_pages_node))
-		return -ENOMEM;
+	if (delta > 0) {
+		if (gather_surplus_pages(delta) < 0)
+			goto out;
+
+		if (delta > cpuset_mems_nr(free_huge_pages_node))
+			goto out;
+	}
+
+	ret = 0;
+	resv_huge_pages += delta;
+	if (delta < 0)
+		return_unused_surplus_pages((unsigned long) -delta);
+
+out:
+	spin_unlock(&hugetlb_lock);
+	return ret;
+}
+
+int hugetlb_reserve_pages(struct inode *inode, long from, long to)
+{
+	long ret, chg;
+
+	chg = region_chg(&inode->i_mapping->private_list, from, to);
+	if (chg < 0)
+		return chg;
 
 	ret = hugetlb_acct_memory(chg);
 	if (ret < 0)
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
