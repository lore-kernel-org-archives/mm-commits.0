From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 12 Dec 2016 16:22:07 -0800
Message-ID: <584f3f2f.S81Qb0aIvAjAyyn3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAVX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes

WARNING: line over 80 characters
#59: FILE: mm/mempolicy.c:1686:
+		 * __GFP_THISNODE shouldn't even be used with the bind policy because

WARNING: line over 80 characters
#60: FILE: mm/mempolicy.c:1687:
+		 * we might easily break the expectation to stay on the requested node

WARNING: line over 80 characters
#69: FILE: mm/mempolicy.c:1690:
+		WARN_ON_ONCE(policy->mode == MPOL_BIND && (gfp & __GFP_THISNODE));

total: 0 errors, 3 warnings, 33 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes
+++ a/mm/mempolicy.c
@@ -1683,9 +1683,9 @@ static struct zonelist *policy_zonelist(
 		nd = policy->v.preferred_node;
 	else {
 		/*
-		 * __GFP_THISNODE shouldn't even be used with the bind policy because
-		 * we might easily break the expectation to stay on the requested node
-		 * and not break the policy.
+		 * __GFP_THISNODE shouldn't even be used with the bind policy
+		 * because we might easily break the expectation to stay on the
+		 * requested node and not break the policy.
 		 */
 		WARN_ON_ONCE(policy->mode == MPOL_BIND && (gfp & __GFP_THISNODE));
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic-fix-fix.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

