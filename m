Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7675C388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B90207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3CG60wK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgKJWWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732177AbgKJWWF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:22:05 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75EFF206B2;
        Tue, 10 Nov 2020 22:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605046924;
        bh=1U5Sd0eUcja9HTZiGmVznz27lNb2PKDiEZ9tFHSxmyI=;
        h=Date:From:To:Subject:From;
        b=P3CG60wKbWu9tkhZ7u20JgxoN8uQtu3QE+CddI6LyI+yVNvKFvxCrkDQn+NzxacMP
         wCz36O4/+WC4Lla+MqJ0gF0We0f3RWmSJ+UcbTi0lG8OMFPF54y8pK5aoi45vORdwI
         /vPzYb5Q32bRdIO2MkD48ggiDJuM1cPEhRTaUOu4=
Date:   Tue, 10 Nov 2020 14:22:03 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, tj@kernel.org
Subject:  + mm-memcg-deprecate-the-non-hierarchical-mode.patch
 added to -mm tree
Message-ID: <20201110222203.JPXKd0Dqc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: deprecate the non-hierarchical mode
has been added to the -mm tree.  Its filename is
     mm-memcg-deprecate-the-non-hierarchical-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-deprecate-the-non-hierarchical-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-deprecate-the-non-hierarchical-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -775,8 +770,6 @@ static inline bool mem_cgroup_is_descend
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
@@ -1132,12 +1132,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
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
@@ -1217,7 +1211,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 out_unlock:
 	rcu_read_unlock();
-out:
 	if (prev && prev != root)
 		css_put(&prev->css);
 
@@ -3408,10 +3401,7 @@ unsigned long mem_cgroup_soft_limit_recl
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
@@ -3471,37 +3461,20 @@ static ssize_t mem_cgroup_force_empty_wr
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
@@ -3689,8 +3662,6 @@ static void memcg_offline_kmem(struct me
 		child = mem_cgroup_from_css(css);
 		BUG_ON(child->kmemcg_id != kmemcg_id);
 		child->kmemcg_id = parent->kmemcg_id;
-		if (!memcg->use_hierarchy)
-			break;
 	}
 	rcu_read_unlock();
 
@@ -5281,38 +5252,22 @@ mem_cgroup_css_alloc(struct cgroup_subsy
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
@@ -6149,24 +6104,6 @@ static void mem_cgroup_move_task(void)
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
@@ -6504,7 +6441,6 @@ struct cgroup_subsys memory_cgrp_subsys
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.post_attach = mem_cgroup_move_task,
-	.bind = mem_cgroup_bind,
 	.dfl_cftypes = memory_files,
 	.legacy_cftypes = mem_cgroup_legacy_files,
 	.early_init = 0,
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

