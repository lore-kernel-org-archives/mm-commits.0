From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-add-support-for-cgroup-removal.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:19 -0700
Message-ID: <20120613204619.EB553A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40113 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2FMUqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:20 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so104039yen.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: add support for cgroup removal
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-add-support-for-cgroup-removal.patch

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
Subject: hugetlb/cgroup: add support for cgroup removal

Add support for cgroup removal.  If we don't have parent cgroup, the
charges are moved to root cgroup.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   70 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-support-for-cgroup-removal mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-support-for-cgroup-removal
+++ a/mm/hugetlb_cgroup.c
@@ -107,10 +107,76 @@ static void hugetlb_cgroup_destroy(struc
 	kfree(h_cgroup);
 }
 
+
+/*
+ * Should be called with hugetlb_lock held.
+ * Since we are holding hugetlb_lock, pages cannot get moved from
+ * active list or uncharged from the cgroup, So no need to get
+ * page reference and test for page active here. This function
+ * cannot fail.
+ */
+static void hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
+				       struct page *page)
+{
+	int csize;
+	struct res_counter *counter;
+	struct res_counter *fail_res;
+	struct hugetlb_cgroup *page_hcg;
+	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
+	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
+
+	page_hcg = hugetlb_cgroup_from_page(page);
+	/*
+	 * We can have pages in active list without any cgroup
+	 * ie, hugepage with less than 3 pages. We can safely
+	 * ignore those pages.
+	 */
+	if (!page_hcg || page_hcg != h_cg)
+		goto out;
+
+	csize = PAGE_SIZE << compound_order(page);
+	if (!parent) {
+		parent = root_h_cgroup;
+		/* root has no limit */
+		res_counter_charge_nofail(&parent->hugepage[idx],
+					  csize, &fail_res);
+	}
+	counter = &h_cg->hugepage[idx];
+	res_counter_uncharge_until(counter, counter->parent, csize);
+
+	set_hugetlb_cgroup(page, parent);
+out:
+	return;
+}
+
+/*
+ * Force the hugetlb cgroup to empty the hugetlb resources by moving them to
+ * the parent cgroup.
+ */
 static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
 {
-	/* We will add the cgroup removal support in later patches */
-	   return -EBUSY;
+	struct hstate *h;
+	struct page *page;
+	int ret = 0, idx = 0;
+
+	do {
+		if (cgroup_task_count(cgroup) ||
+		    !list_empty(&cgroup->children)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		for_each_hstate(h) {
+			spin_lock(&hugetlb_lock);
+			list_for_each_entry(page, &h->hugepage_activelist, lru)
+				hugetlb_cgroup_move_parent(idx, cgroup, page);
+
+			spin_unlock(&hugetlb_lock);
+			idx++;
+		}
+		cond_resched();
+	} while (hugetlb_cgroup_have_usage(cgroup));
+out:
+	return ret;
 }
 
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
_
Subject: Subject: hugetlb/cgroup: add support for cgroup removal

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
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch

