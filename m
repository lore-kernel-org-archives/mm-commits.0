From: akpm@linux-foundation.org
Subject: +
 mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch added to -mm tree
Date: Wed, 19 Oct 2016 16:40:56 -0700
Message-ID: <58080488.xmezLk1VcSQYnH5P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbcJSXk5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 19:40:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

