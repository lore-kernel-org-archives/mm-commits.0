From: akpm@linux-foundation.org
Subject: [merged] list_lru-introduce-list_lru_shrink_countwalk.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:19:42 -0800
Message-ID: <54de5c5e.0YaPjUtoYjtP+JmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru: introduce list_lru_shrink_{count,walk}
has been removed from the -mm tree.  Its filename was
     list_lru-introduce-list_lru_shrink_countwalk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: list_lru: introduce list_lru_shrink_{count,walk}

Kmem accounting of memcg is unusable now, because it lacks slab shrinker
support.  That means when we hit the limit we will get ENOMEM w/o any
chance to recover.  What we should do then is to call shrink_slab, which
would reclaim old inode/dentry caches from this cgroup.  This is what this
patch set is intended to do.

Basically, it does two things.  First, it introduces the notion of
per-memcg slab shrinker.  A shrinker that wants to reclaim objects per
cgroup should mark itself as SHRINKER_MEMCG_AWARE.  Then it will be passed
the memory cgroup to scan from in shrink_control->memcg.  For such
shrinkers shrink_slab iterates over the whole cgroup subtree under the
target cgroup and calls the shrinker for each kmem-active memory cgroup.

Secondly, this patch set makes the list_lru structure per-memcg.  It's
done transparently to list_lru users - everything they have to do is to
tell list_lru_init that they want memcg-aware list_lru.  Then the list_lru
will automatically distribute objects among per-memcg lists basing on
which cgroup the object is accounted to.  This way to make FS shrinkers
(icache, dcache) memcg-aware we only need to make them use memcg-aware
list_lru, and this is what this patch set does.

As before, this patch set only enables per-memcg kmem reclaim when the
pressure goes from memory.limit, not from memory.kmem.limit.  Handling
memory.kmem.limit is going to be tricky due to GFP_NOFS allocations, and
it is still unclear whether we will have this knob in the unified
hierarchy.



This patch (of 9):

NUMA aware slab shrinkers use the list_lru structure to distribute objects
coming from different NUMA nodes to different lists.  Whenever such a
shrinker needs to count or scan objects from a particular node, it issues
commands like this:

        count = list_lru_count_node(lru, sc->nid);
        freed = list_lru_walk_node(lru, sc->nid, isolate_func,
                                   isolate_arg, &sc->nr_to_scan);

where sc is an instance of the shrink_control structure passed to it from
vmscan.

To simplify this, let's add special list_lru functions to be used by
shrinkers, list_lru_shrink_count() and list_lru_shrink_walk(), which
consolidate the nid and nr_to_scan arguments in the shrink_control
structure.

This will also allow us to avoid patching shrinkers that use list_lru when
we make shrink_slab() per-memcg - all we will have to do is extend the
shrink_control structure to include the target memcg and make
list_lru_shrink_{count,walk} handle this appropriately.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
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

 fs/dcache.c              |   14 ++++++--------
 fs/gfs2/quota.c          |    6 +++---
 fs/inode.c               |    7 +++----
 fs/internal.h            |    7 +++----
 fs/super.c               |   24 +++++++++++-------------
 fs/xfs/xfs_buf.c         |    7 +++----
 fs/xfs/xfs_qm.c          |    7 +++----
 include/linux/list_lru.h |   16 ++++++++++++++++
 mm/workingset.c          |    6 +++---
 9 files changed, 51 insertions(+), 43 deletions(-)

diff -puN fs/dcache.c~list_lru-introduce-list_lru_shrink_countwalk fs/dcache.c
--- a/fs/dcache.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/dcache.c
@@ -930,24 +930,22 @@ dentry_lru_isolate(struct list_head *ite
 /**
  * prune_dcache_sb - shrink the dcache
  * @sb: superblock
- * @nr_to_scan : number of entries to try to free
- * @nid: which node to scan for freeable entities
+ * @sc: shrink control, passed to list_lru_shrink_walk()
  *
- * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
- * done when we need more memory an called from the superblock shrinker
+ * Attempt to shrink the superblock dcache LRU by @sc->nr_to_scan entries. This
+ * is done when we need more memory and called from the superblock shrinker
  * function.
  *
  * This function may fail to free any resources if all the dentries are in
  * use.
  */
-long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
-		     int nid)
+long prune_dcache_sb(struct super_block *sb, struct shrink_control *sc)
 {
 	LIST_HEAD(dispose);
 	long freed;
 
-	freed = list_lru_walk_node(&sb->s_dentry_lru, nid, dentry_lru_isolate,
-				       &dispose, &nr_to_scan);
+	freed = list_lru_shrink_walk(&sb->s_dentry_lru, sc,
+				     dentry_lru_isolate, &dispose);
 	shrink_dentry_list(&dispose);
 	return freed;
 }
diff -puN fs/gfs2/quota.c~list_lru-introduce-list_lru_shrink_countwalk fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/gfs2/quota.c
@@ -171,8 +171,8 @@ static unsigned long gfs2_qd_shrink_scan
 	if (!(sc->gfp_mask & __GFP_FS))
 		return SHRINK_STOP;
 
-	freed = list_lru_walk_node(&gfs2_qd_lru, sc->nid, gfs2_qd_isolate,
-				   &dispose, &sc->nr_to_scan);
+	freed = list_lru_shrink_walk(&gfs2_qd_lru, sc,
+				     gfs2_qd_isolate, &dispose);
 
 	gfs2_qd_dispose(&dispose);
 
@@ -182,7 +182,7 @@ static unsigned long gfs2_qd_shrink_scan
 static unsigned long gfs2_qd_shrink_count(struct shrinker *shrink,
 					  struct shrink_control *sc)
 {
-	return vfs_pressure_ratio(list_lru_count_node(&gfs2_qd_lru, sc->nid));
+	return vfs_pressure_ratio(list_lru_shrink_count(&gfs2_qd_lru, sc));
 }
 
 struct shrinker gfs2_qd_shrinker = {
diff -puN fs/inode.c~list_lru-introduce-list_lru_shrink_countwalk fs/inode.c
--- a/fs/inode.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/inode.c
@@ -751,14 +751,13 @@ inode_lru_isolate(struct list_head *item
  * to trim from the LRU. Inodes to be freed are moved to a temporary list and
  * then are freed outside inode_lock by dispose_list().
  */
-long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
-		     int nid)
+long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 {
 	LIST_HEAD(freeable);
 	long freed;
 
-	freed = list_lru_walk_node(&sb->s_inode_lru, nid, inode_lru_isolate,
-				       &freeable, &nr_to_scan);
+	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
+				     inode_lru_isolate, &freeable);
 	dispose_list(&freeable);
 	return freed;
 }
diff -puN fs/internal.h~list_lru-introduce-list_lru_shrink_countwalk fs/internal.h
--- a/fs/internal.h~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/internal.h
@@ -14,6 +14,7 @@ struct file_system_type;
 struct linux_binprm;
 struct path;
 struct mount;
+struct shrink_control;
 
 /*
  * block_dev.c
@@ -111,8 +112,7 @@ extern int open_check_o_direct(struct fi
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
-extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
-			    int nid);
+extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 
 /*
@@ -129,8 +129,7 @@ extern int invalidate_inodes(struct supe
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
 extern int d_set_mounted(struct dentry *dentry);
-extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
-			    int nid);
+extern long prune_dcache_sb(struct super_block *sb, struct shrink_control *sc);
 
 /*
  * read_write.c
diff -puN fs/super.c~list_lru-introduce-list_lru_shrink_countwalk fs/super.c
--- a/fs/super.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/super.c
@@ -77,8 +77,8 @@ static unsigned long super_cache_scan(st
 	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
 
-	inodes = list_lru_count_node(&sb->s_inode_lru, sc->nid);
-	dentries = list_lru_count_node(&sb->s_dentry_lru, sc->nid);
+	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
+	dentries = list_lru_shrink_count(&sb->s_dentry_lru, sc);
 	total_objects = dentries + inodes + fs_objects + 1;
 	if (!total_objects)
 		total_objects = 1;
@@ -86,20 +86,20 @@ static unsigned long super_cache_scan(st
 	/* proportion the scan between the caches */
 	dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
 	inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
+	fs_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects);
 
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
 	 */
-	freed = prune_dcache_sb(sb, dentries, sc->nid);
-	freed += prune_icache_sb(sb, inodes, sc->nid);
+	sc->nr_to_scan = dentries;
+	freed = prune_dcache_sb(sb, sc);
+	sc->nr_to_scan = inodes;
+	freed += prune_icache_sb(sb, sc);
 
-	if (fs_objects) {
-		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
-								total_objects);
+	if (fs_objects)
 		freed += sb->s_op->free_cached_objects(sb, fs_objects,
 						       sc->nid);
-	}
 
 	drop_super(sb);
 	return freed;
@@ -118,17 +118,15 @@ static unsigned long super_cache_count(s
 	 * scalability bottleneck. The counts could get updated
 	 * between super_cache_count and super_cache_scan anyway.
 	 * Call to super_cache_count with shrinker_rwsem held
-	 * ensures the safety of call to list_lru_count_node() and
+	 * ensures the safety of call to list_lru_shrink_count() and
 	 * s_op->nr_cached_objects().
 	 */
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);
 
-	total_objects += list_lru_count_node(&sb->s_dentry_lru,
-						 sc->nid);
-	total_objects += list_lru_count_node(&sb->s_inode_lru,
-						 sc->nid);
+	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
+	total_objects += list_lru_shrink_count(&sb->s_inode_lru, sc);
 
 	total_objects = vfs_pressure_ratio(total_objects);
 	return total_objects;
diff -puN fs/xfs/xfs_buf.c~list_lru-introduce-list_lru_shrink_countwalk fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/xfs/xfs_buf.c
@@ -1583,10 +1583,9 @@ xfs_buftarg_shrink_scan(
 					struct xfs_buftarg, bt_shrinker);
 	LIST_HEAD(dispose);
 	unsigned long		freed;
-	unsigned long		nr_to_scan = sc->nr_to_scan;
 
-	freed = list_lru_walk_node(&btp->bt_lru, sc->nid, xfs_buftarg_isolate,
-				       &dispose, &nr_to_scan);
+	freed = list_lru_shrink_walk(&btp->bt_lru, sc,
+				     xfs_buftarg_isolate, &dispose);
 
 	while (!list_empty(&dispose)) {
 		struct xfs_buf *bp;
@@ -1605,7 +1604,7 @@ xfs_buftarg_shrink_count(
 {
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
-	return list_lru_count_node(&btp->bt_lru, sc->nid);
+	return list_lru_shrink_count(&btp->bt_lru, sc);
 }
 
 void
diff -puN fs/xfs/xfs_qm.c~list_lru-introduce-list_lru_shrink_countwalk fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/fs/xfs/xfs_qm.c
@@ -523,7 +523,6 @@ xfs_qm_shrink_scan(
 	struct xfs_qm_isolate	isol;
 	unsigned long		freed;
 	int			error;
-	unsigned long		nr_to_scan = sc->nr_to_scan;
 
 	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
 		return 0;
@@ -531,8 +530,8 @@ xfs_qm_shrink_scan(
 	INIT_LIST_HEAD(&isol.buffers);
 	INIT_LIST_HEAD(&isol.dispose);
 
-	freed = list_lru_walk_node(&qi->qi_lru, sc->nid, xfs_qm_dquot_isolate, &isol,
-					&nr_to_scan);
+	freed = list_lru_shrink_walk(&qi->qi_lru, sc,
+				     xfs_qm_dquot_isolate, &isol);
 
 	error = xfs_buf_delwri_submit(&isol.buffers);
 	if (error)
@@ -557,7 +556,7 @@ xfs_qm_shrink_count(
 	struct xfs_quotainfo	*qi = container_of(shrink,
 					struct xfs_quotainfo, qi_shrinker);
 
-	return list_lru_count_node(&qi->qi_lru, sc->nid);
+	return list_lru_shrink_count(&qi->qi_lru, sc);
 }
 
 /*
diff -puN include/linux/list_lru.h~list_lru-introduce-list_lru_shrink_countwalk include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-introduce-list_lru_shrink_countwalk
+++ a/include/linux/list_lru.h
@@ -9,6 +9,7 @@
 
 #include <linux/list.h>
 #include <linux/nodemask.h>
+#include <linux/shrinker.h>
 
 /* list_lru_walk_cb has to always return one of those */
 enum lru_status {
@@ -81,6 +82,13 @@ bool list_lru_del(struct list_lru *lru,
  * Callers that want such a guarantee need to provide an outer lock.
  */
 unsigned long list_lru_count_node(struct list_lru *lru, int nid);
+
+static inline unsigned long list_lru_shrink_count(struct list_lru *lru,
+						  struct shrink_control *sc)
+{
+	return list_lru_count_node(lru, sc->nid);
+}
+
 static inline unsigned long list_lru_count(struct list_lru *lru)
 {
 	long count = 0;
@@ -120,6 +128,14 @@ unsigned long list_lru_walk_node(struct
 				 unsigned long *nr_to_walk);
 
 static inline unsigned long
+list_lru_shrink_walk(struct list_lru *lru, struct shrink_control *sc,
+		     list_lru_walk_cb isolate, void *cb_arg)
+{
+	return list_lru_walk_node(lru, sc->nid, isolate, cb_arg,
+				  &sc->nr_to_scan);
+}
+
+static inline unsigned long
 list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
 	      void *cb_arg, unsigned long nr_to_walk)
 {
diff -puN mm/workingset.c~list_lru-introduce-list_lru_shrink_countwalk mm/workingset.c
--- a/mm/workingset.c~list_lru-introduce-list_lru_shrink_countwalk
+++ a/mm/workingset.c
@@ -275,7 +275,7 @@ static unsigned long count_shadow_nodes(
 
 	/* list_lru lock nests inside IRQ-safe mapping->tree_lock */
 	local_irq_disable();
-	shadow_nodes = list_lru_count_node(&workingset_shadow_nodes, sc->nid);
+	shadow_nodes = list_lru_shrink_count(&workingset_shadow_nodes, sc);
 	local_irq_enable();
 
 	pages = node_present_pages(sc->nid);
@@ -376,8 +376,8 @@ static unsigned long scan_shadow_nodes(s
 
 	/* list_lru lock nests inside IRQ-safe mapping->tree_lock */
 	local_irq_disable();
-	ret =  list_lru_walk_node(&workingset_shadow_nodes, sc->nid,
-				  shadow_lru_isolate, NULL, &sc->nr_to_scan);
+	ret =  list_lru_shrink_walk(&workingset_shadow_nodes, sc,
+				    shadow_lru_isolate, NULL);
 	local_irq_enable();
 	return ret;
 }
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

