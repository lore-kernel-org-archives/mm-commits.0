From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch added to -mm tree
Date: Wed, 23 May 2012 16:18:18 -0700
Message-ID: <20120523231818.A4378A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54071 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2EWXSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 19:18:20 -0400
Received: by vbnl22 with SMTP id l22so951741vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 16:18:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg/hugetlb: Add failcnt support for hugetlb extension
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch

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
@@ -4131,7 +4131,7 @@ out:
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int type, name;
+	int type, name, idx;
 
 	type = MEMFILE_TYPE(event);
 	name = MEMFILE_ATTR(event);
@@ -4139,24 +4139,29 @@ static int mem_cgroup_reset(struct cgrou
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
 
@@ -5246,8 +5251,15 @@ int __init mem_cgroup_hugetlb_file_init(
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
Subject: Subject: memcg/hugetlb: Add failcnt support for hugetlb extension

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
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
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
lib-string_helpersc-make-arrays-static.patch

