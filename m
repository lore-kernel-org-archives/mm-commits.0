From: akpm@linux-foundation.org
Subject: [merged]
 inode-convert-inode-lru-list-to-generic-lru-list-code.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 14:15:57 -0700
Message-ID: <5233808d.C0kSlxHwdQMTv0MR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] inode-convert-inode-lru-list-to-generic-lru-list-code.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:57 -0700


The patch titled
     Subject: inode: convert inode lru list to generic lru list code.
has been removed from the -mm tree.  Its filename was
     inode-convert-inode-lru-list-to-generic-lru-list-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: inode: convert inode lru list to generic lru list code.

[glommer@openvz.org: adapted for new LRU return codes]
[glommer@gmail.com: move inode to a different list inside lock]
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

 fs/inode.c         |  175 +++++++++++++++++--------------------------
 fs/super.c         |   12 +-
 include/linux/fs.h |    6 -
 3 files changed, 77 insertions(+), 116 deletions(-)

diff -puN fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code fs/inode.c
--- a/fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code
+++ a/fs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/prefetch.h>
 #include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
+#include <linux/list_lru.h>
 #include "internal.h"
 
 /*
@@ -25,7 +26,7 @@
  *
  * inode->i_lock protects:
  *   inode->i_state, inode->i_hash, __iget()
- * inode->i_sb->s_inode_lru_lock protects:
+ * Inode LRU list locks protect:
  *   inode->i_sb->s_inode_lru, inode->i_lru
  * inode_sb_list_lock protects:
  *   sb->s_inodes, inode->i_sb_list
@@ -38,7 +39,7 @@
  *
  * inode_sb_list_lock
  *   inode->i_lock
- *     inode->i_sb->s_inode_lru_lock
+ *     Inode LRU list locks
  *
  * bdi->wb.list_lock
  *   inode->i_lock
@@ -402,13 +403,8 @@ EXPORT_SYMBOL(ihold);
 
 static void inode_lru_list_add(struct inode *inode)
 {
-	spin_lock(&inode->i_sb->s_inode_lru_lock);
-	if (list_empty(&inode->i_lru)) {
-		list_add(&inode->i_lru, &inode->i_sb->s_inode_lru);
-		inode->i_sb->s_nr_inodes_unused++;
+	if (list_lru_add(&inode->i_sb->s_inode_lru, &inode->i_lru))
 		this_cpu_inc(nr_unused);
-	}
-	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
 /*
@@ -426,13 +422,9 @@ void inode_add_lru(struct inode *inode)
 
 static void inode_lru_list_del(struct inode *inode)
 {
-	spin_lock(&inode->i_sb->s_inode_lru_lock);
-	if (!list_empty(&inode->i_lru)) {
-		list_del_init(&inode->i_lru);
-		inode->i_sb->s_nr_inodes_unused--;
+
+	if (list_lru_del(&inode->i_sb->s_inode_lru, &inode->i_lru))
 		this_cpu_dec(nr_unused);
-	}
-	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
 /**
@@ -676,24 +668,8 @@ int invalidate_inodes(struct super_block
 	return busy;
 }
 
-static int can_unuse(struct inode *inode)
-{
-	if (inode->i_state & ~I_REFERENCED)
-		return 0;
-	if (inode_has_buffers(inode))
-		return 0;
-	if (atomic_read(&inode->i_count))
-		return 0;
-	if (inode->i_data.nrpages)
-		return 0;
-	return 1;
-}
-
 /*
- * Walk the superblock inode LRU for freeable inodes and attempt to free them.
- * This is called from the superblock shrinker function with a number of inodes
- * to trim from the LRU. Inodes to be freed are moved to a temporary list and
- * then are freed outside inode_lock by dispose_list().
+ * Isolate the inode from the LRU in preparation for freeing it.
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  If the inode has metadata buffers attached to
@@ -707,90 +683,79 @@ static int can_unuse(struct inode *inode
  * LRU does not have strict ordering. Hence we don't want to reclaim inodes
  * with this flag set because they are the inodes that are out of order.
  */
-long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan)
+static enum lru_status
+inode_lru_isolate(struct list_head *item, spinlock_t *lru_lock, void *arg)
 {
-	LIST_HEAD(freeable);
-	long nr_scanned;
-	long freed = 0;
-	unsigned long reap = 0;
+	struct list_head *freeable = arg;
+	struct inode	*inode = container_of(item, struct inode, i_lru);
 
-	spin_lock(&sb->s_inode_lru_lock);
-	for (nr_scanned = nr_to_scan; nr_scanned >= 0; nr_scanned--) {
-		struct inode *inode;
+	/*
+	 * we are inverting the lru lock/inode->i_lock here, so use a trylock.
+	 * If we fail to get the lock, just skip it.
+	 */
+	if (!spin_trylock(&inode->i_lock))
+		return LRU_SKIP;
 
-		if (list_empty(&sb->s_inode_lru))
-			break;
+	/*
+	 * Referenced or dirty inodes are still in use. Give them another pass
+	 * through the LRU as we canot reclaim them now.
+	 */
+	if (atomic_read(&inode->i_count) ||
+	    (inode->i_state & ~I_REFERENCED)) {
+		list_del_init(&inode->i_lru);
+		spin_unlock(&inode->i_lock);
+		this_cpu_dec(nr_unused);
+		return LRU_REMOVED;
+	}
 
-		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
+	/* recently referenced inodes get one more pass */
+	if (inode->i_state & I_REFERENCED) {
+		inode->i_state &= ~I_REFERENCED;
+		spin_unlock(&inode->i_lock);
+		return LRU_ROTATE;
+	}
 
-		/*
-		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
-		 * so use a trylock. If we fail to get the lock, just move the
-		 * inode to the back of the list so we don't spin on it.
-		 */
-		if (!spin_trylock(&inode->i_lock)) {
-			list_move(&inode->i_lru, &sb->s_inode_lru);
-			continue;
+	if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+		__iget(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(lru_lock);
+		if (remove_inode_buffers(inode)) {
+			unsigned long reap;
+			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
+			if (current_is_kswapd())
+				__count_vm_events(KSWAPD_INODESTEAL, reap);
+			else
+				__count_vm_events(PGINODESTEAL, reap);
+			if (current->reclaim_state)
+				current->reclaim_state->reclaimed_slab += reap;
 		}
+		iput(inode);
+		spin_lock(lru_lock);
+		return LRU_RETRY;
+	}
 
-		/*
-		 * Referenced or dirty inodes are still in use. Give them
-		 * another pass through the LRU as we canot reclaim them now.
-		 */
-		if (atomic_read(&inode->i_count) ||
-		    (inode->i_state & ~I_REFERENCED)) {
-			list_del_init(&inode->i_lru);
-			spin_unlock(&inode->i_lock);
-			sb->s_nr_inodes_unused--;
-			this_cpu_dec(nr_unused);
-			continue;
-		}
+	WARN_ON(inode->i_state & I_NEW);
+	inode->i_state |= I_FREEING;
+	list_move(&inode->i_lru, freeable);
+	spin_unlock(&inode->i_lock);
 
-		/* recently referenced inodes get one more pass */
-		if (inode->i_state & I_REFERENCED) {
-			inode->i_state &= ~I_REFERENCED;
-			list_move(&inode->i_lru, &sb->s_inode_lru);
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-			__iget(inode);
-			spin_unlock(&inode->i_lock);
-			spin_unlock(&sb->s_inode_lru_lock);
-			if (remove_inode_buffers(inode))
-				reap += invalidate_mapping_pages(&inode->i_data,
-								0, -1);
-			iput(inode);
-			spin_lock(&sb->s_inode_lru_lock);
-
-			if (inode != list_entry(sb->s_inode_lru.next,
-						struct inode, i_lru))
-				continue;	/* wrong inode or list_empty */
-			/* avoid lock inversions with trylock */
-			if (!spin_trylock(&inode->i_lock))
-				continue;
-			if (!can_unuse(inode)) {
-				spin_unlock(&inode->i_lock);
-				continue;
-			}
-		}
-		WARN_ON(inode->i_state & I_NEW);
-		inode->i_state |= I_FREEING;
-		spin_unlock(&inode->i_lock);
+	this_cpu_dec(nr_unused);
+	return LRU_REMOVED;
+}
 
-		list_move(&inode->i_lru, &freeable);
-		sb->s_nr_inodes_unused--;
-		this_cpu_dec(nr_unused);
-		freed++;
-	}
-	if (current_is_kswapd())
-		__count_vm_events(KSWAPD_INODESTEAL, reap);
-	else
-		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&sb->s_inode_lru_lock);
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += reap;
+/*
+ * Walk the superblock inode LRU for freeable inodes and attempt to free them.
+ * This is called from the superblock shrinker function with a number of inodes
+ * to trim from the LRU. Inodes to be freed are moved to a temporary list and
+ * then are freed outside inode_lock by dispose_list().
+ */
+long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan)
+{
+	LIST_HEAD(freeable);
+	long freed;
 
+	freed = list_lru_walk(&sb->s_inode_lru, inode_lru_isolate,
+						&freeable, nr_to_scan);
 	dispose_list(&freeable);
 	return freed;
 }
diff -puN fs/super.c~inode-convert-inode-lru-list-to-generic-lru-list-code fs/super.c
--- a/fs/super.c~inode-convert-inode-lru-list-to-generic-lru-list-code
+++ a/fs/super.c
@@ -78,14 +78,13 @@ static unsigned long super_cache_scan(st
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb);
 
-	total_objects = sb->s_nr_dentry_unused +
-			sb->s_nr_inodes_unused + fs_objects + 1;
+	inodes = list_lru_count(&sb->s_inode_lru);
+	total_objects = sb->s_nr_dentry_unused + inodes + fs_objects + 1;
 
 	/* proportion the scan between the caches */
 	dentries = mult_frac(sc->nr_to_scan, sb->s_nr_dentry_unused,
 								total_objects);
-	inodes = mult_frac(sc->nr_to_scan, sb->s_nr_inodes_unused,
-								total_objects);
+	inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
 
 	/*
 	 * prune the dcache first as the icache is pinned by it, then
@@ -119,7 +118,7 @@ static unsigned long super_cache_count(s
 		total_objects = sb->s_op->nr_cached_objects(sb);
 
 	total_objects += sb->s_nr_dentry_unused;
-	total_objects += sb->s_nr_inodes_unused;
+	total_objects += list_lru_count(&sb->s_inode_lru);
 
 	total_objects = vfs_pressure_ratio(total_objects);
 	drop_super(sb);
@@ -194,8 +193,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		spin_lock_init(&s->s_dentry_lru_lock);
-		INIT_LIST_HEAD(&s->s_inode_lru);
-		spin_lock_init(&s->s_inode_lru_lock);
+		list_lru_init(&s->s_inode_lru);
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
diff -puN include/linux/fs.h~inode-convert-inode-lru-list-to-generic-lru-list-code include/linux/fs.h
--- a/include/linux/fs.h~inode-convert-inode-lru-list-to-generic-lru-list-code
+++ a/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/stat.h>
 #include <linux/cache.h>
 #include <linux/list.h>
+#include <linux/list_lru.h>
 #include <linux/llist.h>
 #include <linux/radix-tree.h>
 #include <linux/rbtree.h>
@@ -1275,10 +1276,7 @@ struct super_block {
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	long			s_nr_dentry_unused;	/* # of dentry on lru */
 
-	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
-	spinlock_t		s_inode_lru_lock ____cacheline_aligned_in_smp;
-	struct list_head	s_inode_lru;		/* unused inode lru */
-	long			s_nr_inodes_unused;	/* # of inodes on lru */
+	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
 
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
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

