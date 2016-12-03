From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-hugetlb-rename-some-allocation-functions.patch removed from -mm tree
Date: Fri, 02 Dec 2016 16:37:08 -0800
Message-ID: <584213b4.wPYtbFM1Ui4uhium%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753440AbcLCAgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: rename some allocation functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-rename-some-allocation-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: hugetlb: rename some allocation functions

Patch series "mm: fix the "counter.sh" failure for libhugetlbfs", v2.

(1) Background
   For the arm64, the hugetlb page size can be 32M (PMD + Contiguous bit).
   In the 4K page environment, the max page order is 10 (max_order - 1),
   so 32M page is the gigantic page.    

   The arm64 MMU supports a Contiguous bit which is a hint that the TTE
   is one of a set of contiguous entries which can be cached in a single
   TLB entry.  Please refer to the arm64v8 mannul :
       DDI0487A_f_armv8_arm.pdf (in page D4-1811)

(2) The bug   
   After I tested the libhugetlbfs, I found the test case "counter.sh"
   will fail with the gigantic page (32M page in arm64 board).

   This patch set adds support for gigantic surplus hugetlb pages,
   allowing the counter.sh unit test to pass.   

The counter.sh is just a wrapper for counter.c, available at
  https://github.com/libhugetlbfs/libhugetlbfs/blob/master/tests/counters.c
  https://github.com/libhugetlbfs/libhugetlbfs/blob/master/tests/counters.sh

 The "counter.sh" test case will fail when we test the ARM64 32M gigantic page.
 The error shows below:

 ----------------------------------------------------------
        ...........................................
	LD_PRELOAD=libhugetlbfs.so shmoverride_unlinked (32M: 64):	PASS
	LD_PRELOAD=libhugetlbfs.so HUGETLB_SHM=yes shmoverride_unlinked (32M: 64):	PASS
	quota.sh (32M: 64):	PASS
	counters.sh (32M: 64):	FAIL mmap failed: Invalid argument
	********** TEST SUMMARY
	*                      32M           
	*                      32-bit 64-bit 
	*     Total testcases:     0     87   
	*             Skipped:     0      0   
	*                PASS:     0     86   
	*                FAIL:     0      1   
	*    Killed by signal:     0      0   
	*   Bad configuration:     0      0   
	*       Expected FAIL:     0      0   
	*     Unexpected PASS:     0      0   
	* Strange test result:     0      0   
	**********
 ----------------------------------------------------------

The failure is caused by:
 1) kernel fails to allocate a gigantic page for the surplus case.
    And the gather_surplus_pages() will return NULL in the end.

 2) The condition checks for some functions are wrong:
     return_unused_surplus_pages()
     nr_overcommit_hugepages_store()
     hugetlb_overcommit_handler()



This patch (of 6):

After a future patch __alloc_buddy_huge_page() will not necessarily use
the buddy allocator.

So remove the "buddy" from these functions:

	__alloc_buddy_huge_page -> __alloc_huge_page
	__alloc_buddy_huge_page_no_mpol -> __alloc_huge_page_no_mpol
	__alloc_buddy_huge_page_with_mpol -> __alloc_huge_page_with_mpol

This patch si in preparation for the later patch.

Link: http://lkml.kernel.org/r/1479107259-2011-2-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A . Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Kaly Xin <kaly.xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-rename-some-allocation-functions mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-rename-some-allocation-functions
+++ a/mm/hugetlb.c
@@ -1157,6 +1157,10 @@ static int alloc_fresh_gigantic_page(str
 
 static inline bool gigantic_page_supported(void) { return true; }
 #else
+static inline struct page *alloc_gigantic_page(int nid, unsigned int order)
+{
+	return NULL;
+}
 static inline bool gigantic_page_supported(void) { return false; }
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
 static inline void destroy_compound_gigantic_page(struct page *page,
@@ -1568,7 +1572,7 @@ static struct page *__hugetlb_alloc_budd
  * For (2), we ignore 'vma' and 'addr' and use 'nid' exclusively. This
  * implies that memory policies will not be taken in to account.
  */
-static struct page *__alloc_buddy_huge_page(struct hstate *h,
+static struct page *__alloc_huge_page(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr, int nid)
 {
 	struct page *page;
@@ -1649,21 +1653,21 @@ static struct page *__alloc_buddy_huge_p
  * anywhere.
  */
 static
-struct page *__alloc_buddy_huge_page_no_mpol(struct hstate *h, int nid)
+struct page *__alloc_huge_page_no_mpol(struct hstate *h, int nid)
 {
 	unsigned long addr = -1;
 
-	return __alloc_buddy_huge_page(h, NULL, addr, nid);
+	return __alloc_huge_page(h, NULL, addr, nid);
 }
 
 /*
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
 static
-struct page *__alloc_buddy_huge_page_with_mpol(struct hstate *h,
+struct page *__alloc_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	return __alloc_buddy_huge_page(h, vma, addr, NUMA_NO_NODE);
+	return __alloc_huge_page(h, vma, addr, NUMA_NO_NODE);
 }
 
 /*
@@ -1681,7 +1685,7 @@ struct page *alloc_huge_page_node(struct
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
-		page = __alloc_buddy_huge_page_no_mpol(h, nid);
+		page = __alloc_huge_page_no_mpol(h, nid);
 
 	return page;
 }
@@ -1711,7 +1715,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = __alloc_buddy_huge_page_no_mpol(h, NUMA_NO_NODE);
+		page = __alloc_huge_page_no_mpol(h, NUMA_NO_NODE);
 		if (!page) {
 			alloc_ok = false;
 			break;
@@ -2027,7 +2031,7 @@ struct page *alloc_huge_page(struct vm_a
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
-		page = __alloc_buddy_huge_page_with_mpol(h, vma, addr);
+		page = __alloc_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
@@ -2285,7 +2289,7 @@ static unsigned long set_max_huge_pages(
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with __alloc_buddy_huge_page() here and be unable
+	 * We might race with __alloc_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -2331,7 +2335,7 @@ static unsigned long set_max_huge_pages(
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * __alloc_buddy_huge_page() is checking the global counter,
+	 * __alloc_huge_page() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-add-a-new-parameter-for-some-functions.patch
mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

