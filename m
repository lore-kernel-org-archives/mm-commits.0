Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FFD290086
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 20:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744317599; cv=none; b=iCUg6+34GXqBbGLPVhPikS3eM6qX82wVi57SmOgo5I8rkQfKWhU9QR1aGFe5zctyM8tZYgatWEIyazs2eV1pVPLkBBn2cSDjJu6cK6kkipdxObEO/+/2U4MtGIzzuUL4SDeDjD3XM68MSLEsJo3Y+k46Ms97dB0QJuWlF+OTrOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744317599; c=relaxed/simple;
	bh=FGVbY0/9+wner+upAIbTfUbFFf6fhAB5GNq8b//Dup4=;
	h=Date:To:From:Subject:Message-Id; b=VBsCtW78YugjbjtjM0kwkdPQ1wvbX2SVuBXhKzEoc6r0FdzZSfvm6fMvup3GQK9ylF+6NrS/DMb02uscyDuygrRk8cgS3+go9ZPsr7jL8y+zlRe+hwdS4HeURqZT9Q14M8pZV09yxXHdQC7ut2jW51x/fifSKueXxqNR2WzsyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kjz0pv2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kjz0pv2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6B4C4CEDD;
	Thu, 10 Apr 2025 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744317599;
	bh=FGVbY0/9+wner+upAIbTfUbFFf6fhAB5GNq8b//Dup4=;
	h=Date:To:From:Subject:From;
	b=Kjz0pv2YSXKxfLwbn73XjyohmFcO7jhlVSUk4haCYk9a1/WZ6wfi4eaqJFmcVDjLT
	 E2bueLmFjZ/GOy+Em7B80C4cUOUsYK8UyW1nIu5jmm3wCCAbMUZ8FZ9ToIKh+3xQIj
	 GyQCOSVwp+uFuIEKNI75qvQQHhxedVph05vj1VvE=
Date: Thu, 10 Apr 2025 13:39:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch added to mm-new branch
Message-Id: <20250410203958.DC6B4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: break on convergence in mas_spanning_rebalance()
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch

This patch will later appear in the mm-new branch at
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
Date: Thu, 10 Apr 2025 19:14:44 +0000

This allows support for using the vacant height to calculate the worst
case number of nodes needed for wr_rebalance operation. 
mas_spanning_rebalance() was seen to perform unnecessary node allocations.
We can reduce allocations by breaking early during the rebalancing loop
once we realize that we have ascended to a common ancestor.

Link: https://lkml.kernel.org/r/20250410191446.2474640-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam Howlett <liam.howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-break-on-convergence-in-mas_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2893,11 +2893,21 @@ static void mas_spanning_rebalance(struc
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
+				break;
+			}
 
-		if (mast_overflow(mast))
 			continue;
+		}
 
 		/* May be a new root stored in mast->bn */
 		if (mas_is_root_limits(mast->orig_l))
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

