From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:34:49 -0700
Message-ID: <51b0e459.XVYUReQ9vsYSJtzK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab3FFTeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com

Subject: [to-be-updated] fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch removed from -mm tree
To: dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:49 -0700


The patch titled
     Subject: fs: convert inode and dentry shrinking to be node aware
has been removed from the -mm tree.  Its filename was
     fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: fs: convert inode and dentry shrinking to be node aware

Now that the shrinker is passing a node in the scan control structure, we
can pass this to the the generic LRU list code to isolate reclaim to the
lists on matching nodes.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |    8 +++++---
 fs/inode.c         |    7 ++++---
 fs/internal.h      |    6 ++++--
 fs/super.c         |   23 ++++++++++++++---------
 fs/xfs/xfs_super.c |    6 ++++--
 include/linux/fs.h |    4 ++--
 6 files changed, 33 insertions(+), 21 deletions(-)

diff -puN fs/dcache.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware fs/dcache.c
--- a/fs/dcache.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/fs/dcache.c
@@ -879,6 +879,7 @@ dentry_lru_isolate(struct list_head *ite
  * prune_dcache_sb - shrink the dcache
  * @sb: superblock
  * @nr_to_scan : number of entries to try to free
+ * @nodes_to_walk: which nodes to scan for freeable entities
  *
  * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
  * done when we need more memory an called from the superblock shrinker
@@ -887,13 +888,14 @@ dentry_lru_isolate(struct list_head *ite
  * This function may fail to free any resources if all the dentries are in
  * use.
  */
-long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan)
+long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
+		     int nid)
 {
 	LIST_HEAD(dispose);
 	long freed;
 
-	freed = list_lru_walk(&sb->s_dentry_lru, dentry_lru_isolate,
-			      &dispose, nr_to_scan);
+	freed = list_lru_walk_node(&sb->s_dentry_lru, nid, dentry_lru_isolate,
+				       &dispose, &nr_to_scan);
 	shrink_dentry_list(&dispose);
 	return freed;
 }
diff -puN fs/inode.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware fs/inode.c
--- a/fs/inode.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/fs/inode.c
@@ -746,13 +746,14 @@ inode_lru_isolate(struct list_head *item
  * to trim from the LRU. Inodes to be freed are moved to a temporary list and
  * then are freed outside inode_lock by dispose_list().
  */
-long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan)
+long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
+		     int nid)
 {
 	LIST_HEAD(freeable);
 	long freed;
 
-	freed = list_lru_walk(&sb->s_inode_lru, inode_lru_isolate,
-						&freeable, nr_to_scan);
+	freed = list_lru_walk_node(&sb->s_inode_lru, nid, inode_lru_isolate,
+				       &freeable, &nr_to_scan);
 	dispose_list(&freeable);
 	return freed;
 }
diff -puN fs/internal.h~fs-convert-inode-and-dentry-shrinking-to-be-node-aware fs/internal.h
--- a/fs/internal.h~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/fs/internal.h
@@ -110,7 +110,8 @@ extern int open_check_o_direct(struct fi
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
-extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan);
+extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
+			    int nid);
 extern void inode_add_lru(struct inode *inode);
 
 /*
@@ -126,7 +127,8 @@ extern int invalidate_inodes(struct supe
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
-extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan);
+extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
+			    int nid);
 
 /*
  * read_write.c
diff -puN fs/super.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware fs/super.c
--- a/fs/super.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/fs/super.c
@@ -75,10 +75,10 @@ static long super_cache_scan(struct shri
 		return -1;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
-		fs_objects = sb->s_op->nr_cached_objects(sb);
+		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
 
-	inodes = list_lru_count(&sb->s_inode_lru);
-	dentries = list_lru_count(&sb->s_dentry_lru);
+	inodes = list_lru_count_node(&sb->s_inode_lru, sc->nid);
+	dentries = list_lru_count_node(&sb->s_dentry_lru, sc->nid);
 	total_objects = dentries + inodes + fs_objects + 1;
 
 	/* proportion the scan between the caches */
@@ -89,13 +89,14 @@ static long super_cache_scan(struct shri
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
 	 */
-	freed = prune_dcache_sb(sb, dentries);
-	freed += prune_icache_sb(sb, inodes);
+	freed = prune_dcache_sb(sb, dentries, sc->nid);
+	freed += prune_icache_sb(sb, inodes, sc->nid);
 
 	if (fs_objects) {
 		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
 								total_objects);
-		freed += sb->s_op->free_cached_objects(sb, fs_objects);
+		freed += sb->s_op->free_cached_objects(sb, fs_objects,
+						       sc->nid);
 	}
 
 	drop_super(sb);
@@ -113,10 +114,13 @@ static long super_cache_count(struct shr
 		return 0;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
-		total_objects = sb->s_op->nr_cached_objects(sb);
+		total_objects = sb->s_op->nr_cached_objects(sb,
+						 sc->nid);
 
-	total_objects += list_lru_count(&sb->s_dentry_lru);
-	total_objects += list_lru_count(&sb->s_inode_lru);
+	total_objects += list_lru_count_node(&sb->s_dentry_lru,
+						 sc->nid);
+	total_objects += list_lru_count_node(&sb->s_inode_lru,
+						 sc->nid);
 
 	total_objects = vfs_pressure_ratio(total_objects);
 	drop_super(sb);
@@ -232,6 +236,7 @@ static struct super_block *alloc_super(s
 		s->s_shrink.scan_objects = super_cache_scan;
 		s->s_shrink.count_objects = super_cache_count;
 		s->s_shrink.batch = 1024;
+		s->s_shrink.flags = SHRINKER_NUMA_AWARE;
 	}
 out:
 	return s;
diff -puN fs/xfs/xfs_super.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/fs/xfs/xfs_super.c
@@ -1536,7 +1536,8 @@ xfs_fs_mount(
 
 static long
 xfs_fs_nr_cached_objects(
-	struct super_block	*sb)
+	struct super_block	*sb,
+	int			nid)
 {
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
@@ -1544,7 +1545,8 @@ xfs_fs_nr_cached_objects(
 static long
 xfs_fs_free_cached_objects(
 	struct super_block	*sb,
-	long			nr_to_scan)
+	long			nr_to_scan,
+	int			nid)
 {
 	return xfs_reclaim_inodes_nr(XFS_M(sb), nr_to_scan);
 }
diff -puN include/linux/fs.h~fs-convert-inode-and-dentry-shrinking-to-be-node-aware include/linux/fs.h
--- a/include/linux/fs.h~fs-convert-inode-and-dentry-shrinking-to-be-node-aware
+++ a/include/linux/fs.h
@@ -1610,8 +1610,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
-	long (*nr_cached_objects)(struct super_block *);
-	long (*free_cached_objects)(struct super_block *, long);
+	long (*nr_cached_objects)(struct super_block *, int);
+	long (*free_cached_objects)(struct super_block *, long, int);
 };
 
 /*
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
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

