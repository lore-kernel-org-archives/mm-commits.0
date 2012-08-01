From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-add-support-for-cgroup-removal.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:40 -0700
Message-ID: <20120801201240.AAB3C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:42 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: add support for cgroup removal
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-support-for-cgroup-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add support for cgroup removal

Add support for cgroup removal.  If we don't have parent cgroup, the
charges are moved to root cgroup.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   70 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-support-for-cgroup-removal mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-support-for-cgroup-removal
+++ a/mm/hugetlb_cgroup.c
@@ -105,10 +105,76 @@ static void hugetlb_cgroup_destroy(struc
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

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

