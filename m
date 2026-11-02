Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793599305;
	b=4vgvRi8NmDwhiqRn+5KJ+JdlyBE+x7LbWfbxpvJ5Aaert5I11DWAhWQpXlCdaJh3voGq
	 JJbzIIfR8YcUmAakxz9OZvPxZXCP4ae+8md0wwIfruYhnJjrniiQMomdvt/yq5HdGDFOg
	 sV11yUf2VvfngO2tZo40b5mh8jsSdG5mo15lySGE8tiQN+kxkP5Laan8702KIf/FNZIfL
	 e1q+/pobBxkEf3u82qr6RaVLeV6GUIxCdHNt7mtisvu7kOlp8qIPz0rJHbecR3zHASvm9
	 BqRz7vMCS2+NU9aruioswGmDeGT/vTjJdamPBsBPx2XoIi8r27xaBAgVd+09qdvClqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793599305;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qKPfhkt1h1VbAtp6wK+How0WoYq7g69YpGg3rkXYAJA=;
	b=mHOTOHE+ZUIH0I5gld/XrVo66q9/FQxyUSgiQ6wQywKeGEdmGITbRN7DmwZbk37tjSlK
	 OZE8EXqc0j8biffrzD569ck/4lRDyJFq41zNapuWyJuuVeDDBGXvcOfR19khmHNBz+1F6
	 MBZr71CDea/7i0R97D5iRtqSAHzpn6Wy4oyHA7rl3V5OL565KkOcwKgbAwRitbqmGDD2c
	 8W6PUFFc5lXRS1KIOCo4oH6H8SjAqNe9eMOpX3AAdUlMWK+9vJbW8VjwqazwLfh8K4T3b
	 tAUVqpaWppp5lCaoNjOed/jSbmkRHJO6M26rB26u+61h66RnRM9nfwPnpZlGohjMj2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oVJqoTNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A78606A327
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oVJqoTNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06E41F00919;
	Mon,  2 Nov 2026 06:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793599305;
	bh=qKPfhkt1h1VbAtp6wK+How0WoYq7g69YpGg3rkXYAJA=;
	h=Date:To:From:Subject;
	b=oVJqoTNh1yUDfv7okWRxOc09syfg9SsFKJ/9ZPxUIZxXR3zgnwZLhf7aF1jp/qARM
	 hBNOp+zAYHgbpFHBtqsvHbZHjore0raZFxyCfyCv6ZoJlt+ukbLY3fXTDmgPpsCSzN
	 zCe7lHaxZXdTXGx6zNuE3avL13IpXbZoHAv+R1UE=
Date: Sun, 01 Nov 2026 22:01:44 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yosry@kernel.org,
	weixugc@google.com,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,
	qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,
	liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches.patch added to mm-new branch
Message-Id: <20261102060144.F06E41F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: move LRU size stat updates out of lru_lock in folio batches
has been added to the -mm mm-new branch.  Its filename is
     mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches.patch

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: move LRU size stat updates out of lru_lock in folio batches
Date: Thu, 29 Oct 2026 13:41:57 -0700

folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
once per batch, but they update the node and memcg lruvec stats for every
folio in the batch while holding the lock.  Only the LRU lists and the
memcg lru_zone_size need lru_lock.  Updating the stats while holding the
lru_lock is unnecessary, and they make up a large part of the critical
section, as seen in [1] where a change that added just a few instructions
to the memcg stat update path cost about 2% throughput because the LRU
stat updates run under lru_lock, and the overhead went away once they were
moved outside of the lock.

With many threads faulting and freeing memory in a single memcg, about
half of all cycles are spent waiting for lru_lock, and the hold time of
the lru_lock directly limits throughput.  A perf profile with 80 threads
faulting in and freeing shmem in a single memcg shows 52.8% of all cycles
spent spinning on lru_lock, split evenly between folio_batch_move_lru()
and folios_put_refs().  About 25% of the time spent holding lru_lock in
those two paths goes to the LRU stat updates, mostly cache misses loading
pn->memcg, pn->lruvec_stats_percpu and the per-cpu counters.  The stat
updates are only 0.7% of all cycles, but they lengthen the critical
section that the other threads are waiting on.

Accumulate the stat changes per LRU list while holding the lock instead,
and only apply them after dropping the lock (while still inside the RCU
read section that keeps the lruvec's memcg alive).  This moves the stat
updates out of the lru_lock critical section and turns the per-folio
updates into at most one update per LRU list per batch.

The batch is attached to the lruvec while lru_lock is held so that the LRU
add/del helpers don't need to pass it down.  To keep struct lruvec from
growing, cost_lock is moved into the hole after lru_lock, which leaves
room for the batch pointer in the same cacheline as lru_lock.

The stats can now lag behind the LRU lists by one batch, which is well
within the per-cpu batching they already have.

On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to CPUs
repeatedly faulting in and freeing memory in a single memcg, average pages
per second over 7 freshly created memcgs per run, 2 boots each:

                     before    after
  shmem, 20 threads  4.74M     5.47M   (+15%)
  shmem, 80 threads  7.94M    10.33M   (+30%)
  anon,  20 threads  3.04M     3.35M   (+10%)
  anon,  80 threads  3.23M     3.41M   (+5%)

Link: https://lore.kernel.org/20261029204157.117879-1-joannelkoong@gmail.com
Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
---

 include/linux/mm_inline.h |   12 +++++-
 include/linux/mmzone.h    |   11 ++++-
 mm/folio.c                |   67 ++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 13 deletions(-)

--- a/include/linux/mm_inline.h~mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches
+++ a/include/linux/mm_inline.h
@@ -50,7 +50,17 @@ static __always_inline void __update_lru
 	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
-	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	/*
+	 * Batches in mm/folio.c attach an lru_size_batch while holding
+	 * lru_lock, to apply the node and memcg lruvec stats only after the
+	 * lock is dropped. The stats don't need lru_lock and updating them is
+	 * a large part of the critical section when batching. The zone stats
+	 * are still updated right away.
+	 */
+	if (lruvec->lru_size_batch)
+		lruvec->lru_size_batch->nr_pages[lru] += nr_pages;
+	else
+		mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
--- a/include/linux/mmzone.h~mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches
+++ a/include/linux/mmzone.h
@@ -739,10 +739,19 @@ struct lru_cost {
 	unsigned long		last_io;
 };
 
+/* LRU size changes made under lru_lock, applied after the lock is dropped */
+struct lru_size_batch {
+	long nr_pages[NR_LRU_LISTS];
+};
+
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
 	/* per lruvec lru_lock for memcg */
 	spinlock_t			lru_lock;
+	/* Protects cost[]. */
+	spinlock_t			cost_lock;
+	/* If set, defers lruvec stat updates until lru_lock is dropped */
+	struct lru_size_batch		*lru_size_batch;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -751,8 +760,6 @@ struct lruvec {
 	 * serialises that update.
 	 */
 	struct lru_cost			cost[ANON_AND_FILE];
-	/* Protects cost[]. */
-	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
--- a/mm/folio.c~mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches
+++ a/mm/folio.c
@@ -64,11 +64,54 @@ static DEFINE_PER_CPU(struct cpu_fbatche
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+/*
+ * lru_lock helpers for batches that defer LRU size stat updates until the
+ * lock is dropped, see __update_lru_size(). The deferred stats are applied
+ * while still in the RCU read section entered by locking, which keeps the
+ * lruvec's memcg alive.
+ */
+static void lruvec_unlock_irqrestore_batched(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	struct lru_size_batch *batch = lruvec->lru_size_batch;
+	enum lru_list lru;
+
+	lruvec->lru_size_batch = NULL;
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+
+	for_each_lru(lru) {
+		long nr_pages = batch->nr_pages[lru];
+
+		if (nr_pages) {
+			mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+			batch->nr_pages[lru] = 0;
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void folio_lruvec_relock_irqsave_batched(struct folio *folio,
+		struct lruvec **lruvecp, unsigned long *flagsp,
+		struct lru_size_batch *batch)
+{
+	if (*lruvecp) {
+		if (folio_matches_lruvec(folio, *lruvecp))
+			return;
+
+		lruvec_unlock_irqrestore_batched(*lruvecp, *flagsp);
+	}
+
+	*lruvecp = folio_lruvec_lock_irqsave(folio, flagsp);
+	VM_WARN_ON_ONCE((*lruvecp)->lru_size_batch);
+	(*lruvecp)->lru_size_batch = batch;
+}
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
-		unsigned long *flagsp)
+		unsigned long *flagsp, struct lru_size_batch *batch)
 {
 	if (folio_test_lru(folio)) {
-		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
+		folio_lruvec_relock_irqsave_batched(folio, lruvecp, flagsp,
+						    batch);
 		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
 	}
@@ -80,12 +123,13 @@ static void __page_cache_release(struct
  */
 static void page_cache_release(struct folio *folio)
 {
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags;
 
-	__page_cache_release(folio, &lruvec, &flags);
+	__page_cache_release(folio, &lruvec, &flags, &batch);
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 }
 
 void __folio_put(struct folio *folio)
@@ -165,6 +209,7 @@ static void lru_add(struct lruvec *lruve
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	struct folio_batch free_fbatch;
@@ -199,14 +244,15 @@ static void folio_batch_move_lru(struct
 			continue;
 		}
 
-		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
+		folio_lruvec_relock_irqsave_batched(folio, &lruvec, &flags,
+						    &batch);
 		move_fn(lruvec, folio);
 
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 
 	/* Cleanup filtered dead folios. */
 	if (is_lru_add) {
@@ -998,6 +1044,7 @@ void lru_cache_disable(void)
 void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 {
 	int i, j;
+	struct lru_size_batch batch = {};
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 
@@ -1014,7 +1061,7 @@ void folios_put_refs(struct folio_batch
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (folio_ref_sub_and_test(folio, nr_refs))
@@ -1028,20 +1075,20 @@ void folios_put_refs(struct folio_batch
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-				lruvec_unlock_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore_batched(lruvec, flags);
 				lruvec = NULL;
 			}
 			free_huge_folio(folio);
 			continue;
 		}
-		__page_cache_release(folio, &lruvec, &flags);
+		__page_cache_release(folio, &lruvec, &flags, &batch);
 
 		if (j != i)
 			folios->folios[j] = folio;
 		j++;
 	}
 	if (lruvec)
-		lruvec_unlock_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore_batched(lruvec, flags);
 	if (!j) {
 		folio_batch_reinit(folios);
 		return;
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-unqueue-deferred-split-folios-outside-the-lruvec-lock.patch
memcg-reduce-cacheline-contention-between-lruvec-stat-updates-and-lru-lists.patch
memcg-dont-go-through-the-lruvec-for-folio-and-kmem-lruvec-stat-updates.patch
mm-move-lru-size-stat-updates-out-of-lru_lock-in-folio-batches.patch

