From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:05 -0700
Message-ID: <20120611211005.5CF60A03E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55385 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab2FKVKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 17:10:09 -0400
Received: by lagr15 with SMTP id r15so249728lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg/hugetlb: Add failcnt support for hugetlb extension
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: memcg/hugetlb: Add failcnt support for hugetlb extension

Expose the failcnt details to userspace similar to memory and memsw.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 -
 mm/memcontrol.c         |   40 ++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension
+++ a/include/linux/hugetlb.h
@@ -218,7 +218,7 @@ struct hstate {
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
 	/* mem cgroup control files */
-	struct cftype mem_cgroup_files[4];
+	struct cftype mem_cgroup_files[5];
 #endif
 	char name[HSTATE_NAME_LEN];
 };
diff -puN mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension
+++ a/mm/memcontrol.c
@@ -4093,7 +4093,7 @@ out:
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int type, name;
+	int type, name, idx;
 
 	type = MEMFILE_TYPE(event);
 	name = MEMFILE_ATTR(event);
@@ -4101,24 +4101,29 @@ static int mem_cgroup_reset(struct cgrou
 	if (!do_swap_account && type == _MEMSWAP)
 		return -EOPNOTSUPP;
 
-	switch (name) {
-	case RES_MAX_USAGE:
-		if (type == _MEM)
+	switch (type) {
+	case _MEM:
+		if (name == RES_MAX_USAGE)
 			res_counter_reset_max(&memcg->res);
-		else if (type == _MEMHUGETLB) {
-			int idx = MEMFILE_IDX(event);
-			res_counter_reset_max(&memcg->hugepage[idx]);
-		} else
-			res_counter_reset_max(&memcg->memsw);
-		break;
-	case RES_FAILCNT:
-		if (type == _MEM)
+		else
 			res_counter_reset_failcnt(&memcg->res);
+		break;
+	case _MEMSWAP:
+		if (name == RES_MAX_USAGE)
+			res_counter_reset_max(&memcg->memsw);
 		else
 			res_counter_reset_failcnt(&memcg->memsw);
 		break;
+	case _MEMHUGETLB:
+		idx = MEMFILE_IDX(event);
+		if (name == RES_MAX_USAGE)
+			res_counter_reset_max(&memcg->hugepage[idx]);
+		else
+			res_counter_reset_failcnt(&memcg->hugepage[idx]);
+		break;
+	default:
+		BUG();
 	}
-
 	return 0;
 }
 
@@ -5150,8 +5155,15 @@ int __init mem_cgroup_hugetlb_file_init(
 	cft->trigger  = mem_cgroup_reset;
 	cft->read = mem_cgroup_read;
 
-	/* NULL terminate the last cft */
+	/* Add the failcntfile */
 	cft = &h->mem_cgroup_files[3];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "hugetlb.%s.failcnt", buf);
+	cft->private  = __MEMFILE_PRIVATE(idx, _MEMHUGETLB, RES_FAILCNT);
+	cft->trigger  = mem_cgroup_reset;
+	cft->read = mem_cgroup_read;
+
+	/* NULL terminate the last cft */
+	cft = &h->mem_cgroup_files[4];
 	memset(cft, 0, sizeof(*cft));
 
 	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, h->mem_cgroup_files));
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

