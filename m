From: akpm@linux-foundation.org
Subject: + memcg-scan-cache-objects-hierarchically.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:11:29 -0700
Message-ID: <51afc5a1.Umn91KCSh/8504NI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + memcg-scan-cache-objects-hierarchically.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:29 -0700


The patch titled
     Subject: memcg: scan cache objects hierarchically
has been added to the -mm tree.  Its filename is
     memcg-scan-cache-objects-hierarchically.patch

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
Subject: memcg: scan cache objects hierarchically

When reaching shrink_slab, we should descent in children memcg searching
for objects that could be shrunk.  This is true even if the memcg does not
have kmem limits on, since the kmem res_counter will also be billed
against the user res_counter of the parent.

It is possible that we will free objects and not free any pages, that will
just harm the child groups without helping the parent group at all.  But
at this point, we basically are prepared to pay the price.

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

 include/linux/memcontrol.h |    6 ++
 mm/memcontrol.c            |   13 +++++
 mm/vmscan.c                |   81 +++++++++++++++++++++++++++--------
 3 files changed, 82 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-scan-cache-objects-hierarchically include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-scan-cache-objects-hierarchically
+++ a/include/linux/memcontrol.h
@@ -441,6 +441,7 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg);
 bool memcg_kmem_is_active(struct mem_cgroup *memcg);
 
 /*
@@ -585,6 +586,11 @@ memcg_kmem_get_cache(struct kmem_cache *
 }
 #else
 
+static inline bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return false;
diff -puN mm/memcontrol.c~memcg-scan-cache-objects-hierarchically mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-scan-cache-objects-hierarchically
+++ a/mm/memcontrol.c
@@ -3069,6 +3069,19 @@ static void __mem_cgroup_commit_charge(s
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, memcg) {
+		if (memcg_kmem_is_active(iter)) {
+			mem_cgroup_iter_break(memcg, iter);
+			return true;
+		}
+	}
+	return false;
+}
+
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
diff -puN mm/vmscan.c~memcg-scan-cache-objects-hierarchically mm/vmscan.c
--- a/mm/vmscan.c~memcg-scan-cache-objects-hierarchically
+++ a/mm/vmscan.c
@@ -148,7 +148,7 @@ static bool global_reclaim(struct scan_c
 static bool has_kmem_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup ||
-		memcg_kmem_is_active(sc->target_mem_cgroup);
+		memcg_kmem_should_reclaim(sc->target_mem_cgroup);
 }
 
 static unsigned long
@@ -346,12 +346,39 @@ shrink_slab_node(struct shrink_control *
  *
  * Returns the number of slab objects which we shrunk.
  */
+static unsigned long
+shrink_slab_one(struct shrink_control *shrinkctl, struct shrinker *shrinker,
+		unsigned long nr_pages_scanned, unsigned long lru_pages)
+{
+	unsigned long freed = 0;
+
+	if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
+		shrinkctl->nid = 0;
+
+		return shrink_slab_node(shrinkctl, shrinker,
+			 nr_pages_scanned, lru_pages,
+			 &shrinker->nr_deferred);
+	}
+
+	for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+		if (!node_online(shrinkctl->nid))
+			continue;
+
+		freed += shrink_slab_node(shrinkctl, shrinker,
+			 nr_pages_scanned, lru_pages,
+			 &shrinker->nr_deferred_node[shrinkctl->nid]);
+	}
+
+	return freed;
+}
+
 unsigned long shrink_slab(struct shrink_control *shrinkctl,
 			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
+	struct mem_cgroup *root = shrinkctl->target_mem_cgroup;
 
 	if (nr_pages_scanned == 0)
 		nr_pages_scanned = SWAP_CLUSTER_MAX;
@@ -368,27 +395,45 @@ unsigned long shrink_slab(struct shrink_
 		 * Otherwise we will limit our scan to shrinkers marked as
 		 * memcg aware
 		 */
-		if (shrinkctl->target_mem_cgroup &&
-		    !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE) &&
+			shrinkctl->target_mem_cgroup)
 			continue;
 
-		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
-			shrinkctl->nid = 0;
+		/*
+		 * In a hierarchical chain, it might be that not all memcgs are
+		 * kmem active. kmemcg design mandates that when one memcg is
+		 * active, its children will be active as well. But it is
+		 * perfectly possible that its parent is not.
+		 *
+		 * We also need to make sure we scan at least once, for the
+		 * global case. So if we don't have a target memcg (saved in
+		 * root), we proceed normally and expect to break in the next
+		 * round.
+		 */
+		do {
+			struct mem_cgroup *memcg = shrinkctl->target_mem_cgroup;
 
-			freed += shrink_slab_node(shrinkctl, shrinker,
-				 nr_pages_scanned, lru_pages,
-				 &shrinker->nr_deferred);
-			continue;
-		}
+			if (!memcg || memcg_kmem_is_active(memcg))
+				freed += shrink_slab_one(shrinkctl, shrinker,
+					 nr_pages_scanned, lru_pages);
+
+			/*
+			 * For non-memcg aware shrinkers, we will arrive here
+			 * at first pass because we need to scan the root
+			 * memcg.  We need to bail out, since exactly because
+			 * they are not memcg aware, instead of noticing they
+			 * have nothing to shrink, they will just shrink again,
+			 * and deplete too many objects.
+			 */
+			if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
+				break;
+
+			shrinkctl->target_mem_cgroup =
+				mem_cgroup_iter(root, memcg, NULL);
+		} while (shrinkctl->target_mem_cgroup);
 
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (!node_online(shrinkctl->nid))
-				continue;
-
-			freed += shrink_slab_node(shrinkctl, shrinker,
-				 nr_pages_scanned, lru_pages,
-				 &shrinker->nr_deferred_node[shrinkctl->nid]);
-		}
+		/* restore original state */
+		shrinkctl->target_mem_cgroup = root;
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

