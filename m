From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:21 -0700
Message-ID: <20120613204621.EE351A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62198 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2FMUqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so90356qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: add hugetlb cgroup control files
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch

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
Subject: hugetlb/cgroup: add hugetlb cgroup control files

Add the control files for hugetlb controller

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |    5 +
 include/linux/hugetlb_cgroup.h |    6 +
 mm/hugetlb.c                   |    8 +
 mm/hugetlb_cgroup.c            |  129 +++++++++++++++++++++++++++++++
 4 files changed, 148 insertions(+)

diff -puN include/linux/hugetlb.h~hugetlb-cgroup-add-hugetlb-cgroup-control-files include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-cgroup-add-hugetlb-cgroup-control-files
+++ a/include/linux/hugetlb.h
@@ -4,6 +4,7 @@
 #include <linux/mm_types.h>
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
+#include <linux/cgroup.h>
 
 struct ctl_table;
 struct user_struct;
@@ -221,6 +222,10 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+	/* cgroup control files */
+	struct cftype cgroup_files[5];
+#endif
 	char name[HSTATE_NAME_LEN];
 };
 
diff -puN include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-hugetlb-cgroup-control-files include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-hugetlb-cgroup-control-files
+++ a/include/linux/hugetlb_cgroup.h
@@ -62,6 +62,7 @@ extern void hugetlb_cgroup_uncharge_page
 					 struct page *page);
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
+extern int hugetlb_cgroup_file_init(int idx) __init;
 
 #else
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
@@ -108,5 +109,10 @@ hugetlb_cgroup_uncharge_cgroup(int idx, 
 	return;
 }
 
+static inline int __init hugetlb_cgroup_file_init(int idx)
+{
+	return 0;
+}
+
 #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
 #endif
diff -puN mm/hugetlb.c~hugetlb-cgroup-add-hugetlb-cgroup-control-files mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-cgroup-add-hugetlb-cgroup-control-files
+++ a/mm/hugetlb.c
@@ -30,6 +30,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
+#include <linux/hugetlb_cgroup.h>
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
@@ -1930,6 +1931,13 @@ void __init hugetlb_add_hstate(unsigned 
 	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
+	/*
+	 * Add cgroup control files only if the huge page consists
+	 * of more than two normal pages. This is because we use
+	 * page[2].lru.next for storing cgoup details.
+	 */
+	if (order >= HUGETLB_CGROUP_MIN_ORDER)
+		hugetlb_cgroup_file_init(hugetlb_max_hstate - 1);
 
 	parsed_hstate = h;
 }
diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-hugetlb-cgroup-control-files mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-hugetlb-cgroup-control-files
+++ a/mm/hugetlb_cgroup.c
@@ -26,6 +26,10 @@ struct hugetlb_cgroup {
 	struct res_counter hugepage[HUGE_MAX_HSTATE];
 };
 
+#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
+#define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
+#define MEMFILE_ATTR(val)	((val) & 0xffff)
+
 struct cgroup_subsys hugetlb_subsys __read_mostly;
 struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
@@ -259,6 +263,131 @@ void hugetlb_cgroup_uncharge_cgroup(int 
 	return;
 }
 
+static ssize_t hugetlb_cgroup_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct file *file, char __user *buf,
+				   size_t nbytes, loff_t *ppos)
+{
+	u64 val;
+	char str[64];
+	int idx, name, len;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
+
+	idx = MEMFILE_IDX(cft->private);
+	name = MEMFILE_ATTR(cft->private);
+
+	val = res_counter_read_u64(&h_cg->hugepage[idx], name);
+	len = scnprintf(str, sizeof(str), "%llu\n", (unsigned long long)val);
+	return simple_read_from_buffer(buf, nbytes, ppos, str, len);
+}
+
+static int hugetlb_cgroup_write(struct cgroup *cgroup, struct cftype *cft,
+				const char *buffer)
+{
+	int idx, name, ret;
+	unsigned long long val;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
+
+	idx = MEMFILE_IDX(cft->private);
+	name = MEMFILE_ATTR(cft->private);
+
+	switch (name) {
+	case RES_LIMIT:
+		if (hugetlb_cgroup_is_root(h_cg)) {
+			/* Can't set limit on root */
+			ret = -EINVAL;
+			break;
+		}
+		/* This function does all necessary parse...reuse it */
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (ret)
+			break;
+		ret = res_counter_set_limit(&h_cg->hugepage[idx], val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int hugetlb_cgroup_reset(struct cgroup *cgroup, unsigned int event)
+{
+	int idx, name, ret = 0;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cgroup);
+
+	idx = MEMFILE_IDX(event);
+	name = MEMFILE_ATTR(event);
+
+	switch (name) {
+	case RES_MAX_USAGE:
+		res_counter_reset_max(&h_cg->hugepage[idx]);
+		break;
+	case RES_FAILCNT:
+		res_counter_reset_failcnt(&h_cg->hugepage[idx]);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static char *mem_fmt(char *buf, int size, unsigned long hsize)
+{
+	if (hsize >= (1UL << 30))
+		snprintf(buf, size, "%luGB", hsize >> 30);
+	else if (hsize >= (1UL << 20))
+		snprintf(buf, size, "%luMB", hsize >> 20);
+	else
+		snprintf(buf, size, "%luKB", hsize >> 10);
+	return buf;
+}
+
+int __init hugetlb_cgroup_file_init(int idx)
+{
+	char buf[32];
+	struct cftype *cft;
+	struct hstate *h = &hstates[idx];
+
+	/* format the size */
+	mem_fmt(buf, 32, huge_page_size(h));
+
+	/* Add the limit file */
+	cft = &h->cgroup_files[0];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
+	cft->read = hugetlb_cgroup_read;
+	cft->write_string = hugetlb_cgroup_write;
+
+	/* Add the usage file */
+	cft = &h->cgroup_files[1];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
+	cft->read = hugetlb_cgroup_read;
+
+	/* Add the MAX usage file */
+	cft = &h->cgroup_files[2];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
+	cft->trigger = hugetlb_cgroup_reset;
+	cft->read = hugetlb_cgroup_read;
+
+	/* Add the failcntfile */
+	cft = &h->cgroup_files[3];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
+	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
+	cft->trigger  = hugetlb_cgroup_reset;
+	cft->read = hugetlb_cgroup_read;
+
+	/* NULL terminate the last cft */
+	cft = &h->cgroup_files[4];
+	memset(cft, 0, sizeof(*cft));
+
+	WARN_ON(cgroup_add_cftypes(&hugetlb_subsys, h->cgroup_files));
+
+	return 0;
+}
+
 struct cgroup_subsys hugetlb_subsys = {
 	.name = "hugetlb",
 	.create     = hugetlb_cgroup_create,
_
Subject: Subject: hugetlb/cgroup: add hugetlb cgroup control files

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

