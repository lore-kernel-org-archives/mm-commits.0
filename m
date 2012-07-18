From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-simplify-pre_destroy-callback.patch added to -mm tree
Date: Wed, 18 Jul 2012 14:26:36 -0700
Message-ID: <20120718212637.133475C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33547 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2GRV0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 17:26:40 -0400
Received: by eekb47 with SMTP id b47so109086eek.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 14:26:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb/cgroup: simplify pre_destroy callback
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-simplify-pre_destroy-callback.patch

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
Subject: hugetlb/cgroup: simplify pre_destroy callback

Since we cannot fail in hugetlb_cgroup_move_parent(), we don't really need
to check whether cgroup have any change left after that.  Also skip those
hstates for which we don't have any charge in this cgroup.

Based on an earlier patch from Wanpeng Li.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-simplify-pre_destroy-callback mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-simplify-pre_destroy-callback
+++ a/mm/hugetlb_cgroup.c
@@ -65,18 +65,6 @@ static inline struct hugetlb_cgroup *par
 	return hugetlb_cgroup_from_cgroup(cg->parent);
 }
 
-static inline bool hugetlb_cgroup_have_usage(struct cgroup *cg)
-{
-	int idx;
-	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cg);
-
-	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
-		if ((res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE)) > 0)
-			return true;
-	}
-	return false;
-}
-
 static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
 {
 	int idx;
@@ -159,24 +147,29 @@ static int hugetlb_cgroup_pre_destroy(st
 {
 	struct hstate *h;
 	struct page *page;
-	int ret = 0, idx = 0;
+	int ret = 0, idx;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
 
-	do {
-		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)) {
-			ret = -EBUSY;
-			goto out;
-		}
-		for_each_hstate(h) {
-			spin_lock(&hugetlb_lock);
-			list_for_each_entry(page, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(idx, cgroup, page);
 
-			spin_unlock(&hugetlb_lock);
-			idx++;
-		}
-		cond_resched();
-	} while (hugetlb_cgroup_have_usage(cgroup));
+	if (cgroup_task_count(cgroup) ||
+	    !list_empty(&cgroup->children)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	for_each_hstate(h) {
+		/*
+		 * if we don't have any charge, skip this hstate
+		 */
+		idx = hstate_index(h);
+		if (res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE) == 0)
+			continue;
+		spin_lock(&hugetlb_lock);
+		list_for_each_entry(page, &h->hugepage_activelist, lru)
+			hugetlb_cgroup_move_parent(idx, cgroup, page);
+		spin_unlock(&hugetlb_lock);
+		VM_BUG_ON(res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE));
+	}
 out:
 	return ret;
 }
_
Subject: Subject: hugetlb/cgroup: simplify pre_destroy callback

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
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-3.patch
mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
hugetlb-cgroup-simplify-pre_destroy-callback.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch

