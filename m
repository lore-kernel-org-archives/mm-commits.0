From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-new-hugetlb-cgroup.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:13 -0700
Message-ID: <20120613204613.EEEDAA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51860 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab2FMUqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:16 -0400
Received: by eaao13 with SMTP id o13so55041eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm/hugetlb: add new HugeTLB cgroup
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-new-hugetlb-cgroup.patch

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
Subject: mm/hugetlb: add new HugeTLB cgroup

Implement a new controller that allows us to control HugeTLB allocations. 
The extension allows to limit the HugeTLB usage per control group and
enforces the controller limit during page fault.  Since HugeTLB doesn't
support page reclaim, enforcing the limit at page fault time implies that,
the application will get SIGBUS signal if it tries to access HugeTLB pages
beyond its limit.  This requires the application to know beforehand how
much HugeTLB pages it would require for its use.

The charge/uncharge calls will be added to HugeTLB code in later patch. 
Support for cgroup removal will be added in later patches.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h  |    6 +
 include/linux/hugetlb_cgroup.h |   37 +++++++++
 init/Kconfig                   |   15 +++
 mm/Makefile                    |    1 
 mm/hugetlb_cgroup.c            |  122 +++++++++++++++++++++++++++++++
 5 files changed, 181 insertions(+)

diff -puN include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~mm-hugetlb-add-new-hugetlb-cgroup
+++ a/include/linux/cgroup_subsys.h
@@ -72,3 +72,9 @@ SUBSYS(net_prio)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+SUBSYS(hugetlb)
+#endif
+
+/* */
diff -puN /dev/null include/linux/hugetlb_cgroup.h
--- /dev/null
+++ a/include/linux/hugetlb_cgroup.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright IBM Corporation, 2012
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#ifndef _LINUX_HUGETLB_CGROUP_H
+#define _LINUX_HUGETLB_CGROUP_H
+
+#include <linux/res_counter.h>
+
+struct hugetlb_cgroup;
+
+#ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
+static inline bool hugetlb_cgroup_disabled(void)
+{
+	if (hugetlb_subsys.disabled)
+		return true;
+	return false;
+}
+
+#else
+static inline bool hugetlb_cgroup_disabled(void)
+{
+	return true;
+}
+
+#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
+#endif
diff -puN init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup init/Kconfig
--- a/init/Kconfig~mm-hugetlb-add-new-hugetlb-cgroup
+++ a/init/Kconfig
@@ -751,6 +751,21 @@ config CGROUP_MEM_RES_CTLR_KMEM
 	  the kmem extension can use it to guarantee that no group of processes
 	  will ever exhaust kernel resources alone.
 
+config CGROUP_HUGETLB_RES_CTLR
+	bool "HugeTLB Resource Controller for Control Groups"
+	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
+	default n
+	help
+	  Provides a cgroup Resource Controller for HugeTLB pages.
+	  When you enable this, you can put a per cgroup limit on HugeTLB usage.
+	  The limit is enforced during page fault. Since HugeTLB doesn't
+	  support page reclaim, enforcing the limit at page fault time implies
+	  that, the application will get SIGBUS signal if it tries to access
+	  HugeTLB pages beyond its limit. This requires the application to know
+	  beforehand how much HugeTLB pages it would require for its use. The
+	  control group is tracked in the third page lru pointer. This means
+	  that we cannot use the controller with huge page less than 3 pages.
+
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
 	depends on PERF_EVENTS && CGROUPS
diff -puN mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup mm/Makefile
--- a/mm/Makefile~mm-hugetlb-add-new-hugetlb-cgroup
+++ a/mm/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_CGROUP_HUGETLB_RES_CTLR) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
diff -puN /dev/null mm/hugetlb_cgroup.c
--- /dev/null
+++ a/mm/hugetlb_cgroup.c
@@ -0,0 +1,122 @@
+/*
+ *
+ * Copyright IBM Corporation, 2012
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
+
+struct hugetlb_cgroup {
+	struct cgroup_subsys_state css;
+	/*
+	 * the counter to account for hugepages from hugetlb.
+	 */
+	struct res_counter hugepage[HUGE_MAX_HSTATE];
+};
+
+struct cgroup_subsys hugetlb_subsys __read_mostly;
+struct hugetlb_cgroup *root_h_cgroup __read_mostly;
+
+static inline
+struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
+{
+	if (s)
+		return container_of(s, struct hugetlb_cgroup, css);
+	return NULL;
+}
+
+static inline
+struct hugetlb_cgroup *hugetlb_cgroup_from_cgroup(struct cgroup *cgroup)
+{
+	return hugetlb_cgroup_from_css(cgroup_subsys_state(cgroup,
+							   hugetlb_subsys_id));
+}
+
+static inline
+struct hugetlb_cgroup *hugetlb_cgroup_from_task(struct task_struct *task)
+{
+	return hugetlb_cgroup_from_css(task_subsys_state(task,
+							 hugetlb_subsys_id));
+}
+
+static inline bool hugetlb_cgroup_is_root(struct hugetlb_cgroup *h_cg)
+{
+	return (h_cg == root_h_cgroup);
+}
+
+static inline struct hugetlb_cgroup *parent_hugetlb_cgroup(struct cgroup *cg)
+{
+	if (!cg->parent)
+		return NULL;
+	return hugetlb_cgroup_from_cgroup(cg->parent);
+}
+
+static inline bool hugetlb_cgroup_have_usage(struct cgroup *cg)
+{
+	int idx;
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cg);
+
+	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
+		if ((res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE)) > 0)
+			return true;
+	}
+	return false;
+}
+
+static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
+{
+	int idx;
+	struct cgroup *parent_cgroup;
+	struct hugetlb_cgroup *h_cgroup, *parent_h_cgroup;
+
+	h_cgroup = kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
+	if (!h_cgroup)
+		return ERR_PTR(-ENOMEM);
+
+	parent_cgroup = cgroup->parent;
+	if (parent_cgroup) {
+		parent_h_cgroup = hugetlb_cgroup_from_cgroup(parent_cgroup);
+		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+			res_counter_init(&h_cgroup->hugepage[idx],
+					 &parent_h_cgroup->hugepage[idx]);
+	} else {
+		root_h_cgroup = h_cgroup;
+		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
+			res_counter_init(&h_cgroup->hugepage[idx], NULL);
+	}
+	return &h_cgroup->css;
+}
+
+static void hugetlb_cgroup_destroy(struct cgroup *cgroup)
+{
+	struct hugetlb_cgroup *h_cgroup;
+
+	h_cgroup = hugetlb_cgroup_from_cgroup(cgroup);
+	kfree(h_cgroup);
+}
+
+static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
+{
+	/* We will add the cgroup removal support in later patches */
+	   return -EBUSY;
+}
+
+struct cgroup_subsys hugetlb_subsys = {
+	.name = "hugetlb",
+	.create     = hugetlb_cgroup_create,
+	.pre_destroy = hugetlb_cgroup_pre_destroy,
+	.destroy    = hugetlb_cgroup_destroy,
+	.subsys_id  = hugetlb_subsys_id,
+};
_
Subject: Subject: mm/hugetlb: add new HugeTLB cgroup

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

