Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3711C2A1D8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188451; cv=none; b=u5PRofP3KjqHcqaIqRiuFxFSvC09Gy9Bx4t402ZU56k3HSy6fl/ExTRRZUKLNd+VPdV4MtBIS/zp+SJIX75X/j/VHiLX2q6S8Jn/7vWAktSv4LBekuYLgZr2fNr/3AIUHtEpzkXDEiiWjfYgWmuJN81rQs0814Mk64BZl6QzLJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188451; c=relaxed/simple;
	bh=AVnrcrd7h+M4iILG8nCG1+TvOhVkcPTskcUUGaUcR/A=;
	h=Date:To:From:Subject:Message-Id; b=hBwLg249t7nB2iD6y+iI+uyS/e01RiK6eqdXEJwiVEhxqAWc+nJSYYx6azcClP456Wzc5keqb8/yng35Go5uT1M6y7x78ZFLQDHravFyF3BgdPxqbo/X02MM1ZaDqS10OVWC4vHQOmbxT9McWGVawwTMD842xCFMHo679/dwnwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0d9oM8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0d9oM8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D12FC4CEEC;
	Mon, 17 Mar 2025 05:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188451;
	bh=AVnrcrd7h+M4iILG8nCG1+TvOhVkcPTskcUUGaUcR/A=;
	h=Date:To:From:Subject:From;
	b=J0d9oM8V/n1CM9hHcS3/kgE7+dH7Lxbz10r0gU3UlB3aLZRB2OwcrFZpo7DszFJ3L
	 aqGUEU9yHNyswDCyDj6NZieBBlPPg12o04afqouo95D0wkqwCYgT8p0i4RBpgIVGr/
	 NzIHwcd59LZef0rV4PvvUCFMJNf5kwqKQkGrF+cw=
Date: Sun, 16 Mar 2025 22:14:10 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch removed from -mm tree
Message-Id: <20250317051411.0D12FC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove setting SWAP_MAP_BAD for discard cluster
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: remove setting SWAP_MAP_BAD for discard cluster
Date: Sun, 23 Feb 2025 00:08:48 +0800

Before alloc from a cluster, we will aqcuire cluster's lock and make sure
it is usable by cluster_is_usable(), so there is no need to set
SWAP_MAP_BAD for cluster to be discarded.

Link: https://lkml.kernel.org/r/20250222160850.505274-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
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


