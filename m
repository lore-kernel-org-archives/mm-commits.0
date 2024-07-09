Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343714374C
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561822; cv=none; b=kkatNk8vqEZNl9M/TEfWRkRyYNdNn0v8nZodvN4BOLIAfexb5ivdcnM9i3h4TSuydtFeorGMnlkS+RrJCx0er5OyJnWSrMw8zDS5kGpYhbHJ+ZF/g3ncQ8OvVJ/Z+DPo3wfKVhUdDHnjzReOFggfhfO/yHzFcQdW6tr5IChGDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561822; c=relaxed/simple;
	bh=QkTspA8DPBkfNhb0ymau7j3nrWDjuFhtqKvLbbCnnW8=;
	h=Date:To:From:Subject:Message-Id; b=Xvy0HI6mSNLuJpYRnppCHncZeHHqZPBai3Vi1gFuRx8uUOHaOm9vm3ndMbdWlsQ6rG5hTgj+Tbf/tBc7/LwvEPjJAqNj0XJhYM/7PeYh5Kc30vpZ5Tdryv5hdaDbeKWMGEv0TQCSYUB30hCXVJSDZjbGFzoKcPrtvWgLj6kjA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1Sva5Fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1Sva5Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71401C3277B;
	Tue,  9 Jul 2024 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720561821;
	bh=QkTspA8DPBkfNhb0ymau7j3nrWDjuFhtqKvLbbCnnW8=;
	h=Date:To:From:Subject:From;
	b=x1Sva5Fe+0oYUVM/I+mpWIdR82tTLohSA75OkPpO8iufuSpkR2ISlICxl4A+Ua+nm
	 gCGMS8Qk4K52IbZ/8GztK4hWR0+xKoVlQ8Sy/APl9UYi2mLHvm3erR1gApx1XkymZL
	 TmDvklp8VQnrfWi5xLq9mLYK1MzqiUvjS3rl/Lco=
Date: Tue, 09 Jul 2024 14:50:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-zonelist_zone-to-get-zone.patch removed from -mm tree
Message-Id: <20240709215021.71401C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zonelist_zone() to get zone
has been removed from the -mm tree.  Its filename was
     mm-use-zonelist_zone-to-get-zone.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: use zonelist_zone() to get zone
Date: Sat, 6 Jul 2024 01:50:44 +0000

Instead of accessing zoneref->zone directly, use zonelist_zone() like
other places for consistency.

No functional change.

Link: https://lkml.kernel.org/r/20240706015044.27789-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-use-zonelist_zone-to-get-zone
+++ a/include/linux/mmzone.h
@@ -1690,7 +1690,7 @@ static inline struct zoneref *first_zone
 			zone = zonelist_zone(z))
 
 #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
-	for (zone = z->zone;	\
+	for (zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
@@ -1726,7 +1726,7 @@ static inline bool movable_only_nodes(no
 	nid = first_node(*nodes);
 	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
 	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
-	return (!z->zone) ? true : false;
+	return (!zonelist_zone(z)) ? true : false;
 }
 
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

