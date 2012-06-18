From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch added to -mm tree
Date: Mon, 18 Jun 2012 14:25:36 -0700
Message-ID: <20120618212536.E6FD0A01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:56094 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2FRVZi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:25:38 -0400
Received: by vbnl22 with SMTP id l22so503118vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:25:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch

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
Subject: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate

We already hold the hugetlb_lock.  That should prevent a parallel cgroup
rmdir from touching page's hugetlb cgroup.  So remove the exclude and
wakeup calls.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate
+++ a/mm/hugetlb_cgroup.c
@@ -387,6 +387,10 @@ int __init hugetlb_cgroup_file_init(int 
 	return 0;
 }
 
+/*
+ * hugetlb_lock will make sure a parallel cgroup rmdir won't happen
+ * when we migrate hugepages
+ */
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
 	struct hugetlb_cgroup *h_cg;
@@ -399,13 +403,11 @@ void hugetlb_cgroup_migrate(struct page 
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
-	cgroup_exclude_rmdir(&h_cg->css);
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
-	cgroup_release_and_wakeup_rmdir(&h_cg->css);
 	return;
 }
 
_
Subject: Subject: hugetlb/cgroup: remove exclude and wakeup rmdir calls from migrate

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

