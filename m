From: akpm@linux-foundation.org
Subject: [merged] dcache-convert-to-use-new-lru-list-infrastructure.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 14:15:59 -0700
Message-ID: <5233808f.52ccxVrd7z7aGFg2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] dcache-convert-to-use-new-lru-list-infrastructure.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:59 -0700


The patch titled
     Subject: dcache: convert to use new lru list infrastructure
has been removed from the -mm tree.  Its filename was
     dcache-convert-to-use-new-lru-list-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: dcache: convert to use new lru list infrastructure

[glommer@openvz.org: don't reintroduce double decrement of nr_unused_dentries, adapted for new LRU return codes]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
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

 fs/dcache.c        |  165 +++++++++++++++++++------------------------
 fs/super.c         |   11 +-
 include/linux/fs.h |   15 +--
 3 files changed, 87 insertions(+), 104 deletions(-)

diff -puN fs/dcache.c~dcache-convert-to-use-new-lru-list-infrastructure fs/dcache.c
--- a/fs/dcache.c~dcache-convert-to-use-new-lru-list-infrastructure
+++ a/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
+#include <linux/list_lru.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -332,20 +333,8 @@ static void dentry_unlink_inode(struct d
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
-	if (list_empty(&dentry->d_lru)) {
-		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
-		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
-		dentry->d_sb->s_nr_dentry_unused++;
+	if (list_lru_add(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
 		this_cpu_inc(nr_dentry_unused);
-		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
-	}
-}
-
-static void __dentry_lru_del(struct dentry *dentry)
-{
-	list_del_init(&dentry->d_lru);
-	dentry->d_sb->s_nr_dentry_unused--;
-	this_cpu_dec(nr_dentry_unused);
 }
 
 /*
@@ -363,26 +352,8 @@ static void dentry_lru_del(struct dentry
 		return;
 	}
 
-	if (!list_empty(&dentry->d_lru)) {
-		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
-		__dentry_lru_del(dentry);
-		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
-	}
-}
-
-static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
-{
-	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
-
-	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
-	if (list_empty(&dentry->d_lru)) {
-		list_add_tail(&dentry->d_lru, list);
-	} else {
-		list_move_tail(&dentry->d_lru, list);
-		dentry->d_sb->s_nr_dentry_unused--;
+	if (list_lru_del(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
 		this_cpu_dec(nr_dentry_unused);
-	}
-	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
 
 /**
@@ -872,12 +843,72 @@ static void shrink_dentry_list(struct li
 	rcu_read_unlock();
 }
 
+static enum lru_status
+dentry_lru_isolate(struct list_head *item, spinlock_t *lru_lock, void *arg)
+{
+	struct list_head *freeable = arg;
+	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
+
+
+	/*
+	 * we are inverting the lru lock/dentry->d_lock here,
+	 * so use a trylock. If we fail to get the lock, just skip
+	 * it
+	 */
+	if (!spin_trylock(&dentry->d_lock))
+		return LRU_SKIP;
+
+	/*
+	 * Referenced dentries are still in use. If they have active
+	 * counts, just remove them from the LRU. Otherwise give them
+	 * another pass through the LRU.
+	 */
+	if (d_count(dentry)) {
+		list_del_init(&dentry->d_lru);
+		spin_unlock(&dentry->d_lock);
+		return LRU_REMOVED;
+	}
+
+	if (dentry->d_flags & DCACHE_REFERENCED) {
+		dentry->d_flags &= ~DCACHE_REFERENCED;
+		spin_unlock(&dentry->d_lock);
+
+		/*
+		 * The list move itself will be made by the common LRU code. At
+		 * this point, we've dropped the dentry->d_lock but keep the
+		 * lru lock. This is safe to do, since every list movement is
+		 * protected by the lru lock even if both locks are held.
+		 *
+		 * This is guaranteed by the fact that all LRU management
+		 * functions are intermediated by the LRU API calls like
+		 * list_lru_add and list_lru_del. List movement in this file
+		 * only ever occur through this functions or through callbacks
+		 * like this one, that are called from the LRU API.
+		 *
+		 * The only exceptions to this are functions like
+		 * shrink_dentry_list, and code that first checks for the
+		 * DCACHE_SHRINK_LIST flag.  Those are guaranteed to be
+		 * operating only with stack provided lists after they are
+		 * properly isolated from the main list.  It is thus, always a
+		 * local access.
+		 */
+		return LRU_ROTATE;
+	}
+
+	dentry->d_flags |= DCACHE_SHRINK_LIST;
+	list_move_tail(&dentry->d_lru, freeable);
+	this_cpu_dec(nr_dentry_unused);
+	spin_unlock(&dentry->d_lock);
+
+	return LRU_REMOVED;
+}
+
 /**
  * prune_dcache_sb - shrink the dcache
  * @sb: superblock
- * @count: number of entries to try to free
+ * @nr_to_scan : number of entries to try to free
  *
- * Attempt to shrink the superblock dcache LRU by @count entries. This is
+ * Attempt to shrink the superblock dcache LRU by @nr_to_scan entries. This is
  * done when we need more memory an called from the superblock shrinker
  * function.
  *
@@ -886,45 +917,12 @@ static void shrink_dentry_list(struct li
  */
 long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan)
 {
-	struct dentry *dentry;
-	LIST_HEAD(referenced);
-	LIST_HEAD(tmp);
-	long freed = 0;
-
-relock:
-	spin_lock(&sb->s_dentry_lru_lock);
-	while (!list_empty(&sb->s_dentry_lru)) {
-		dentry = list_entry(sb->s_dentry_lru.prev,
-				struct dentry, d_lru);
-		BUG_ON(dentry->d_sb != sb);
-
-		if (!spin_trylock(&dentry->d_lock)) {
-			spin_unlock(&sb->s_dentry_lru_lock);
-			cpu_relax();
-			goto relock;
-		}
-
-		if (dentry->d_flags & DCACHE_REFERENCED) {
-			dentry->d_flags &= ~DCACHE_REFERENCED;
-			list_move(&dentry->d_lru, &referenced);
-			spin_unlock(&dentry->d_lock);
-		} else {
-			list_move(&dentry->d_lru, &tmp);
-			dentry->d_flags |= DCACHE_SHRINK_LIST;
-			this_cpu_dec(nr_dentry_unused);
-			sb->s_nr_dentry_unused--;
-			spin_unlock(&dentry->d_lock);
-			freed++;
-			if (!--nr_to_scan)
-				break;
-		}
-		cond_resched_lock(&sb->s_dentry_lru_lock);
-	}
-	if (!list_empty(&referenced))
-		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&sb->s_dentry_lru_lock);
+	LIST_HEAD(dispose);
+	long freed;
 
-	shrink_dentry_list(&tmp);
+	freed = list_lru_walk(&sb->s_dentry_lru, dentry_lru_isolate,
+			      &dispose, nr_to_scan);
+	shrink_dentry_list(&dispose);
 	return freed;
 }
 
@@ -958,24 +956,10 @@ shrink_dcache_list(
  */
 void shrink_dcache_sb(struct super_block *sb)
 {
-	LIST_HEAD(tmp);
+	long disposed;
 
-	spin_lock(&sb->s_dentry_lru_lock);
-	while (!list_empty(&sb->s_dentry_lru)) {
-		/*
-		 * account for removal here so we don't need to handle it later
-		 * even though the dentry is no longer on the lru list.
-		 */
-		list_splice_init(&sb->s_dentry_lru, &tmp);
-		this_cpu_sub(nr_dentry_unused, sb->s_nr_dentry_unused);
-		sb->s_nr_dentry_unused = 0;
-		spin_unlock(&sb->s_dentry_lru_lock);
-
-		shrink_dcache_list(&tmp);
-
-		spin_lock(&sb->s_dentry_lru_lock);
-	}
-	spin_unlock(&sb->s_dentry_lru_lock);
+	disposed = list_lru_dispose_all(&sb->s_dentry_lru, shrink_dcache_list);
+	this_cpu_sub(nr_dentry_unused, disposed);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
@@ -1342,7 +1326,8 @@ static enum d_walk_ret select_collect(vo
 	if (dentry->d_lockref.count) {
 		dentry_lru_del(dentry);
 	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
-		dentry_lru_move_list(dentry, &data->dispose);
+		dentry_lru_del(dentry);
+		list_add_tail(&dentry->d_lru, &data->dispose);
 		dentry->d_flags |= DCACHE_SHRINK_LIST;
 		data->found++;
 		ret = D_WALK_NORETRY;
diff -puN fs/super.c~dcache-convert-to-use-new-lru-list-infrastructure fs/super.c
--- a/fs/super.c~dcache-convert-to-use-new-lru-list-infrastructure
+++ a/fs/super.c
@@ -79,11 +79,11 @@ static unsigned long super_cache_scan(st
 		fs_objects = sb->s_op->nr_cached_objects(sb);
 
 	inodes = list_lru_count(&sb->s_inode_lru);
-	total_objects = sb->s_nr_dentry_unused + inodes + fs_objects + 1;
+	dentries = list_lru_count(&sb->s_dentry_lru);
+	total_objects = dentries + inodes + fs_objects + 1;
 
 	/* proportion the scan between the caches */
-	dentries = mult_frac(sc->nr_to_scan, sb->s_nr_dentry_unused,
-								total_objects);
+	dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
 	inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
 
 	/*
@@ -117,7 +117,7 @@ static unsigned long super_cache_count(s
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb);
 
-	total_objects += sb->s_nr_dentry_unused;
+	total_objects += list_lru_count(&sb->s_dentry_lru);
 	total_objects += list_lru_count(&sb->s_inode_lru);
 
 	total_objects = vfs_pressure_ratio(total_objects);
@@ -191,8 +191,7 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
-		INIT_LIST_HEAD(&s->s_dentry_lru);
-		spin_lock_init(&s->s_dentry_lru_lock);
+		list_lru_init(&s->s_dentry_lru);
 		list_lru_init(&s->s_inode_lru);
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
diff -puN include/linux/fs.h~dcache-convert-to-use-new-lru-list-infrastructure include/linux/fs.h
--- a/include/linux/fs.h~dcache-convert-to-use-new-lru-list-infrastructure
+++ a/include/linux/fs.h
@@ -1270,14 +1270,6 @@ struct super_block {
 	struct list_head	s_files;
 #endif
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-
-	/* s_dentry_lru_lock protects s_dentry_lru and s_nr_dentry_unused */
-	spinlock_t		s_dentry_lru_lock ____cacheline_aligned_in_smp;
-	struct list_head	s_dentry_lru;	/* unused dentry lru */
-	long			s_nr_dentry_unused;	/* # of dentry on lru */
-
-	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
-
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
 	struct mtd_info		*s_mtd;
@@ -1329,6 +1321,13 @@ struct super_block {
 	/* Being remounted read-only */
 	int s_readonly_remount;
 
+	/*
+	 * Keep the lru lists last in the structure so they always sit on their
+	 * own individual cachelines.
+	 */
+	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
+	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
+
 	/* AIO completions deferred from interrupt context */
 	struct workqueue_struct *s_dio_done_wq;
 };
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
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

