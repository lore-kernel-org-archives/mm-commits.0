From: akpm@linux-foundation.org
Subject: [merged]
 memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:54 -0800
Message-ID: <54de5c6a.jZNICbEhxpII09Vb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add rwsem to synchronize against memcg_caches arrays relocation
has been removed from the -mm tree.  Its filename was
     memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: add rwsem to synchronize against memcg_caches arrays relocation

We need a stable value of memcg_nr_cache_ids in kmem_cache_create()
(memcg_alloc_cache_params() wants it for root caches), where we only hold
the slab_mutex and no memcg-related locks.  As a result, we have to update
memcg_nr_cache_ids under the slab_mutex, which we can only take on the
slab's side (see memcg_update_array_size).  This looks awkward and will
become even worse when per-memcg list_lru is introduced, which also wants
stable access to memcg_nr_cache_ids.

To get rid of this dependency between the memcg_nr_cache_ids and the
slab_mutex, this patch introduces a special rwsem.  The rwsem is held for
writing during memcg_caches arrays relocation and memcg_nr_cache_ids
updates.  Therefore one can take it for reading to get a stable access to
memcg_caches arrays and/or memcg_nr_cache_ids.

Currently the semaphore is taken for reading only from kmem_cache_create,
right before taking the slab_mutex, so right now there's no much point in
using rwsem instead of mutex.  However, once list_lru is made per-memcg it
will allow list_lru initializations to proceed concurrently.

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

 include/linux/memcontrol.h |   12 ++++++++++--
 mm/memcontrol.c            |   29 +++++++++++++++++++----------
 mm/slab_common.c           |    9 ++++-----
 3 files changed, 33 insertions(+), 17 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation
+++ a/include/linux/memcontrol.h
@@ -399,6 +399,8 @@ static inline void sock_release_memcg(st
 extern struct static_key memcg_kmem_enabled_key;
 
 extern int memcg_nr_cache_ids;
+extern void memcg_get_cache_ids(void);
+extern void memcg_put_cache_ids(void);
 
 /*
  * Helper macro to loop through all memcg-specific caches. Callers must still
@@ -434,8 +436,6 @@ void __memcg_kmem_uncharge_pages(struct
 
 int memcg_cache_id(struct mem_cgroup *memcg);
 
-void memcg_update_array_size(int num_groups);
-
 struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
@@ -569,6 +569,14 @@ static inline int memcg_cache_id(struct
 	return -1;
 }
 
+static inline void memcg_get_cache_ids(void)
+{
+}
+
+static inline void memcg_put_cache_ids(void)
+{
+}
+
 static inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
diff -puN mm/memcontrol.c~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation
+++ a/mm/memcontrol.c
@@ -544,6 +544,19 @@ static void disarm_sock_keys(struct mem_
 static DEFINE_IDA(memcg_cache_ida);
 int memcg_nr_cache_ids;
 
+/* Protects memcg_nr_cache_ids */
+static DECLARE_RWSEM(memcg_cache_ids_sem);
+
+void memcg_get_cache_ids(void)
+{
+	down_read(&memcg_cache_ids_sem);
+}
+
+void memcg_put_cache_ids(void)
+{
+	up_read(&memcg_cache_ids_sem);
+}
+
 /*
  * MIN_SIZE is different than 1, because we would like to avoid going through
  * the alloc/free process all the time. In a small machine, 4 kmem-limited
@@ -2549,6 +2562,7 @@ static int memcg_alloc_cache_id(void)
 	 * There's no space for the new id in memcg_caches arrays,
 	 * so we have to grow them.
 	 */
+	down_write(&memcg_cache_ids_sem);
 
 	size = 2 * (id + 1);
 	if (size < MEMCG_CACHES_MIN_SIZE)
@@ -2557,6 +2571,11 @@ static int memcg_alloc_cache_id(void)
 		size = MEMCG_CACHES_MAX_SIZE;
 
 	err = memcg_update_all_caches(size);
+	if (!err)
+		memcg_nr_cache_ids = size;
+
+	up_write(&memcg_cache_ids_sem);
+
 	if (err) {
 		ida_simple_remove(&memcg_cache_ida, id);
 		return err;
@@ -2569,16 +2588,6 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
-/*
- * We should update the current array size iff all caches updates succeed. This
- * can only be done from the slab side. The slab mutex needs to be held when
- * calling this.
- */
-void memcg_update_array_size(int num)
-{
-	memcg_nr_cache_ids = num;
-}
-
 struct memcg_kmem_cache_create_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
diff -puN mm/slab_common.c~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation mm/slab_common.c
--- a/mm/slab_common.c~memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation
+++ a/mm/slab_common.c
@@ -169,8 +169,8 @@ int memcg_update_all_caches(int num_memc
 {
 	struct kmem_cache *s;
 	int ret = 0;
-	mutex_lock(&slab_mutex);
 
+	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
 		if (!is_root_cache(s))
 			continue;
@@ -181,11 +181,8 @@ int memcg_update_all_caches(int num_memc
 		 * up to this point in an updated state.
 		 */
 		if (ret)
-			goto out;
+			break;
 	}
-
-	memcg_update_array_size(num_memcgs);
-out:
 	mutex_unlock(&slab_mutex);
 	return ret;
 }
@@ -369,6 +366,7 @@ kmem_cache_create(const char *name, size
 
 	get_online_cpus();
 	get_online_mems();
+	memcg_get_cache_ids();
 
 	mutex_lock(&slab_mutex);
 
@@ -407,6 +405,7 @@ kmem_cache_create(const char *name, size
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
+	memcg_put_cache_ids();
 	put_online_mems();
 	put_online_cpus();
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

