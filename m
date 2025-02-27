Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2006823E34F
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695010; cv=none; b=ejk5scp+ZCtbOYRWEgq8QP5POroMTHOE7txWdkzw05sCiLXVplAooDpXg3OmDjK/AFaxrAB48uM0rj4PHF+onRpT51RJdWEGM6hqB0GAdcsekrHW7yDxMkhfGOe5PJ44vsmKLkzVqt6oP65NjjM0xtak4uYywOVzQWhqdAw98HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695010; c=relaxed/simple;
	bh=8NhoqVNwjNmSGD+NIYC99kkfR+53zr60ujvtXM1otnU=;
	h=Date:To:From:Subject:Message-Id; b=aeRuhvxxZWsUXoC9fCdOESCsA7JZSAr4xZh0AK8MHJSmkqBgDl7bZXg4Dx6QoRzuBeE6rEB4Dkp7AiO658PfDav6c49g5r/WsxbcEhAUXZITvvwJxM2fEB0vVehDfvJse5ntKeF2NF1ueeyFM7YbUu64yKi0QXQqnF6i+vde3zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0Ko/QxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0Ko/QxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91886C4CEE4;
	Thu, 27 Feb 2025 22:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695009;
	bh=8NhoqVNwjNmSGD+NIYC99kkfR+53zr60ujvtXM1otnU=;
	h=Date:To:From:Subject:From;
	b=b0Ko/QxI5UrdTshzQabI+wMTH8UW9kR573FOXFcHBu77QXJP4Jsvi1sIXt67se5Os
	 vMRawlYBMmG6VPWrPcucuEqEwVRAPggqiI3mVLSr+rSCubivvXbL1vV55f4VCSwacG
	 hfnS28GTliTcm2j/e7ymFe1tA/hiFl0+aXn5LvCY=
Date: Thu, 27 Feb 2025 14:23:29 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch added to mm-unstable branch
Message-Id: <20250227222329.91886C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: break on convergence in mas_spanning_rebalance()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: break on convergence in mas_spanning_rebalance()
Date: Thu, 27 Feb 2025 20:48:21 +0000

This allows support for using the vacant height to calculate the worst
case number of nodes needed for wr_rebalance operation. 
mas_spanning_rebalance() was seen to perform unnecessary node allocations.
We can reduce allocations by breaking early during the rebalancing loop
once we realize that we have ascended to a common ancestor.

Link: https://lkml.kernel.org/r/20250227204823.758784-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam Howlett <liam.howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-break-on-convergence-in-mas_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2895,11 +2895,24 @@ static void mas_spanning_rebalance(struc
 		mast_combine_cp_right(mast);
 		mast->orig_l->last = mast->orig_l->max;
 
-		if (mast_sufficient(mast))
-			continue;
+		if (mast_sufficient(mast)) {
+			if (mast_overflow(mast))
+				continue;
+
+			if (mast->orig_l->node == mast->orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast->l->offset;
+				/* May be a new root stored in mast->bn */
+				if (mas_is_root_limits(mast->orig_l))
+					new_height++;
+				break;
+			}
 
-		if (mast_overflow(mast))
 			continue;
+		}
 
 		/* May be a new root stored in mast->bn */
 		if (mas_is_root_limits(mast->orig_l)) {
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

