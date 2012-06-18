From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch added to -mm tree
Date: Mon, 18 Jun 2012 14:25:34 -0700
Message-ID: <20120618212534.C04B7A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47231 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2FRVZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:25:37 -0400
Received: by wibhn6 with SMTP id hn6so123541wib.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:25:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb/cgroup: assign the page hugetlb cgroup when we move the page to active list.
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -218,6 +218,7 @@ done:
 	return ret;
 }
 
+/* Should be called with hugetlb_lock held */
 void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 				  struct hugetlb_cgroup *h_cg,
 				  struct page *page)
@@ -225,9 +226,7 @@ void hugetlb_cgroup_commit_charge(int id
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, h_cg);
-	spin_unlock(&hugetlb_lock);
 	return;
 }
 
@@ -391,6 +390,7 @@ int __init hugetlb_cgroup_file_init(int 
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
 	struct hugetlb_cgroup *h_cg;
+	struct hstate *h = page_hstate(oldhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -403,6 +403,7 @@ void hugetlb_cgroup_migrate(struct page 
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
+	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	cgroup_release_and_wakeup_rmdir(&h_cg->css);
 	return;
_
Subject: Subject: hugetlb/cgroup: assign the page hugetlb cgroup when we move the page to active list.

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch

