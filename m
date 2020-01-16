From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-controller-for-cgroups-v2.patch
 removed from -mm tree
Date: Thu, 16 Jan 2020 15:21:33 -0800
Message-ID: <20200116232133.Ek-2vdAgu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390675AbgAPXVf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gscrivan@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, mike.kravetz@oracle.com, mkoutny@suse.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm: hugetlb controller for cgroups
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-controller-for-cgroups-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: mm: hugetlb controller for cgroups

In the effort of supporting cgroups v2 into Kubernetes, I stumped on the
lack of the hugetlb controller.

When the controller is enabled, it exposes four new files for each hugetlb
size on non-root cgroups:

- hugetlb.<hugepagesize>.current
- hugetlb.<hugepagesize>.max
- hugetlb.<hugepagesize>.events
- hugetlb.<hugepagesize>.events.local

The differences with the legacy hierarchy are in the file names and using
the value "max" instead of "-1" to disable a limit.

The file .limit_in_bytes is renamed to .max.

The file .usage_in_bytes is renamed to .current.

.failcnt is not provided as a single file anymore, but its value can be
read through the new flat-keyed files .events and .events.local, through
the "max" key.

Link: http://lkml.kernel.org/r/20191216193831.540953-1-gscrivan@redhat.com
Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   29 +++
 include/linux/hugetlb.h                 |    3 
 mm/hugetlb_cgroup.c                     |  198 ++++++++++++++++++++--
 3 files changed, 218 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-hugetlb-controller-for-cgroups-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -61,6 +61,8 @@ v1 is available under Documentation/admi
      5-6. Device
      5-7. RDMA
        5-7-1. RDMA Interface Files
+     5-8. HugeTLB
+       5.8-1. HugeTLB Interface Files
      5-8. Misc
        5-8-1. perf_event
      5-N. Non-normative information
@@ -2056,6 +2058,33 @@ RDMA Interface Files
 	  mlx4_0 hca_handle=1 hca_object=20
 	  ocrdma1 hca_handle=1 hca_object=23
 
+HugeTLB
+-------
+
+The HugeTLB controller allows to limit the HugeTLB usage per control group and
+enforces the controller limit during page fault.
+
+HugeTLB Interface Files
+~~~~~~~~~~~~~~~~~~~~~~~
+
+  hugetlb.<hugepagesize>.current
+	Show current usage for "hugepagesize" hugetlb.  It exists for all
+	the cgroup except root.
+
+  hugetlb.<hugepagesize>.max
+	Set/show the hard limit of "hugepagesize" hugetlb usage.
+	The default value is "max".  It exists for all the cgroup except root.
+
+  hugetlb.<hugepagesize>.events
+	A read-only flat-keyed file which exists on non-root cgroups.
+
+	  max
+		The number of allocation failure due to HugeTLB limit
+
+  hugetlb.<hugepagesize>.events.local
+	Similar to hugetlb.<hugepagesize>.events but the fields in the file
+	are local to the cgroup i.e. not hierarchical. The file modified event
+	generated on this file reflects only the local events.
 
 Misc
 ----
--- a/include/linux/hugetlb.h~mm-hugetlb-controller-for-cgroups-v2
+++ a/include/linux/hugetlb.h
@@ -432,7 +432,8 @@ struct hstate {
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 #ifdef CONFIG_CGROUP_HUGETLB
 	/* cgroup control files */
-	struct cftype cgroup_files[5];
+	struct cftype cgroup_files_dfl[5];
+	struct cftype cgroup_files_legacy[5];
 #endif
 	char name[HSTATE_NAME_LEN];
 };
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-controller-for-cgroups-v2
+++ a/mm/hugetlb_cgroup.c
@@ -3,6 +3,10 @@
  * Copyright IBM Corporation, 2012
  * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
  *
+ * Cgroup v2
+ * Copyright (C) 2019 Red Hat, Inc.
+ * Author: Giuseppe Scrivano <gscrivan@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2.1 of the GNU Lesser General Public License
  * as published by the Free Software Foundation.
@@ -19,18 +23,36 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 
+enum hugetlb_memory_event {
+	HUGETLB_MAX,
+	HUGETLB_NR_MEMORY_EVENTS,
+};
+
 struct hugetlb_cgroup {
 	struct cgroup_subsys_state css;
+
 	/*
 	 * the counter to account for hugepages from hugetlb.
 	 */
 	struct page_counter hugepage[HUGE_MAX_HSTATE];
+
+	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+
+	/* Handle for "hugetlb.events" */
+	struct cgroup_file events_file[HUGE_MAX_HSTATE];
+
+	/* Handle for "hugetlb.events.local" */
+	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
 };
 
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+#define hugetlb_cgroup_from_counter(counter, idx)                   \
+	container_of(counter, struct hugetlb_cgroup, hugepage[idx])
+
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
 static inline
@@ -178,6 +200,19 @@ static void hugetlb_cgroup_css_offline(s
 	} while (hugetlb_cgroup_have_usage(h_cg));
 }
 
+static inline void hugetlb_event(struct hugetlb_cgroup *hugetlb, int idx,
+				 enum hugetlb_memory_event event)
+{
+	atomic_long_inc(&hugetlb->events_local[idx][event]);
+	cgroup_file_notify(&hugetlb->events_local_file[idx]);
+
+	do {
+		atomic_long_inc(&hugetlb->events[idx][event]);
+		cgroup_file_notify(&hugetlb->events_file[idx]);
+	} while ((hugetlb = parent_hugetlb_cgroup(hugetlb)) &&
+		 !hugetlb_cgroup_is_root(hugetlb));
+}
+
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 				 struct hugetlb_cgroup **ptr)
 {
@@ -202,8 +237,12 @@ again:
 	}
 	rcu_read_unlock();
 
-	if (!page_counter_try_charge(&h_cg->hugepage[idx], nr_pages, &counter))
+	if (!page_counter_try_charge(&h_cg->hugepage[idx], nr_pages,
+				     &counter)) {
 		ret = -ENOMEM;
+		hugetlb_event(hugetlb_cgroup_from_counter(counter, idx), idx,
+			      HUGETLB_MAX);
+	}
 	css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
@@ -283,10 +322,45 @@ static u64 hugetlb_cgroup_read_u64(struc
 	}
 }
 
+static int hugetlb_cgroup_read_u64_max(struct seq_file *seq, void *v)
+{
+	int idx;
+	u64 val;
+	struct cftype *cft = seq_cft(seq);
+	unsigned long limit;
+	struct page_counter *counter;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(seq_css(seq));
+
+	idx = MEMFILE_IDX(cft->private);
+	counter = &h_cg->hugepage[idx];
+
+	limit = round_down(PAGE_COUNTER_MAX,
+			   1 << huge_page_order(&hstates[idx]));
+
+	switch (MEMFILE_ATTR(cft->private)) {
+	case RES_USAGE:
+		val = (u64)page_counter_read(counter);
+		seq_printf(seq, "%llu\n", val * PAGE_SIZE);
+		break;
+	case RES_LIMIT:
+		val = (u64)counter->max;
+		if (val == limit)
+			seq_puts(seq, "max\n");
+		else
+			seq_printf(seq, "%llu\n", val * PAGE_SIZE);
+		break;
+	default:
+		BUG();
+	}
+
+	return 0;
+}
+
 static DEFINE_MUTEX(hugetlb_limit_mutex);
 
 static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
-				    char *buf, size_t nbytes, loff_t off)
+				    char *buf, size_t nbytes, loff_t off,
+				    const char *max)
 {
 	int ret, idx;
 	unsigned long nr_pages;
@@ -296,7 +370,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return -EINVAL;
 
 	buf = strstrip(buf);
-	ret = page_counter_memparse(buf, "-1", &nr_pages);
+	ret = page_counter_memparse(buf, max, &nr_pages);
 	if (ret)
 		return ret;
 
@@ -316,6 +390,18 @@ static ssize_t hugetlb_cgroup_write(stru
 	return ret ?: nbytes;
 }
 
+static ssize_t hugetlb_cgroup_write_legacy(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	return hugetlb_cgroup_write(of, buf, nbytes, off, "-1");
+}
+
+static ssize_t hugetlb_cgroup_write_dfl(struct kernfs_open_file *of,
+					char *buf, size_t nbytes, loff_t off)
+{
+	return hugetlb_cgroup_write(of, buf, nbytes, off, "max");
+}
+
 static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
@@ -350,7 +436,36 @@ static char *mem_fmt(char *buf, int size
 	return buf;
 }
 
-static void __init __hugetlb_cgroup_file_init(int idx)
+static int __hugetlb_events_show(struct seq_file *seq, bool local)
+{
+	int idx;
+	long max;
+	struct cftype *cft = seq_cft(seq);
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(seq_css(seq));
+
+	idx = MEMFILE_IDX(cft->private);
+
+	if (local)
+		max = atomic_long_read(&h_cg->events_local[idx][HUGETLB_MAX]);
+	else
+		max = atomic_long_read(&h_cg->events[idx][HUGETLB_MAX]);
+
+	seq_printf(seq, "max %lu\n", max);
+
+	return 0;
+}
+
+static int hugetlb_events_show(struct seq_file *seq, void *v)
+{
+	return __hugetlb_events_show(seq, false);
+}
+
+static int hugetlb_events_local_show(struct seq_file *seq, void *v)
+{
+	return __hugetlb_events_show(seq, true);
+}
+
+static void __init __hugetlb_cgroup_file_dfl_init(int idx)
 {
 	char buf[32];
 	struct cftype *cft;
@@ -360,38 +475,93 @@ static void __init __hugetlb_cgroup_file
 	mem_fmt(buf, 32, huge_page_size(h));
 
 	/* Add the limit file */
-	cft = &h->cgroup_files[0];
+	cft = &h->cgroup_files_dfl[0];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
+	cft->seq_show = hugetlb_cgroup_read_u64_max;
+	cft->write = hugetlb_cgroup_write_dfl;
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
+	/* Add the current usage file */
+	cft = &h->cgroup_files_dfl[1];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.current", buf);
+	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
+	cft->seq_show = hugetlb_cgroup_read_u64_max;
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
+	/* Add the events file */
+	cft = &h->cgroup_files_dfl[2];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
+	cft->private = MEMFILE_PRIVATE(idx, 0);
+	cft->seq_show = hugetlb_events_show;
+	cft->file_offset = offsetof(struct hugetlb_cgroup, events_file[idx]),
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
+	/* Add the events.local file */
+	cft = &h->cgroup_files_dfl[3];
+	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events.local", buf);
+	cft->private = MEMFILE_PRIVATE(idx, 0);
+	cft->seq_show = hugetlb_events_local_show;
+	cft->file_offset = offsetof(struct hugetlb_cgroup,
+				    events_local_file[idx]),
+	cft->flags = CFTYPE_NOT_ON_ROOT;
+
+	/* NULL terminate the last cft */
+	cft = &h->cgroup_files_dfl[4];
+	memset(cft, 0, sizeof(*cft));
+
+	WARN_ON(cgroup_add_dfl_cftypes(&hugetlb_cgrp_subsys,
+				       h->cgroup_files_dfl));
+}
+
+static void __init __hugetlb_cgroup_file_legacy_init(int idx)
+{
+	char buf[32];
+	struct cftype *cft;
+	struct hstate *h = &hstates[idx];
+
+	/* format the size */
+	mem_fmt(buf, 32, huge_page_size(h));
+
+	/* Add the limit file */
+	cft = &h->cgroup_files_legacy[0];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.limit_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_LIMIT);
 	cft->read_u64 = hugetlb_cgroup_read_u64;
-	cft->write = hugetlb_cgroup_write;
+	cft->write = hugetlb_cgroup_write_legacy;
 
 	/* Add the usage file */
-	cft = &h->cgroup_files[1];
+	cft = &h->cgroup_files_legacy[1];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.usage_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_USAGE);
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* Add the MAX usage file */
-	cft = &h->cgroup_files[2];
+	cft = &h->cgroup_files_legacy[2];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
 	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* Add the failcntfile */
-	cft = &h->cgroup_files[3];
+	cft = &h->cgroup_files_legacy[3];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
 	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
 	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* NULL terminate the last cft */
-	cft = &h->cgroup_files[4];
+	cft = &h->cgroup_files_legacy[4];
 	memset(cft, 0, sizeof(*cft));
 
 	WARN_ON(cgroup_add_legacy_cftypes(&hugetlb_cgrp_subsys,
-					  h->cgroup_files));
+					  h->cgroup_files_legacy));
+}
+
+static void __init __hugetlb_cgroup_file_init(int idx)
+{
+	__hugetlb_cgroup_file_dfl_init(idx);
+	__hugetlb_cgroup_file_legacy_init(idx);
 }
 
 void __init hugetlb_cgroup_file_init(void)
@@ -433,8 +603,14 @@ void hugetlb_cgroup_migrate(struct page
 	return;
 }
 
+static struct cftype hugetlb_files[] = {
+	{} /* terminate */
+};
+
 struct cgroup_subsys hugetlb_cgrp_subsys = {
 	.css_alloc	= hugetlb_cgroup_css_alloc,
 	.css_offline	= hugetlb_cgroup_css_offline,
 	.css_free	= hugetlb_cgroup_css_free,
+	.dfl_cftypes	= hugetlb_files,
+	.legacy_cftypes	= hugetlb_files,
 };
_

Patches currently in -mm which might be from gscrivan@redhat.com are
