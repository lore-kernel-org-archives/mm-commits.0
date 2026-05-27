Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9BE264612
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779919387; cv=none; b=VV5HkIBUdtIvAMtkiRIOAH6eVHw4rSZnbCJ5J0H/QKHz9BlVf9Uj2pxfqvwXNvglwHqb0K8X7O8qJGu6H6B6YVBuiqebjR+yfjKei+1HJoy8mdae86s0QLq3aiBNsq/mo7Fs/Hu2gRK/opK+5T3nepCwlBw+ApQ6nCeNGpj2yDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779919387; c=relaxed/simple;
	bh=DTiXrG7TDDOCNqi9TmNttkNAXBH3HILu/ZFynNZi4ds=;
	h=Date:To:From:Subject:Message-Id; b=HE1N2nZhJNyulWb3kKOEGB8mVmXLrP+anGo6iOCxPv6XeWZGdV8sCXcQcgKKfycaOXNrbB8x7Lk9Rai5uGKTl1u6noXGaTfbawnW3FEM1j9L+VQm8WDNBpPQmk1XNqlTd36Bf9pCPJpr+sHC/7LYjbSLqNoj2F/5S3QSOTh23hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rW3uWk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rW3uWk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F04A1F000E9;
	Wed, 27 May 2026 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779919385;
	bh=VwhdIKI1Qo+y3AbjsgtXLus7yMUzlTPpvUmP2kXGwDY=;
	h=Date:To:From:Subject;
	b=1rW3uWk5VZ1AMWgidkORRo3HVqsRpP8qtwX+AfxSNps5Vb4wrIJARq64aK/B8GHgq
	 jTVw2fHPsyvF+ZR1Gi2rLtE8ObJZlaYPxNhmdBXTbVb57j/Qy+wAR+c9uE2wzazcZl
	 6FLQouFhGweqL367E1yg9+Qr/cTcBVViPo3aTnkE=
Date: Wed, 27 May 2026 15:03:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zaslonko@linux.ibm.com,vbabka@kernel.org,usama.arif@linux.dev,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,gor@linux.ibm.com,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion.patch added to mm-new branch
Message-Id: <20260527220305.8F04A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: fix set_shrinker_bit() call during race with cgroup deletion
has been added to the -mm mm-new branch.  Its filename is
     mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion.patch

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
Subject: mm: list_lru: fix set_shrinker_bit() call during race with cgroup deletion
Date: Wed, 27 May 2026 16:45:08 -0400

Patch series "mm: switch THP shrinker to list_lru", v5.

The open-coded deferred split queue has issues.  It's not NUMA-aware (when
cgroup is enabled), and it's more complicated in the callsites interacting
with it.  Switching to list_lru fixes the NUMA problem and streamlines
things.  It also simplifies planned shrinker work.

Patch 1 fixes a pre-existing list_lru bug where the shrinker bit is set on
the caller's memcg rather than the ancestor whose sublist the item
actually lands on after a walk-up.  Standalone, backportable; the rest of
the series depends on it.

Patches 2-5 are cleanups and small refactors in list_lru code.  They're
basically independent, but make the THP shrinker conversion easier.

Patch 6 extends the list_lru API to allow the caller to control the
locking scope.  The THP shrinker has private state it needs to keep
synchronized with the LRU state.

Patch 7 extends the list_lru API with a convenience helper to do list_lru
head allocation (memcg_list_lru_alloc) when coming from a folio.  Anon
THPs are instantiated in several places, and with the folio reparenting
patches pending, folio_memcg() access is now a more delicate dance.  This
avoids having to replicate that dance everywhere.

Patch 8 flattens the alloc_anon_folio() retry loop so the next patch's
list_lru hook lands as a clean addition rather than nested deep inside an
if (folio) block.

Patch 9 finally switches the deferred_split_queue to list_lru.


This patch (of 9):

When list_lru_add() races with cgroup deletion, the shrinker bit is set on
the wrong group and lost.  This can cause a shrinker run to miss the
cgroup that actually has the object.

When the passed in memcg is dead, the function finds the first non-dead
parent from the passed in memcg and adds the object there; but the
shrinker bit is set on the memcg that was passed in.

This bug is as old as the shrinker bitmap itself.

Fix it by returning the "effective" memcg from the locking function, and
have the caller use that.

Link: https://lore.kernel.org/20260527204757.2544958-1-hannes@cmpxchg.org
Link: https://lore.kernel.org/20260527204757.2544958-2-hannes@cmpxchg.org
Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Usama Arif <usama.arif@linux.dev>
Reported-by: Sashiko
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion
+++ a/mm/list_lru.c
@@ -77,14 +77,14 @@ static inline bool lock_list_lru(struct
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
 {
 	struct list_lru_one *l;
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
 	if (likely(l) && lock_list_lru(l, irq)) {
 		rcu_read_unlock();
 		return l;
@@ -97,8 +97,8 @@ again:
 		rcu_read_unlock();
 		return NULL;
 	}
-	VM_WARN_ON(!css_is_dying(&memcg->css));
-	memcg = parent_mem_cgroup(memcg);
+	VM_WARN_ON(!css_is_dying(&(*memcg)->css));
+	*memcg = parent_mem_cgroup(*memcg);
 	goto again;
 }
 
@@ -135,8 +135,8 @@ list_lru_from_memcg_idx(struct list_lru
 }
 
 static inline struct list_lru_one *
-lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
-		       bool irq, bool skip_empty)
+lock_list_lru_of_memcg(struct list_lru *lru, int nid,
+		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
@@ -164,12 +164,16 @@ bool list_lru_add(struct list_lru *lru,
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
 
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
 	if (!l)
 		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
-		/* Set shrinker bit if the first element was added */
+		/*
+		 * Set shrinker bit on the memcg that owns the locked
+		 * sublist - lock_list_lru_of_memcg() may have walked up
+		 * past a dying memcg, and the bit must be set there.
+		 */
 		if (!l->nr_items++)
 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
 		unlock_list_lru(l, false);
@@ -204,7 +208,7 @@ bool list_lru_del(struct list_lru *lru,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
-	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
 	if (!l)
 		return false;
 	if (!list_empty(item)) {
@@ -288,7 +292,7 @@ __list_lru_walk_one(struct list_lru *lru
 	unsigned long isolated = 0;
 
 restart:
-	l = lock_list_lru_of_memcg(lru, nid, memcg, irq_off, true);
+	l = lock_list_lru_of_memcg(lru, nid, &memcg, irq_off, true);
 	if (!l)
 		return isolated;
 	list_for_each_safe(item, n, &l->list) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-list_lru-fix-set_shrinker_bit-call-during-race-with-cgroup-deletion.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-memory-flatten-alloc_anon_folio-retry-loop.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

