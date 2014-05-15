From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch added
 to -mm tree
Date: Thu, 15 May 2014 15:42:58 -0700
Message-ID: <537542f2.eEMfFgR8dI+JNEG4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaEOWm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 18:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, davidlohr@hp.com, nasa4836@gmail.com

Subject: + mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch added to -mm tree
To: nasa4836@gmail.com,davidlohr@hp.com,hannes@cmpxchg.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 15:42:58 -0700


The patch titled
     Subject: mm, hugetlb: move the error handle logic out of normal code path
has been added to the -mm tree.  Its filename is
     mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm, hugetlb: move the error handle logic out of normal code path

alloc_huge_page() now mixes normal code path with error handle logic. 
This patches move out the error handle logic, to make normal code path
more clean and redue code duplicate.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path
+++ a/mm/hugetlb.c
@@ -1387,24 +1387,17 @@ static struct page *alloc_huge_page(stru
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		if (chg || avoid_reserve)
-			hugepage_subpool_put_pages(spool, 1);
-		return ERR_PTR(-ENOSPC);
-	}
+	if (ret)
+		goto out_subpool_put;
+
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page) {
-			hugetlb_cgroup_uncharge_cgroup(idx,
-						       pages_per_huge_page(h),
-						       h_cg);
-			if (chg || avoid_reserve)
-				hugepage_subpool_put_pages(spool, 1);
-			return ERR_PTR(-ENOSPC);
-		}
+		if (!page)
+			goto out_uncharge_cgroup;
+
 		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
@@ -1416,6 +1409,13 @@ static struct page *alloc_huge_page(stru
 
 	vma_commit_reservation(h, vma, addr);
 	return page;
+
+out_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
+out_subpool_put:
+	if (chg || avoid_reserve)
+		hugepage_subpool_put_pages(spool, 1);
+	return ERR_PTR(-ENOSPC);
 }
 
 /*
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
linux-next.patch

