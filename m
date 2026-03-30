Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143EF3803DD
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897431; cv=none; b=n2bV19mEwpPFt33nRWKRgMOMX8xW8JZEqPNlPhme45ZeXN7rDBlQb3lYMG8B/8t8U0aMPRKtTlbHoPihs9EFabHZ2V4bBuSpmilE9Le4nQH0n8XpsZ+hTX8uraVAaL5G4YB71mGCxPyg9jb0ryAwsYRBiuHo8USM508JLMnmGBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897431; c=relaxed/simple;
	bh=J/B/gdewBU/2D7oGgBZDDa7mQ4fNA8mOhq9CoUlC1S0=;
	h=Date:To:From:Subject:Message-Id; b=VRs2aLHqKKgNed3X0BLAWA05ihoMsaiQNh92YMskOHa5RXpFQ+v/ismBLdaJbMcoJOrxoCL9/E8CIaHs7snzQN2m/10bRlFSJwkdRE67DtB2PnnDWHhtYByA8Tik2aXsXeKr2zyLqcCOKXmh8aoEUPrVNNHkfP7stVEuKtyNrJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K+JV8vZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K+JV8vZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D9CC4CEF7;
	Mon, 30 Mar 2026 19:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897430;
	bh=J/B/gdewBU/2D7oGgBZDDa7mQ4fNA8mOhq9CoUlC1S0=;
	h=Date:To:From:Subject:From;
	b=K+JV8vZQH9ovRWljhQncU61RHyQQwQCVf13pUzcK3UH+o3iFBpO+UF7cmDJ6xsm0f
	 hPwZ8gHrtkvZsbPDFrL/UuIC0ovw3EFNNp4LaLl6uURIgNif84KAbOccTjpo/G0t3v
	 C9OQUOwsKFA5u+e41XZiRKg5P81uARQh4KNi+0d0=
Date: Mon, 30 Mar 2026 12:03:50 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-list_lru-deduplicate-lock_list_lru.patch removed from -mm tree
Message-Id: <20260330190350.D6D9CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: deduplicate lock_list_lru()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-deduplicate-lock_list_lru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: deduplicate lock_list_lru()
Date: Wed, 18 Mar 2026 15:53:22 -0400

The MEMCG and !MEMCG paths have the same pattern. Share the code.

Link: https://lkml.kernel.org/r/20260318200352.1039011-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-deduplicate-lock_list_lru
+++ a/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		       bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
+	lock_list_lru(l, irq);
 
 	return l;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

