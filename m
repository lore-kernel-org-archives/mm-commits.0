From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch
 added to -mm tree
Date: Wed, 19 Oct 2016 16:39:53 -0700
Message-ID: <58080449.bp4jXdJcCZXfozNa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754100AbcJSXjy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 19:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, khandual@linux.vnet.ibm.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempolicy: clean up __GFP_THISNODE confusion in policy_zonelist
has been added to the -mm tree.  Its filename is
     mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, mempolicy: clean up __GFP_THISNODE confusion in policy_zonelist

__GFP_THISNODE is documented to enforce the allocation to be satisified
from the requested node with no fallbacks or placement policy
enforcements.  policy_zonelist seemingly breaks this semantic if the
current policy is MPOL_MBIND and instead of taking the node it will
fallback to the first node in the mask if the requested one is not in the
mask.  This is confusing to say the least because it fact we shouldn't
ever go that path.  First tasks shouldn't be scheduled on CPUs with nodes
outside of their mempolicy binding.  And secondly policy_zonelist is
called only from 3 places:

- huge_zonelist - never should do __GFP_THISNODE when going this path

- alloc_pages_vma - which shouldn't depend on __GFP_THISNODE either

- alloc_pages_current - which uses default_policy id __GFP_THISNODE is
  used

So we shouldn't even need to care about this possibility and can drop the
confusing code.  Let's keep a WARN_ON_ONCE in place to catch potential
users and fix them up properly (aka use a different allocation function
which ignores mempolicy).

Link: http://lkml.kernel.org/r/20161013125958.32155-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist
+++ a/mm/mempolicy.c
@@ -1679,25 +1679,17 @@ static nodemask_t *policy_nodemask(gfp_t
 static struct zonelist *policy_zonelist(gfp_t gfp, struct mempolicy *policy,
 	int nd)
 {
-	switch (policy->mode) {
-	case MPOL_PREFERRED:
-		if (!(policy->flags & MPOL_F_LOCAL))
-			nd = policy->v.preferred_node;
-		break;
-	case MPOL_BIND:
+	if (policy->mode == MPOL_PREFERRED && !(policy->flags & MPOL_F_LOCAL))
+		nd = policy->v.preferred_node;
+	else {
 		/*
-		 * Normally, MPOL_BIND allocations are node-local within the
-		 * allowed nodemask.  However, if __GFP_THISNODE is set and the
-		 * current node isn't part of the mask, we use the zonelist for
-		 * the first node in the mask instead.
+		 * __GFP_THISNODE shouldn't even be used with the bind policy because
+		 * we might easily break the expectation to stay on the requested node
+		 * and not break the policy.
 		 */
-		if (unlikely(gfp & __GFP_THISNODE) &&
-				unlikely(!node_isset(nd, policy->v.nodes)))
-			nd = first_node(policy->v.nodes);
-		break;
-	default:
-		BUG();
+		WARN_ON_ONCE(policy->mode == MPOL_BIND && (gfp & __GFP_THISNODE));
 	}
+
 	return node_zonelist(nd, gfp);
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-compaction-allow-compaction-for-gfp_nofs-requests.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch

