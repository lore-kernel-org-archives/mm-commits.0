From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch added to -mm tree
Date: Mon, 14 Nov 2016 14:44:46 -0800
Message-ID: <582a3e5e.w9Jzzrw7ARARDznd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934180AbcKNWos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 17:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: change the return type of alloc_fresh_gigantic_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: hugetlb: change the return type of alloc_fresh_gigantic_page()

Change the return type to "struct page*" for alloc_fresh_gigantic_page().

This is in preparation for a later patch.

Link: http://lkml.kernel.org/r/1479107259-2011-4-git-send-email-shijie.huang@arm.com
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

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page
+++ a/mm/hugetlb.c
@@ -1142,7 +1142,7 @@ static struct page *alloc_fresh_gigantic
 	return page;
 }
 
-static int alloc_fresh_gigantic_page(struct hstate *h,
+static struct page *alloc_fresh_gigantic_page(struct hstate *h,
 				nodemask_t *nodes_allowed, bool no_init)
 {
 	struct page *page = NULL;
@@ -1151,10 +1151,10 @@ static int alloc_fresh_gigantic_page(str
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
 		page = alloc_fresh_gigantic_page_node(h, node, no_init);
 		if (page)
-			return 1;
+			return page;
 	}
 
-	return 0;
+	return NULL;
 }
 
 static inline bool gigantic_page_supported(void) { return true; }
@@ -1167,8 +1167,8 @@ static inline bool gigantic_page_support
 static inline void free_gigantic_page(struct page *page, unsigned int order) { }
 static inline void destroy_compound_gigantic_page(struct page *page,
 						unsigned int order) { }
-static inline int alloc_fresh_gigantic_page(struct hstate *h,
-		nodemask_t *nodes_allowed, bool no_init) { return 0; }
+static inline struct page *alloc_fresh_gigantic_page(struct hstate *h,
+		nodemask_t *nodes_allowed, bool no_init) { return NULL; }
 #endif
 
 static void update_and_free_page(struct hstate *h, struct page *page)
@@ -2315,7 +2315,7 @@ static unsigned long set_max_huge_pages(
 		cond_resched();
 
 		if (hstate_is_gigantic(h))
-			ret = alloc_fresh_gigantic_page(h, nodes_allowed,
+			ret = !!alloc_fresh_gigantic_page(h, nodes_allowed,
 							false);
 		else
 			ret = alloc_fresh_huge_page(h, nodes_allowed);
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-rename-some-allocation-functions.patch
mm-hugetlb-add-a-new-parameter-for-some-functions.patch
mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-support-gigantic-surplus-pages.patch

