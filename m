Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38197C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2173861C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhGFTVg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhGFTVg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B744861C7A;
        Tue,  6 Jul 2021 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599137;
        bh=+hHdXQbWsxnSE8aEp6ekIyrW3xqwszAwjJHRLgd3bWI=;
        h=Date:From:To:Subject:From;
        b=nTT9rxtSzBSGp4UHcwkx1roLmWMV2d9RgyqNG3IsQOSIFcAL+t5JgQDnBx6hgBXFp
         WkzmOEpGk9L/LPOgQ5YhbKfo45sYraCt5tUWBUnO5FEp1fSAH92WYNCPWEXuYqqokc
         mBveWtIcsY2bEC9cY1DjMinkJtHwc3IQsMdh4jdQ=
Date:   Tue, 06 Jul 2021 12:18:56 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rientjes@google.com, vbabka@suse.cz,
        ying.huang@intel.com
Subject:  [merged]
 mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch removed from
 -mm tree
Message-ID: <20210706191856.4_H1fvR2p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: cleanup nodemask intersection check for oom
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-cleanup-nodemask-intersection-check-for-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/mempolicy: cleanup nodemask intersection check for oom

Patch series "mm/mempolicy: some fix and semantics cleanup", v4.

Current memory policy code has some confusing and ambiguous part about
MPOL_LOCAL policy, as it is handled as a faked MPOL_PREFERRED one, and
there are many places having to distinguish them.  Also the nodemask
intersection check needs cleanup to be more explicit for OOM use, and
handle MPOL_INTERLEAVE correctly.  This patchset cleans up these and
unifies the parameter sanity check for mbind() and set_mempolicy().


This patch (of 3):

mempolicy_nodemask_intersects seem to be a general purpose mempolicy
function.  In fact it is partially tailored for the OOM purpose
instead.  The oom proper is the only existing user so rename the
function to make that purpose explicit.

While at it drop the MPOL_INTERLEAVE as those allocations never has a
nodemask defined (see alloc_page_interleave) so this is a dead code and
a confusing one because MPOL_INTERLEAVE is a hint rather than a hard
requirement so it shouldn't be considered during the OOM.

The final code can be reduced to a check for MPOL_BIND which is the
only memory policy that is a hard requirement and thus relevant to a
constrained OOM logic.

[mhocko@suse.com: changelog edits]
Link: https://lkml.kernel.org/r/1622560492-1294-1-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/1622560492-1294-2-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/1622469956-82897-1-git-send-email-feng.tang@intel.com
Link: https://lkml.kernel.org/r/1622469956-82897-2-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
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


