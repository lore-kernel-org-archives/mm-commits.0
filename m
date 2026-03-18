Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23B93F8DE6
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 20:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864818; cv=none; b=IJAdMJNZf14OdaKC8a9c+swpoyhG1bF+Y/t2ZbnqSJR6WvR1dKpmD6XPQqN6ZayWyKmLhQbNTrUqJNsx0Rwr0qDM+ithDMiP6Pem4jtWbbUBrQ50Hp6xfArbAaNjq/WhCmKTryBKmZAKl88EXuwvdmWY0MPF2YjIe87K5Gud/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864818; c=relaxed/simple;
	bh=nASrKK9LX2lgoCuk1PUfaDlBbaDa0n07L3Ou/CCqnfo=;
	h=Date:To:From:Subject:Message-Id; b=jKMrofqHfhd+crQnbdoYQdoh0B9IJVAJl1tAJf1xfNYNm2RaCvXfFrso2VKc6aOKLm//7uKU2tN+zYfk6zoe1ozqkbtEn/HL4Crt6Fkm/9jDpE6rq/CIBJs2Dpm5t11X1S/jhk5jof+y9QSkhKrO56zXPf73FcNQKf/V/lizbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PuL2zr5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PuL2zr5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49105C19421;
	Wed, 18 Mar 2026 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773864818;
	bh=nASrKK9LX2lgoCuk1PUfaDlBbaDa0n07L3Ou/CCqnfo=;
	h=Date:To:From:Subject:From;
	b=PuL2zr5Egdtx2tI7MmBO96TDSbvdOaqVYQ+97RXVrlI7r/sOV3ZqQ/KOCcwNT7bKC
	 QxF25jDiJfxL+zPHEss+gQVzqEdFmIHdEHDGEvePaJWWnzce3cf6NqBrgOuC3cRFbP
	 G+kUw2xhGi3QrhwXT2cSedYvk8KQWGGwhPa/Px/g=
Date: Wed, 18 Mar 2026 13:13:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch added to mm-new branch
Message-Id: <20260318201338.49105C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Wed, 18 Mar 2026 15:53:21 -0400

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting.  Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Link: https://lkml.kernel.org/r/20260318200352.1039011-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch
mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

