From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:43 -0700
Message-ID: <56e9ba7b.74am9zN+qcAFH7+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: separate shadow unpacking and refault calculation
has been removed from the -mm tree.  Its filename was
     mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: separate shadow unpacking and refault calculation

Per-cgroup thrash detection will need to derive a live memcg from the
eviction cookie, and doing that inside unpack_shadow() will get nasty with
the reference handling spread over two functions.

In preparation, make unpack_shadow() clearly about extracting static data,
and let workingset_refault() do all the higher-level handling.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   56 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff -puN mm/workingset.c~mm-workingset-separate-shadow-unpacking-and-refault-calculation mm/workingset.c
--- a/mm/workingset.c~mm-workingset-separate-shadow-unpacking-and-refault-calculation
+++ a/mm/workingset.c
@@ -165,13 +165,10 @@ static void *pack_shadow(unsigned long e
 	return (void *)(eviction | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
-static void unpack_shadow(void *shadow,
-			  struct zone **zone,
-			  unsigned long *distance)
+static void unpack_shadow(void *shadow, struct zone **zonep,
+			  unsigned long *evictionp)
 {
 	unsigned long entry = (unsigned long)shadow;
-	unsigned long eviction;
-	unsigned long refault;
 	int zid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -179,29 +176,9 @@ static void unpack_shadow(void *shadow,
 	entry >>= ZONES_SHIFT;
 	nid = entry & ((1UL << NODES_SHIFT) - 1);
 	entry >>= NODES_SHIFT;
-	eviction = entry;
-
-	*zone = NODE_DATA(nid)->node_zones + zid;
 
-	refault = atomic_long_read(&(*zone)->inactive_age);
-
-	/*
-	 * The unsigned subtraction here gives an accurate distance
-	 * across inactive_age overflows in most cases.
-	 *
-	 * There is a special case: usually, shadow entries have a
-	 * short lifetime and are either refaulted or reclaimed along
-	 * with the inode before they get too old.  But it is not
-	 * impossible for the inactive_age to lap a shadow entry in
-	 * the field, which can then can result in a false small
-	 * refault distance, leading to a false activation should this
-	 * old entry actually refault again.  However, earlier kernels
-	 * used to deactivate unconditionally with *every* reclaim
-	 * invocation for the longest time, so the occasional
-	 * inappropriate activation leading to pressure on the active
-	 * list is not a problem.
-	 */
-	*distance = (refault - eviction) & EVICTION_MASK;
+	*zonep = NODE_DATA(nid)->node_zones + zid;
+	*evictionp = entry;
 }
 
 /**
@@ -233,9 +210,32 @@ void *workingset_eviction(struct address
 bool workingset_refault(void *shadow)
 {
 	unsigned long refault_distance;
+	unsigned long eviction;
+	unsigned long refault;
 	struct zone *zone;
 
-	unpack_shadow(shadow, &zone, &refault_distance);
+	unpack_shadow(shadow, &zone, &eviction);
+
+	refault = atomic_long_read(&zone->inactive_age);
+
+	/*
+	 * The unsigned subtraction here gives an accurate distance
+	 * across inactive_age overflows in most cases.
+	 *
+	 * There is a special case: usually, shadow entries have a
+	 * short lifetime and are either refaulted or reclaimed along
+	 * with the inode before they get too old.  But it is not
+	 * impossible for the inactive_age to lap a shadow entry in
+	 * the field, which can then can result in a false small
+	 * refault distance, leading to a false activation should this
+	 * old entry actually refault again.  However, earlier kernels
+	 * used to deactivate unconditionally with *every* reclaim
+	 * invocation for the longest time, so the occasional
+	 * inappropriate activation leading to pressure on the active
+	 * list is not a problem.
+	 */
+	refault_distance = (refault - eviction) & EVICTION_MASK;
+
 	inc_zone_state(zone, WORKINGSET_REFAULT);
 
 	if (refault_distance <= zone_page_state(zone, NR_ACTIVE_FILE)) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

