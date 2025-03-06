Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F929CF0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239454; cv=none; b=B66Ct+RYy+7t8U1ERGfBe3FGREljXO5JbfevUQF/BRIpInBM3ANfbHWBdLtItWUlD8HTcFWXlUfnNeJcYotn500UwZwIiPL0F/iNUTyQnQY4unWRme8/coHSBZY5MU9LhQ+CeqEkUoQO626hd0IQqdeCXw8L2ht7fKdpUKY+8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239454; c=relaxed/simple;
	bh=DwEUVW4+gUsAxFoItdfHb0L8uBIK1Nt61Fbjp6vhnag=;
	h=Date:To:From:Subject:Message-Id; b=dAhAXsXeSwCgZAtMH6XeZj1eCHe6HB0lfoNKIM1Iop3y8N2bAEIa6aee793KAyGB+0SKQRwrSMSCdP0nYzDJuA/8BoTSNMth4zs5S9KjsdWCo9EUeqr8j7fyto2NxusJR2Euqxrh7tHAeoc/rSNpu9celWtXePCyDt7radeTjXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mQaF2S4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mQaF2S4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB587C4CEE4;
	Thu,  6 Mar 2025 05:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239453;
	bh=DwEUVW4+gUsAxFoItdfHb0L8uBIK1Nt61Fbjp6vhnag=;
	h=Date:To:From:Subject:From;
	b=mQaF2S4tt4oD42hOtwWcCC20vqH83haeNaOHa/hs1JHF8MeZGuD1t91Gky1fJAzWy
	 MxopGGg9NtXgEvjwmu/AFF4TZNFFTS9ETEyygueKpOd19BVRtgeu1dySNEBF3Be5oN
	 86mavtWU+ABtApyGXBy3YmNrDwq0BC5rP7VQIFDE=
Date: Wed, 05 Mar 2025 21:37:33 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-avoid-bug_on-in-relocate_cluster.patch removed from -mm tree
Message-Id: <20250306053733.BB587C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: avoid BUG_ON in relocate_cluster()
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-bug_on-in-relocate_cluster.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: avoid BUG_ON in relocate_cluster()
Date: Sun, 23 Feb 2025 00:08:47 +0800

If allocation is racy with swapoff, we may call free_cluster for cluster
already in free list and trigger BUG_ON() as following:

Allocation                        Swapoff
cluster_alloc_swap_entry
 ...
 /* may get a free cluster with offset */
 offset = xxx;
 if (offset)
  ci = lock_cluster(si, offset);

                                  ...
                                   del_from_avail_list(p, true);
                                    si->flags &= ~SWP_WRITEOK;

  alloc_swap_scan_cluster(si, ci, ...)
   ...
   /* failed to alloc entry from free entry */
   if (!cluster_alloc_range(...))
    break;
   ...
   /* add back a free cluster */
   relocate_cluster(si, ci);
    if (!ci->count)
     free_cluster(si, ci);
      VM_BUG_ON(ci->flags == CLUSTER_FLAG_FREE);

To prevent the BUG_ON(), call free_cluster() for free cluster to move the
cluster to tail of list.

Check cluster is not free before calling free_cluster() in
relocate_cluster() to avoid BUG_ON().

Link: https://lkml.kernel.org/r/20250222160850.505274-4-shikemeng@huaweicloud.com
Fixes: 3b644773eefd ("mm, swap: reduce contention on device lock")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-avoid-bug_on-in-relocate_cluster
+++ a/mm/swapfile.c
@@ -653,7 +653,8 @@ static void relocate_cluster(struct swap
 		return;
 
 	if (!ci->count) {
-		free_cluster(si, ci);
+		if (ci->flags != CLUSTER_FLAG_FREE)
+			free_cluster(si, ci);
 	} else if (ci->count != SWAPFILE_CLUSTER) {
 		if (ci->flags != CLUSTER_FLAG_FRAG)
 			move_cluster(si, ci, &si->frag_clusters[ci->order],
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

