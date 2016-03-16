From: akpm@linux-foundation.org
Subject: [merged] mm-workingset-define-radix-entry-eviction-mask.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:41 -0700
Message-ID: <56e9ba79.Bh3ktrpyr5HlHUa/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: #define radix entry eviction mask
has been removed from the -mm tree.  Its filename was
     mm-workingset-define-radix-entry-eviction-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: #define radix entry eviction mask

This is a compile-time constant, no need to calculate it on refault.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/workingset.c~mm-workingset-define-radix-entry-eviction-mask mm/workingset.c
--- a/mm/workingset.c~mm-workingset-define-radix-entry-eviction-mask
+++ a/mm/workingset.c
@@ -152,6 +152,10 @@
  * refault distance will immediately activate the refaulting page.
  */
 
+#define EVICTION_SHIFT	(RADIX_TREE_EXCEPTIONAL_ENTRY + \
+			 ZONES_SHIFT + NODES_SHIFT)
+#define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+
 static void *pack_shadow(unsigned long eviction, struct zone *zone)
 {
 	eviction = (eviction << NODES_SHIFT) | zone_to_nid(zone);
@@ -168,7 +172,6 @@ static void unpack_shadow(void *shadow,
 	unsigned long entry = (unsigned long)shadow;
 	unsigned long eviction;
 	unsigned long refault;
-	unsigned long mask;
 	int zid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -181,8 +184,7 @@ static void unpack_shadow(void *shadow,
 	*zone = NODE_DATA(nid)->node_zones + zid;
 
 	refault = atomic_long_read(&(*zone)->inactive_age);
-	mask = ~0UL >> (NODES_SHIFT + ZONES_SHIFT +
-			RADIX_TREE_EXCEPTIONAL_SHIFT);
+
 	/*
 	 * The unsigned subtraction here gives an accurate distance
 	 * across inactive_age overflows in most cases.
@@ -199,7 +201,7 @@ static void unpack_shadow(void *shadow,
 	 * inappropriate activation leading to pressure on the active
 	 * list is not a problem.
 	 */
-	*distance = (refault - eviction) & mask;
+	*distance = (refault - eviction) & EVICTION_MASK;
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

