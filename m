From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
 removed from -mm tree
Date: Fri, 02 Dec 2016 16:37:25 -0800
Message-ID: <584213c5.VtAURnM3HVoSdr1C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755333AbcLCAhE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2

Since the huge_nodemask() is changed, we have to change this function a
little.

Link: http://lkml.kernel.org/r/1479279304-31379-1-git-send-email-shijie.huang@arm.com
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

 mm/hugetlb.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2
+++ a/mm/hugetlb.c
@@ -1507,19 +1507,19 @@ int dissolve_free_huge_pages(unsigned lo
  *    the gigantic page.
  *
  * 2. The NUMA is enabled, but the vma is NULL.
- *    Create a @nodes_allowed, use alloc_fresh_gigantic_page() to get
+ *    Create a @nodes_allowed, and use alloc_fresh_gigantic_page() to get
  *    the gigantic page.
  *
  * 3. The NUMA is enabled, and the vma is valid.
  *    Use the @vma's memory policy.
- *    Get @nodes_mask by huge_nodemask(), and use alloc_fresh_gigantic_page()
+ *    Get @nodes_allowed by huge_nodemask(), and use alloc_fresh_gigantic_page()
  *    to get the gigantic page.
  */
 static struct page *__hugetlb_alloc_gigantic_page(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr, int nid)
 {
-	struct page *page;
-	nodemask_t *nodes_mask;
+	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
+	struct page *page = NULL;
 
 	/* Not NUMA */
 	if (!IS_ENABLED(CONFIG_NUMA)) {
@@ -1530,14 +1530,12 @@ static struct page *__hugetlb_alloc_giga
 		if (page)
 			prep_compound_gigantic_page(page, huge_page_order(h));
 
+		NODEMASK_FREE(nodes_allowed);
 		return page;
 	}
 
 	/* NUMA && !vma */
 	if (!vma) {
-		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
-				GFP_KERNEL | __GFP_NORETRY);
-
 		if (nid == NUMA_NO_NODE) {
 			if (!init_nodemask_of_mempolicy(nodes_allowed)) {
 				NODEMASK_FREE(nodes_allowed);
@@ -1558,13 +1556,11 @@ static struct page *__hugetlb_alloc_giga
 	}
 
 	/* NUMA && vma */
-	nodes_mask = huge_nodemask(vma, addr);
-	if (nodes_mask) {
-		page = alloc_fresh_gigantic_page(h, nodes_mask, true);
-		if (page)
-			return page;
-	}
-	return NULL;
+	if (huge_nodemask(vma, addr, nodes_allowed))
+		page = alloc_fresh_gigantic_page(h, nodes_allowed, true);
+
+	NODEMASK_FREE(nodes_allowed);
+	return page;
 }
 
 /*
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

