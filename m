Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10056199931
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591296; cv=none; b=TVjFMRbOVOZTzxzDz0v4FIwDrnPEAiIcp5AVq9lKHaV8MvR1gk3AjPpfHNisPMNeDZ5IrndSH+Kb7u7KIo9HSUe/JkmV4Yp/Wx7auXnUiY4YSgl1rbBY5vAqOMbUQ95ex7ukOmCbovbcnuPoSL+lEMXmEdBc6E7BY5Fw1lYlS9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591296; c=relaxed/simple;
	bh=qExlTddBTLBmbw54EQjhANBIBRhAQRjaYQfPE9Q5r7E=;
	h=Date:To:From:Subject:Message-Id; b=esDK6NLTN7AZO3FLpfmE57eQxCR0LZRBcHBCBYvDAAEYHx7f81mJzI1QWRBCckrh5719katL8OeaNdqvIJ5JVwQM3iO00H1l7qiVGU1eioCPNpUmKb6gBAFDliRAsRx8g6UDyYSg+SS0uCLpgM9Zj7inHr8mb70O8YeJmUCeWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qheOS783; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qheOS783"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACF01F000E9;
	Mon, 20 Jul 2026 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591294;
	bh=DzHIZHoClVgb+2XSw/lux3/hYmUi8WvUU8A/yXgS3gQ=;
	h=Date:To:From:Subject;
	b=qheOS783BBXbVl1mnihx/o8U3zvHZnJOKvnR4BfM3ihdgaRQOwu80W90OkX5gbI5u
	 bdLqoNYAsoMXb7+7JVlUCoAwwiXJG/0F+b1g/nkUQPhbYlw97j8DJnXsOQuHGB2Pfp
	 ljhWDdNCs24zoeU9vWrPpeO5cLjnJAzl9TyEME7w=
Date: Mon, 20 Jul 2026 16:48:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,kuba@kernel.org,jackmanb@google.com,horms@kernel.org,hannes@cmpxchg.org,edumazet@google.com,david@kernel.org,davem@davemloft.net,axelrasmussen@google.com,realwujing@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-boost-watermarks-on-atomic-allocation-failure.patch added to mm-new branch
Message-Id: <20260720234814.AACF01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: boost watermarks on atomic allocation failure
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-boost-watermarks-on-atomic-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-boost-watermarks-on-atomic-allocation-failure.patch

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
From: Qiliang Yuan <realwujing@gmail.com>
Subject: mm/page_alloc: boost watermarks on atomic allocation failure
Date: Mon, 20 Jul 2026 16:15:48 +0800

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim.

Handle these failures by introducing a watermark boost mechanism for
atomic requests. Refactor boost_watermark() using an internal helper to
support both fragmentation and atomic paths. Apply zone-proportional
boosts (~0.1% of managed pages) for atomic allocations, while
decoupling it from watermark_boost_factor.

Implement boost_zones_for_atomic() to iterate through and boost all
eligible zones in the zonelist, respecting nodemasks. Use a per-zone
1-second debounce timer via last_boost_jiffies to prevent excessive
boosting. Check and update the debounce timestamp under zone->lock,
alongside the watermark modification, so concurrent callers on other
CPUs cannot all observe a stale timestamp and pile onto the same zone
within the same window. Verify with lockdep. Integrate the mechanism
into the page allocation slowpath specifically for order-0 GFP_ATOMIC
requests.

This approach reuses existing infrastructure and ensures emergency
reserves even if fragmentation boosting is disabled.

The mechanism is bounded by construction. Each zone accepts at most
one boost per second (the debounce timer), and zone->watermark_boost
is clamped to zone->_watermark[WMARK_HIGH] / 10 regardless of how
long the atomic pressure lasts or how many zones are boosted in a
single slowpath call. Worst case, sustained atomic pressure across
all zones in a zonelist adds at most one extra kswapd wakeup per zone
per second, and the boost on any single zone cannot exceed 10% of
that zone's high watermark. It cannot run away or starve unrelated
allocations beyond that ceiling.

This failure signature keeps recurring in production: a host running
a downstream 4.19 kernel logged 144 order-0 GFP_ATOMIC failures over a
4h15m window, all through the same NIC driver receive softirq path,
across several unrelated network-facing services on the box. This
confirms the underlying problem is real and ongoing. It does not by
itself measure this patch's effect, since the fix has not been
deployed on that fleet yet.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Link: https://lore.kernel.org/20260720-feat-mm-page_alloc-v11-v11-1-7376b02c27b3@gmail.com
Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Jing Wu <realwujing@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |   80 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 72 insertions(+), 9 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-boost-watermarks-on-atomic-allocation-failure
+++ a/include/linux/mmzone.h
@@ -971,6 +971,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
--- a/mm/page_alloc.c~mm-page_alloc-boost-watermarks-on-atomic-allocation-failure
+++ a/mm/page_alloc.c
@@ -2172,12 +2172,15 @@ bool pageblock_unisolate_and_move_free_p
 
 #endif /* CONFIG_MEMORY_ISOLATION */
 
-static inline bool boost_watermark(struct zone *zone)
+/*
+ * Helper for boosting watermarks. Called with zone->lock held.
+ * Use max_boost to limit the boost to a percentage of the high watermark.
+ */
+static inline bool __boost_watermark(struct zone *zone, unsigned long amount,
+				     unsigned long max_boost)
 {
-	unsigned long max_boost;
+	lockdep_assert_held(&zone->lock);
 
-	if (!watermark_boost_factor)
-		return false;
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
 	 * On small machines, including kdump capture kernels running
@@ -2187,9 +2190,6 @@ static inline bool boost_watermark(struc
 	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
 		return false;
 
-	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
-			watermark_boost_factor, 10000);
-
 	/*
 	 * high watermark may be uninitialised if fragmentation occurs
 	 * very early in boot so do not boost. We do not fall
@@ -2203,13 +2203,71 @@ static inline bool boost_watermark(struc
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
-		max_boost);
+	zone->watermark_boost = min(zone->watermark_boost + amount,
+				    max_boost);
 
 	return true;
 }
 
 /*
+ * Boost watermarks to increase reclaim pressure when fragmentation occurs
+ * and we fall back to other migratetypes.
+ */
+static inline bool boost_watermark(struct zone *zone)
+{
+	if (!watermark_boost_factor)
+		return false;
+
+	return __boost_watermark(zone, pageblock_nr_pages,
+			mult_frac(zone->_watermark[WMARK_HIGH],
+				  watermark_boost_factor, 10000));
+}
+
+/*
+ * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
+ * This provides zone-proportional safety buffers: ~1MB per 1GB of zone
+ * size. Max boost ceiling is fixed at ~10% of high watermark.
+ *
+ * This emergency reserve is independent of watermark_boost_factor.
+ */
+static inline bool boost_watermark_atomic(struct zone *zone)
+{
+	return __boost_watermark(zone,
+			max(pageblock_nr_pages, zone_managed_pages(zone) / 1000),
+			zone->_watermark[WMARK_HIGH] / 10);
+}
+
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+					ac->highest_zoneidx, ac->nodemask) {
+		unsigned long flags;
+		bool should_wake = false;
+
+		/*
+		 * Check and update the per-zone debounce timestamp under
+		 * zone->lock so concurrent callers on other CPUs (e.g. a
+		 * multi-queue NIC spreading GFP_ATOMIC allocations across
+		 * several softirqs) cannot all observe a stale timestamp
+		 * and pile onto the same zone within the same window.
+		 */
+		spin_lock_irqsave(&zone->lock, flags);
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			zone->last_boost_jiffies = now;
+			should_wake = boost_watermark_atomic(zone);
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+
+		if (should_wake)
+			wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+	}
+}
+
+/*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
  * polluting multiple pageblocks?
@@ -4770,6 +4828,10 @@ restart:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 
+	/* Boost watermarks for atomic requests entering slowpath */
+	if (((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) && order == 0 && !can_direct_reclaim)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
_

Patches currently in -mm which might be from realwujing@gmail.com are

mm-page_alloc-boost-watermarks-on-atomic-allocation-failure.patch

