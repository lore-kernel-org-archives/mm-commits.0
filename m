From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-add-a-new-parameter-for-some-functions.patch removed from -mm
 tree
Date: Fri, 02 Dec 2016 16:37:10 -0800
Message-ID: <584213b6.XDunknfIk99ftuPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755258AbcLCAgu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: add a new parameter for some functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-a-new-parameter-for-some-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: hugetlb: add a new parameter for some functions

Add a new parameter, the "no_init", to these functions:

   alloc_fresh_gigantic_page_node()
   alloc_fresh_gigantic_page()

prep_new_huge_page() does some initialization for the new page.  But
sometimes we do not need it to do so, such as in the surplus case in a
later patch.

With this parameter, prep_new_huge_page() can be called by needed:
   If the "no_init" is false, calls the prep_new_huge_page() in
   the alloc_fresh_gigantic_page_node();

This is in preparation for later patches.

Link: http://lkml.kernel.org/r/1479107259-2011-3-git-send-email-shijie.huang@arm.com
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

 mm/hugetlb.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-a-new-parameter-for-some-functions mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-a-new-parameter-for-some-functions
+++ a/mm/hugetlb.c
@@ -1127,27 +1127,29 @@ static struct page *alloc_gigantic_page(
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
 static void prep_compound_gigantic_page(struct page *page, unsigned int order);
 
-static struct page *alloc_fresh_gigantic_page_node(struct hstate *h, int nid)
+static struct page *alloc_fresh_gigantic_page_node(struct hstate *h,
+					int nid, bool no_init)
 {
 	struct page *page;
 
 	page = alloc_gigantic_page(nid, huge_page_order(h));
 	if (page) {
 		prep_compound_gigantic_page(page, huge_page_order(h));
-		prep_new_huge_page(h, page, nid);
+		if (!no_init)
+			prep_new_huge_page(h, page, nid);
 	}
 
 	return page;
 }
 
 static int alloc_fresh_gigantic_page(struct hstate *h,
-				nodemask_t *nodes_allowed)
+				nodemask_t *nodes_allowed, bool no_init)
 {
 	struct page *page = NULL;
 	int nr_nodes, node;
 
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		page = alloc_fresh_gigantic_page_node(h, node);
+		page = alloc_fresh_gigantic_page_node(h, node, no_init);
 		if (page)
 			return 1;
 	}
@@ -1166,7 +1168,7 @@ static inline void free_gigantic_page(st
 static inline void destroy_compound_gigantic_page(struct page *page,
 						unsigned int order) { }
 static inline int alloc_fresh_gigantic_page(struct hstate *h,
-					nodemask_t *nodes_allowed) { return 0; }
+		nodemask_t *nodes_allowed, bool no_init) { return 0; }
 #endif
 
 static void update_and_free_page(struct hstate *h, struct page *page)
@@ -2313,7 +2315,8 @@ static unsigned long set_max_huge_pages(
 		cond_resched();
 
 		if (hstate_is_gigantic(h))
-			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
+			ret = alloc_fresh_gigantic_page(h, nodes_allowed,
+							false);
 		else
 			ret = alloc_fresh_huge_page(h, nodes_allowed);
 		spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

