Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227528F4
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275129; cv=none; b=prcOkmB9MMAcBpQ4gE0LGVX2Sf1l3UAdsqpLKobzxwZ5UXuIivWndTcSvhoL7TlaDJeoznY6tUMOH6TJV++QZhmWBp7fPW+RvFxTD8SCiw4xkwdPM18gvO++rWf/v/AS042iwmuTCTmGSist4NxKpLdbw4+EK+eQyk2H5g3dZ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275129; c=relaxed/simple;
	bh=dvBA2kohMfY1JfEDR5+DeDNMY+n7k9Cuq91XKS6rnrQ=;
	h=Date:To:From:Subject:Message-Id; b=HOiHanUMoU5GiBIF8yuV7+60eg1S4eMmlgM/j4j1jU63dN0J3MfHJOydzSRTbEGSy9HbKjahEXSzupln4Oy5ns3EIqc5dkVrMyASputIiwKWal3y+eGQO/NYw5Dc4jw5kvF9CFvLWzkX3IraGbVMaT4H/eMMczPmS7XDVrCrTL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMf7ijQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMf7ijQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB9C4CED1;
	Sun, 23 Feb 2025 01:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275129;
	bh=dvBA2kohMfY1JfEDR5+DeDNMY+n7k9Cuq91XKS6rnrQ=;
	h=Date:To:From:Subject:From;
	b=HMf7ijQ6ouFLGM7dPVHHH/8pzVnNYrbwdryAaiDilBdEdl5vXZ9cNAIGIEI/kYzrG
	 4HQO1743vGsHiEO7xB2vdOc3p0/gHLJQQhT46Me4F3rC2Bx1ouA0AIVD8JOR4eompO
	 lABCsycRRYwq3ulvgO5rprxaJioexP1KtIcdHSf4=
Date: Sat, 22 Feb 2025 17:45:28 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch added to mm-unstable branch
Message-Id: <20250223014529.1DCB9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove setting SWAP_MAP_BAD for discard cluster
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: remove setting SWAP_MAP_BAD for discard cluster
Date: Sun, 23 Feb 2025 00:08:48 +0800

Before alloc from a cluster, we will aqcuire cluster's lock and make sure
it is usable by cluster_is_usable(), so there is no need to set
SWAP_MAP_BAD for cluster to be discarded.

Link: https://lkml.kernel.org/r/20250222160850.505274-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-setting-swap_map_bad-for-discard-cluster
+++ a/mm/swapfile.c
@@ -479,15 +479,6 @@ static void move_cluster(struct swap_inf
 static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 		struct swap_cluster_info *ci)
 {
-	unsigned int idx = cluster_index(si, ci);
-	/*
-	 * If scan_swap_map_slots() can't find a free cluster, it will check
-	 * si->swap_map directly. To make sure the discarding cluster isn't
-	 * taken by scan_swap_map_slots(), mark the swap entries bad (occupied).
-	 * It will be cleared after discard
-	 */
-	memset(si->swap_map + idx * SWAPFILE_CLUSTER,
-			SWAP_MAP_BAD, SWAPFILE_CLUSTER);
 	VM_BUG_ON(ci->flags == CLUSTER_FLAG_FREE);
 	move_cluster(si, ci, &si->discard_clusters, CLUSTER_FLAG_DISCARD);
 	schedule_work(&si->discard_work);
@@ -571,8 +562,6 @@ static bool swap_do_scheduled_discard(st
 		 * return the cluster to allocation list.
 		 */
 		ci->flags = CLUSTER_FLAG_NONE;
-		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
-				0, SWAPFILE_CLUSTER);
 		__free_cluster(si, ci);
 		spin_unlock(&ci->lock);
 		ret = true;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

