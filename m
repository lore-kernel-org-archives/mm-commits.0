From: akpm@linux-foundation.org
Subject: + vmscan-also-shrink-slab-in-memcg-pressure.patch added to -mm
 tree
Date: Wed, 05 Jun 2013 16:11:19 -0700
Message-ID: <51afc597.vGxNkkAhST5sa/NB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + vmscan-also-shrink-slab-in-memcg-pressure.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:19 -0700


The patch titled
     Subject: vmscan: also shrink slab in memcg pressure
has been added to the -mm tree.  Its filename is
     vmscan-also-shrink-slab-in-memcg-pressure.patch

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
Subject: vmscan: also shrink slab in memcg pressure

Without the surrounding infrastructure, this patch is a bit of a hammer:
it will basically shrink objects from all memcgs under memcg pressure.  At
least, however, we will keep the scan limited to the shrinkers marked as
per-memcg.

Future patches will implement the in-shrinker logic to filter objects
based on its memcg association.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 ++++++++++++
 include/linux/shrinker.h   |    6 +++-
 mm/memcontrol.c            |   16 +++++++++++-
 mm/vmscan.c                |   46 ++++++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-also-shrink-slab-in-memcg-pressure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/include/linux/memcontrol.h
@@ -200,6 +200,9 @@ void mem_cgroup_split_huge_fixup(struct
 bool mem_cgroup_bad_page_check(struct page *page);
 void mem_cgroup_print_bad_page(struct page *page);
 #endif
+
+unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone);
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
@@ -378,6 +381,12 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
+
+static inline unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG */
 
 #if !defined(CONFIG_MEMCG) || !defined(CONFIG_DEBUG_VM)
@@ -430,6 +439,8 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_is_active(struct mem_cgroup *memcg);
+
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -563,6 +574,12 @@ memcg_kmem_get_cache(struct kmem_cache *
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
+
+static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
 
diff -puN include/linux/shrinker.h~vmscan-also-shrink-slab-in-memcg-pressure include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/include/linux/shrinker.h
@@ -22,6 +22,9 @@ struct shrink_control {
 	nodemask_t nodes_to_scan;
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
+
+	/* reclaim from this memcg only (if not NULL) */
+	struct mem_cgroup *target_mem_cgroup;
 };
 
 /*
@@ -75,7 +78,8 @@ struct shrinker {
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
 /* Flags */
-#define SHRINKER_NUMA_AWARE (1 << 0)
+#define SHRINKER_NUMA_AWARE	(1 << 0)
+#define SHRINKER_MEMCG_AWARE	(1 << 1)
 
 extern int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
diff -puN mm/memcontrol.c~vmscan-also-shrink-slab-in-memcg-pressure mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/mm/memcontrol.c
@@ -465,7 +465,7 @@ static inline void memcg_kmem_set_active
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
@@ -1044,6 +1044,20 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 	return ret;
 }
 
+unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+	unsigned long val;
+
+	val = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid, LRU_ALL_FILE);
+	if (do_swap_account)
+		val += mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+						    LRU_ALL_ANON);
+	return val;
+}
+
 static unsigned long
 mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 			int nid, unsigned int lru_mask)
diff -puN mm/vmscan.c~vmscan-also-shrink-slab-in-memcg-pressure mm/vmscan.c
--- a/mm/vmscan.c~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/mm/vmscan.c
@@ -139,11 +139,42 @@ static bool global_reclaim(struct scan_c
 {
 	return !sc->target_mem_cgroup;
 }
+
+/*
+ * kmem reclaim should usually not be triggered when we are doing targetted
+ * reclaim. It is only valid when global reclaim is triggered, or when the
+ * underlying memcg has kmem objects.
+ */
+static bool has_kmem_reclaim(struct scan_control *sc)
+{
+	return !sc->target_mem_cgroup ||
+		memcg_kmem_is_active(sc->target_mem_cgroup);
+}
+
+static unsigned long
+zone_nr_reclaimable_pages(struct scan_control *sc, struct zone *zone)
+{
+	if (global_reclaim(sc))
+		return zone_reclaimable_pages(zone);
+	return memcg_zone_reclaimable_pages(sc->target_mem_cgroup, zone);
+}
+
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
+
+static bool has_kmem_reclaim(struct scan_control *sc)
+{
+	return true;
+}
+
+static unsigned long
+zone_nr_reclaimable_pages(struct scan_control *sc, struct zone *zone)
+{
+	return zone_reclaimable_pages(zone);
+}
 #endif
 
 static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
@@ -332,6 +363,14 @@ unsigned long shrink_slab(struct shrink_
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
+		/*
+		 * If we don't have a target mem cgroup, we scan them all.
+		 * Otherwise we will limit our scan to shrinkers marked as
+		 * memcg aware
+		 */
+		if (shrinkctl->target_mem_cgroup &&
+		    !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+			continue;
 
 		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
 			shrinkctl->nid = 0;
@@ -2402,9 +2441,9 @@ static unsigned long do_try_to_free_page
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
-		 * over limit cgroups
+		 * over limit cgroups, unless we know they have kmem objects
 		 */
-		if (global_reclaim(sc)) {
+		if (has_kmem_reclaim(sc)) {
 			unsigned long lru_pages = 0;
 
 			nodes_clear(shrink->nodes_to_scan);
@@ -2413,7 +2452,7 @@ static unsigned long do_try_to_free_page
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
-				lru_pages += zone_reclaimable_pages(zone);
+				lru_pages += zone_nr_reclaimable_pages(sc, zone);
 				node_set(zone_to_nid(zone),
 					 shrink->nodes_to_scan);
 			}
@@ -2670,6 +2709,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
+		.target_mem_cgroup = memcg,
 	};
 
 	/*
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
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

