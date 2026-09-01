Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A14481238
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302440; cv=none; b=aqq0XN2NJhpCYlL0WkKg36GeLyvOO2es16Mzgey6OiedOhj2AzJ0sES9nW/dA60/tdKIdKoSVQ1LG6DBgUPEAzV9ibYvOwn7qKPUTfV+HoWbca0tzhPxY002fqMvP1F6SchRR61mBJQm6E48lkxM4jG+ngLA4CkIaTrNzJ9TmRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302440; c=relaxed/simple;
	bh=KTM0Ysal4toofrkAcuHRhxI6AVrnWmK6wyaQo3l+M2Q=;
	h=Date:To:From:Subject:Message-Id; b=jlLzCDqvDMDHjulsgK1IKX62AE3hjGr7pH090ULBz1XGqkEqxyX6OC7z0DqeWdQ2qXpIfatcB5SEUIoeORLTQ0YE4Mv86Fe2eookavyvuxirobrjhvCR/1WqeTuiarmYdOs/ez1n0g+iiP+8zvqf5WY8yYF7jZvtsK+97Mo6h/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbollFBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbollFBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210951F000E9;
	Tue,  1 Sep 2026 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788302436;
	bh=TYpLS5nTu5pI0j7HAdqusKoib07kBwKWLDOzTbKFWjs=;
	h=Date:To:From:Subject;
	b=qbollFBqiFQCJ8n1SCruV4v22CEgMluwyWuuUhE+H7QPti9sSUegQyZrgLawnhBRK
	 bFoRMIZrSJ6lbLJWrM+qb1acSCcKCTj8U2tIyll4ek95ab9VpCYzdUiShttZXbRLOF
	 +VlBiTmOby1512jugfJbBfKrzH1o91vqHipHPGsQ=
Date: Tue, 01 Sep 2026 15:40:35 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check.patch removed from -mm tree
Message-Id: <20260901224036.210951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: make lru_zone_size atomic and simplify sanity check
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/memcontrol: make lru_zone_size atomic and simplify sanity check
Date: Wed, 26 Aug 2026 01:53:34 +0800

Patch series "mm/mglru: clean up folio counters and flag usage", v3.

This is a cleanup series separated out from the MGLRU-FG series [1].  As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix.  It mostly replaces the
open-coded bit operations scattered throughout the MGLRU code with new
helpers, with proper kdocs, sanity debug checks, and hardens a few MGLRU
functions.

A subtle generation counter leak is also found during the refactoring and
the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.


This patch (of 6):

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which was more
of a workaround for another bug: lru_zone_size is unsigned, so underflow
wraps it around and returns an enormously large number, then the memcg
shrinker loops almost forever as the calculated number of folios to shrink
is huge.  That commit also checked if a zero value matches the empty LRU
list, so we have to hold the LRU lock, and handle the positive and
negative deltas separately.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging for
lowmem requests when memcg is enabled") already removed the LRU emptiness
check, so handling the deltas separately is no longer needed.  And if we
just turn it into an atomic long, underflow isn't a big issue either, and
can be checked at the reader side, which is called much less frequently
than the updater.

So let's turn the counter into an atomic long and check at the reader side
instead, which has a smaller overhead.  The underflow correction is
removed: a massive leak of the LRU size counter would indicate that
something else has gone very wrong, and one should fix that leaking site
instead.  Besides, the updater-side sanity check is unlikely to catch the
leaking site anyway: if a folio was removed without updating the counter
while other folios remain on the LRU, the WARN only triggers much later,
from a likely innocent callsite.

Link: https://lore.kernel.org/20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com
Link: https://lore.kernel.org/20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com
Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +++++++--
 mm/memcontrol.c            |   18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check
+++ a/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -902,10 +902,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
--- a/mm/memcontrol.c~mm-memcontrol-make-lru_zone_size-atomic-and-simplify-sanity-check
+++ a/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct l
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

