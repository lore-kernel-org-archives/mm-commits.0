From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:56:46 -0700
Message-ID: <56e9ba7e.salZtJO64voRteCu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: eviction buckets for bigmem/lowbit machines
has been removed from the -mm tree.  Its filename was
     mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: eviction buckets for bigmem/lowbit machines

For per-cgroup thrash detection, we need to store the memcg ID inside the
radix tree cookie as well.  However, on 32 bit that doesn't leave enough
bits for the eviction timestamp to cover the necessary range of recently
evicted pages.  The radix tree entry would look like this:

[ RADIX_TREE_EXCEPTIONAL(2) | ZONEID(2) | MEMCGID(16) | EVICTION(12) ]

12 bits means 4096 pages, means 16M worth of recently evicted pages.  But
refaults are actionable up to distances covering half of memory.  To not
miss refaults, we have to stretch out the range at the cost of how
precisely we can tell when a page was evicted.  This way we can shave off
lower bits from the eviction timestamp until the necessary range is
covered.  E.g.  grouping evictions into 1M buckets (256 pages) will
stretch the longest representable refault distance to 4G.

This patch implements eviction buckets that are automatically sized
according to the available bits and the necessary refault range, in
preparation for per-cgroup thrash detection.

The maximum actionable distance is currently half of memory, but to
support memory hotplug of up to 200% of boot-time memory, we size the
buckets to cover double the distance.  Beyond that, thrashing won't be
detectable anymore.

During boot, the kernel will print out the exact parameters, like so:

[    0.113929] workingset: timestamp_bits=12 max_order=18 bucket_order=6

In this example, there are 12 radix entry bits available for the eviction
timestamp, to cover a maximum distance of 2^18 pages (this is a 1G
machine).  Consequently, evictions must be grouped into buckets of 2^6
pages, or 256K.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-eviction-buckets-for-bigmem-lowbit-machines mm/workingset.c
--- a/mm/workingset.c~mm-workingset-eviction-buckets-for-bigmem-lowbit-machines
+++ a/mm/workingset.c
@@ -156,8 +156,19 @@
 			 ZONES_SHIFT + NODES_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
 
+/*
+ * Eviction timestamps need to be able to cover the full range of
+ * actionable refaults. However, bits are tight in the radix tree
+ * entry, and after storing the identifier for the lruvec there might
+ * not be enough left to represent every single actionable refault. In
+ * that case, we have to sacrifice granularity for distance, and group
+ * evictions into coarser buckets by shaving off lower timestamp bits.
+ */
+static unsigned int bucket_order __read_mostly;
+
 static void *pack_shadow(unsigned long eviction, struct zone *zone)
 {
+	eviction >>= bucket_order;
 	eviction = (eviction << NODES_SHIFT) | zone_to_nid(zone);
 	eviction = (eviction << ZONES_SHIFT) | zone_idx(zone);
 	eviction = (eviction << RADIX_TREE_EXCEPTIONAL_SHIFT);
@@ -178,7 +189,7 @@ static void unpack_shadow(void *shadow,
 	entry >>= NODES_SHIFT;
 
 	*zonep = NODE_DATA(nid)->node_zones + zid;
-	*evictionp = entry;
+	*evictionp = entry << bucket_order;
 }
 
 /**
@@ -400,8 +411,25 @@ static struct lock_class_key shadow_node
 
 static int __init workingset_init(void)
 {
+	unsigned int timestamp_bits;
+	unsigned int max_order;
 	int ret;
 
+	BUILD_BUG_ON(BITS_PER_LONG < EVICTION_SHIFT);
+	/*
+	 * Calculate the eviction bucket size to cover the longest
+	 * actionable refault distance, which is currently half of
+	 * memory (totalram_pages/2). However, memory hotplug may add
+	 * some more pages at runtime, so keep working with up to
+	 * double the initial memory by using totalram_pages as-is.
+	 */
+	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
+	max_order = fls_long(totalram_pages - 1);
+	if (max_order > timestamp_bits)
+		bucket_order = max_order - timestamp_bits;
+	printk("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
+	       timestamp_bits, max_order, bucket_order);
+
 	ret = list_lru_init_key(&workingset_shadow_nodes, &shadow_nodes_key);
 	if (ret)
 		goto err;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

