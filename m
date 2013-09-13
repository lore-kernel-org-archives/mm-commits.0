From: akpm@linux-foundation.org
Subject: [merged] mm-new-shrinker-api.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:15:51 -0700
Message-ID: <52338087.5EqbhlznJOG6wHoG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3IMVPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@parallels.com, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] mm-new-shrinker-api.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@parallels.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:51 -0700


The patch titled
     Subject: mm: new shrinker API
has been removed from the -mm tree.  Its filename was
     mm-new-shrinker-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Mel Gorman <mgorman@suse.de>
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

 include/linux/shrinker.h |   38 +++++++++++++++++------
 mm/vmscan.c              |   60 ++++++++++++++++++++++++-------------
 2 files changed, 69 insertions(+), 29 deletions(-)

diff -puN include/linux/shrinker.h~mm-new-shrinker-api include/linux/shrinker.h
--- a/include/linux/shrinker.h~mm-new-shrinker-api
+++ a/include/linux/shrinker.h
@@ -4,6 +4,12 @@
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
@@ -12,23 +18,37 @@ struct shrink_control {
 	unsigned long nr_to_scan;
 };
 
+#define SHRINK_STOP (~0UL)
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
+ * @scan_objects will only be called if @count_objects returned a non-zero
+ * value for the number of freeable objects. The callout should scan the cache
+ * and attempt to free items from the cache. It should then return the number
+ * of objects freed during the scan, or SHRINK_STOP if progress cannot be made
+ * due to potential deadlocks. If SHRINK_STOP is returned, then no further
+ * attempts to call the @scan_objects will be made from the current reclaim
+ * context.
  */
 struct shrinker {
 	int (*shrink)(struct shrinker *, struct shrink_control *sc);
+	unsigned long (*count_objects)(struct shrinker *,
+				       struct shrink_control *sc);
+	unsigned long (*scan_objects)(struct shrinker *,
+				      struct shrink_control *sc);
+
 	int seeks;	/* seeks to recreate an obj */
 	long batch;	/* reclaim batch size, 0 = default */
 
diff -puN mm/vmscan.c~mm-new-shrinker-api mm/vmscan.c
--- a/mm/vmscan.c~mm-new-shrinker-api
+++ a/mm/vmscan.c
@@ -236,19 +236,24 @@ static inline int do_shrinker_shrink(str
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
-		/* Assume we'll be able to shrink next time */
-		ret = 1;
+		/*
+		 * If we would return 0, our callers would understand that we
+		 * have nothing else to shrink and give up trying. By returning
+		 * 1 we keep it going and assume we'll be able to shrink next
+		 * time.
+		 */
+		freed = 1;
 		goto out;
 	}
 
@@ -256,14 +261,16 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long long delta;
 		long total_scan;
 		long max_pass;
-		int shrink_ret = 0;
 		long nr;
 		long new_nr;
 		long batch_size = shrinker->batch ? shrinker->batch
 						  : SHRINK_BATCH;
 
-		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
-		if (max_pass <= 0)
+		if (shrinker->count_objects)
+			max_pass = shrinker->count_objects(shrinker, shrinkctl);
+		else
+			max_pass = do_shrinker_shrink(shrinker, shrinkctl, 0);
+		if (max_pass == 0)
 			continue;
 
 		/*
@@ -279,8 +286,8 @@ unsigned long shrink_slab(struct shrink_
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
@@ -308,20 +315,33 @@ unsigned long shrink_slab(struct shrink_
 		if (total_scan > max_pass * 2)
 			total_scan = max_pass * 2;
 
-		trace_mm_shrink_slab_start(shrinker, shrink, nr,
+		trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 					nr_pages_scanned, lru_pages,
 					max_pass, delta, total_scan);
 
 		while (total_scan >= batch_size) {
-			int nr_before;
 
-			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
-			shrink_ret = do_shrinker_shrink(shrinker, shrink,
-							batch_size);
-			if (shrink_ret == -1)
-				break;
-			if (shrink_ret < nr_before)
-				ret += nr_before - shrink_ret;
+			if (shrinker->scan_objects) {
+				unsigned long ret;
+				shrinkctl->nr_to_scan = batch_size;
+				ret = shrinker->scan_objects(shrinker, shrinkctl);
+
+				if (ret == SHRINK_STOP)
+					break;
+				freed += ret;
+			} else {
+				int nr_before;
+				long ret;
+
+				nr_before = do_shrinker_shrink(shrinker, shrinkctl, 0);
+				ret = do_shrinker_shrink(shrinker, shrinkctl,
+								batch_size);
+				if (ret == -1)
+					break;
+				if (ret < nr_before)
+					freed += nr_before - ret;
+			}
+
 			count_vm_events(SLABS_SCANNED, batch_size);
 			total_scan -= batch_size;
 
@@ -339,12 +359,12 @@ unsigned long shrink_slab(struct shrink_
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

origin.patch
linux-next.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
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
list_lru-dynamically-adjust-node-arrays.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

