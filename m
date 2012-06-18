From: akpm@linux-foundation.org
Subject: + hugetlb-move-all-the-in-use-pages-to-active-list.patch added to -mm tree
Date: Mon, 18 Jun 2012 14:25:32 -0700
Message-ID: <20120618212533.25744A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:35509 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2FRVZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:25:35 -0400
Received: by lbbgp10 with SMTP id gp10so353898lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:25:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: move all the in use pages to active list
has been added to the -mm tree.  Its filename is
     hugetlb-move-all-the-in-use-pages-to-active-list.patch

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
Subject: hugetlb: move all the in use pages to active list

When we fail to allocate pages from the reserve pool, hugetlb tries to
allocate huge pages using alloc_buddy_huge_page.  Add these to the active
list.  We also need to add the huge page we allocate when we soft offline
the oldpage to active list.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-move-all-the-in-use-pages-to-active-list mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-move-all-the-in-use-pages-to-active-list
+++ a/mm/hugetlb.c
@@ -928,8 +928,14 @@ struct page *alloc_huge_page_node(struct
 	page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
-	if (!page)
+	if (!page) {
 		page = alloc_buddy_huge_page(h, nid);
+		if (page) {
+			spin_lock(&hugetlb_lock);
+			list_move(&page->lru, &h->hugepage_activelist);
+			spin_unlock(&hugetlb_lock);
+		}
+	}
 
 	return page;
 }
@@ -1155,6 +1161,9 @@ static struct page *alloc_huge_page(stru
 			hugepage_subpool_put_pages(spool, chg);
 			return ERR_PTR(-ENOSPC);
 		}
+		spin_lock(&hugetlb_lock);
+		list_move(&page->lru, &h->hugepage_activelist);
+		spin_unlock(&hugetlb_lock);
 	}
 
 	set_page_private(page, (unsigned long)spool);
_
Subject: Subject: hugetlb: move all the in use pages to active list

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

