Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A4381B1F
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897429; cv=none; b=s73W6A8YCMOs1wlteIOYBF+rVETanVnpiKl+s0872sTkv50q7kUqPi1PW2oDB7uNF8DL3GjDlDh2LkXnK5ibLmsaQv07P0mK+DcvjRN6IRGH8wUeVbGwqeHLHHEk+9GNGjdPiS5O7A/sEeaEaeS2lCQPcdCjDk9hBHufgtSSYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897429; c=relaxed/simple;
	bh=emuh/z5dN74KmAalZ7Eg9XRFR84AyZ/s0iCGyvG7JIQ=;
	h=Date:To:From:Subject:Message-Id; b=YrFAXJC1oxEeoD/UQZj5iwmUaxRlanJKW5O5ZMlScCDMjoFt/FVM1HnLq6O6iX5OiR+B4FfG1dC5lhthMLyqkie7xBjYSPgviFOe0A7aBUhPby5VKoKZDTgrv5LPW+dtZF9F/iDgQKRugyQ1Af+rrScNntK2wkb8X3O0MCP2qN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAzI1zx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAzI1zx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625D4C4CEF7;
	Mon, 30 Mar 2026 19:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897429;
	bh=emuh/z5dN74KmAalZ7Eg9XRFR84AyZ/s0iCGyvG7JIQ=;
	h=Date:To:From:Subject:From;
	b=IAzI1zx+JQE/YrHy9Ep+7URHhPonZGcZj9tMgYinsA+Vb0xHQxwVUULuJEgnyUSzi
	 CKBI5XuoCjtoj4kowDVS35zJ+riz2xRli+6IBjb185Uj/t/MWIIebnmvQl+q+/2gZX
	 HPXQ/GpUtbbCji/oROyPhA94cnkLLE00rzOHzj5s=
Date: Mon, 30 Mar 2026 12:03:48 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch removed from -mm tree
Message-Id: <20260330190349.625D4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Wed, 18 Mar 2026 15:53:21 -0400

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting.  Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Link: https://lkml.kernel.org/r/20260318200352.1039011-4-hannes@cmpxchg.org
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

 mm/list_lru.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg
+++ a/mm/list_lru.c
@@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
 {
 	if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		unlock_list_lru(l, irq);
-		return false;
-	}
-	return true;
 }
 
 static inline struct list_lru_one *
@@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

