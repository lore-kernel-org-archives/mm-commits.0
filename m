From: akpm@linux-foundation.org
Subject: + memcg-rename-some-cache-id-related-variables.patch added to -mm tree
Date: Fri, 09 Jan 2015 16:12:28 -0800
Message-ID: <54b06e6c.FWSl5eBDEmVSgm+0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename some cache id related variables
has been added to the -mm tree.  Its filename is
     memcg-rename-some-cache-id-related-variables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-rename-some-cache-id-related-variables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-rename-some-cache-id-related-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: rename some cache id related variables

memcg_limited_groups_array_size, which defines the size of memcg_caches
arrays, sounds rather cumbersome.  Also it doesn't point anyhow that it's
related to kmem/caches stuff.  So let's rename it to memcg_nr_cache_ids. 
It's concise and points us directly to memcg_cache_id.

Also, rename kmem_limited_groups to memcg_cache_ida.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   19 +++++++++----------
 mm/slab_common.c           |    4 ++--
 3 files changed, 13 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-rename-some-cache-id-related-variables include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-rename-some-cache-id-related-variables
+++ a/include/linux/memcontrol.h
@@ -360,7 +360,7 @@ static inline void sock_release_memcg(st
 #ifdef CONFIG_MEMCG_KMEM
 extern struct static_key memcg_kmem_enabled_key;
 
-extern int memcg_limited_groups_array_size;
+extern int memcg_nr_cache_ids;
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
@@ -368,7 +368,7 @@ extern int memcg_limited_groups_array_si
  * the slab_mutex must be held when looping through those caches
  */
 #define for_each_memcg_cache_index(_idx)	\
-	for ((_idx) = 0; (_idx) < memcg_limited_groups_array_size; (_idx)++)
+	for ((_idx) = 0; (_idx) < memcg_nr_cache_ids; (_idx)++)
 
 static inline bool memcg_kmem_enabled(void)
 {
diff -puN mm/memcontrol.c~memcg-rename-some-cache-id-related-variables mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-some-cache-id-related-variables
+++ a/mm/memcontrol.c
@@ -564,12 +564,11 @@ static void disarm_sock_keys(struct mem_
  *  memcgs, and none but the 200th is kmem-limited, we'd have to have a
  *  200 entry array for that.
  *
- * The current size of the caches array is stored in
- * memcg_limited_groups_array_size.  It will double each time we have to
- * increase it.
+ * The current size of the caches array is stored in memcg_nr_cache_ids. It
+ * will double each time we have to increase it.
  */
-static DEFINE_IDA(kmem_limited_groups);
-int memcg_limited_groups_array_size;
+static DEFINE_IDA(memcg_cache_ida);
+int memcg_nr_cache_ids;
 
 /*
  * MIN_SIZE is different than 1, because we would like to avoid going through
@@ -2547,12 +2546,12 @@ static int memcg_alloc_cache_id(void)
 	int id, size;
 	int err;
 
-	id = ida_simple_get(&kmem_limited_groups,
+	id = ida_simple_get(&memcg_cache_ida,
 			    0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
 	if (id < 0)
 		return id;
 
-	if (id < memcg_limited_groups_array_size)
+	if (id < memcg_nr_cache_ids)
 		return id;
 
 	/*
@@ -2568,7 +2567,7 @@ static int memcg_alloc_cache_id(void)
 
 	err = memcg_update_all_caches(size);
 	if (err) {
-		ida_simple_remove(&kmem_limited_groups, id);
+		ida_simple_remove(&memcg_cache_ida, id);
 		return err;
 	}
 	return id;
@@ -2576,7 +2575,7 @@ static int memcg_alloc_cache_id(void)
 
 static void memcg_free_cache_id(int id)
 {
-	ida_simple_remove(&kmem_limited_groups, id);
+	ida_simple_remove(&memcg_cache_ida, id);
 }
 
 /*
@@ -2586,7 +2585,7 @@ static void memcg_free_cache_id(int id)
  */
 void memcg_update_array_size(int num)
 {
-	memcg_limited_groups_array_size = num;
+	memcg_nr_cache_ids = num;
 }
 
 struct memcg_kmem_cache_create_work {
diff -puN mm/slab_common.c~memcg-rename-some-cache-id-related-variables mm/slab_common.c
--- a/mm/slab_common.c~memcg-rename-some-cache-id-related-variables
+++ a/mm/slab_common.c
@@ -116,7 +116,7 @@ static int memcg_alloc_cache_params(stru
 
 	if (!memcg) {
 		size = offsetof(struct memcg_cache_params, memcg_caches);
-		size += memcg_limited_groups_array_size * sizeof(void *);
+		size += memcg_nr_cache_ids * sizeof(void *);
 	} else
 		size = sizeof(struct memcg_cache_params);
 
@@ -154,7 +154,7 @@ static int memcg_update_cache_params(str
 
 	cur_params = s->memcg_params;
 	memcpy(new_params->memcg_caches, cur_params->memcg_caches,
-	       memcg_limited_groups_array_size * sizeof(void *));
+	       memcg_nr_cache_ids * sizeof(void *));
 
 	new_params->is_root_cache = true;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch

