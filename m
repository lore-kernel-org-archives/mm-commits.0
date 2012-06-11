From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:56 -0700
Message-ID: <20120611210956.93851A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49946 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKVJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:57 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so124916qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: add memcg control files for hugetlbfs
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlbfs: add memcg control files for hugetlbfs

Add the control files for hugetlbfs in memcg.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h    |    5 +++
 include/linux/memcontrol.h |    7 ++++
 mm/hugetlb.c               |    2 -
 mm/memcontrol.c            |   51 +++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs
+++ a/include/linux/hugetlb.h
@@ -4,6 +4,7 @@
 #include <linux/mm_types.h>
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
+#include <linux/cgroup.h>
 
 struct ctl_table;
 struct user_struct;
@@ -215,6 +216,10 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+	/* mem cgroup control files */
+	struct cftype mem_cgroup_files[4];
+#endif
 	char name[HSTATE_NAME_LEN];
 };
 
diff -puN include/linux/memcontrol.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~hugetlbfs-add-memcg-control-files-for-hugetlbfs
+++ a/include/linux/memcontrol.h
@@ -428,6 +428,7 @@ extern void mem_cgroup_hugetlb_uncharge_
 					     struct page *page);
 extern void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
 					      struct mem_cgroup *memcg);
+extern int mem_cgroup_hugetlb_file_init(int idx) __init;
 
 #else
 static inline int
@@ -458,6 +459,12 @@ mem_cgroup_hugetlb_uncharge_memcg(int id
 {
 	return;
 }
+
+static inline int mem_cgroup_hugetlb_file_init(int idx)
+{
+	return 0;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/hugetlb.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs
+++ a/mm/hugetlb.c
@@ -1931,7 +1931,7 @@ void __init hugetlb_add_hstate(unsigned 
 	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
-
+	mem_cgroup_hugetlb_file_init(hugetlb_max_hstate - 1);
 	parsed_hstate = h;
 }
 
diff -puN mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs
+++ a/mm/memcontrol.c
@@ -5109,6 +5109,57 @@ static void mem_cgroup_destroy(struct cg
 	mem_cgroup_put(memcg);
 }
 
+#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
+static char *mem_fmt(char *buf, unsigned long n)
+{
+	if (n >= (1UL << 30))
+		sprintf(buf, "%luGB", n >> 30);
+	else if (n >= (1UL << 20))
+		sprintf(buf, "%luMB", n >> 20);
+	else
+		sprintf(buf, "%luKB", n >> 10);
+	return buf;
+}
+
+int __init mem_cgroup_hugetlb_file_init(int idx)
+{
+	char buf[32];
+	struct cftype *cft;
+	struct hstate *h = &hstates[idx];
+
+	/* format the size */
+	mem_fmt(buf, huge_page_size(h));
+
+	/* Add the limit file */
+	cft = &h->mem_cgroup_files[0];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "hugetlb.%s.limit_in_bytes", buf);
+	cft->private = __MEMFILE_PRIVATE(idx, _MEMHUGETLB, RES_LIMIT);
+	cft->read = mem_cgroup_read;
+	cft->write_string = mem_cgroup_write;
+
+	/* Add the usage file */
+	cft = &h->mem_cgroup_files[1];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "hugetlb.%s.usage_in_bytes", buf);
+	cft->private  = __MEMFILE_PRIVATE(idx, _MEMHUGETLB, RES_USAGE);
+	cft->read = mem_cgroup_read;
+
+	/* Add the MAX usage file */
+	cft = &h->mem_cgroup_files[2];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "hugetlb.%s.max_usage_in_bytes", buf);
+	cft->private  = __MEMFILE_PRIVATE(idx, _MEMHUGETLB, RES_MAX_USAGE);
+	cft->trigger  = mem_cgroup_reset;
+	cft->read = mem_cgroup_read;
+
+	/* NULL terminate the last cft */
+	cft = &h->mem_cgroup_files[3];
+	memset(cft, 0, sizeof(*cft));
+
+	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, h->mem_cgroup_files));
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 #define PRECHARGE_COUNT_AT_ONCE	256
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
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
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

