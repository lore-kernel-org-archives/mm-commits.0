Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82FC32B989
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068104; cv=none; b=BMY9Oa2p17qGmdn2I3l4HEB7MiaCRmHKan1RSwItCUEDYl251FbULvVaLuqh4W9yprlukXMPE4a/gu/H0UqNdS1/4HqosUkA5c1xjvFaXlzXkWGFsXpBEIH3p/ND73GudCCO+INuitS5Vu7t4lOqetJAp89blKIJA+hwj2M/TUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068104; c=relaxed/simple;
	bh=azBAQw7Dj0k1X28FHcWzRz2ghrkPmjq0CuBE80GEfqQ=;
	h=Date:To:From:Subject:Message-Id; b=I7ETe9cu/xPYTywA36Ck+qRuKUo3f4rXZM9dny6C80Hr3q75KItL6Db6jzM4gZV86b8Kls3ZhwhZjBFGC7JM0789NRxQVmtqRcFBT4KqYP8DoxFcxzNiux38VaR3iKaSWP/rK0h9ICaYydnACMFbg/NKf0oIRSqo5iHLWmAYwt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xS7tnZrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xS7tnZrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9156C1F00A3A;
	Fri,  7 Aug 2026 02:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068102;
	bh=a/RGAODwLf8FbBdBILJs3EuBq3+is1qDxOp+MrTeQjQ=;
	h=Date:To:From:Subject;
	b=xS7tnZrL+XadbgeN7uat0XMeeJ+ycCt0mHr9SinUUOt9FeZ49I5N4b0Z621qEWW0f
	 /gFr6O9TROjYYdriBgVWv9TH2D0EVTRYALbLOCO9rFlPxVLs0hXFmVsvMMCMblFeut
	 zaPcKdBs71bt25S/CSORGsMDYQIarm2emCg7Dl9Y=
Date: Thu, 06 Aug 2026 19:01:42 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,david@kernel.org,dave@stgolabs.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch removed from -mm tree
Message-Id: <20260807020142.9156C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
Date: Fri, 24 Jul 2026 11:34:34 +0800

Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
moved the scan_control construction out to the callers and passed the
struct in by pointer.  After that change every use of the gfp mask inside
__node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
unused.  Just remove the dead parameter and update the callers
accordingly.  No functional change.

Link: https://lore.kernel.org/20260724033435.2573323-4-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-drop-unused-gfp_mask-parameter-from-__node_reclaim
+++ a/mm/vmscan.c
@@ -7740,7 +7740,7 @@ static unsigned long node_pagecache_recl
 /*
  * Try to free up some pages from this node through reclaim.
  */
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7832,7 +7832,7 @@ unsigned long node_reclaim(struct pglist
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return 0;
 
-	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
+	ret = __node_reclaim(pgdat, nr_pages, &sc);
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (ret >= nr_pages)
@@ -7845,7 +7845,7 @@ unsigned long node_reclaim(struct pglist
 
 #else
 
-static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+static unsigned long __node_reclaim(struct pglist_data *pgdat,
 				    unsigned long nr_pages,
 				    struct scan_control *sc)
 {
@@ -7958,8 +7958,7 @@ int user_proactive_reclaim(char *buf,
 						  &pgdat->flags))
 				return -EBUSY;
 
-			reclaimed = __node_reclaim(pgdat, gfp_mask,
-						   batch_size, &sc);
+			reclaimed = __node_reclaim(pgdat, batch_size, &sc);
 			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 		}
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

memcg-move-mem_cgroup_swappiness-and-vm_swappiness-to-mm-swaph.patch
mm-vmscan-fix-node-reclaim-ignoring-swappiness-parameter.patch

