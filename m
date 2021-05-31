Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE903C47083
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A00D36101C
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhEaVn2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232186AbhEaVnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 800A261005;
        Mon, 31 May 2021 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497304;
        bh=NwaArrPMWrMms4Bhnpw8qjUbpLFySi5PjPKu3zQbrHc=;
        h=Date:From:To:Subject:From;
        b=Blk9yX2aZt2fQv1ufdIizDXQ6aoMQWQBYPBf0IP61cY2we6kWLCnNFnX20tXuVdL2
         vcx7PX+Roa2Lmu2y03S/p40gRnFV+TTOa/6BvQ9FngrIjRrvtuhazLP24DAXG+bLiw
         HEKzj5xWkrA5K11DeFFqC0q1ycvE2WlQH94skkhU=
Date:   Mon, 31 May 2021 14:41:42 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
 added to -mm tree
Message-ID: <20210531214142.0p_C2P4tn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: don't handle MPOL_LOCAL like a fake MPOL_PREFERRED policy
has been added to the -mm tree.  Its filename is
     mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/mempolicy: don't handle MPOL_LOCAL like a fake MPOL_PREFERRED policy

MPOL_LOCAL policy has been setup as a real policy, but it is still handled
like a faked POL_PREFERRED policy with one internal MPOL_F_LOCAL flag bit
set, and there are many places having to judge the real 'prefer' or the
'local' policy, which are quite confusing.

In current code, there are 4 cases that MPOL_LOCAL are used:
1. user specifies 'local' policy
2. user specifies 'prefer' policy, but with empty nodemask
3. system 'default' policy is used
4. 'prefer' policy + valid 'preferred' node with MPOL_F_STATIC_NODES
   flag set, and when it is 'rebind' to a nodemask which doesn't
   contains the 'preferred' node, it will perform as 'local' policy

So make 'local' a real policy instead of a fake 'prefer' one, and kill
MPOL_F_LOCAL bit, which can greatly reduce the confusion for code reading.

For case 4, the logic of mpol_rebind_preferred() is confusing, as Michal
Hocko pointed out:

: I do believe that rebinding preferred policy is just bogus and it should
: be dropped altogether on the ground that a preference is a mere hint from
: userspace where to start the allocation.  Unless I am missing something
: cpusets will be always authoritative for the final placement.  The
: preferred node just acts as a starting point and it should be really
: preserved when cpusets changes.  Otherwise we have a very subtle behavior
: corner cases.

So dump all the tricky transformation between 'prefer' and 'local',
and just record the new nodemask of rebinding.

Link: https://lkml.kernel.org/r/1622469956-82897-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    1 
 mm/mempolicy.c                 |  131 +++++++++++++------------------
 2 files changed, 55 insertions(+), 77 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy
+++ a/include/uapi/linux/mempolicy.h
@@ -60,7 +60,6 @@ enum {
  * are never OR'ed into the mode in mempolicy API arguments.
  */
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
-#define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
--- a/mm/mempolicy.c~mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy
+++ a/mm/mempolicy.c
@@ -121,8 +121,7 @@ enum zone_type policy_zone = 0;
  */
 static struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
-	.mode = MPOL_PREFERRED,
-	.flags = MPOL_F_LOCAL,
+	.mode = MPOL_LOCAL,
 };
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
@@ -200,12 +199,9 @@ static int mpol_new_interleave(struct me
 
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (!nodes)
-		pol->flags |= MPOL_F_LOCAL;	/* local allocation */
-	else if (nodes_empty(*nodes))
-		return -EINVAL;			/*  no allowed nodes */
-	else
-		pol->v.preferred_node = first_node(*nodes);
+	if (nodes_empty(*nodes))
+		return -EINVAL;
+	pol->v.preferred_node = first_node(*nodes);
 	return 0;
 }
 
@@ -217,6 +213,11 @@ static int mpol_new_bind(struct mempolic
 	return 0;
 }
 
+static int mpol_new_local(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	return 0;
+}
+
 /*
  * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
  * any, for the new policy.  mpol_new() has already validated the nodes
@@ -239,25 +240,19 @@ static int mpol_set_nodemask(struct memp
 		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
 
 	VM_BUG_ON(!nodes);
-	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
-		nodes = NULL;	/* explicit local allocation */
-	else {
-		if (pol->flags & MPOL_F_RELATIVE_NODES)
-			mpol_relative_nodemask(&nsc->mask2, nodes, &nsc->mask1);
-		else
-			nodes_and(nsc->mask2, *nodes, nsc->mask1);
 
-		if (mpol_store_user_nodemask(pol))
-			pol->w.user_nodemask = *nodes;
-		else
-			pol->w.cpuset_mems_allowed =
-						cpuset_current_mems_allowed;
-	}
+	if (pol->flags & MPOL_F_RELATIVE_NODES)
+		mpol_relative_nodemask(&nsc->mask2, nodes, &nsc->mask1);
+	else
+		nodes_and(nsc->mask2, *nodes, nsc->mask1);
 
-	if (nodes)
-		ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
+	if (mpol_store_user_nodemask(pol))
+		pol->w.user_nodemask = *nodes;
 	else
-		ret = mpol_ops[pol->mode].create(pol, NULL);
+		pol->w.cpuset_mems_allowed =
+					cpuset_current_mems_allowed;
+
+	ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
 	return ret;
 }
 
@@ -290,13 +285,14 @@ static struct mempolicy *mpol_new(unsign
 			if (((flags & MPOL_F_STATIC_NODES) ||
 			     (flags & MPOL_F_RELATIVE_NODES)))
 				return ERR_PTR(-EINVAL);
+
+			mode = MPOL_LOCAL;
 		}
 	} else if (mode == MPOL_LOCAL) {
 		if (!nodes_empty(*nodes) ||
 		    (flags & MPOL_F_STATIC_NODES) ||
 		    (flags & MPOL_F_RELATIVE_NODES))
 			return ERR_PTR(-EINVAL);
-		mode = MPOL_PREFERRED;
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
@@ -344,25 +340,7 @@ static void mpol_rebind_nodemask(struct
 static void mpol_rebind_preferred(struct mempolicy *pol,
 						const nodemask_t *nodes)
 {
-	nodemask_t tmp;
-
-	if (pol->flags & MPOL_F_STATIC_NODES) {
-		int node = first_node(pol->w.user_nodemask);
-
-		if (node_isset(node, *nodes)) {
-			pol->v.preferred_node = node;
-			pol->flags &= ~MPOL_F_LOCAL;
-		} else
-			pol->flags |= MPOL_F_LOCAL;
-	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
-		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
-		pol->v.preferred_node = first_node(tmp);
-	} else if (!(pol->flags & MPOL_F_LOCAL)) {
-		pol->v.preferred_node = node_remap(pol->v.preferred_node,
-						   pol->w.cpuset_mems_allowed,
-						   *nodes);
-		pol->w.cpuset_mems_allowed = *nodes;
-	}
+	pol->w.cpuset_mems_allowed = *nodes;
 }
 
 /*
@@ -376,7 +354,7 @@ static void mpol_rebind_policy(struct me
 {
 	if (!pol)
 		return;
-	if (!mpol_store_user_nodemask(pol) && !(pol->flags & MPOL_F_LOCAL) &&
+	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
 
@@ -427,6 +405,10 @@ static const struct mempolicy_operations
 		.create = mpol_new_bind,
 		.rebind = mpol_rebind_nodemask,
 	},
+	[MPOL_LOCAL] = {
+		.create = mpol_new_local,
+		.rebind = mpol_rebind_default,
+	},
 };
 
 static int migrate_page_add(struct page *page, struct list_head *pagelist,
@@ -919,10 +901,12 @@ static void get_policy_nodemask(struct m
 	case MPOL_INTERLEAVE:
 		*nodes = p->v.nodes;
 		break;
+	case MPOL_LOCAL:
+		/* return empty node mask for local allocation */
+		break;
+
 	case MPOL_PREFERRED:
-		if (!(p->flags & MPOL_F_LOCAL))
-			node_set(p->v.preferred_node, *nodes);
-		/* else return empty node mask for local allocation */
+		node_set(p->v.preferred_node, *nodes);
 		break;
 	default:
 		BUG();
@@ -1894,9 +1878,9 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 /* Return the node id preferred by the given mempolicy, or the given id */
 static int policy_node(gfp_t gfp, struct mempolicy *policy, int nd)
 {
-	if (policy->mode == MPOL_PREFERRED && !(policy->flags & MPOL_F_LOCAL))
+	if (policy->mode == MPOL_PREFERRED) {
 		nd = policy->v.preferred_node;
-	else {
+	} else {
 		/*
 		 * __GFP_THISNODE shouldn't even be used with the bind policy
 		 * because we might easily break the expectation to stay on the
@@ -1933,14 +1917,11 @@ unsigned int mempolicy_slab_node(void)
 		return node;
 
 	policy = current->mempolicy;
-	if (!policy || policy->flags & MPOL_F_LOCAL)
+	if (!policy)
 		return node;
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
-		/*
-		 * handled MPOL_F_LOCAL above
-		 */
 		return policy->v.preferred_node;
 
 	case MPOL_INTERLEAVE:
@@ -1960,6 +1941,8 @@ unsigned int mempolicy_slab_node(void)
 							&policy->v.nodes);
 		return z->zone ? zone_to_nid(z->zone) : node;
 	}
+	case MPOL_LOCAL:
+		return node;
 
 	default:
 		BUG();
@@ -2072,16 +2055,18 @@ bool init_nodemask_of_mempolicy(nodemask
 	mempolicy = current->mempolicy;
 	switch (mempolicy->mode) {
 	case MPOL_PREFERRED:
-		if (mempolicy->flags & MPOL_F_LOCAL)
-			nid = numa_node_id();
-		else
-			nid = mempolicy->v.preferred_node;
+		nid = mempolicy->v.preferred_node;
 		init_nodemask_of_node(mask, nid);
 		break;
 
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		*mask =  mempolicy->v.nodes;
+		*mask = mempolicy->v.nodes;
+		break;
+
+	case MPOL_LOCAL:
+		nid = numa_node_id();
+		init_nodemask_of_node(mask, nid);
 		break;
 
 	default:
@@ -2188,7 +2173,7 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		 * If the policy is interleave, or does not allow the current
 		 * node in its nodemask, we allocate the standard way.
 		 */
-		if (pol->mode == MPOL_PREFERRED && !(pol->flags & MPOL_F_LOCAL))
+		if (pol->mode == MPOL_PREFERRED)
 			hpage_node = pol->v.preferred_node;
 
 		nmask = policy_nodemask(gfp, pol);
@@ -2324,10 +2309,9 @@ bool __mpol_equal(struct mempolicy *a, s
 	case MPOL_INTERLEAVE:
 		return !!nodes_equal(a->v.nodes, b->v.nodes);
 	case MPOL_PREFERRED:
-		/* a's ->flags is the same as b's */
-		if (a->flags & MPOL_F_LOCAL)
-			return true;
 		return a->v.preferred_node == b->v.preferred_node;
+	case MPOL_LOCAL:
+		return true;
 	default:
 		BUG();
 		return false;
@@ -2465,10 +2449,11 @@ int mpol_misplaced(struct page *page, st
 		break;
 
 	case MPOL_PREFERRED:
-		if (pol->flags & MPOL_F_LOCAL)
-			polnid = numa_node_id();
-		else
-			polnid = pol->v.preferred_node;
+		polnid = pol->v.preferred_node;
+		break;
+
+	case MPOL_LOCAL:
+		polnid = numa_node_id();
 		break;
 
 	case MPOL_BIND:
@@ -2835,9 +2820,6 @@ void numa_default_policy(void)
  * Parse and format mempolicy from/to strings
  */
 
-/*
- * "local" is implemented internally by MPOL_PREFERRED with MPOL_F_LOCAL flag.
- */
 static const char * const policy_modes[] =
 {
 	[MPOL_DEFAULT]    = "default",
@@ -2915,7 +2897,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (nodelist)
 			goto out;
-		mode = MPOL_PREFERRED;
 		break;
 	case MPOL_DEFAULT:
 		/*
@@ -2959,7 +2940,7 @@ int mpol_parse_str(char *str, struct mem
 	else if (nodelist)
 		new->v.preferred_node = first_node(nodes);
 	else
-		new->flags |= MPOL_F_LOCAL;
+		new->mode = MPOL_LOCAL;
 
 	/*
 	 * Save nodes for contextualization: this will be used to "clone"
@@ -3005,12 +2986,10 @@ void mpol_to_str(char *buffer, int maxle
 
 	switch (mode) {
 	case MPOL_DEFAULT:
+	case MPOL_LOCAL:
 		break;
 	case MPOL_PREFERRED:
-		if (flags & MPOL_F_LOCAL)
-			mode = MPOL_LOCAL;
-		else
-			node_set(pol->v.preferred_node, nodes);
+		node_set(pol->v.preferred_node, nodes);
 		break;
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

