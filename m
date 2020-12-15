Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B59C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E194E20731
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgLODaf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgLODHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:05 -0500
Date:   Mon, 14 Dec 2020 19:06:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001609;
        bh=HEfhJlqXltI2hWCIwuex+N7adj9kBTU0iRXRWi+Oqlg=;
        h=From:To:Subject:In-Reply-To:From;
        b=MB1r48hulgDaHvt0nAWACNOV6QiTcC092667Kc5Uw4gXGrYPhY0xVNfHfasSegPn2
         TY+ELeMgQZUnR/ZXknUZI0bYz0FIwgzFBadDJqfC1Ma4YcFJkuCfQ+Zg4ak2RI0bHU
         wUo5qu/S4pWeJNE9oYEJFEIzj5VRhLPMlQl3jQmU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 063/200] mm: memcg: deprecate the non-hierarchical
 mode
Message-ID: <20201215030649.lUq4Br7fB%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: deprecate the non-hierarchical mode

Patch series "mm: memcg: deprecate cgroup v1 non-hierarchical mode", v1.

The non-hierarchical cgroup v1 mode is a legacy of early days
of the memory controller and doesn't bring any value today.
However, it complicates the code and creates many edge cases
all over the memory controller code.

It's a good time to deprecate it completely. This patchset removes
the internal logic, adjusts the user interface and updates
the documentation. The alt patch removes some bits of the cgroup
core code, which become obsolete.

Michal Hocko said:

: All that we know today is that we have a warning in place to complain
: loudly when somebody relies on use_hierarchy=0 with a deeper hierarchy. 
: For all those years we have seen _zero_ reports that would describe a
: sensible usecase.
: 
: Moreover we (SUSE) have backported this warning into old distribution
: kernels (since 3.0 based kernels) to extend the coverage and didn't hear
: even for users who adopt new kernels only very slowly.  The only report we
: have seen so far was a LTP test suite which doesn't really reflect any
: real life usecase.


This patch (of 3):

The non-hierarchical cgroup v1 mode is a legacy of early days of the
memory controller and doesn't bring any value today.  However, it
complicates the code and creates many edge cases all over the memory
controller code.

It's a good time to deprecate it completely.

Functionally this patch enabled is by default for all cgroups and forbids
switching it off.  Nothing changes if cgroup v2 is used: hierarchical mode
was enforced from scratch.

To protect the ABI memory.use_hierarchy interface is preserved with a
limited functionality: reading always returns "1", writing of "1" passes
silently, writing of any other value fails with -EINVAL and a warning to
dmesg (on the first occasion).

Link: https://lkml.kernel.org/r/20201110220800.929549-1-guro@fb.com
Link: https://lkml.kernel.org/r/20201110220800.929549-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 --
 kernel/cgroup/cgroup.c     |    5 -
 mm/memcontrol.c            |   90 +++++------------------------------
 3 files changed, 13 insertions(+), 89 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-deprecate-the-non-hierarchical-mode
+++ a/include/linux/memcontrol.h
@@ -235,11 +235,6 @@ struct mem_cgroup {
 	struct vmpressure vmpressure;
 
 	/*
-	 * Should the accounting and control be hierarchical, per subtree?
-	 */
-	bool use_hierarchy;
-
-	/*
 	 * Should the OOM killer kill all belonging tasks, had it kill one?
 	 */
 	bool oom_group;
@@ -588,8 +583,6 @@ static inline bool mem_cgroup_is_descend
 {
 	if (root == memcg)
 		return true;
-	if (!root->use_hierarchy)
-		return false;
 	return cgroup_is_descendant(memcg->css.cgroup, root->css.cgroup);
 }
 
--- a/kernel/cgroup/cgroup.c~mm-memcg-deprecate-the-non-hierarchical-mode
+++ a/kernel/cgroup/cgroup.c
@@ -281,9 +281,6 @@ bool cgroup_ssid_enabled(int ssid)
  * - cpuset: a task can be moved into an empty cpuset, and again it takes
  *   masks of ancestors.
  *
- * - memcg: use_hierarchy is on by default and the cgroup file for the flag
- *   is not created.
- *
  * - blkcg: blk-throttle becomes properly hierarchical.
  *
  * - debug: disallowed on the default hierarchy.
@@ -5156,8 +5153,6 @@ static struct cgroup_subsys_state *css_c
 	    cgroup_parent(parent)) {
 		pr_warn("%s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
 			current->comm, current->pid, ss->name);
-		if (!strcmp(ss->name, "memory"))
-			pr_warn("\"memory\" requires setting use_hierarchy to 1 on the root\n");
 		ss->warned_broken_hierarchy = true;
 	}
 
--- a/mm/memcontrol.c~mm-memcg-deprecate-the-non-hierarchical-mode
+++ a/mm/memcontrol.c
@@ -1141,12 +1141,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (prev && !reclaim)
 		pos = prev;
 
-	if (!root->use_hierarchy && root != root_mem_cgroup) {
-		if (prev)
-			goto out;
-		return root;
-	}
-
 	rcu_read_lock();
 
 	if (reclaim) {
@@ -1226,7 +1220,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 out_unlock:
 	rcu_read_unlock();
-out:
 	if (prev && prev != root)
 		css_put(&prev->css);
 
@@ -3461,10 +3454,7 @@ unsigned long mem_cgroup_soft_limit_recl
 }
 
 /*
- * Test whether @memcg has children, dead or alive.  Note that this
- * function doesn't care whether @memcg has use_hierarchy enabled and
- * returns %true if there are child csses according to the cgroup
- * hierarchy.  Testing use_hierarchy is the caller's responsibility.
+ * Test whether @memcg has children, dead or alive.
  */
 static inline bool memcg_has_children(struct mem_cgroup *memcg)
 {
@@ -3524,37 +3514,20 @@ static ssize_t mem_cgroup_force_empty_wr
 static u64 mem_cgroup_hierarchy_read(struct cgroup_subsys_state *css,
 				     struct cftype *cft)
 {
-	return mem_cgroup_from_css(css)->use_hierarchy;
+	return 1;
 }
 
 static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
 				      struct cftype *cft, u64 val)
 {
-	int retval = 0;
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent_memcg = mem_cgroup_from_css(memcg->css.parent);
-
-	if (memcg->use_hierarchy == val)
+	if (val == 1)
 		return 0;
 
-	/*
-	 * If parent's use_hierarchy is set, we can't make any modifications
-	 * in the child subtrees. If it is unset, then the change can
-	 * occur, provided the current cgroup has no children.
-	 *
-	 * For the root cgroup, parent_mem is NULL, we allow value to be
-	 * set if there are no children.
-	 */
-	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
-				(val == 1 || val == 0)) {
-		if (!memcg_has_children(memcg))
-			memcg->use_hierarchy = val;
-		else
-			retval = -EBUSY;
-	} else
-		retval = -EINVAL;
+	pr_warn_once("Non-hierarchical mode is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
 
-	return retval;
+	return -EINVAL;
 }
 
 static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
@@ -3742,8 +3715,6 @@ static void memcg_offline_kmem(struct me
 		child = mem_cgroup_from_css(css);
 		BUG_ON(child->kmemcg_id != kmemcg_id);
 		child->kmemcg_id = parent->kmemcg_id;
-		if (!memcg->use_hierarchy)
-			break;
 	}
 	rcu_read_unlock();
 
@@ -5334,38 +5305,22 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
-	}
-	if (!parent) {
-		page_counter_init(&memcg->memory, NULL);
-		page_counter_init(&memcg->swap, NULL);
-		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcpmem, NULL);
-	} else if (parent->use_hierarchy) {
-		memcg->use_hierarchy = true;
+
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
-		page_counter_init(&memcg->memory, &root_mem_cgroup->memory);
-		page_counter_init(&memcg->swap, &root_mem_cgroup->swap);
-		page_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
-		page_counter_init(&memcg->tcpmem, &root_mem_cgroup->tcpmem);
-		/*
-		 * Deeper hierachy with use_hierarchy == false doesn't make
-		 * much sense so let cgroup subsystem know about this
-		 * unfortunate state in our controller.
-		 */
-		if (parent != root_mem_cgroup)
-			memory_cgrp_subsys.broken_hierarchy = true;
-	}
+		page_counter_init(&memcg->memory, NULL);
+		page_counter_init(&memcg->swap, NULL);
+		page_counter_init(&memcg->kmem, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
 
-	/* The following stuff does not apply to the root */
-	if (!parent) {
 		root_mem_cgroup = memcg;
 		return &memcg->css;
 	}
 
+	/* The following stuff does not apply to the root */
 	error = memcg_online_kmem(memcg);
 	if (error)
 		goto fail;
@@ -6202,24 +6157,6 @@ static void mem_cgroup_move_task(void)
 }
 #endif
 
-/*
- * Cgroup retains root cgroups across [un]mount cycles making it necessary
- * to verify whether we're attached to the default hierarchy on each mount
- * attempt.
- */
-static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
-{
-	/*
-	 * use_hierarchy is forced on the default hierarchy.  cgroup core
-	 * guarantees that @root doesn't have any children, so turning it
-	 * on for the root memcg is enough.
-	 */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		root_mem_cgroup->use_hierarchy = true;
-	else
-		root_mem_cgroup->use_hierarchy = false;
-}
-
 static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
 {
 	if (value == PAGE_COUNTER_MAX)
@@ -6557,7 +6494,6 @@ struct cgroup_subsys memory_cgrp_subsys
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.post_attach = mem_cgroup_move_task,
-	.bind = mem_cgroup_bind,
 	.dfl_cftypes = memory_files,
 	.legacy_cftypes = mem_cgroup_legacy_files,
 	.early_init = 0,
_
