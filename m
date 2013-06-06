From: akpm@linux-foundation.org
Subject: + vmscan-per-node-deferred-work.patch added to -mm tree
Date: Thu, 06 Jun 2013 14:11:37 -0700
Message-ID: <51b0fb09.A7l3NwYsRW7SI0A2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFVLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + vmscan-per-node-deferred-work.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:11:37 -0700


The patch titled
     Subject: vmscan: per-node deferred work
has been added to the -mm tree.  Its filename is
     vmscan-per-node-deferred-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: vmscan: per-node deferred work

The list_lru infrastructure already keeps per-node LRU lists in its
node-specific list_lru_node arrays and provide us with a per-node API, and
the shrinkers are properly equiped with node information.  This means that
we can now focus our shrinking effort in a single node, but the work that
is deferred from one run to another is kept global at nr_in_batch.  Work
can be deferred, for instance, during direct reclaim under a GFP_NOFS
allocation, where situation, all the filesystem shrinkers will be
prevented from running and accumulate in nr_in_batch the amount of work
they should have done, but could not.

This creates an impedance problem, where upon node pressure, work deferred
will accumulate and end up being flushed in other nodes.  The problem we
describe is particularly harmful in big machines, where many nodes can
accumulate at the same time, all adding to the global counter nr_in_batch.
 As we accumulate more and more, we start to ask for the caches to flush
even bigger numbers.  The result is that the caches are depleted and do
not stabilize.  To achieve stable steady state behavior, we need to tackle
it differently.

In this patch we keep the deferred count per-node, in the new array
nr_deferred[] (the name is also a bit more descriptive) and will never
accumulate that to other nodes.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   14 +-
 mm/vmscan.c              |  243 +++++++++++++++++++++----------------
 2 files changed, 153 insertions(+), 104 deletions(-)

diff -puN include/linux/shrinker.h~vmscan-per-node-deferred-work include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-per-node-deferred-work
+++ a/include/linux/shrinker.h
@@ -19,6 +19,8 @@ struct shrink_control {
 
 	/* shrink from these nodes */
 	nodemask_t nodes_to_scan;
+	/* current node being shrunk (for NUMA aware shrinkers) */
+	int nid;
 };
 
 #define SHRINK_STOP (~0UL)
@@ -44,6 +46,8 @@ struct shrink_control {
  * due to potential deadlocks. If SHRINK_STOP is returned, then no further
  * attempts to call the @scan_objects will be made from the current reclaim
  * context.
+ *
+ * @flags determine the shrinker abilities, like numa awareness
  */
 struct shrinker {
 	int (*shrink)(struct shrinker *, struct shrink_control *sc);
@@ -54,12 +58,18 @@ struct shrinker {
 
 	int seeks;	/* seeks to recreate an obj */
 	long batch;	/* reclaim batch size, 0 = default */
+	unsigned long flags;
 
 	/* These are for internal use */
 	struct list_head list;
-	atomic_long_t nr_in_batch; /* objs pending delete */
+	/* objs pending delete, per node */
+	atomic_long_t *nr_deferred;
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
@@ -155,14 +155,31 @@ static unsigned long get_lru_size(struct
 }
 
 /*
- * Add a shrinker callback to be called from the vm
+ * Add a shrinker callback to be called from the vm.
  */
-void register_shrinker(struct shrinker *shrinker)
+int register_shrinker(struct shrinker *shrinker)
 {
-	atomic_long_set(&shrinker->nr_in_batch, 0);
+	size_t size = sizeof(*shrinker->nr_deferred);
+
+	/*
+	 * If we only have one possible node in the system anyway, save
+	 * ourselves the trouble and disable NUMA aware behavior. This way we
+	 * will save memory and some small loop time later.
+	 */
+	if (nr_node_ids == 1)
+		shrinker->flags &= ~SHRINKER_NUMA_AWARE;
+
+	if (shrinker->flags & SHRINKER_NUMA_AWARE)
+		size *= nr_node_ids;
+
+	shrinker->nr_deferred = kzalloc(size, GFP_KERNEL);
+	if (!shrinker->nr_deferred)
+		return -ENOMEM;
+
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	up_write(&shrinker_rwsem);
+	return 0;
 }
 EXPORT_SYMBOL(register_shrinker);
 
@@ -186,6 +203,118 @@ static inline int do_shrinker_shrink(str
 }
 
 #define SHRINK_BATCH 128
+
+static unsigned long
+shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
+		 unsigned long nr_pages_scanned, unsigned long lru_pages)
+{
+	unsigned long freed = 0;
+	unsigned long long delta;
+	long total_scan;
+	long max_pass;
+	long nr;
+	long new_nr;
+	int nid = shrinkctl->nid;
+	long batch_size = shrinker->batch ? shrinker->batch
+					  : SHRINK_BATCH;
+
+	if (shrinker->count_objects)
+		max_pass = shrinker->count_objects(shrinker, shrinkctl);
+	else
+		max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
+	if (max_pass == 0)
+		return 0;
+
+	/*
+	 * copy the current shrinker scan count into a local variable
+	 * and zero it so that other concurrent shrinker invocations
+	 * don't also do this scanning work.
+	 */
+	nr = atomic_long_xchg(&shrinker->nr_deferred[nid], 0);
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
+
+		if (shrinker->scan_objects) {
+			unsigned long ret;
+			shrinkctl->nr_to_scan = batch_size;
+			ret = shrinker->scan_objects(shrinker, shrinkctl);
+
+			if (ret == SHRINK_STOP)
+				break;
+			freed += ret;
+		} else {
+			int nr_before;
+			long ret;
+
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
+		new_nr = atomic_long_add_return(total_scan,
+						&shrinker->nr_deferred[nid]);
+	else
+		new_nr = atomic_long_read(&shrinker->nr_deferred[nid]);
+
+	trace_mm_shrink_slab_end(shrinker, freed, nr, new_nr);
+	return freed;
+}
+
 /*
  * Call the shrink functions to age shrinkable caches
  *
@@ -227,108 +356,18 @@ unsigned long shrink_slab(struct shrink_
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		unsigned long long delta;
-		long total_scan;
-		long max_pass;
-		long nr;
-		long new_nr;
-		long batch_size = shrinker->batch ? shrinker->batch
-						  : SHRINK_BATCH;
-
-		if (shrinker->count_objects)
-			max_pass = shrinker->count_objects(shrinker, shrinkctl);
-		else
-			max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
-		if (max_pass == 0)
-			continue;
+		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+			if (!node_online(shrinkctl->nid))
+				continue;
+
+			if (!(shrinker->flags & SHRINKER_NUMA_AWARE) &&
+			    (shrinkctl->nid != 0))
+				break;
 
-		/*
-		 * copy the current shrinker scan count into a local variable
-		 * and zero it so that other concurrent shrinker invocations
-		 * don't also do this scanning work.
-		 */
-		nr = atomic_long_xchg(&shrinker->nr_in_batch, 0);
+			freed += shrink_slab_node(shrinkctl, shrinker,
+				 nr_pages_scanned, lru_pages);
 
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
 		}
-
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
-
-			if (shrinker->scan_objects) {
-				unsigned long ret;
-				shrinkctl->nr_to_scan = batch_size;
-				ret = shrinker->scan_objects(shrinker, shrinkctl);
-
-				if (ret == SHRINK_STOP)
-					break;
-				freed += ret;
-			} else {
-				int nr_before;
-				long ret;
-
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
-		}
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

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

