Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80434964E
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720038737; cv=none; b=qPV1IuElDN4APoVsTZfIjvr3KV0WozbRWsi5dowBJ5mK0hWDX76TGpGyTH9snJCVY7ASKyEivYO+hgaNm7e5BDn4STWMuDunwaxXdAjq+jTmguTj6wf/uaDS8+9dUdgpFBw3Eqv0FYwsFnG28XG3vhRia8XYb3EAX2qk+6Vc3PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720038737; c=relaxed/simple;
	bh=1Gy+Rkv6fHCnn90DlQRVsWHged07MHKU9hTO2Ymnvdc=;
	h=Date:To:From:Subject:Message-Id; b=tyic18sirOnNiMQ/kD3a1lfQGFz3A1VeXrAuX+dF9nUDJ8w/rv3V7NmLVcPeRVsLLUP0E5P23xaHknQArl7ZVeVH/gmSXLRBaScnv5xnuS2Q1cKXqOqUhuaejzLPrQX2Np9Hz5u+HOdD17rGVaXMdskaW6GuYI0R2lvcEYQ0Q2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TvT0v+eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TvT0v+eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F3DC2BD10;
	Wed,  3 Jul 2024 20:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720038737;
	bh=1Gy+Rkv6fHCnn90DlQRVsWHged07MHKU9hTO2Ymnvdc=;
	h=Date:To:From:Subject:From;
	b=TvT0v+eMgb0FU0OSzu/shAbb+RHezTZa+4FPeCxKPpUOtiHxZpwnUGce9h4zah4FT
	 mEKxVcM48qY06a1HBxN0X0TnFnIk9pw7P1JuZvgSUL6xHAa4hY3LxRBDWT+qnRCZsM
	 Om2dh6gFAztRze+rIey4AUMV5L7RpExBJOb0CsJ0=
Date: Wed, 03 Jul 2024 13:32:16 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,maarten.lankhorst@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_counter-move-calculating-protection-values-to-page_counter.patch added to mm-unstable branch
Message-Id: <20240703203217.24F3DC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_counter: move calculating protection values to page_counter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_counter-move-calculating-protection-values-to-page_counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_counter-move-calculating-protection-values-to-page_counter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: mm/page_counter: move calculating protection values to page_counter
Date: Wed, 3 Jul 2024 13:25:10 +0200

It's a lot of math, and there is nothing memcontrol specific about it. 
This makes it easier to use inside of the drm cgroup controller.

Link: https://lkml.kernel.org/r/20240703112510.36424-1-maarten.lankhorst@linux.intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    4 
 mm/memcontrol.c              |  154 -----------------------------
 mm/page_counter.c            |  173 +++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+), 151 deletions(-)

--- a/include/linux/page_counter.h~mm-page_counter-move-calculating-protection-values-to-page_counter
+++ a/include/linux/page_counter.h
@@ -81,4 +81,8 @@ static inline void page_counter_reset_wa
 	counter->watermark = page_counter_read(counter);
 }
 
+void page_counter_calculate_protection(struct page_counter *root,
+				       struct page_counter *counter,
+				       bool recursive_protection);
+
 #endif /* _LINUX_PAGE_COUNTER_H */
--- a/mm/memcontrol.c~mm-page_counter-move-calculating-protection-values-to-page_counter
+++ a/mm/memcontrol.c
@@ -4428,122 +4428,6 @@ struct cgroup_subsys memory_cgrp_subsys
 	.early_init = 0,
 };
 
-/*
- * This function calculates an individual cgroup's effective
- * protection which is derived from its own memory.min/low, its
- * parent's and siblings' settings, as well as the actual memory
- * distribution in the tree.
- *
- * The following rules apply to the effective protection values:
- *
- * 1. At the first level of reclaim, effective protection is equal to
- *    the declared protection in memory.min and memory.low.
- *
- * 2. To enable safe delegation of the protection configuration, at
- *    subsequent levels the effective protection is capped to the
- *    parent's effective protection.
- *
- * 3. To make complex and dynamic subtrees easier to configure, the
- *    user is allowed to overcommit the declared protection at a given
- *    level. If that is the case, the parent's effective protection is
- *    distributed to the children in proportion to how much protection
- *    they have declared and how much of it they are utilizing.
- *
- *    This makes distribution proportional, but also work-conserving:
- *    if one cgroup claims much more protection than it uses memory,
- *    the unused remainder is available to its siblings.
- *
- * 4. Conversely, when the declared protection is undercommitted at a
- *    given level, the distribution of the larger parental protection
- *    budget is NOT proportional. A cgroup's protection from a sibling
- *    is capped to its own memory.min/low setting.
- *
- * 5. However, to allow protecting recursive subtrees from each other
- *    without having to declare each individual cgroup's fixed share
- *    of the ancestor's claim to protection, any unutilized -
- *    "floating" - protection from up the tree is distributed in
- *    proportion to each cgroup's *usage*. This makes the protection
- *    neutral wrt sibling cgroups and lets them compete freely over
- *    the shared parental protection budget, but it protects the
- *    subtree as a whole from neighboring subtrees.
- *
- * Note that 4. and 5. are not in conflict: 4. is about protecting
- * against immediate siblings whereas 5. is about protecting against
- * neighboring subtrees.
- */
-static unsigned long effective_protection(unsigned long usage,
-					  unsigned long parent_usage,
-					  unsigned long setting,
-					  unsigned long parent_effective,
-					  unsigned long siblings_protected)
-{
-	unsigned long protected;
-	unsigned long ep;
-
-	protected = min(usage, setting);
-	/*
-	 * If all cgroups at this level combined claim and use more
-	 * protection than what the parent affords them, distribute
-	 * shares in proportion to utilization.
-	 *
-	 * We are using actual utilization rather than the statically
-	 * claimed protection in order to be work-conserving: claimed
-	 * but unused protection is available to siblings that would
-	 * otherwise get a smaller chunk than what they claimed.
-	 */
-	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
-
-	/*
-	 * Ok, utilized protection of all children is within what the
-	 * parent affords them, so we know whatever this child claims
-	 * and utilizes is effectively protected.
-	 *
-	 * If there is unprotected usage beyond this value, reclaim
-	 * will apply pressure in proportion to that amount.
-	 *
-	 * If there is unutilized protection, the cgroup will be fully
-	 * shielded from reclaim, but we do return a smaller value for
-	 * protection than what the group could enjoy in theory. This
-	 * is okay. With the overcommit distribution above, effective
-	 * protection is always dependent on how memory is actually
-	 * consumed among the siblings anyway.
-	 */
-	ep = protected;
-
-	/*
-	 * If the children aren't claiming (all of) the protection
-	 * afforded to them by the parent, distribute the remainder in
-	 * proportion to the (unprotected) memory of each cgroup. That
-	 * way, cgroups that aren't explicitly prioritized wrt each
-	 * other compete freely over the allowance, but they are
-	 * collectively protected from neighboring trees.
-	 *
-	 * We're using unprotected memory for the weight so that if
-	 * some cgroups DO claim explicit protection, we don't protect
-	 * the same bytes twice.
-	 *
-	 * Check both usage and parent_usage against the respective
-	 * protected values. One should imply the other, but they
-	 * aren't read atomically - make sure the division is sane.
-	 */
-	if (!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT))
-		return ep;
-	if (parent_effective > siblings_protected &&
-	    parent_usage > siblings_protected &&
-	    usage > protected) {
-		unsigned long unclaimed;
-
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
-
-		ep += unclaimed;
-	}
-
-	return ep;
-}
-
 /**
  * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
@@ -4555,8 +4439,8 @@ static unsigned long effective_protectio
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg)
 {
-	unsigned long usage, parent_usage;
-	struct mem_cgroup *parent;
+	bool recursive_protection =
+		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -4564,39 +4448,7 @@ void mem_cgroup_calculate_protection(str
 	if (!root)
 		root = root_mem_cgroup;
 
-	/*
-	 * Effective values of the reclaim targets are ignored so they
-	 * can be stale. Have a look at mem_cgroup_protection for more
-	 * details.
-	 * TODO: calculation should be more robust so that we do not need
-	 * that special casing.
-	 */
-	if (memcg == root)
-		return;
-
-	usage = page_counter_read(&memcg->memory);
-	if (!usage)
-		return;
-
-	parent = parent_mem_cgroup(memcg);
-
-	if (parent == root) {
-		memcg->memory.emin = READ_ONCE(memcg->memory.min);
-		memcg->memory.elow = READ_ONCE(memcg->memory.low);
-		return;
-	}
-
-	parent_usage = page_counter_read(&parent->memory);
-
-	WRITE_ONCE(memcg->memory.emin, effective_protection(usage, parent_usage,
-			READ_ONCE(memcg->memory.min),
-			READ_ONCE(parent->memory.emin),
-			atomic_long_read(&parent->memory.children_min_usage)));
-
-	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
-			READ_ONCE(memcg->memory.low),
-			READ_ONCE(parent->memory.elow),
-			atomic_long_read(&parent->memory.children_low_usage)));
+	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
--- a/mm/page_counter.c~mm-page_counter-move-calculating-protection-values-to-page_counter
+++ a/mm/page_counter.c
@@ -262,3 +262,176 @@ int page_counter_memparse(const char *bu
 
 	return 0;
 }
+
+
+/*
+ * This function calculates an individual page counter's effective
+ * protection which is derived from its own memory.min/low, its
+ * parent's and siblings' settings, as well as the actual memory
+ * distribution in the tree.
+ *
+ * The following rules apply to the effective protection values:
+ *
+ * 1. At the first level of reclaim, effective protection is equal to
+ *    the declared protection in memory.min and memory.low.
+ *
+ * 2. To enable safe delegation of the protection configuration, at
+ *    subsequent levels the effective protection is capped to the
+ *    parent's effective protection.
+ *
+ * 3. To make complex and dynamic subtrees easier to configure, the
+ *    user is allowed to overcommit the declared protection at a given
+ *    level. If that is the case, the parent's effective protection is
+ *    distributed to the children in proportion to how much protection
+ *    they have declared and how much of it they are utilizing.
+ *
+ *    This makes distribution proportional, but also work-conserving:
+ *    if one counter claims much more protection than it uses memory,
+ *    the unused remainder is available to its siblings.
+ *
+ * 4. Conversely, when the declared protection is undercommitted at a
+ *    given level, the distribution of the larger parental protection
+ *    budget is NOT proportional. A counter's protection from a sibling
+ *    is capped to its own memory.min/low setting.
+ *
+ * 5. However, to allow protecting recursive subtrees from each other
+ *    without having to declare each individual counter's fixed share
+ *    of the ancestor's claim to protection, any unutilized -
+ *    "floating" - protection from up the tree is distributed in
+ *    proportion to each counter's *usage*. This makes the protection
+ *    neutral wrt sibling cgroups and lets them compete freely over
+ *    the shared parental protection budget, but it protects the
+ *    subtree as a whole from neighboring subtrees.
+ *
+ * Note that 4. and 5. are not in conflict: 4. is about protecting
+ * against immediate siblings whereas 5. is about protecting against
+ * neighboring subtrees.
+ */
+static unsigned long effective_protection(unsigned long usage,
+					  unsigned long parent_usage,
+					  unsigned long setting,
+					  unsigned long parent_effective,
+					  unsigned long siblings_protected,
+					  bool recursive_protection)
+{
+	unsigned long protected;
+	unsigned long ep;
+
+	protected = min(usage, setting);
+	/*
+	 * If all cgroups at this level combined claim and use more
+	 * protection than what the parent affords them, distribute
+	 * shares in proportion to utilization.
+	 *
+	 * We are using actual utilization rather than the statically
+	 * claimed protection in order to be work-conserving: claimed
+	 * but unused protection is available to siblings that would
+	 * otherwise get a smaller chunk than what they claimed.
+	 */
+	if (siblings_protected > parent_effective)
+		return protected * parent_effective / siblings_protected;
+
+	/*
+	 * Ok, utilized protection of all children is within what the
+	 * parent affords them, so we know whatever this child claims
+	 * and utilizes is effectively protected.
+	 *
+	 * If there is unprotected usage beyond this value, reclaim
+	 * will apply pressure in proportion to that amount.
+	 *
+	 * If there is unutilized protection, the cgroup will be fully
+	 * shielded from reclaim, but we do return a smaller value for
+	 * protection than what the group could enjoy in theory. This
+	 * is okay. With the overcommit distribution above, effective
+	 * protection is always dependent on how memory is actually
+	 * consumed among the siblings anyway.
+	 */
+	ep = protected;
+
+	/*
+	 * If the children aren't claiming (all of) the protection
+	 * afforded to them by the parent, distribute the remainder in
+	 * proportion to the (unprotected) memory of each cgroup. That
+	 * way, cgroups that aren't explicitly prioritized wrt each
+	 * other compete freely over the allowance, but they are
+	 * collectively protected from neighboring trees.
+	 *
+	 * We're using unprotected memory for the weight so that if
+	 * some cgroups DO claim explicit protection, we don't protect
+	 * the same bytes twice.
+	 *
+	 * Check both usage and parent_usage against the respective
+	 * protected values. One should imply the other, but they
+	 * aren't read atomically - make sure the division is sane.
+	 */
+	if (!recursive_protection)
+		return ep;
+
+	if (parent_effective > siblings_protected &&
+	    parent_usage > siblings_protected &&
+	    usage > protected) {
+		unsigned long unclaimed;
+
+		unclaimed = parent_effective - siblings_protected;
+		unclaimed *= usage - protected;
+		unclaimed /= parent_usage - siblings_protected;
+
+		ep += unclaimed;
+	}
+
+	return ep;
+}
+
+
+/**
+ * page_counter_calculate_protection - check if memory consumption is in the normal range
+ * @root: the top ancestor of the sub-tree being checked
+ * @memcg: the memory cgroup to check
+ * @recursive_protection: Whether to use memory_recursiveprot behavior.
+ *
+ * Calculates elow/emin thresholds for given page_counter.
+ *
+ * WARNING: This function is not stateless! It can only be used as part
+ *          of a top-down tree iteration, not for isolated queries.
+ */
+void page_counter_calculate_protection(struct page_counter *root,
+				       struct page_counter *counter,
+				       bool recursive_protection)
+{
+	unsigned long usage, parent_usage;
+	struct page_counter *parent = counter->parent;
+
+	/*
+	 * Effective values of the reclaim targets are ignored so they
+	 * can be stale. Have a look at mem_cgroup_protection for more
+	 * details.
+	 * TODO: calculation should be more robust so that we do not need
+	 * that special casing.
+	 */
+	if (root == counter)
+		return;
+
+	usage = page_counter_read(counter);
+	if (!usage)
+		return;
+
+	if (parent == root) {
+		counter->emin = READ_ONCE(counter->min);
+		counter->elow = READ_ONCE(counter->low);
+		return;
+	}
+
+	parent_usage = page_counter_read(parent);
+
+	WRITE_ONCE(counter->emin, effective_protection(usage, parent_usage,
+			READ_ONCE(counter->min),
+			READ_ONCE(parent->emin),
+			atomic_long_read(&parent->children_min_usage),
+			recursive_protection));
+
+	WRITE_ONCE(counter->elow, effective_protection(usage, parent_usage,
+			READ_ONCE(counter->low),
+			READ_ONCE(parent->elow),
+			atomic_long_read(&parent->children_low_usage),
+			recursive_protection));
+}
_

Patches currently in -mm which might be from maarten.lankhorst@linux.intel.com are

mm-page_counter-move-calculating-protection-values-to-page_counter.patch

