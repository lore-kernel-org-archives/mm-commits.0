From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:58 -0700
Message-ID: <20120801201259.255345C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51698 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:00 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so293205eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: assign the page hugetlb cgroup when we move the page to active list.
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: assign the page hugetlb cgroup when we move the page to active list.

A page's hugetlb cgroup assignment and movement to the active list should
occur with hugetlb_lock held.  Otherwise when we remove the hugetlb cgroup
we will iterate the active list and find pages with NULL hugetlb cgroup
values.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |   22 ++++++++++------------
 mm/hugetlb_cgroup.c |    5 +++--
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list
+++ a/mm/hugetlb.c
@@ -928,14 +928,8 @@ struct page *alloc_huge_page_node(struct
 	page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
-	if (!page) {
+	if (!page)
 		page = alloc_buddy_huge_page(h, nid);
-		if (page) {
-			spin_lock(&hugetlb_lock);
-			list_move(&page->lru, &h->hugepage_activelist);
-			spin_unlock(&hugetlb_lock);
-		}
-	}
 
 	return page;
 }
@@ -1150,9 +1144,13 @@ static struct page *alloc_huge_page(stru
 	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
-	spin_unlock(&hugetlb_lock);
-
-	if (!page) {
+	if (page) {
+		/* update page cgroup details */
+		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
+					     h_cg, page);
+		spin_unlock(&hugetlb_lock);
+	} else {
+		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
 			hugetlb_cgroup_uncharge_cgroup(idx,
@@ -1162,6 +1160,8 @@ static struct page *alloc_huge_page(stru
 			return ERR_PTR(-ENOSPC);
 		}
 		spin_lock(&hugetlb_lock);
+		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
+					     h_cg, page);
 		list_move(&page->lru, &h->hugepage_activelist);
 		spin_unlock(&hugetlb_lock);
 	}
@@ -1169,8 +1169,6 @@ static struct page *alloc_huge_page(stru
 	set_page_private(page, (unsigned long)spool);
 
 	vma_commit_reservation(h, vma, addr);
-	/* update page cgroup details */
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	return page;
 }
 
diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list
+++ a/mm/hugetlb_cgroup.c
@@ -213,6 +213,7 @@ done:
 	return ret;
 }
 
+/* Should be called with hugetlb_lock held */
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 				  struct hugetlb_cgroup *h_cg,
 				  struct page *page)
@@ -220,9 +221,7 @@ void hugetlb_cgroup_commit_charge(int id
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, h_cg);
-	spin_unlock(&hugetlb_lock);
 	return;
 }
 
@@ -389,6 +388,7 @@ int __init hugetlb_cgroup_file_init(int 
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
 	struct hugetlb_cgroup *h_cg;
+	struct hstate *h = page_hstate(oldhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -401,6 +401,7 @@ void hugetlb_cgroup_migrate(struct page 
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
+	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	cgroup_release_and_wakeup_rmdir(&h_cg->css);
 	return;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

