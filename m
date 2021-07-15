Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BA3C12002
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55DE61361
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhGOATs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 20:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbhGOATs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 20:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A8E613CA;
        Thu, 15 Jul 2021 00:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626308216;
        bh=ZEqMzuJBPT7l/hyfC+q4J8+Z9/Y/6hVWTl4NUkjfX/E=;
        h=Date:From:To:Subject:From;
        b=qVJ0hH0tk32+RUDcPYccKBQfi7Y7t2/LW8VFOzpX5juSeEnTwZVuKA1or9pAKvdQO
         yKanO9lXfP13SL+CYbiU77Qm8csHEPuImIa/Fkh8HAVynu59g8Zg7oGMbKLCS8F3c/
         lf6KHPyP30zh/a4nPEl0H4NCClsWjZQjdMf9PH0w=
Date:   Wed, 14 Jul 2021 17:16:55 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch
 added to -mm tree
Message-ID: <20210715001655.gC41OVHto%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: add MPOL_PREFERRED_MANY for multiple preferred nodes
has been added to the -mm tree.  Its filename is
     mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/mempolicy: add MPOL_PREFERRED_MANY for multiple preferred nodes

Patch series "Introduce multi-preference mempolicy", v6.

This patch series introduces the concept of the MPOL_PREFERRED_MANY
mempolicy.  This mempolicy mode can be used with either the
set_mempolicy(2) or mbind(2) interfaces.  Like the MPOL_PREFERRED
interface, it allows an application to set a preference for nodes which
will fulfil memory allocation requests.  Unlike the MPOL_PREFERRED mode,
it takes a set of nodes.  Like the MPOL_BIND interface, it works over a
set of nodes.  Unlike MPOL_BIND, it will not cause a SIGSEGV or invoke the
OOM killer if those preferred nodes are not available.

Along with these patches are patches for libnuma, numactl, numademo, and
memhog.  They still need some polish, but can be found here:
https://gitlab.com/bwidawsk/numactl/-/tree/prefer-many It allows new
usage: `numactl -P 0,3,4`

The goal of the new mode is to enable some use-cases when using tiered
memory usage models which I've lovingly named

1a. The Hare - The interconnect is fast enough to meet bandwidth and
    latency requirements allowing preference to be given to all nodes with
    "fast" memory.

1b. The Indiscriminate Hare - An application knows it wants fast
    memory (or perhaps slow memory), but doesn't care which node it runs
    on.  The application can prefer a set of nodes and then xpu bind to
    the local node (cpu, accelerator, etc).  This reverses the nodes are
    chosen today where the kernel attempts to use local memory to the CPU
    whenever possible.  This will attempt to use the local accelerator to
    the memory.

2.  The Tortoise - The administrator (or the application itself) is
    aware it only needs slow memory, and so can prefer that.

Much of this is almost achievable with the bind interface, but the bind
interface suffers from an inability to fallback to another set of nodes if
binding fails to all nodes in the nodemask.

Like MPOL_BIND a nodemask is given.  Inherently this removes ordering from
the preference.

: /* Set first two nodes as preferred in an 8 node system. */
: const unsigned long nodes = 0x3
: set_mempolicy(MPOL_PREFER_MANY, &nodes, 8);

: /* Mimic interleave policy, but have fallback *.
: const unsigned long nodes = 0xaa
: set_mempolicy(MPOL_PREFER_MANY, &nodes, 8);

Some internal discussion took place around the interface.  There are two
alternatives which we have discussed, plus one I stuck in:

1. Ordered list of nodes.  Currently it's believed that the added
   complexity is nod needed for expected usecases.

2. A flag for bind to allow falling back to other nodes.  This
   confuses the notion of binding and is less flexible than the current
   solution.

3. Create flags or new modes that helps with some ordering.  This
   offers both a friendlier API as well as a solution for more customized
   usage.  It's unknown if it's worth the complexity to support this. 
   Here is sample code for how this might work:

: // Prefer specific nodes for some something wacky
: set_mempolicy(MPOL_PREFER_MANY, 0x17c, 1024);
:
: // Default
: set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_SOCKET, NULL, 0);
: // which is the same as
: set_mempolicy(MPOL_DEFAULT, NULL, 0);
:
: // The Hare
: set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE, NULL, 0);
:
: // The Tortoise
: set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE_REV, NULL, 0);
:
: // Prefer the fast memory of the first two sockets
: set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE, -1, 2);
:

In v1, Andi Kleen brought up reusing MPOL_PREFERRED as the mode for the
API.  There wasn't consensus around this, so I've left the existing API as
it was.  I'm open to more feedback here, but my slight preference is to
use a new API as it ensures if people are using it, they are entirely
aware of what they're doing and not accidentally misusing the old
interface.  (In a similar way to how MPOL_LOCAL was introduced).

In v1, Michal also brought up renaming this MPOL_PREFERRED_MASK.  I'm
equally fine with that change, but I hadn't heard much emphatic support
for one way or another, so I've left that too.


This patch (of 6):

The NUMA APIs currently allow passing in a "preferred node" as a single
bit set in a nodemask.  If more than one bit it set, bits after the first
are ignored.

This single node is generally OK for location-based NUMA where memory
being allocated will eventually be operated on by a single CPU.  However,
in systems with multiple memory types, folks want to target a *type* of
memory instead of a location.  For instance, someone might want some
high-bandwidth memory but do not care about the CPU next to which it is
allocated.  Or, they want a cheap, high capacity allocation and want to
target all NUMA nodes which have persistent memory in volatile mode.  In
both of these cases, the application wants to target a *set* of nodes, but
does not want strict MPOL_BIND behavior as that could lead to OOM killer
or SIGSEGV.

So add MPOL_PREFERRED_MANY policy to support the multiple preferred nodes
requirement.  This is not a pie-in-the-sky dream for an API.  This was a
response to a specific ask of more than one group at Intel.  Specifically:

1. There are existing libraries that target memory types such as
   https://github.com/memkind/memkind.  These are known to suffer from
   SIGSEGV's when memory is low on targeted memory "kinds" that span more
   than one node.  The MCDRAM on a Xeon Phi in "Cluster on Die" mode is an
   example of this.

2. Volatile-use persistent memory users want to have a memory policy
   which is targeted at either "cheap and slow" (PMEM) or "expensive and
   fast" (DRAM).  However, they do not want to experience allocation
   failures when the targeted type is unavailable.

3. Allocate-then-run.  Generally, we let the process scheduler decide
   on which physical CPU to run a task.  That location provides a default
   allocation policy, and memory availability is not generally considered
   when placing tasks.  For situations where memory is valuable and
   constrained, some users want to allocate memory first, *then* allocate
   close compute resources to the allocation.  This is the reverse of the
   normal (CPU) model.  Accelerators such as GPUs that operate on
   core-mm-managed memory are interested in this model.

A check is added in sanitize_mpol_flags() to not permit 'prefer_many'
policy to be used for now, and will be removed in later patch after all
implementations for 'prefer_many' are ready, as suggested by Michal Hocko.

Link: https://lore.kernel.org/r/20200630212517.308045-4-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1626077374-81682-2-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Co-developed-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    1 
 mm/mempolicy.c                 |   44 +++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 5 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes
+++ a/include/uapi/linux/mempolicy.h
@@ -22,6 +22,7 @@ enum {
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
 	MPOL_LOCAL,
+	MPOL_PREFERRED_MANY,
 	MPOL_MAX,	/* always last member of enum */
 };
 
--- a/mm/mempolicy.c~mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes
+++ a/mm/mempolicy.c
@@ -31,6 +31,9 @@
  *                but useful to set in a VMA when you have a non default
  *                process policy.
  *
+ * preferred many Try a set of nodes first before normal fallback. This is
+ *                similar to preferred without the special case.
+ *
  * default        Allocate on the local node first, or when on a VMA
  *                use the process policy. This is what Linux always did
  *		  in a NUMA aware kernel and still does by, ahem, default.
@@ -207,6 +210,14 @@ static int mpol_new_preferred(struct mem
 	return 0;
 }
 
+static int mpol_new_preferred_many(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (nodes_empty(*nodes))
+		return -EINVAL;
+	pol->nodes = *nodes;
+	return 0;
+}
+
 static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
 {
 	if (nodes_empty(*nodes))
@@ -408,6 +419,10 @@ static const struct mempolicy_operations
 	[MPOL_LOCAL] = {
 		.rebind = mpol_rebind_default,
 	},
+	[MPOL_PREFERRED_MANY] = {
+		.create = mpol_new_preferred_many,
+		.rebind = mpol_rebind_preferred,
+	},
 };
 
 static int migrate_page_add(struct page *page, struct list_head *pagelist,
@@ -900,6 +915,7 @@ static void get_policy_nodemask(struct m
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
 		*nodes = p->nodes;
 		break;
 	case MPOL_LOCAL:
@@ -1446,7 +1462,13 @@ static inline int sanitize_mpol_flags(in
 {
 	*flags = *mode & MPOL_MODE_FLAGS;
 	*mode &= ~MPOL_MODE_FLAGS;
-	if ((unsigned int)(*mode) >= MPOL_MAX)
+
+	/*
+	 * The check should be 'mode >= MPOL_MAX', but as 'prefer_many'
+	 * is not fully implemented, don't permit it to be used for now,
+	 * and the logic will be restored in following patch
+	 */
+	if ((unsigned int)(*mode) >=  MPOL_PREFERRED_MANY)
 		return -EINVAL;
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
@@ -1887,7 +1909,8 @@ nodemask_t *policy_nodemask(gfp_t gfp, s
 /* Return the node id preferred by the given mempolicy, or the given id */
 static int policy_node(gfp_t gfp, struct mempolicy *policy, int nd)
 {
-	if (policy->mode == MPOL_PREFERRED) {
+	if (policy->mode == MPOL_PREFERRED ||
+	    policy->mode == MPOL_PREFERRED_MANY) {
 		nd = first_node(policy->nodes);
 	} else {
 		/*
@@ -1931,6 +1954,7 @@ unsigned int mempolicy_slab_node(void)
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
 		return first_node(policy->nodes);
 
 	case MPOL_INTERLEAVE:
@@ -2063,6 +2087,7 @@ bool init_nodemask_of_mempolicy(nodemask
 	mempolicy = current->mempolicy;
 	switch (mempolicy->mode) {
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
 		*mask = mempolicy->nodes;
@@ -2173,10 +2198,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		 * node and don't fall back to other nodes, as the cost of
 		 * remote accesses would likely offset THP benefits.
 		 *
-		 * If the policy is interleave, or does not allow the current
-		 * node in its nodemask, we allocate the standard way.
+		 * If the policy is interleave or multiple preferred nodes, or
+		 * does not allow the current node in its nodemask, we allocate
+		 * the standard way.
 		 */
-		if (pol->mode == MPOL_PREFERRED)
+		if ((pol->mode == MPOL_PREFERRED ||
+		     pol->mode == MPOL_PREFERRED_MANY))
 			hpage_node = first_node(pol->nodes);
 
 		nmask = policy_nodemask(gfp, pol);
@@ -2311,6 +2338,7 @@ bool __mpol_equal(struct mempolicy *a, s
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
 		return !!nodes_equal(a->nodes, b->nodes);
 	case MPOL_LOCAL:
 		return true;
@@ -2451,6 +2479,9 @@ int mpol_misplaced(struct page *page, st
 		break;
 
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
+		if (node_isset(curnid, pol->nodes))
+			goto out;
 		polnid = first_node(pol->nodes);
 		break;
 
@@ -2829,6 +2860,7 @@ static const char * const policy_modes[]
 	[MPOL_BIND]       = "bind",
 	[MPOL_INTERLEAVE] = "interleave",
 	[MPOL_LOCAL]      = "local",
+	[MPOL_PREFERRED_MANY]  = "prefer (many)",
 };
 
 
@@ -2907,6 +2939,7 @@ int mpol_parse_str(char *str, struct mem
 		if (!nodelist)
 			err = 0;
 		goto out;
+	case MPOL_PREFERRED_MANY:
 	case MPOL_BIND:
 		/*
 		 * Insist on a nodelist
@@ -2993,6 +3026,7 @@ void mpol_to_str(char *buffer, int maxle
 	case MPOL_LOCAL:
 		break;
 	case MPOL_PREFERRED:
+	case MPOL_PREFERRED_MANY:
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
 		nodes = pol->nodes;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

