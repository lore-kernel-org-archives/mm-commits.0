From: akpm@linux-foundation.org
Subject: + memory-cgroup-hierarchy-feature-selector-v4.patch added to -mm tree
Date: Tue, 18 Nov 2008 15:32:07 -0800
Message-ID: <200811182332.mAINW7qI026448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbYKRXcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 18:32:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: memory cgroup hierarchy feature selector
has been added to the -mm tree.  Its filename is
     memory-cgroup-hierarchy-feature-selector-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory cgroup hierarchy feature selector
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Don't enable multiple hierarchy support by default.  This patch introduces
a features element that can be set to enable the nested depth hierarchy
feature.  This feature can only be enabled when the cgroup for which the
feature this is enabled, has no children.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-hierarchy-feature-selector-v4
+++ a/mm/memcontrol.c
@@ -149,6 +149,10 @@ struct mem_cgroup {
 	 * reclaimed from. Protected by cgroup_lock()
 	 */
 	struct mem_cgroup *last_scanned_child;
+	/*
+	 * Should the accounting and control be hierarchical, per subtree?
+	 */
+	unsigned long use_hierarchy;
 
 	int		obsolete;
 	atomic_t	refcnt;
@@ -1538,6 +1542,44 @@ int mem_cgroup_force_empty_write(struct 
 }
 
 
+static u64 mem_cgroup_hierarchy_read(struct cgroup *cont, struct cftype *cft)
+{
+	return mem_cgroup_from_cont(cont)->use_hierarchy;
+}
+
+static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
+					u64 val)
+{
+	int retval = 0;
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
+	struct cgroup *parent = cont->parent;
+	struct mem_cgroup *parent_mem = NULL;
+
+	if (parent)
+		parent_mem = mem_cgroup_from_cont(parent);
+
+	cgroup_lock();
+	/*
+	 * If parent's use_hiearchy is set, we can't make any modifications
+	 * in the child subtrees. If it is unset, then the change can
+	 * occur, provided the current cgroup has no children.
+	 *
+	 * For the root cgroup, parent_mem is NULL, we allow value to be
+	 * set if there are no children.
+	 */
+	if (!parent_mem || (!parent_mem->use_hierarchy &&
+				(val == 1 || val == 0))) {
+		if (list_empty(&cont->children))
+			mem->use_hierarchy = val;
+		else
+			retval = -EBUSY;
+	} else
+		retval = -EINVAL;
+	cgroup_unlock();
+
+	return retval;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
@@ -1701,6 +1743,11 @@ static struct cftype mem_cgroup_files[] 
 		.name = "force_empty",
 		.trigger = mem_cgroup_force_empty_write,
 	},
+	{
+		.name = "use_hierarchy",
+		.write_u64 = mem_cgroup_hierarchy_write,
+		.read_u64 = mem_cgroup_hierarchy_read,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
@@ -1876,12 +1923,18 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (cont->parent == NULL) {
 		enable_swap_cgroup();
 		parent = NULL;
-	} else
+	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
+		mem->use_hierarchy = parent->use_hierarchy;
+	}
 
-	res_counter_init(&mem->res, parent ? &parent->res : NULL);
-	res_counter_init(&mem->memsw, parent ? &parent->memsw : NULL);
-
+	if (parent && parent->use_hierarchy) {
+		res_counter_init(&mem->res, &parent->res);
+		res_counter_init(&mem->memsw, &parent->memsw);
+	} else {
+		res_counter_init(&mem->res, NULL);
+		res_counter_init(&mem->memsw, NULL);
+	}
 
 	mem->last_scanned_child = NULL;
 
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchy-feature-selector-v4.patch

