From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-some-cache-id-related-variables.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:51 -0800
Message-ID: <54de5c67.VNGNxLQe6qtu7EiK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rename some cache id related variables
has been removed from the -mm tree.  Its filename was
     memcg-rename-some-cache-id-related-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -398,7 +398,7 @@ static inline void sock_release_memcg(st
 #ifdef CONFIG_MEMCG_KMEM
 extern struct static_key memcg_kmem_enabled_key;
 
-extern int memcg_limited_groups_array_size;
+extern int memcg_nr_cache_ids;
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
@@ -406,7 +406,7 @@ extern int memcg_limited_groups_array_si
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
@@ -538,12 +538,11 @@ static void disarm_sock_keys(struct mem_
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
@@ -2538,12 +2537,12 @@ static int memcg_alloc_cache_id(void)
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
@@ -2559,7 +2558,7 @@ static int memcg_alloc_cache_id(void)
 
 	err = memcg_update_all_caches(size);
 	if (err) {
-		ida_simple_remove(&kmem_limited_groups, id);
+		ida_simple_remove(&memcg_cache_ida, id);
 		return err;
 	}
 	return id;
@@ -2567,7 +2566,7 @@ static int memcg_alloc_cache_id(void)
 
 static void memcg_free_cache_id(int id)
 {
-	ida_simple_remove(&kmem_limited_groups, id);
+	ida_simple_remove(&memcg_cache_ida, id);
 }
 
 /*
@@ -2577,7 +2576,7 @@ static void memcg_free_cache_id(int id)
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

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

