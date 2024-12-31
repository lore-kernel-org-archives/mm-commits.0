Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD2A1078F
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604954; cv=none; b=mfEVaVDiHUyHC2iLLSmphF+IdJQLDHoQEoitRxxGf31Vbc4C5sLbfD3zChEQPKYAQGNz4X2Ug9AqEcd+UsNFFQv4Ou+cv9hmwB36nqwstoiXsioTMTJB05dHcl4/YzoWIdrP1vBol1122ewIUFn6wNb66QyffWRYMf3ctMZy6Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604954; c=relaxed/simple;
	bh=umrn0w5jE5zDtQJ2uCp3BvMY61qkP653GKAXz+QmySg=;
	h=Date:To:From:Subject:Message-Id; b=pqrkFdVWWBQj9yUx7v2bVSqurEz+CB5I6lYJaYt4IDi1qKxxRQ7qwNDE4+gO0BSUsiZCjDy7lQDAVT2d7H+YcylIiH4OfNLu4pean4IGVyokMfd62IdzZ/E9MiODR1B5nmDAq7jvSgBxsZSuS6wypeFnhR5PbcqL3CeDD6sBv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xAOvCnSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xAOvCnSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5122C4CED0;
	Tue, 31 Dec 2024 00:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735604953;
	bh=umrn0w5jE5zDtQJ2uCp3BvMY61qkP653GKAXz+QmySg=;
	h=Date:To:From:Subject:From;
	b=xAOvCnSianOwusSfqisMP4wf7K7fNQEs+hw7xyDREoX2D6uIMskuyua7eFhly2bL9
	 tSY0rGi+4RiqsZ2iny9xM08Rnv9eB3CsY0Mzl6pDyfYb60dANHcoIza3+jxWP6eKk8
	 +g1v5jjJtP99593wxELUn81GKr+IB+6U0IH/aWyw=
Date: Mon, 30 Dec 2024 16:29:13 -0800
To: mm-commits@vger.kernel.org,gourry@gourry.net,ak@linux.intel.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch added to mm-hotfixes-unstable branch
Message-Id: <20241231002913.D5122C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: count MPOL_WEIGHTED_INTERLEAVE to "interleave_hit"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Honggyu Kim <honggyu.kim@sk.com>
Subject: mm/mempolicy: count MPOL_WEIGHTED_INTERLEAVE to "interleave_hit"
Date: Fri, 27 Dec 2024 18:57:37 +0900

Commit fa3bea4e1f82 introduced MPOL_WEIGHTED_INTERLEAVE but it missed
adding its counter to "interleave_hit" of numastat, which is located at
/sys/devices/system/node/nodeN/ directory.

It'd be better to add weighted interleving counter info to the existing
"interleave_hit" instead of introducing a new counter
"weighted_interleave_hit".

Link: https://lkml.kernel.org/r/20241227095737.645-1-honggyu.kim@sk.com
Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit
+++ a/mm/mempolicy.c
@@ -2268,7 +2268,8 @@ struct page *alloc_pages_mpol_noprof(gfp
 
 	page = __alloc_pages_noprof(gfp, order, nid, nodemask);
 
-	if (unlikely(pol->mode == MPOL_INTERLEAVE) && page) {
+	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
+		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
 		/* skip NUMA_INTERLEAVE_HIT update if numa stats is disabled */
 		if (static_branch_likely(&vm_numa_stat_key) &&
 		    page_to_nid(page) == nid) {
_

Patches currently in -mm which might be from honggyu.kim@sk.com are

mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch
mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch

