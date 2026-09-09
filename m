Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD735E1CE
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976211; cv=none; b=EcKNNqoc73rbhDQf7zRmupv5Gi5NOwyXuECucq7D0Jo6KIky4xzgkLHxAeIRdx6qdXA1CnyPJ/szLyu22ytn1k46hYHZvuBRc1R3nkJTE3qBjqfGufFf+8Bz0D+JrTK3LgOy4ZzWygm/JESqFX0D82AZIynQBhNbPSCY/p6AHwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976211; c=relaxed/simple;
	bh=sKiiMRPV1jY9gn9vsy/msySsynl7xUo7N+OvX3l3J4E=;
	h=Date:To:From:Subject:Message-Id; b=kORhtQtbwuF1rZ3FSE4VLy3hQa20dYLsbhIAiHpSpRa1jNeayslV1/RdroDJZa51um63W4kdMdivFILqicT3+ecYf52VYJKkY8iY1Si1UiIXDv/ORwLWU04XmMoSKkHrT+PVQnjsYiBzflB3141gBTqWJy+aQsIEnvyZuJEPZ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T/4ZlZi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T/4ZlZi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114461F000FF;
	Wed,  9 Sep 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788976210;
	bh=V5Clng4mShbFQH6Lk/HqPZ+0MWZwjo+neWR6paNkP3s=;
	h=Date:To:From:Subject;
	b=T/4ZlZi8xr3T9um1xHWHma1hdwn+a0BBiWf9jZUtVSkyjq+4keqgt+bGslQ8Gc8PV
	 MlOjEROkbEUd87TKx3HU58e4u1tJdd8hlqTWAOkVLTGEEfae3C2xLneVfhIJFUh0s1
	 ttwEYgD6oWvbdqaLrDFE0y4ukkixjmuKIY92cWHQ=
Date: Wed, 09 Sep 2026 10:50:09 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch added to mm-new branch
Message-Id: <20260909175010.114461F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: fix stale comment on swap_info_struct::cluster_info
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swap: fix stale comment on swap_info_struct::cluster_info
Date: Thu, 10 Sep 2026 01:15:51 +0900

Patch series "mm/swap: skip empty clusters in the swapoff scan", v4.

Speed up swapoff and reduce scanning stalls on large, mostly empty swap
devices by skipping empty clusters.  Reduce swapoff time on a 1 TiB device
from 158 ms to 94 ms after filling 128 GiB, and from 392 ms to 73 ms after
filling 512 GiB; expect little benefit when substantial swap data remains.

find_next_to_unuse() walks a swap device one offset at a time.  Slot state
now lives in a per cluster swap table, so patch 2 dismisses an empty
cluster with one counter read instead of SWAPFILE_CLUSTER table reads.

Patch 1 is an unrelated one line comment fix noticed on the way.

A debug test confirmed the skip path runs, and swapoff completed under
load with no DEBUG_VM or lockdep splats.


This patch (of 2):

setup_swap_clusters_info() allocates cluster_info for every swap area, not
only for SSDs.

Link: https://lore.kernel.org/20260909161552.2335971-1-youngjun.park@lge.com
Link: https://lore.kernel.org/20260909161552.2335971-2-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info
+++ a/include/linux/swap.h
@@ -240,7 +240,7 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch
mm-swap-scan-by-cluster-in-find_next_to_unuse.patch

