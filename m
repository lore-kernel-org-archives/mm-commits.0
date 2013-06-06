From: akpm@linux-foundation.org
Subject: [to-be-updated] shrinker-add-node-awareness.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:34:43 -0700
Message-ID: <51b0e453.0oQcsKd7tznGogSX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3FFTen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com

Subject: [to-be-updated] shrinker-add-node-awareness.patch removed from -mm tree
To: dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:43 -0700


The patch titled
     Subject: shrinker: add node awareness
has been removed from the -mm tree.  Its filename was
     shrinker-add-node-awareness.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: add node awareness

Pass the node of the current zone being reclaimed to shrink_slab(),
allowing the shrinker control nodemask to be set appropriately for node
aware shrinkers.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/ashmem.c |    3 +++
 fs/drop_caches.c                 |    1 +
 include/linux/shrinker.h         |    3 +++
 mm/memory-failure.c              |    2 ++
 mm/vmscan.c                      |   11 ++++++++---
 5 files changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/staging/android/ashmem.c~shrinker-add-node-awareness drivers/staging/android/ashmem.c
--- a/drivers/staging/android/ashmem.c~shrinker-add-node-awareness
+++ a/drivers/staging/android/ashmem.c
@@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *fi
 				.gfp_mask = GFP_KERNEL,
 				.nr_to_scan = 0,
 			};
+
+			nodes_setall(sc.nodes_to_scan);
+
 			ret = ashmem_shrink(&ashmem_shrinker, &sc);
 			sc.nr_to_scan = ret;
 			ashmem_shrink(&ashmem_shrinker, &sc);
diff -puN fs/drop_caches.c~shrinker-add-node-awareness fs/drop_caches.c
--- a/fs/drop_caches.c~shrinker-add-node-awareness
+++ a/fs/drop_caches.c
@@ -44,6 +44,7 @@ static void drop_slab(void)
 		.gfp_mask = GFP_KERNEL,
 	};
 
+	nodes_setall(shrink.nodes_to_scan);
 	do {
 		nr_objects = shrink_slab(&shrink, 1000, 1000);
 	} while (nr_objects > 10);
diff -puN include/linux/shrinker.h~shrinker-add-node-awareness include/linux/shrinker.h
--- a/include/linux/shrinker.h~shrinker-add-node-awareness
+++ a/include/linux/shrinker.h
@@ -16,6 +16,9 @@ struct shrink_control {
 
 	/* How many slab objects shrinker() should scan and try to reclaim */
 	long nr_to_scan;
+
+	/* shrink from these nodes */
+	nodemask_t nodes_to_scan;
 };
 
 /*
diff -puN mm/memory-failure.c~shrinker-add-node-awareness mm/memory-failure.c
--- a/mm/memory-failure.c~shrinker-add-node-awareness
+++ a/mm/memory-failure.c
@@ -248,10 +248,12 @@ void shake_page(struct page *p, int acce
 	 */
 	if (access) {
 		int nr;
+		int nid = page_to_nid(p);
 		do {
 			struct shrink_control shrink = {
 				.gfp_mask = GFP_KERNEL,
 			};
+			node_set(nid, shrink.nodes_to_scan);
 
 			nr = shrink_slab(&shrink, 1000, 1000);
 			if (page_count(p) == 1)
diff -puN mm/vmscan.c~shrinker-add-node-awareness mm/vmscan.c
--- a/mm/vmscan.c~shrinker-add-node-awareness
+++ a/mm/vmscan.c
@@ -2379,12 +2379,16 @@ static unsigned long do_try_to_free_page
 		 */
 		if (global_reclaim(sc)) {
 			unsigned long lru_pages = 0;
+
+			nodes_clear(shrink->nodes_to_scan);
 			for_each_zone_zonelist(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask)) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
 				lru_pages += zone_reclaimable_pages(zone);
+				node_set(zone_to_nid(zone),
+					 shrink->nodes_to_scan);
 			}
 
 			shrink_slab(shrink, sc->nr_scanned, lru_pages);
@@ -2841,6 +2845,8 @@ static bool kswapd_shrink_zone(struct zo
 		return true;
 
 	shrink_zone(zone, sc);
+	nodes_clear(shrink.nodes_to_scan);
+	node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 
 	reclaim_state->reclaimed_slab = 0;
 	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
@@ -3549,10 +3555,9 @@ static int __zone_reclaim(struct zone *z
 		 * number of slab pages and shake the slab until it is reduced
 		 * by the same nr_pages that we used for reclaiming unmapped
 		 * pages.
-		 *
-		 * Note that shrink_slab will free memory on all zones and may
-		 * take a long time.
 		 */
+		nodes_clear(shrink.nodes_to_scan);
+		node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 		for (;;) {
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

