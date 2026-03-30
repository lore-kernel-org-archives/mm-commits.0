Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CF136404D
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897428; cv=none; b=H4Fs/+/b88L62B0OPseyX/mgiFQBdZv6l7oYCq/Lzk7/YjHb6Jvkj05xYZEz52iQ0XwdNdlMKj4V5QiFq7cPpgdpggkxxPjJaeqKToCuT9Jr0BdUUBxnIyJcqJTjINQ74NxryMhm9tZg+rBUJ7BVfzTTvyxkHimdWJmzkf3mEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897428; c=relaxed/simple;
	bh=XKN4gLbUEHPtC/Qu9c4cSrT457ZzarAt/78FfIJ2snU=;
	h=Date:To:From:Subject:Message-Id; b=XDkr3kBYcdbzeYWkGUBRHksn8H2u3AJMBCZcCrvVBKteA35tPPL0yIIil+Vy+CkUkmDIk70JawiAKChhetFNFp+fPMmWC4EfAsbQEu4GY9YbpiFjl8ARtU64qJEagrBxZ0eooR+6ei33YAIKNRg7IwU4lgx9HKxO1fvAwwcOhAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fFoWEJYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fFoWEJYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A59FC4CEF7;
	Mon, 30 Mar 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897428;
	bh=XKN4gLbUEHPtC/Qu9c4cSrT457ZzarAt/78FfIJ2snU=;
	h=Date:To:From:Subject:From;
	b=fFoWEJYNC42qxNW69XXf4BLklW9g2I6HlLJMhhEqa3gnODoGB5APVIyzMmZdzDDlB
	 2UHAYb/VxWeG8mqWZVk/aoKO42VPnFTgGIm767xvgCdWt3qDhw0iAbshOZDYF0uQI7
	 boldxswM6ry6WME/TfsRRIsNgWUoAsMvkISz5byI=
Date: Mon, 30 Mar 2026 12:03:47 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-list_lru-deduplicate-unlock_list_lru.patch removed from -mm tree
Message-Id: <20260330190348.0A59FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: deduplicate unlock_list_lru()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-deduplicate-unlock_list_lru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: deduplicate unlock_list_lru()
Date: Wed, 18 Mar 2026 15:53:20 -0400

The MEMCG and !MEMCG variants are the same.  lock_list_lru() has the same
pattern when bailing.  Consolidate into a common implementation.

Link: https://lkml.kernel.org/r/20260318200352.1039011-3-hannes@cmpxchg.org
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

 mm/list_lru.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-deduplicate-unlock_list_lru
+++ a/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+{
+	if (irq_off)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct
 	else
 		spin_lock(&l->lock);
 	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+		unlock_list_lru(l, irq);
 		return false;
 	}
 	return true;
@@ -101,14 +106,6 @@ again:
 	memcg = parent_mem_cgroup(memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *
 
 	return l;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

