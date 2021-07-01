Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16ADC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE11761474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhGABxk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238468AbhGABxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5D161468;
        Thu,  1 Jul 2021 01:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104270;
        bh=JnVUbSLfZsZmoOyg28767H4B8Pe64nRGdlXby+6qmPY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zvykVeDhZZ97bfxv8Kicgwr0bX6Ch1bsxTMmIUv1HOg61G4ljIRz9kz0Y52u8TflQ
         lrAimpfj3c6SVyv+cVjCHu4GjXhufyA9oZooU2Mp2CMfW+zitsLU6fIFLFDxwwcuoN
         KZHj/nsoHKQ3S5NnXAYwycELQ46fTjHdWljQwGDQ=
Date:   Wed, 30 Jun 2021 18:51:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org,
        ben.widawsky@intel.com, dave.hansen@intel.com, feng.tang@intel.com,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 075/192] mm/mempolicy: use unified 'nodes' for
 bind/interleave/prefer policies
Message-ID: <20210701015110.uKksWhAPf%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/mempolicy: use unified 'nodes' for bind/interleave/prefer policies

Current structure 'mempolicy' uses a union to store the node info for
bind/interleave/perfer policies.

	union {
		short 		 preferred_node; /* preferred */
		nodemask_t	 nodes;		/* interleave/bind */
		/* undefined for default */
	} v;

Since preferred node can also be represented by a nodemask_t with only ont
bit set, unify these policies with using one nodemask_t 'nodes', which can
remove a union, simplify the code and make it easier to support future's
new policy's node info.

Link: https://lore.kernel.org/r/20200630212517.308045-7-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1623399825-75651-1-git-send-email-feng.tang@intel.com
Co-developed-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    7 --
 mm/mempolicy.c            |   96 ++++++++++++++++--------------------
 2 files changed, 46 insertions(+), 57 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-use-unified-nodes-for-bind-interleave-prefer-policies
+++ a/include/linux/mempolicy.h
@@ -46,11 +46,8 @@ struct mempolicy {
 	atomic_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
-	union {
-		short 		 preferred_node; /* preferred */
-		nodemask_t	 nodes;		/* interleave/bind */
-		/* undefined for default */
-	} v;
+	nodemask_t nodes;	/* interleave/bind/perfer */
+
 	union {
 		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
 		nodemask_t user_nodemask;	/* nodemask passed by user */
--- a/mm/mempolicy.c~mm-mempolicy-use-unified-nodes-for-bind-interleave-prefer-policies
+++ a/mm/mempolicy.c
@@ -193,7 +193,7 @@ static int mpol_new_interleave(struct me
 {
 	if (nodes_empty(*nodes))
 		return -EINVAL;
-	pol->v.nodes = *nodes;
+	pol->nodes = *nodes;
 	return 0;
 }
 
@@ -201,7 +201,9 @@ static int mpol_new_preferred(struct mem
 {
 	if (nodes_empty(*nodes))
 		return -EINVAL;
-	pol->v.preferred_node = first_node(*nodes);
+
+	nodes_clear(pol->nodes);
+	node_set(first_node(*nodes), pol->nodes);
 	return 0;
 }
 
@@ -209,7 +211,7 @@ static int mpol_new_bind(struct mempolic
 {
 	if (nodes_empty(*nodes))
 		return -EINVAL;
-	pol->v.nodes = *nodes;
+	pol->nodes = *nodes;
 	return 0;
 }
 
@@ -324,7 +326,7 @@ static void mpol_rebind_nodemask(struct
 	else if (pol->flags & MPOL_F_RELATIVE_NODES)
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 	else {
-		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
+		nodes_remap(tmp, pol->nodes, pol->w.cpuset_mems_allowed,
 								*nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
@@ -332,7 +334,7 @@ static void mpol_rebind_nodemask(struct
 	if (nodes_empty(tmp))
 		tmp = *nodes;
 
-	pol->v.nodes = tmp;
+	pol->nodes = tmp;
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
@@ -897,15 +899,12 @@ static void get_policy_nodemask(struct m
 	switch (p->mode) {
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		*nodes = p->v.nodes;
+	case MPOL_PREFERRED:
+		*nodes = p->nodes;
 		break;
 	case MPOL_LOCAL:
 		/* return empty node mask for local allocation */
 		break;
-
-	case MPOL_PREFERRED:
-		node_set(p->v.preferred_node, *nodes);
-		break;
 	default:
 		BUG();
 	}
@@ -989,7 +988,7 @@ static long do_get_mempolicy(int *policy
 			*policy = err;
 		} else if (pol == current->mempolicy &&
 				pol->mode == MPOL_INTERLEAVE) {
-			*policy = next_node_in(current->il_prev, pol->v.nodes);
+			*policy = next_node_in(current->il_prev, pol->nodes);
 		} else {
 			err = -EINVAL;
 			goto out;
@@ -1857,14 +1856,14 @@ static int apply_policy_zone(struct memp
 	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
 
 	/*
-	 * if policy->v.nodes has movable memory only,
+	 * if policy->nodes has movable memory only,
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
 	 *
-	 * policy->v.nodes is intersect with node_states[N_MEMORY].
+	 * policy->nodes is intersect with node_states[N_MEMORY].
 	 * so if the following test fails, it implies
-	 * policy->v.nodes has movable memory only.
+	 * policy->nodes has movable memory only.
 	 */
-	if (!nodes_intersects(policy->v.nodes, node_states[N_HIGH_MEMORY]))
+	if (!nodes_intersects(policy->nodes, node_states[N_HIGH_MEMORY]))
 		dynamic_policy_zone = ZONE_MOVABLE;
 
 	return zone >= dynamic_policy_zone;
@@ -1879,8 +1878,8 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 	/* Lower zones don't get a nodemask applied for MPOL_BIND */
 	if (unlikely(policy->mode == MPOL_BIND) &&
 			apply_policy_zone(policy, gfp_zone(gfp)) &&
-			cpuset_nodemask_valid_mems_allowed(&policy->v.nodes))
-		return &policy->v.nodes;
+			cpuset_nodemask_valid_mems_allowed(&policy->nodes))
+		return &policy->nodes;
 
 	return NULL;
 }
@@ -1889,7 +1888,7 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 static int policy_node(gfp_t gfp, struct mempolicy *policy, int nd)
 {
 	if (policy->mode == MPOL_PREFERRED) {
-		nd = policy->v.preferred_node;
+		nd = first_node(policy->nodes);
 	} else {
 		/*
 		 * __GFP_THISNODE shouldn't even be used with the bind policy
@@ -1908,7 +1907,7 @@ static unsigned interleave_nodes(struct
 	unsigned next;
 	struct task_struct *me = current;
 
-	next = next_node_in(me->il_prev, policy->v.nodes);
+	next = next_node_in(me->il_prev, policy->nodes);
 	if (next < MAX_NUMNODES)
 		me->il_prev = next;
 	return next;
@@ -1932,7 +1931,7 @@ unsigned int mempolicy_slab_node(void)
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
-		return policy->v.preferred_node;
+		return first_node(policy->nodes);
 
 	case MPOL_INTERLEAVE:
 		return interleave_nodes(policy);
@@ -1948,7 +1947,7 @@ unsigned int mempolicy_slab_node(void)
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
 		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
-							&policy->v.nodes);
+							&policy->nodes);
 		return z->zone ? zone_to_nid(z->zone) : node;
 	}
 	case MPOL_LOCAL:
@@ -1961,12 +1960,12 @@ unsigned int mempolicy_slab_node(void)
 
 /*
  * Do static interleaving for a VMA with known offset @n.  Returns the n'th
- * node in pol->v.nodes (starting from n=0), wrapping around if n exceeds the
+ * node in pol->nodes (starting from n=0), wrapping around if n exceeds the
  * number of present nodes.
  */
 static unsigned offset_il_node(struct mempolicy *pol, unsigned long n)
 {
-	unsigned nnodes = nodes_weight(pol->v.nodes);
+	unsigned nnodes = nodes_weight(pol->nodes);
 	unsigned target;
 	int i;
 	int nid;
@@ -1974,9 +1973,9 @@ static unsigned offset_il_node(struct me
 	if (!nnodes)
 		return numa_node_id();
 	target = (unsigned int)n % nnodes;
-	nid = first_node(pol->v.nodes);
+	nid = first_node(pol->nodes);
 	for (i = 0; i < target; i++)
-		nid = next_node(nid, pol->v.nodes);
+		nid = next_node(nid, pol->nodes);
 	return nid;
 }
 
@@ -2032,7 +2031,7 @@ int huge_node(struct vm_area_struct *vma
 	} else {
 		nid = policy_node(gfp_flags, *mpol, numa_node_id());
 		if ((*mpol)->mode == MPOL_BIND)
-			*nodemask = &(*mpol)->v.nodes;
+			*nodemask = &(*mpol)->nodes;
 	}
 	return nid;
 }
@@ -2056,7 +2055,6 @@ int huge_node(struct vm_area_struct *vma
 bool init_nodemask_of_mempolicy(nodemask_t *mask)
 {
 	struct mempolicy *mempolicy;
-	int nid;
 
 	if (!(mask && current->mempolicy))
 		return false;
@@ -2065,18 +2063,13 @@ bool init_nodemask_of_mempolicy(nodemask
 	mempolicy = current->mempolicy;
 	switch (mempolicy->mode) {
 	case MPOL_PREFERRED:
-		nid = mempolicy->v.preferred_node;
-		init_nodemask_of_node(mask, nid);
-		break;
-
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		*mask = mempolicy->v.nodes;
+		*mask = mempolicy->nodes;
 		break;
 
 	case MPOL_LOCAL:
-		nid = numa_node_id();
-		init_nodemask_of_node(mask, nid);
+		init_nodemask_of_node(mask, numa_node_id());
 		break;
 
 	default:
@@ -2110,7 +2103,7 @@ bool mempolicy_in_oom_domain(struct task
 	task_lock(tsk);
 	mempolicy = tsk->mempolicy;
 	if (mempolicy && mempolicy->mode == MPOL_BIND)
-		ret = nodes_intersects(mempolicy->v.nodes, *mask);
+		ret = nodes_intersects(mempolicy->nodes, *mask);
 	task_unlock(tsk);
 
 	return ret;
@@ -2184,7 +2177,7 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		 * node in its nodemask, we allocate the standard way.
 		 */
 		if (pol->mode == MPOL_PREFERRED)
-			hpage_node = pol->v.preferred_node;
+			hpage_node = first_node(pol->nodes);
 
 		nmask = policy_nodemask(gfp, pol);
 		if (!nmask || node_isset(hpage_node, *nmask)) {
@@ -2317,9 +2310,8 @@ bool __mpol_equal(struct mempolicy *a, s
 	switch (a->mode) {
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
-		return a->v.preferred_node == b->v.preferred_node;
+		return !!nodes_equal(a->nodes, b->nodes);
 	case MPOL_LOCAL:
 		return true;
 	default:
@@ -2459,7 +2451,7 @@ int mpol_misplaced(struct page *page, st
 		break;
 
 	case MPOL_PREFERRED:
-		polnid = pol->v.preferred_node;
+		polnid = first_node(pol->nodes);
 		break;
 
 	case MPOL_LOCAL:
@@ -2469,7 +2461,7 @@ int mpol_misplaced(struct page *page, st
 	case MPOL_BIND:
 		/* Optimize placement among multiple nodes via NUMA balancing */
 		if (pol->flags & MPOL_F_MORON) {
-			if (node_isset(thisnid, pol->v.nodes))
+			if (node_isset(thisnid, pol->nodes))
 				break;
 			goto out;
 		}
@@ -2480,12 +2472,12 @@ int mpol_misplaced(struct page *page, st
 		 * else select nearest allowed node, if any.
 		 * If no allowed nodes, use current [!misplaced].
 		 */
-		if (node_isset(curnid, pol->v.nodes))
+		if (node_isset(curnid, pol->nodes))
 			goto out;
 		z = first_zones_zonelist(
 				node_zonelist(numa_node_id(), GFP_HIGHUSER),
 				gfp_zone(GFP_HIGHUSER),
-				&pol->v.nodes);
+				&pol->nodes);
 		polnid = zone_to_nid(z->zone);
 		break;
 
@@ -2688,7 +2680,7 @@ int mpol_set_shared_policy(struct shared
 		 vma->vm_pgoff,
 		 sz, npol ? npol->mode : -1,
 		 npol ? npol->flags : -1,
-		 npol ? nodes_addr(npol->v.nodes)[0] : NUMA_NO_NODE);
+		 npol ? nodes_addr(npol->nodes)[0] : NUMA_NO_NODE);
 
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
@@ -2786,7 +2778,7 @@ void __init numa_policy_init(void)
 			.refcnt = ATOMIC_INIT(1),
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
-			.v = { .preferred_node = nid, },
+			.nodes = nodemask_of_node(nid),
 		};
 	}
 
@@ -2945,12 +2937,14 @@ int mpol_parse_str(char *str, struct mem
 	 * Save nodes for mpol_to_str() to show the tmpfs mount options
 	 * for /proc/mounts, /proc/pid/mounts and /proc/pid/mountinfo.
 	 */
-	if (mode != MPOL_PREFERRED)
-		new->v.nodes = nodes;
-	else if (nodelist)
-		new->v.preferred_node = first_node(nodes);
-	else
+	if (mode != MPOL_PREFERRED) {
+		new->nodes = nodes;
+	} else if (nodelist) {
+		nodes_clear(new->nodes);
+		node_set(first_node(nodes), new->nodes);
+	} else {
 		new->mode = MPOL_LOCAL;
+	}
 
 	/*
 	 * Save nodes for contextualization: this will be used to "clone"
@@ -2999,11 +2993,9 @@ void mpol_to_str(char *buffer, int maxle
 	case MPOL_LOCAL:
 		break;
 	case MPOL_PREFERRED:
-		node_set(pol->v.preferred_node, nodes);
-		break;
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		nodes = pol->v.nodes;
+		nodes = pol->nodes;
 		break;
 	default:
 		WARN_ON_ONCE(1);
_
