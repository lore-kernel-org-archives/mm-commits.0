From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-new-shrinker-api.patch removed from -mm tree
Date: Thu, 06 Jun 2013 12:34:31 -0700
Message-ID: <51b0e447.adTuSYB6738GjmVO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3FFTec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com

Subject: [to-be-updated] mm-new-shrinker-api.patch removed from -mm tree
To: dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:31 -0700


The patch titled
     Subject: mm: new shrinker API
has been removed from the -mm tree.  Its filename was
     mm-new-shrinker-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: mm: new shrinker API

The current shrinker callout API uses an a single shrinker call for
multiple functions.  To determine the function, a special magical value is
passed in a parameter to change the behaviour.  This complicates the
implementation and return value specification for the different
behaviours.

Separate the two different behaviours into separate operations, one to
return a count of freeable objects in the cache, and another to scan a
certain number of objects in the cache for freeing.  In defining these new
operations, ensure the return values and resultant behaviours are clearly
defined and documented.

Modify shrink_slab() to use the new API and implement the callouts for all
the existing shrinkers.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   36 +++++++++++++++++++-------
 mm/vmscan.c              |   50 +++++++++++++++++++++++--------------
 2 files changed, 58 insertions(+), 28 deletions(-)

diff -puN include/linux/shrinker.h~mm-new-shrinker-api include/linux/shrinker.h
--- a/include/linux/shrinker.h~mm-new-shrinker-api
+++ a/include/linux/shrinker.h
@@ -4,31 +4,47 @@
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
  * We consolidate the values for easier extention later.
+ *
+ * The 'gfpmask' refers to the allocation we are currently trying to
+ * fulfil.
+ *
+ * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
+ * querying the cache size, so a fastpath for that case is appropriate.
  */
 struct shrink_control {
 	gfp_t gfp_mask;
 
 	/* How many slab objects shrinker() should scan and try to reclaim */
-	unsigned long nr_to_scan;
+	long nr_to_scan;
 };
 
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
- * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
- * and a 'gfpmask'.  It should look through the least-recently-used
- * 'nr_to_scan' entries and attempt to free them up.  It should return
- * the number of objects which remain in the cache.  If it returns -1, it means
- * it cannot do any scanning at this time (eg. there is a risk of deadlock).
+ * @shrink() should look through the least-recently-used 'nr_to_scan' entries
+ * and attempt to free them up.  It should return the number of objects which
+ * remain in the cache.  If it returns -1, it means it cannot do any scanning at
+ * this time (eg. there is a risk of deadlock).
  *
- * The 'gfpmask' refers to the allocation we are currently trying to
- * fulfil.
+ * @count_objects should return the number of freeable items in the cache. If
+ * there are no objects to free or the number of freeable items cannot be
+ * determined, it should return 0. No deadlock checks should be done during the
+ * count callback - the shrinker relies on aggregating scan counts that couldn't
+ * be executed due to potential deadlocks to be run at a later call when the
+ * deadlock condition is no longer pending.
  *
- * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
- * querying the cache size, so a fastpath for that case is appropriate.
+ * @scan_objects will only be called if @count_objects returned a positive
+ * value for the number of freeable objects. The callout should scan the cache
+ * and attempt to free items from the cache. It should then return the number of
+ * objects freed during the scan, or -1 if progress cannot be made due to
+ * potential deadlocks. If -1 is returned, then no further attempts to call the
+ * @scan_objects will be made from the current reclaim context.
  */
 struct shrinker {
 	int (*shrink)(struct shrinker *, struct shrink_control *sc);
+	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
+	long (*scan_objects)(struct shrinker *, struct shrink_control *sc);
+
 	int seeks;	/* seeks to recreate an obj */
 	long batch;	/* reclaim batch size, 0 = default */
 
diff -puN mm/vmscan.c~mm-new-shrinker-api mm/vmscan.c
--- a/mm/vmscan.c~mm-new-shrinker-api
+++ a/mm/vmscan.c
@@ -205,19 +205,19 @@ static inline int do_shrinker_shrink(str
  *
  * Returns the number of slab objects which we shrunk.
  */
-unsigned long shrink_slab(struct shrink_control *shrink,
+unsigned long shrink_slab(struct shrink_control *shrinkctl,
 			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
-	unsigned long ret = 0;
+	unsigned long freed = 0;
 
 	if (nr_pages_scanned == 0)
 		nr_pages_scanned = SWAP_CLUSTER_MAX;
 
 	if (!down_read_trylock(&shrinker_rwsem)) {
 		/* Assume we'll be able to shrink next time */
-		ret = 1;
+		freed = 1;
 		goto out;
 	}
 
@@ -225,13 +225,16 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long long delta;
 		long total_scan;
 		long max_pass;
-		int shrink_ret = 0;
 		long nr;
 		long new_nr;
 		long batch_size = shrinker->batch ? shrinker->batch
 						  : SHRINK_BATCH;
 
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		if (shrinker->scan_objects) {
+			max_pass = shrinker->count_objects(shrinker, shrinkctl);
+			WARN_ON(max_pass < 0);
+		} else
+			max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
 		if (max_pass <= 0)
 			continue;
 
@@ -248,8 +251,8 @@ unsigned long shrink_slab(struct shrink_
 		do_div(delta, lru_pages + 1);
 		total_scan += delta;
 		if (total_scan < 0) {
-			printk(KERN_ERR "shrink_slab: %pF negative objects to "
-			       "delete nr=%ld\n",
+			printk(KERN_ERR
+			"shrink_slab: %pF negative objects to delete nr=%ld\n",
 			       shrinker->shrink, total_scan);
 			total_scan = max_pass;
 		}
@@ -277,20 +280,31 @@ unsigned long shrink_slab(struct shrink_
 		if (total_scan > max_pass * 2)
 			total_scan = max_pass * 2;
 
-		trace_mm_shrink_slab_start(shrinker, shrink, nr,
+		trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 					nr_pages_scanned, lru_pages,
 					max_pass, delta, total_scan);
 
 		while (total_scan >= batch_size) {
-			int nr_before;
+			long ret;
+
+			if (shrinker->scan_objects) {
+				shrinkctl->nr_to_scan = batch_size;
+				ret = shrinker->scan_objects(shrinker, shrinkctl);
+
+				if (ret == -1)
+					break;
+				freed += ret;
+			} else {
+				int nr_before;
+				nr_before = do_shrinker_shrink(shrinker, shrinkctl, 0);
+				ret = do_shrinker_shrink(shrinker, shrinkctl,
+								batch_size);
+				if (ret == -1)
+					break;
+				if (ret < nr_before)
+					freed += nr_before - ret;
+			}
 
-			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
-			shrink_ret = do_shrinker_shrink(shrinker, shrink,
-							batch_size);
-			if (shrink_ret == -1)
-				break;
-			if (shrink_ret < nr_before)
-				ret += nr_before - shrink_ret;
 			count_vm_events(SLABS_SCANNED, batch_size);
 			total_scan -= batch_size;
 
@@ -308,12 +322,12 @@ unsigned long shrink_slab(struct shrink_
 		else
 			new_nr = atomic_long_read(&shrinker->nr_in_batch);
 
-		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
+		trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
 	}
 	up_read(&shrinker_rwsem);
 out:
 	cond_resched();
-	return ret;
+	return freed;
 }
 
 static inline int is_page_cache_freeable(struct page *page)
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
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

