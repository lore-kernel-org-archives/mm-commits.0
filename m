From: akpm@linux-foundation.org
Subject: + shrinker-convert-superblock-shrinkers-to-new-api.patch added to -mm tree
Date: Thu, 06 Jun 2013 14:11:24 -0700
Message-ID: <51b0fafc.O9GHZ34DAP3pPSW+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFVLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + shrinker-convert-superblock-shrinkers-to-new-api.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:11:23 -0700


The patch titled
     Subject: shrinker: convert superblock shrinkers to new API
has been added to the -mm tree.  Its filename is
     shrinker-convert-superblock-shrinkers-to-new-api.patch

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
Subject: shrinker: convert superblock shrinkers to new API

Convert superblock shrinker to use the new count/scan API, and propagate
the API changes through to the filesystem callouts.  The filesystem
callouts already use a count/scan API, so it's just changing counters to
longs to match the VM API.

This requires the dentry and inode shrinker callouts to be converted to
the count/scan API.  This is mainly a mechanical change.

[glommer@openvz.org: use mult_frac for fractional proportions, build fixes]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
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

 fs/dcache.c         |   10 +++--
 fs/inode.c          |    7 ++-
 fs/internal.h       |    2 +
 fs/super.c          |   78 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_icache.c |    4 +-
 fs/xfs/xfs_icache.h |    2 -
 fs/xfs/xfs_super.c  |    8 ++--
 include/linux/fs.h  |    8 +---
 8 files changed, 69 insertions(+), 50 deletions(-)

diff -puN fs/dcache.c~shrinker-convert-superblock-shrinkers-to-new-api fs/dcache.c
--- a/fs/dcache.c~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/dcache.c
@@ -868,11 +868,12 @@ static void shrink_dentry_list(struct li
  * This function may fail to free any resources if all the dentries are in
  * use.
  */
-void prune_dcache_sb(struct super_block *sb, int count)
+long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan)
 {
 	struct dentry *dentry;
 	LIST_HEAD(referenced);
 	LIST_HEAD(tmp);
+	long freed = 0;
 
 relock:
 	spin_lock(&sb->s_dentry_lru_lock);
@@ -897,7 +898,8 @@ relock:
 			this_cpu_dec(nr_dentry_unused);
 			sb->s_nr_dentry_unused--;
 			spin_unlock(&dentry->d_lock);
-			if (!--count)
+			freed++;
+			if (!--nr_to_scan)
 				break;
 		}
 		cond_resched_lock(&sb->s_dentry_lru_lock);
@@ -907,6 +909,7 @@ relock:
 	spin_unlock(&sb->s_dentry_lru_lock);
 
 	shrink_dentry_list(&tmp);
+	return freed;
 }
 
 /*
@@ -1294,9 +1297,8 @@ rename_retry:
 void shrink_dcache_parent(struct dentry * parent)
 {
 	LIST_HEAD(dispose);
-	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0) {
+	while (select_parent(parent, &dispose)) {
 		shrink_dentry_list(&dispose);
 		cond_resched();
 	}
diff -puN fs/inode.c~shrinker-convert-superblock-shrinkers-to-new-api fs/inode.c
--- a/fs/inode.c~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/inode.c
@@ -704,10 +704,11 @@ static int can_unuse(struct inode *inode
  * LRU does not have strict ordering. Hence we don't want to reclaim inodes
  * with this flag set because they are the inodes that are out of order.
  */
-void prune_icache_sb(struct super_block *sb, int nr_to_scan)
+long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan)
 {
 	LIST_HEAD(freeable);
-	int nr_scanned;
+	long nr_scanned;
+	long freed = 0;
 	unsigned long reap = 0;
 
 	spin_lock(&sb->s_inode_lru_lock);
@@ -777,6 +778,7 @@ void prune_icache_sb(struct super_block
 		list_move(&inode->i_lru, &freeable);
 		sb->s_nr_inodes_unused--;
 		this_cpu_dec(nr_unused);
+		freed++;
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
@@ -787,6 +789,7 @@ void prune_icache_sb(struct super_block
 		current->reclaim_state->reclaimed_slab += reap;
 
 	dispose_list(&freeable);
+	return freed;
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
diff -puN fs/internal.h~shrinker-convert-superblock-shrinkers-to-new-api fs/internal.h
--- a/fs/internal.h~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/internal.h
@@ -110,6 +110,7 @@ extern int open_check_o_direct(struct fi
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
+extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan);
 extern void inode_add_lru(struct inode *inode);
 
 /*
@@ -125,6 +126,7 @@ extern int invalidate_inodes(struct supe
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan);
 
 /*
  * read_write.c
diff -puN fs/super.c~shrinker-convert-superblock-shrinkers-to-new-api fs/super.c
--- a/fs/super.c~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/super.c
@@ -53,11 +53,14 @@ static char *sb_writers_name[SB_FREEZE_L
  * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
-static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
+static long super_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct super_block *sb;
-	int	fs_objects = 0;
-	int	total_objects;
+	long	fs_objects = 0;
+	long	total_objects;
+	long	freed = 0;
+	long	dentries;
+	long	inodes;
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
@@ -65,11 +68,11 @@ static int prune_super(struct shrinker *
 	 * Deadlock avoidance.  We may hold various FS locks, and we don't want
 	 * to recurse into the FS that called us in clear_inode() and friends..
 	 */
-	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
-		return -1;
+	if (!(sc->gfp_mask & __GFP_FS))
+		return SHRINK_STOP;
 
 	if (!grab_super_passive(sb))
-		return -1;
+		return SHRINK_STOP;
 
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
@@ -77,33 +80,45 @@ static int prune_super(struct shrinker *
 	total_objects = sb->s_nr_dentry_unused +
 			sb->s_nr_inodes_unused + fs_objects + 1;
 
-	if (sc->nr_to_scan) {
-		int	dentries;
-		int	inodes;
-
-		/* proportion the scan between the caches */
-		dentries = mult_frac(sc->nr_to_scan, sb->s_nr_dentry_unused,
-							total_objects);
-		inodes = mult_frac(sc->nr_to_scan, sb->s_nr_inodes_unused,
-							total_objects);
-		if (fs_objects)
-			fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
-							total_objects);
-		/*
-		 * prune the dcache first as the icache is pinned by it, then
-		 * prune the icache, followed by the filesystem specific caches
-		 */
-		prune_dcache_sb(sb, dentries);
-		prune_icache_sb(sb, inodes);
+	/* proportion the scan between the caches */
+	dentries = mult_frac(sc->nr_to_scan, sb->s_nr_dentry_unused,
+								total_objects);
+	inodes = mult_frac(sc->nr_to_scan, sb->s_nr_inodes_unused,
+								total_objects);
 
-		if (fs_objects && sb->s_op->free_cached_objects) {
-			sb->s_op->free_cached_objects(sb, fs_objects);
-			fs_objects = sb->s_op->nr_cached_objects(sb);
-		}
-		total_objects = sb->s_nr_dentry_unused +
-				sb->s_nr_inodes_unused + fs_objects;
+	/*
+	 * prune the dcache first as the icache is pinned by it, then
+	 * prune the icache, followed by the filesystem specific caches
+	 */
+	freed = prune_dcache_sb(sb, dentries);
+	freed += prune_icache_sb(sb, inodes);
+
+	if (fs_objects) {
+		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
+								total_objects);
+		freed += sb->s_op->free_cached_objects(sb, fs_objects);
 	}
 
+	drop_super(sb);
+	return freed;
+}
+
+static long super_cache_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	struct super_block *sb;
+	long	total_objects = 0;
+
+	sb = container_of(shrink, struct super_block, s_shrink);
+
+	if (!grab_super_passive(sb))
+		return 0;
+
+	if (sb->s_op && sb->s_op->nr_cached_objects)
+		total_objects = sb->s_op->nr_cached_objects(sb);
+
+	total_objects += sb->s_nr_dentry_unused;
+	total_objects += sb->s_nr_inodes_unused;
+
 	total_objects = vfs_pressure_ratio(total_objects);
 	drop_super(sb);
 	return total_objects;
@@ -217,7 +232,8 @@ static struct super_block *alloc_super(s
 		s->cleancache_poolid = -1;
 
 		s->s_shrink.seeks = DEFAULT_SEEKS;
-		s->s_shrink.shrink = prune_super;
+		s->s_shrink.scan_objects = super_cache_scan;
+		s->s_shrink.count_objects = super_cache_count;
 		s->s_shrink.batch = 1024;
 	}
 out:
diff -puN fs/xfs/xfs_icache.c~shrinker-convert-superblock-shrinkers-to-new-api fs/xfs/xfs_icache.c
--- a/fs/xfs/xfs_icache.c~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/xfs/xfs_icache.c
@@ -1164,7 +1164,7 @@ xfs_reclaim_inodes(
  * them to be cleaned, which we hope will not be very long due to the
  * background walker having already kicked the IO off on those dirty inodes.
  */
-void
+long
 xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
@@ -1173,7 +1173,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
+	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
 }
 
 /*
diff -puN fs/xfs/xfs_icache.h~shrinker-convert-superblock-shrinkers-to-new-api fs/xfs/xfs_icache.h
--- a/fs/xfs/xfs_icache.h~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/xfs/xfs_icache.h
@@ -31,7 +31,7 @@ void xfs_reclaim_worker(struct work_stru
 
 int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
-void xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
+long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
diff -puN fs/xfs/xfs_super.c~shrinker-convert-superblock-shrinkers-to-new-api fs/xfs/xfs_super.c
--- a/fs/xfs/xfs_super.c~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/fs/xfs/xfs_super.c
@@ -1534,19 +1534,19 @@ xfs_fs_mount(
 	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
 }
 
-static int
+static long
 xfs_fs_nr_cached_objects(
 	struct super_block	*sb)
 {
 	return xfs_reclaim_inodes_count(XFS_M(sb));
 }
 
-static void
+static long
 xfs_fs_free_cached_objects(
 	struct super_block	*sb,
-	int			nr_to_scan)
+	long			nr_to_scan)
 {
-	xfs_reclaim_inodes_nr(XFS_M(sb), nr_to_scan);
+	return xfs_reclaim_inodes_nr(XFS_M(sb), nr_to_scan);
 }
 
 static const struct super_operations xfs_super_operations = {
diff -puN include/linux/fs.h~shrinker-convert-superblock-shrinkers-to-new-api include/linux/fs.h
--- a/include/linux/fs.h~shrinker-convert-superblock-shrinkers-to-new-api
+++ a/include/linux/fs.h
@@ -1327,10 +1327,6 @@ struct super_block {
 	int s_readonly_remount;
 };
 
-/* superblock cache pruning functions */
-extern void prune_icache_sb(struct super_block *sb, int nr_to_scan);
-extern void prune_dcache_sb(struct super_block *sb, int nr_to_scan);
-
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
@@ -1617,8 +1613,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
-	int (*nr_cached_objects)(struct super_block *);
-	void (*free_cached_objects)(struct super_block *, int);
+	long (*nr_cached_objects)(struct super_block *);
+	long (*free_cached_objects)(struct super_block *, long);
 };
 
 /*
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
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

