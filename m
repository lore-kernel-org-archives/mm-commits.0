From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:16:14 -0700
Message-ID: <20120416231614.37400A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61370 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2DPXQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:16:19 -0400
Received: by bkcjm19 with SMTP id jm19so261352bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:16:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: hugetlbfs: add memcg control files for hugetlbfs
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch

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
@@ -203,6 +204,10 @@ struct hstate {
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
@@ -459,6 +459,7 @@ extern void mem_cgroup_hugetlb_uncharge_
 					     struct page *page);
 extern void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
 					      struct mem_cgroup *memcg);
+extern int mem_cgroup_hugetlb_file_init(int idx) __init;
 
 #else
 static inline int
@@ -489,6 +490,12 @@ mem_cgroup_hugetlb_uncharge_memcg(int id
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
@@ -5195,6 +5195,57 @@ static void mem_cgroup_destroy(struct cg
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
Subject: Subject: hugetlbfs: add memcg control files for hugetlbfs

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

