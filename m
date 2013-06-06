From: akpm@linux-foundation.org
Subject: [to-be-updated] vmscan-per-node-deferred-work.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:34:45 -0700
Message-ID: <51b0e455.rlh9NvoguQfZKytW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3FFTeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] vmscan-per-node-deferred-work.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:45 -0700


The patch titled
     Subject: vmscan: per-node deferred work
has been removed from the -mm tree.  Its filename was
     vmscan-per-node-deferred-work.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: vmscan: per-node deferred work

We already keep per-node LRU lists for objects being shrunk, but the work
that is deferred from one run to another is kept global.  This creates an
impedance problem, where upon node pressure, work deferred will accumulate
and end up being flushed in other nodes.

In large machines, many nodes can accumulate at the same time, all adding
to the global counter.  As we accumulate more and more, we start to ask
for the caches to flush even bigger numbers.  The result is that the
caches are depleted and do not stabilize.  To achieve stable steady state
behavior, we need to tackle it differently.

In this patch we keep the deferred count per-node, and will never
accumulate that to other nodes.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   30 ++++
 mm/vmscan.c              |  247 ++++++++++++++++++++++---------------
 2 files changed, 176 insertions(+), 101 deletions(-)

diff -puN include/linux/shrinker.h~vmscan-per-node-deferred-work include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-per-node-deferred-work
+++ a/include/linux/shrinker.h
@@ -19,6 +19,8 @@ struct shrink_control {
 
 	/* shrink from these nodes */
 	nodemask_t nodes_to_scan;
+	/* current node being shrunk (for NUMA aware shrinkers) */
+	int nid;
 };
 
 /*
@@ -42,6 +44,8 @@ struct shrink_control {
  * objects freed during the scan, or -1 if progress cannot be made due to
  * potential deadlocks. If -1 is returned, then no further attempts to call the
  * @scan_objects will be made from the current reclaim context.
+ *
+ * @flags determine the shrinker abilities, like numa awareness
  */
 struct shrinker {
 	int (*shrink)(struct shrinker *, struct shrink_control *sc);
@@ -50,12 +54,34 @@ struct shrinker {
 
 	int seeks;	/* seeks to recreate an obj */
 	long batch;	/* reclaim batch size, 0 = default */
+	unsigned long flags;
 
 	/* These are for internal use */
 	struct list_head list;
-	atomic_long_t nr_in_batch; /* objs pending delete */
+	/*
+	 * We would like to avoid allocating memory when registering a new
+	 * shrinker. All shrinkers will need to keep track of deferred objects,
+	 * and we need a counter for this. If the shrinkers are not NUMA aware,
+	 * this is a small and bounded space that fits into an atomic_long_t.
+	 * This is because that the deferring decisions are global, and we will
+	 * not allocate in this case.
+	 *
+	 * When the shrinker is NUMA aware, we will need this to be a per-node
+	 * array. Numerically speaking, the minority of shrinkers are NUMA
+	 * aware, so this saves quite a bit.
+	 */
+	union {
+		/* objs pending delete */
+		atomic_long_t nr_deferred;
+		/* objs pending delete, per node */
+		atomic_long_t *nr_deferred_node;
+	};
 };
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
-extern void register_shrinker(struct shrinker *);
+
+/* Flags */
+#define SHRINKER_NUMA_AWARE (1 << 0)
+
+extern int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
 #endif
diff -puN mm/vmscan.c~vmscan-per-node-deferred-work mm/vmscan.c
--- a/mm/vmscan.c~vmscan-per-node-deferred-work
+++ a/mm/vmscan.c
@@ -155,14 +155,36 @@ static unsigned long get_lru_size(struct
 }
 
 /*
- * Add a shrinker callback to be called from the vm
+ * Add a shrinker callback to be called from the vm.
+ *
+ * It cannot fail, unless the flag SHRINKER_NUMA_AWARE is specified.
+ * With this flag set, this function will allocate memory and may fail.
  */
-void register_shrinker(struct shrinker *shrinker)
+int register_shrinker(struct shrinker *shrinker)
 {
-	atomic_long_set(&shrinker->nr_in_batch, 0);
+	/*
+	 * If we only have one possible node in the system anyway, save
+	 * ourselves the trouble and disable NUMA aware behavior. This way we
+	 * will allocate nothing and save memory and some small loop time
+	 * later.
+	 */
+	if (nr_node_ids == 1)
+		shrinker->flags &= ~SHRINKER_NUMA_AWARE;
+
+	if (shrinker->flags & SHRINKER_NUMA_AWARE) {
+		size_t size;
+
+		size = sizeof(*shrinker->nr_deferred_node) * nr_node_ids;
+		shrinker->nr_deferred_node = kzalloc(size, GFP_KERNEL);
+		if (!shrinker->nr_deferred_node)
+			return -ENOMEM;
+	} else
+		atomic_long_set(&shrinker->nr_deferred, 0);
+
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
+	return 0;
 }
 EXPORT_SYMBOL(register_shrinker);
 
@@ -186,6 +208,116 @@ static inline int do_shrinker_shrink(str
 }
 
 #define SHRINK_BATCH 128
+
+static unsigned long
+shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
+		 unsigned long nr_pages_scanned, unsigned long lru_pages,
+		 atomic_long_t *deferred)
+{
+	unsigned long freed = 0;
+	unsigned long long delta;
+	long total_scan;
+	long max_pass;
+	long nr;
+	long new_nr;
+	long batch_size = shrinker->batch ? shrinker->batch
+					  : SHRINK_BATCH;
+
+	if (shrinker->scan_objects) {
+		max_pass = shrinker->count_objects(shrinker, shrinkctl);
+		WARN_ON(max_pass < 0);
+	} else
+		max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
+	if (max_pass <= 0)
+		return 0;
+
+	/*
+	 * copy the current shrinker scan count into a local variable
+	 * and zero it so that other concurrent shrinker invocations
+	 * don't also do this scanning work.
+	 */
+	nr = atomic_long_xchg(deferred, 0);
+
+	total_scan = nr;
+	delta = (4 * nr_pages_scanned) / shrinker->seeks;
+	delta *= max_pass;
+	do_div(delta, lru_pages + 1);
+	total_scan += delta;
+	if (total_scan < 0) {
+		printk(KERN_ERR
+		"shrink_slab: %pF negative objects to delete nr=%ld\n",
+		       shrinker->shrink, total_scan);
+		total_scan = max_pass;
+	}
+
+	/*
+	 * We need to avoid excessive windup on filesystem shrinkers
+	 * due to large numbers of GFP_NOFS allocations causing the
+	 * shrinkers to return -1 all the time. This results in a large
+	 * nr being built up so when a shrink that can do some work
+	 * comes along it empties the entire cache due to nr >>>
+	 * max_pass.  This is bad for sustaining a working set in
+	 * memory.
+	 *
+	 * Hence only allow the shrinker to scan the entire cache when
+	 * a large delta change is calculated directly.
+	 */
+	if (delta < max_pass / 4)
+		total_scan = min(total_scan, max_pass / 2);
+
+	/*
+	 * Avoid risking looping forever due to too large nr value:
+	 * never try to free more than twice the estimate number of
+	 * freeable entries.
+	 */
+	if (total_scan > max_pass * 2)
+		total_scan = max_pass * 2;
+
+	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
+				nr_pages_scanned, lru_pages,
+				max_pass, delta, total_scan);
+
+	while (total_scan >= batch_size) {
+		long ret;
+
+		if (shrinker->scan_objects) {
+			shrinkctl->nr_to_scan = batch_size;
+			ret = shrinker->scan_objects(shrinker, shrinkctl);
+
+			if (ret == -1)
+				break;
+			freed += ret;
+		} else {
+			int nr_before;
+			nr_before = do_shrinker_shrink(shrinker, shrinkctl, 0);
+			ret = do_shrinker_shrink(shrinker, shrinkctl,
+							batch_size);
+			if (ret == -1)
+				break;
+			if (ret < nr_before)
+				freed += nr_before - ret;
+		}
+
+		count_vm_events(SLABS_SCANNED, batch_size);
+		total_scan -= batch_size;
+
+		cond_resched();
+	}
+
+	/*
+	 * move the unused scan count back into the shrinker in a
+	 * manner that handles concurrent updates. If we exhausted the
+	 * scan, there is no need to do an update.
+	 */
+	if (total_scan > 0)
+		new_nr = atomic_long_add_return(total_scan, deferred);
+	else
+		new_nr = atomic_long_read(deferred);
+
+	trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
+	return freed;
+}
+
 /*
  * Call the shrink functions to age shrinkable caches
  *
@@ -222,107 +354,24 @@ unsigned long shrink_slab(struct shrink_
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		unsigned long long delta;
-		long total_scan;
-		long max_pass;
-		long nr;
-		long new_nr;
-		long batch_size = shrinker->batch ? shrinker->batch
-						  : SHRINK_BATCH;
 
-		if (shrinker->scan_objects) {
-			max_pass = shrinker->count_objects(shrinker, shrinkctl);
-			WARN_ON(max_pass < 0);
-		} else
-			max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
-		if (max_pass <= 0)
-			continue;
+		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
+			shrinkctl->nid = 0;
 
-		/*
-		 * copy the current shrinker scan count into a local variable
-		 * and zero it so that other concurrent shrinker invocations
-		 * don't also do this scanning work.
-		 */
-		nr = atomic_long_xchg(&shrinker->nr_in_batch, 0);
-
-		total_scan = nr;
-		delta = (4 * nr_pages_scanned) / shrinker->seeks;
-		delta *= max_pass;
-		do_div(delta, lru_pages + 1);
-		total_scan += delta;
-		if (total_scan < 0) {
-			printk(KERN_ERR
-			"shrink_slab: %pF negative objects to delete nr=%ld\n",
-			       shrinker->shrink, total_scan);
-			total_scan = max_pass;
+			freed += shrink_slab_node(shrinkctl, shrinker,
+				 nr_pages_scanned, lru_pages,
+				 &shrinker->nr_deferred);
+			continue;
 		}
 
-		/*
-		 * We need to avoid excessive windup on filesystem shrinkers
-		 * due to large numbers of GFP_NOFS allocations causing the
-		 * shrinkers to return -1 all the time. This results in a large
-		 * nr being built up so when a shrink that can do some work
-		 * comes along it empties the entire cache due to nr >>>
-		 * max_pass.  This is bad for sustaining a working set in
-		 * memory.
-		 *
-		 * Hence only allow the shrinker to scan the entire cache when
-		 * a large delta change is calculated directly.
-		 */
-		if (delta < max_pass / 4)
-			total_scan = min(total_scan, max_pass / 2);
-
-		/*
-		 * Avoid risking looping forever due to too large nr value:
-		 * never try to free more than twice the estimate number of
-		 * freeable entries.
-		 */
-		if (total_scan > max_pass * 2)
-			total_scan = max_pass * 2;
-
-		trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
-					nr_pages_scanned, lru_pages,
-					max_pass, delta, total_scan);
-
-		while (total_scan >= batch_size) {
-			long ret;
-
-			if (shrinker->scan_objects) {
-				shrinkctl->nr_to_scan = batch_size;
-				ret = shrinker->scan_objects(shrinker, shrinkctl);
-
-				if (ret == -1)
-					break;
-				freed += ret;
-			} else {
-				int nr_before;
-				nr_before = do_shrinker_shrink(shrinker, shrinkctl, 0);
-				ret = do_shrinker_shrink(shrinker, shrinkctl,
-								batch_size);
-				if (ret == -1)
-					break;
-				if (ret < nr_before)
-					freed += nr_before - ret;
-			}
-
-			count_vm_events(SLABS_SCANNED, batch_size);
-			total_scan -= batch_size;
-
-			cond_resched();
+		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+			if (!node_online(shrinkctl->nid))
+				continue;
+
+			freed += shrink_slab_node(shrinkctl, shrinker,
+				 nr_pages_scanned, lru_pages,
+				 &shrinker->nr_deferred_node[shrinkctl->nid]);
 		}
-
-		/*
-		 * move the unused scan count back into the shrinker in a
-		 * manner that handles concurrent updates. If we exhausted the
-		 * scan, there is no need to do an update.
-		 */
-		if (total_scan > 0)
-			new_nr = atomic_long_add_return(total_scan,
-					&shrinker->nr_in_batch);
-		else
-			new_nr = atomic_long_read(&shrinker->nr_in_batch);
-
-		trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
 	}
 	up_read(&shrinker_rwsem);
 out:
_

Patches currently in -mm which might be from glommer@openvz.org are

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

