Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550413777E
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737447; cv=none; b=Q3RbHCbEZt6EPYm6h6gwISXqONaKcLCsf1/CfWoZmWMoYXmnYSywoPaeijTDOaMfPIJyrQ8y0YqjHhSpONeqlMDHPwOVJZPy+aMuJ807QOzBTV4q+sQGB1W3hHWOblN/IDhfs60KwIor+ToGRLJf0zcFewC0d+ZYNKdLVA5Fp/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737447; c=relaxed/simple;
	bh=S9uYghd5Vhja07sOXduhdFK4xuST8TimkvEzLQaUHlY=;
	h=Date:To:From:Subject:Message-Id; b=R8RAw7FM2CusHF0uy/NwphSbe4sIOQRPiMVDRNQ2RNIg4kcHuIUV0yxX7xjbYf0vf2iWKRGI0coKbEy3ZzMVHciPcizuaP0Zq8uxAg2R1ilgUDhJuLzvrQ4hTx/3Gk9VkqZAEb/HIzttOzLZXN5bwZG1D7bmWUd16cmoJKSI0rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1DuywBex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1DuywBex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2235BC4CEE0;
	Mon, 13 Jan 2025 03:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737447;
	bh=S9uYghd5Vhja07sOXduhdFK4xuST8TimkvEzLQaUHlY=;
	h=Date:To:From:Subject:From;
	b=1DuywBexD4bAqGhtdTD+6CcgfIrY6/auIIPbWq+ZP2e+l3es9Lw3zT/p9pw+rioEX
	 trigYSJDrw/6rIoTGbbnJGzMicXHzrIROCp/fecDi0JNeu3v86IV5RSKMhR5RVQGQO
	 Ox4T9aJ1ioBpPQWUY1v/e6BrxBKfmdtIj0ROXLIk=
Date: Sun, 12 Jan 2025 19:04:06 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,hyeonggon.yoo@sk.com,gourry@gourry.net,ak@linux.intel.com,honggyu.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch removed from -mm tree
Message-Id: <20250113030407.2235BC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: count MPOL_WEIGHTED_INTERLEAVE to "interleave_hit"
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-count-mpol_weighted_interleave-to-interleave_hit.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Hyeonggon Yoo <hyeonggon.yoo@sk.com>
Tested-by: Yunjeong Mun <yunjeong.mun@sk.com>
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

mm-damon-core-remove-duplicate-list_empty-quota-goals-check.patch

