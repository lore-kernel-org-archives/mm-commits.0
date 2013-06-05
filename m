From: akpm@linux-foundation.org
Subject: + shrinker-kill-old-shrink-api.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:11:17 -0700
Message-ID: <51afc595.AG6MiWAp3/KX9+dH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + shrinker-kill-old-shrink-api.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:17 -0700


The patch titled
     Subject: shrinker: Kill old ->shrink API
has been added to the -mm tree.  Its filename is
     shrinker-kill-old-shrink-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: shrinker: Kill old ->shrink API

There are no more users of this API, so kill it dead, dead, dead and
quietly bury the corpse in a shallow, unmarked grave in a dark forest deep
in the hills...

[glommer@openvz.org: added flowers to the grave]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Greg Thelen <gthelen@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
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
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
mm-new-shrinker-api.patch
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
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

