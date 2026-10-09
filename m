Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B4240DB3C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525480; cv=none; b=OY3mgudKzIKs8vuAoZvDnGNykCPR9bcMMpPiqCUPxdwEAzfoU+penIDkWpEk8HUNm1SIXhdefQ9I1kc73c6FTsAK47e2Lb2ufZ8mGNO89Os+1koDRt/Z9AB9WJ7U6AW2ik9nDuw9i2+eziXiSaD6va2gpF1OcuvnWgeMwkCY55I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525480; c=relaxed/simple;
	bh=25fSSVdyUQLlT3wQw2IPTbChohWEUmYcILaef9/Bsxo=;
	h=Date:To:From:Subject:Message-Id; b=Hp/l4iYQOBHo/1B716Nf825ghNq7zveYHaTYkNLkXTX1jY+pnuU77nOYI1CxgSHhyUngnf7FGOx1F4W8+wLD0+SgpQjQNqUcixV8gYtg4OCoSrcvb01azuf2WCDegQWezPbaiG1lvBhtN5bLvtj5E6MNJWkggl5+bDfDh30mnXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y1TKlpKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y1TKlpKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836B81F00893;
	Fri,  9 Oct 2026 05:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525475;
	bh=QpKuWDS/QFz1fIy43Qa5ivuIZt0PUHUDmlrbq5wOZag=;
	h=Date:To:From:Subject;
	b=y1TKlpKC3JxTeEp2PyMG8w6Q6cMGSDqRr6U8zMh+WxW+zZZhKGt7qzPQZ5vnHLq9m
	 hhFaLHfA3ywQ5Rq3077O5GwPo5a/sg88/eDayZ0wJ4h9+ZwySv3hL6GTy3BFM7PQ81
	 urj8z27wV46wBEx/YGbRw3jPbrckHlEs28RnS6+A=
Date: Thu, 08 Oct 2026 22:57:55 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch removed from -mm tree
Message-Id: <20261009055755.836B81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix stale comment on swap_info_struct::cluster_info
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-stale-comment-on-swap_info_struct-cluster_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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


