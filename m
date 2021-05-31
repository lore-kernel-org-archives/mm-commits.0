Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45745C47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27ABC61159
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaVnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhEaVnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3715660FE3;
        Mon, 31 May 2021 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497299;
        bh=PBJBw8D1OdgapotCRpAVsefpk2+U8Ro3+rolya7ZXT4=;
        h=Date:From:To:Subject:From;
        b=nQG6rdZkfMMkWbCUBOWRjx70k4rgjxCjjKYUBMaxj+9NOffaMnUYf6A0Eeur0L4Yi
         22WcX+4CoggFrMLlJYhzIB/ipkC7QEVoFXIdIuq298g3sW/rL3rv/EhNuqa0Q7fLk1
         +tnYhZE/pjiXjQ8H3X+WoIe/AjGOb5a1Kr3yvV20=
Date:   Mon, 31 May 2021 14:41:38 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch added to -mm
 tree
Message-ID: <20210531214138.-voDIho_P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: cleanup nodemask intersection check for oom
has been added to the -mm tree.  Its filename is
     mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch

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
Subject: mm/mempolicy: cleanup nodemask intersection check for oom

Patch series "mm/mempolicy: some fix and semantics cleanup", v3.

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
https://gitlab.com/bwidawsk/numactl/-/tree/prefer-many. It allows new
usage: `numactl -P 0,3,4`

The goal of the new mode is to enable some use-cases when using tiered
memory usage models which I've lovingly named.

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

> /* Set first two nodes as preferred in an 8 node system. */
> const unsigned long nodes = 0x3
> set_mempolicy(MPOL_PREFER_MANY, &nodes, 8);

> /* Mimic interleave policy, but have fallback *.
> const unsigned long nodes = 0xaa
> set_mempolicy(MPOL_PREFER_MANY, &nodes, 8);

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

> // Prefer specific nodes for some something wacky
> set_mempolicy(MPOL_PREFER_MANY, 0x17c, 1024);
>
> // Default
> set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_SOCKET, NULL, 0);
> // which is the same as
> set_mempolicy(MPOL_DEFAULT, NULL, 0);
>
> // The Hare
> set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE, NULL, 0);
>
> // The Tortoise
> set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE_REV, NULL, 0);
>
> // Prefer the fast memory of the first two sockets
> set_mempolicy(MPOL_PREFER_MANY | MPOL_F_PREFER_ORDER_TYPE, -1, 2);
>


This patch (of 3):

mempolicy_nodemask_intersects() is used in oom case to check if a task may
have memory allocated on some memory nodes.

As it's only used by OOM check, rename it to mempolicy_in_oom_domain() to
reduce confusion.

As only for 'bind' policy, the nodemask is a force requirement for from
where to allocate memory, only do the intesection check for it, and return
true for all other policies.

Link: https://lkml.kernel.org/r/1622469956-82897-1-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/1622469956-82897-2-git-send-email-feng.tang@intel.com
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

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |   34 +++++++++-------------------------
 mm/oom_kill.c             |    2 +-
 3 files changed, 11 insertions(+), 27 deletions(-)

--- a/include/linux/mempolicy.h~mm-mempolicy-cleanup-nodemask-intersection-check-for-oom
+++ a/include/linux/mempolicy.h
@@ -150,7 +150,7 @@ extern int huge_node(struct vm_area_stru
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
-extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+extern bool mempolicy_in_oom_domain(struct task_struct *tsk,
 				const nodemask_t *mask);
 extern nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *policy);
 
--- a/mm/mempolicy.c~mm-mempolicy-cleanup-nodemask-intersection-check-for-oom
+++ a/mm/mempolicy.c
@@ -2094,16 +2094,16 @@ bool init_nodemask_of_mempolicy(nodemask
 #endif
 
 /*
- * mempolicy_nodemask_intersects
+ * mempolicy_in_oom_domain
  *
- * If tsk's mempolicy is "default" [NULL], return 'true' to indicate default
- * policy.  Otherwise, check for intersection between mask and the policy
- * nodemask for 'bind' or 'interleave' policy.  For 'preferred' or 'local'
- * policy, always return true since it may allocate elsewhere on fallback.
+ * If tsk's mempolicy is "bind", check for intersection between mask and
+ * the policy nodemask. Otherwise, return true for all other policies
+ * including "interleave", as a tsk with "interleave" policy may have
+ * memory allocated from all nodes in system.
  *
  * Takes task_lock(tsk) to prevent freeing of its mempolicy.
  */
-bool mempolicy_nodemask_intersects(struct task_struct *tsk,
+bool mempolicy_in_oom_domain(struct task_struct *tsk,
 					const nodemask_t *mask)
 {
 	struct mempolicy *mempolicy;
@@ -2111,29 +2111,13 @@ bool mempolicy_nodemask_intersects(struc
 
 	if (!mask)
 		return ret;
+
 	task_lock(tsk);
 	mempolicy = tsk->mempolicy;
-	if (!mempolicy)
-		goto out;
-
-	switch (mempolicy->mode) {
-	case MPOL_PREFERRED:
-		/*
-		 * MPOL_PREFERRED and MPOL_F_LOCAL are only preferred nodes to
-		 * allocate from, they may fallback to other nodes when oom.
-		 * Thus, it's possible for tsk to have allocated memory from
-		 * nodes in mask.
-		 */
-		break;
-	case MPOL_BIND:
-	case MPOL_INTERLEAVE:
+	if (mempolicy && mempolicy->mode == MPOL_BIND)
 		ret = nodes_intersects(mempolicy->v.nodes, *mask);
-		break;
-	default:
-		BUG();
-	}
-out:
 	task_unlock(tsk);
+
 	return ret;
 }
 
--- a/mm/oom_kill.c~mm-mempolicy-cleanup-nodemask-intersection-check-for-oom
+++ a/mm/oom_kill.c
@@ -104,7 +104,7 @@ static bool oom_cpuset_eligible(struct t
 			 * mempolicy intersects current, otherwise it may be
 			 * needlessly killed.
 			 */
-			ret = mempolicy_nodemask_intersects(tsk, mask);
+			ret = mempolicy_in_oom_domain(tsk, mask);
 		} else {
 			/*
 			 * This is not a mempolicy constrained oom, so only
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch
mm-mempolicy-dont-handle-mpol_local-like-a-fake-mpol_preferred-policy.patch
mm-mempolicy-unify-the-parameter-sanity-check-for-mbind-and-set_mempolicy.patch

