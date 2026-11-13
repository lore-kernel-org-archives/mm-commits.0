Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546447;
	b=JeIf0MdndiZoXtA8ICNsX5U0RlBhHCfkxQvCko+jeTU5WbzebWeSr/buysEe7LlGlyBV
	 yLtyfwkxLsU35NLzAvh54GxJV3slmkZgwU4gx3ZDii7xqCifEQH8R0ylHaLltAy6aVXfd
	 Mk0wYKytnv8oTG1L0+gLrTkmXFzJKWyMs3w/TMhnyZ/ORGvX7IjyCYCA9CBtoWOPMr2gG
	 prhwUi7KMwv6CTRQuU1GdHL/bpkQcILwbr3GbAa8b1zH6Q+98c694Qw9HEA6w4UyDSkQu
	 REmEUpzztJa5uaHZSFffLpyzxneBhTO/3GquSrx5cAhNBXObogQsgPWcXNVib5mO5tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546447;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bJ/Vd+X3+YSoEZDt3dXN3rzmU7VJvoETw5Ih7hrgRq8=;
	b=GP2RjNf4/S78FY4attGjOyd/PMuxrDX4pphqcH6QFclFWuHAj9VVTj/Hb1u3HqQDH4rG
	 VmxJPEHORBkmrDO+O55tWt9l9wQBvW1u1KJ1Pio6qL8tzjhVsXz0OkVfpWEB/7FKpGbhN
	 +hRP491RAjjnCQGvR+x0RRahx4VMOCr74J6iFK+cFxIsSYKcur1BmMEgn1kCQg2dqLsMs
	 OhADGJYJdWIC1JRKLC1B95tN+zF3rAHjKfUpOfFrWJJWjkmrIa73j98f5Z2XH84fuxB5/
	 FSHzNzBk9h+tNwCOWEisWrnK9OFuu/o9oUdF+bnbiu1ZirVNz4Y2B2xeVRPY0tNxgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s6T+abRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AD606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s6T+abRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B9E1F000C5;
	Fri, 13 Nov 2026 05:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794546446;
	bh=bJ/Vd+X3+YSoEZDt3dXN3rzmU7VJvoETw5Ih7hrgRq8=;
	h=Date:To:From:Subject;
	b=s6T+abRIxb7fu77UbIGxsyruSO1SSRjzCIsu7jQ+L98hw7cy95Eewel3Glt9YBdDI
	 IyF65lt8k7uxhOFQ7rz84W+LY9r7OqJPqb0TjPsRSO4cTqyOwJNIOY3yxhUriFC3ci
	 0gmm9uXqffg7KOI7znpndWD6TuaKJSaQvfNqT6ek=
Date: Thu, 12 Nov 2026 21:07:26 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,
	muchun.song@linux.dev,mhocko@kernel.org,mason@kernel.org,hannes@cmpxchg.org,
	david@kernel.org,david@fromorbit.com,shakeel.butt@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch added to mm-hotfixes-unstable branch
Message-Id: <20261113050726.99B9E1F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: list_lru: don't use a new memcg's lists for an offline memcg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm: list_lru: don't use a new memcg's lists for an offline memcg
Date: Thu, 12 Nov 2026 14:12:48 -0800

A memcg's list_lru lists are found by its kmemcg_id, which is its
private ID. Offlining a memcg moves its lists to the parent and frees
the ID right away, with no RCU grace period. The next new memcg can get
the same ID and allocate its own lists at that index.

A caller that holds only the RCU read lock, such as
__folio_unqueue_deferred_split(), can still hold the offline memcg. If
it is preempted until the ID is reused, it then locks the new memcg's
list and unlinks a folio that now sits on the parent's list, without
holding the parent's lock. A concurrent change to the parent's list can
then leave a pointer to a freed folio on it.

Users see list corruption reports, crashes or silent memory corruption
when memory cgroups are removed and created while THPs are freed, on
kernels with preemptible RCU, which is the default on x86 and arm64.
They can also see a warning from memcg_reparent_list_lru_one() when the
new memcg is removed, because the wrong unlink made its count negative.

Fix it by recording the owning memcg in each list_lru_memcg, and by
treating the index as empty when its lists belong to another memcg. The
lookup then moves up to the parent, whose list holds the folio.

Link: https://lore.kernel.org/20261112221248.3512447-1-shakeel.butt@linux.dev
Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 include/linux/list_lru.h |    2 ++
 mm/list_lru.c            |   18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg
+++ a/include/linux/list_lru.h
@@ -38,6 +38,8 @@ struct list_lru_one {
 
 struct list_lru_memcg {
 	struct rcu_head		rcu;
+	/* owning memcg, only compared and never dereferenced */
+	const void		*memcg;
 	/* array of per cgroup per node lists, indexed by node id */
 	struct list_lru_one	node[];
 };
--- a/mm/list_lru.c~mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg
+++ a/mm/list_lru.c
@@ -72,12 +72,15 @@ static int lru_shrinker_id(struct list_l
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
+	int idx = memcg_kmem_id(memcg);
+
 	if (list_lru_memcg_aware(lru) && idx >= 0) {
 		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
-		return mlru ? &mlru->node[nid] : NULL;
+		/* Lists at a reused index belong to another memcg. */
+		return mlru && mlru->memcg == memcg ? &mlru->node[nid] : NULL;
 	}
 	return &lru->node[nid].lru;
 }
@@ -91,7 +94,7 @@ lock_list_lru_of_memcg(struct list_lru *
 
 	rcu_read_lock();
 again:
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(*memcg));
+	l = list_lru_from_memcg(lru, nid, *memcg);
 	if (likely(l)) {
 		lock_list_lru(l, irq, irq_flags);
 		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
@@ -132,7 +135,7 @@ static inline bool list_lru_memcg_aware(
 }
 
 static inline struct list_lru_one *
-list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
+list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
 {
 	return &lru->node[nid].lru;
 }
@@ -313,7 +316,7 @@ unsigned long list_lru_count_one(struct
 	long count;
 
 	rcu_read_lock();
-	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
+	l = list_lru_from_memcg(lru, nid, memcg);
 	count = l ? READ_ONCE(l->nr_items) : 0;
 	rcu_read_unlock();
 
@@ -502,11 +505,10 @@ static void memcg_reparent_list_lru_one(
 					struct list_lru_one *src,
 					struct mem_cgroup *dst_memcg)
 {
-	int dst_idx = dst_memcg->kmemcg_id;
 	struct list_lru_one *dst;
 
 	spin_lock_irq(&src->lock);
-	dst = list_lru_from_memcg_idx(lru, nid, dst_idx);
+	dst = list_lru_from_memcg(lru, nid, dst_memcg);
 	spin_lock_nested(&dst->lock, SINGLE_DEPTH_NESTING);
 
 	list_splice_init(&src->list, &dst->list);
@@ -602,6 +604,8 @@ static int __memcg_list_lru_alloc(struct
 			if (!mlru)
 				return -ENOMEM;
 		}
+		/* Set before the lists are published, and never changed after. */
+		mlru->memcg = pos;
 		xas_set(&xas, pos->kmemcg_id);
 		do {
 			xas_lock_irqsave(&xas, flags);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-mglru-splice-all-generations-when-reparenting-a-memcg.patch
memcg-flush-nr_charged_bytes-when-the-obj-stock-trylock-fails.patch
mm-list_lru-fix-null-deref-when-a-folio-moves-to-the-root-memcg.patch
mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch

