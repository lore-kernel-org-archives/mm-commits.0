From: akpm@linux-foundation.org
Subject: [to-be-updated] shrinker-kill-old-shrink-api.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:35:07 -0700
Message-ID: <51b0e46b.lT59MXcotFEBnS/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3FFTfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com

Subject: [to-be-updated] shrinker-kill-old-shrink-api.patch removed from -mm tree
To: dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:07 -0700


The patch titled
     Subject: shrinker: Kill old ->shrink API
has been removed from the -mm tree.  Its filename was
     shrinker-kill-old-shrink-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: Kill old ->shrink API

There are no more users of this API, so kill it dead, dead, dead and
quietly bury the corpse in a shallow, unmarked grave in a dark forest deep
in the hills...

[glommer@openvz.org: added flowers to the grave]
Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h      |   15 ++++--------
 include/trace/events/vmscan.h |    4 +--
 mm/vmscan.c                   |   40 +++++++-------------------------
 3 files changed, 16 insertions(+), 43 deletions(-)

diff -puN include/linux/shrinker.h~shrinker-kill-old-shrink-api include/linux/shrinker.h
--- a/include/linux/shrinker.h~shrinker-kill-old-shrink-api
+++ a/include/linux/shrinker.h
@@ -7,14 +7,15 @@
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
- *
- * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
- * querying the cache size, so a fastpath for that case is appropriate.
  */
 struct shrink_control {
 	gfp_t gfp_mask;
 
-	/* How many slab objects shrinker() should scan and try to reclaim */
+	/*
+	 * How many objects scan_objects should scan and try to reclaim.
+	 * This is reset before every call, so it is safe for callees
+	 * to modify.
+	 */
 	long nr_to_scan;
 
 	/* shrink from these nodes */
@@ -26,11 +27,6 @@ struct shrink_control {
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
- * @shrink() should look through the least-recently-used 'nr_to_scan' entries
- * and attempt to free them up.  It should return the number of objects which
- * remain in the cache.  If it returns -1, it means it cannot do any scanning at
- * this time (eg. there is a risk of deadlock).
- *
  * @count_objects should return the number of freeable items in the cache. If
  * there are no objects to free or the number of freeable items cannot be
  * determined, it should return 0. No deadlock checks should be done during the
@@ -48,7 +44,6 @@ struct shrink_control {
  * @flags determine the shrinker abilities, like numa awareness
  */
 struct shrinker {
-	int (*shrink)(struct shrinker *, struct shrink_control *sc);
 	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
 	long (*scan_objects)(struct shrinker *, struct shrink_control *sc);
 
diff -puN include/trace/events/vmscan.h~shrinker-kill-old-shrink-api include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~shrinker-kill-old-shrink-api
+++ a/include/trace/events/vmscan.h
@@ -202,7 +202,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->shrink = shr->shrink;
+		__entry->shrink = shr->scan_objects;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = sc->gfp_mask;
 		__entry->pgs_scanned = pgs_scanned;
@@ -241,7 +241,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->shrink = shr->shrink;
+		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
 		__entry->retval = shrinker_retval;
diff -puN mm/vmscan.c~shrinker-kill-old-shrink-api mm/vmscan.c
--- a/mm/vmscan.c~shrinker-kill-old-shrink-api
+++ a/mm/vmscan.c
@@ -199,14 +199,6 @@ void unregister_shrinker(struct shrinker
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
-static inline int do_shrinker_shrink(struct shrinker *shrinker,
-				     struct shrink_control *sc,
-				     unsigned long nr_to_scan)
-{
-	sc->nr_to_scan = nr_to_scan;
-	return (*shrinker->shrink)(shrinker, sc);
-}
-
 #define SHRINK_BATCH 128
 
 static unsigned long
@@ -223,11 +215,8 @@ shrink_slab_node(struct shrink_control *
 	long batch_size = shrinker->batch ? shrinker->batch
 					  : SHRINK_BATCH;
 
-	if (shrinker->scan_objects) {
-		max_pass = shrinker->count_objects(shrinker, shrinkctl);
-		WARN_ON(max_pass < 0);
-	} else
-		max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
+	max_pass = shrinker->count_objects(shrinker, shrinkctl);
+	WARN_ON(max_pass < 0);
 	if (max_pass <= 0)
 		return 0;
 
@@ -246,7 +235,7 @@ shrink_slab_node(struct shrink_control *
 	if (total_scan < 0) {
 		printk(KERN_ERR
 		"shrink_slab: %pF negative objects to delete nr=%ld\n",
-		       shrinker->shrink, total_scan);
+		       shrinker->scan_objects, total_scan);
 		total_scan = max_pass;
 	}
 
@@ -280,23 +269,12 @@ shrink_slab_node(struct shrink_control *
 	while (total_scan >= batch_size) {
 		long ret;
 
-		if (shrinker->scan_objects) {
-			shrinkctl->nr_to_scan = batch_size;
-			ret = shrinker->scan_objects(shrinker, shrinkctl);
-
-			if (ret == -1)
-				break;
-			freed += ret;
-		} else {
-			int nr_before;
-			nr_before = do_shrinker_shrink(shrinker, shrinkctl, 0);
-			ret = do_shrinker_shrink(shrinker, shrinkctl,
-							batch_size);
-			if (ret == -1)
-				break;
-			if (ret < nr_before)
-				freed += nr_before - ret;
-		}
+		shrinkctl->nr_to_scan = batch_size;
+		ret = shrinker->scan_objects(shrinker, shrinkctl);
+
+		if (ret == -1)
+			break;
+		freed += ret;
 
 		count_vm_events(SLABS_SCANNED, batch_size);
 		total_scan -= batch_size;
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
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

