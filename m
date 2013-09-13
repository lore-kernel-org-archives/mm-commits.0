From: akpm@linux-foundation.org
Subject: [merged] xfs-convert-buftarg-lru-to-generic-code.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 14:16:13 -0700
Message-ID: <5233809d.fb/JhZKecIOpCse5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] xfs-convert-buftarg-lru-to-generic-code.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:13 -0700


The patch titled
     Subject: xfs: convert buftarg LRU to generic code
has been removed from the -mm tree.  Its filename was
     xfs-convert-buftarg-lru-to-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: xfs: convert buftarg LRU to generic code

Convert the buftarg LRU to use the new generic LRU list and take advantage
of the functionality it supplies to make the buffer cache shrinker node
aware.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Glauber Costa <glommer@openvz.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
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

 fs/xfs/xfs_buf.c |  170 +++++++++++++++++++++------------------------
 fs/xfs/xfs_buf.h |    5 -
 2 files changed, 82 insertions(+), 93 deletions(-)

diff -puN fs/xfs/xfs_buf.c~xfs-convert-buftarg-lru-to-generic-code fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~xfs-convert-buftarg-lru-to-generic-code
+++ a/fs/xfs/xfs_buf.c
@@ -86,20 +86,14 @@ xfs_buf_vmap_len(
  * The LRU takes a new reference to the buffer so that it will only be freed
  * once the shrinker takes the buffer off the LRU.
  */
-STATIC void
+static void
 xfs_buf_lru_add(
 	struct xfs_buf	*bp)
 {
-	struct xfs_buftarg *btp = bp->b_target;
-
-	spin_lock(&btp->bt_lru_lock);
-	if (list_empty(&bp->b_lru)) {
-		atomic_inc(&bp->b_hold);
-		list_add_tail(&bp->b_lru, &btp->bt_lru);
-		btp->bt_lru_nr++;
+	if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
 		bp->b_lru_flags &= ~_XBF_LRU_DISPOSE;
+		atomic_inc(&bp->b_hold);
 	}
-	spin_unlock(&btp->bt_lru_lock);
 }
 
 /*
@@ -108,24 +102,13 @@ xfs_buf_lru_add(
  * The unlocked check is safe here because it only occurs when there are not
  * b_lru_ref counts left on the inode under the pag->pag_buf_lock. it is there
  * to optimise the shrinker removing the buffer from the LRU and calling
- * xfs_buf_free(). i.e. it removes an unnecessary round trip on the
- * bt_lru_lock.
+ * xfs_buf_free().
  */
-STATIC void
+static void
 xfs_buf_lru_del(
 	struct xfs_buf	*bp)
 {
-	struct xfs_buftarg *btp = bp->b_target;
-
-	if (list_empty(&bp->b_lru))
-		return;
-
-	spin_lock(&btp->bt_lru_lock);
-	if (!list_empty(&bp->b_lru)) {
-		list_del_init(&bp->b_lru);
-		btp->bt_lru_nr--;
-	}
-	spin_unlock(&btp->bt_lru_lock);
+	list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
 }
 
 /*
@@ -152,18 +135,10 @@ xfs_buf_stale(
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
 	atomic_set(&(bp)->b_lru_ref, 0);
-	if (!list_empty(&bp->b_lru)) {
-		struct xfs_buftarg *btp = bp->b_target;
+	if (!(bp->b_lru_flags & _XBF_LRU_DISPOSE) &&
+	    (list_lru_del(&bp->b_target->bt_lru, &bp->b_lru)))
+		atomic_dec(&bp->b_hold);
 
-		spin_lock(&btp->bt_lru_lock);
-		if (!list_empty(&bp->b_lru) &&
-		    !(bp->b_lru_flags & _XBF_LRU_DISPOSE)) {
-			list_del_init(&bp->b_lru);
-			btp->bt_lru_nr--;
-			atomic_dec(&bp->b_hold);
-		}
-		spin_unlock(&btp->bt_lru_lock);
-	}
 	ASSERT(atomic_read(&bp->b_hold) >= 1);
 }
 
@@ -1502,83 +1477,97 @@ xfs_buf_iomove(
  * returned. These buffers will have an elevated hold count, so wait on those
  * while freeing all the buffers only held by the LRU.
  */
-void
-xfs_wait_buftarg(
-	struct xfs_buftarg	*btp)
-{
-	struct xfs_buf		*bp;
+static enum lru_status
+xfs_buftarg_wait_rele(
+	struct list_head	*item,
+	spinlock_t		*lru_lock,
+	void			*arg)
 
-restart:
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-		if (atomic_read(&bp->b_hold) > 1) {
-			trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
-			list_move_tail(&bp->b_lru, &btp->bt_lru);
-			spin_unlock(&btp->bt_lru_lock);
-			delay(100);
-			goto restart;
-		}
+{
+	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
+
+	if (atomic_read(&bp->b_hold) > 1) {
+		/* need to wait */
+		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
+		spin_unlock(lru_lock);
+		delay(100);
+	} else {
 		/*
 		 * clear the LRU reference count so the buffer doesn't get
 		 * ignored in xfs_buf_rele().
 		 */
 		atomic_set(&bp->b_lru_ref, 0);
-		spin_unlock(&btp->bt_lru_lock);
+		spin_unlock(lru_lock);
 		xfs_buf_rele(bp);
-		spin_lock(&btp->bt_lru_lock);
 	}
-	spin_unlock(&btp->bt_lru_lock);
+
+	spin_lock(lru_lock);
+	return LRU_RETRY;
 }
 
-int
-xfs_buftarg_shrink(
+void
+xfs_wait_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	while (list_lru_count(&btp->bt_lru))
+		list_lru_walk(&btp->bt_lru, xfs_buftarg_wait_rele,
+			      NULL, LONG_MAX);
+}
+
+static enum lru_status
+xfs_buftarg_isolate(
+	struct list_head	*item,
+	spinlock_t		*lru_lock,
+	void			*arg)
+{
+	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
+	struct list_head	*dispose = arg;
+
+	/*
+	 * Decrement the b_lru_ref count unless the value is already
+	 * zero. If the value is already zero, we need to reclaim the
+	 * buffer, otherwise it gets another trip through the LRU.
+	 */
+	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0))
+		return LRU_ROTATE;
+
+	bp->b_lru_flags |= _XBF_LRU_DISPOSE;
+	list_move(item, dispose);
+	return LRU_REMOVED;
+}
+
+static unsigned long
+xfs_buftarg_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
-	struct xfs_buf		*bp;
-	int nr_to_scan = sc->nr_to_scan;
 	LIST_HEAD(dispose);
+	unsigned long		freed;
+	unsigned long		nr_to_scan = sc->nr_to_scan;
 
-	if (!nr_to_scan)
-		return btp->bt_lru_nr;
-
-	spin_lock(&btp->bt_lru_lock);
-	while (!list_empty(&btp->bt_lru)) {
-		if (nr_to_scan-- <= 0)
-			break;
-
-		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
-
-		/*
-		 * Decrement the b_lru_ref count unless the value is already
-		 * zero. If the value is already zero, we need to reclaim the
-		 * buffer, otherwise it gets another trip through the LRU.
-		 */
-		if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
-			list_move_tail(&bp->b_lru, &btp->bt_lru);
-			continue;
-		}
-
-		/*
-		 * remove the buffer from the LRU now to avoid needing another
-		 * lock round trip inside xfs_buf_rele().
-		 */
-		list_move(&bp->b_lru, &dispose);
-		btp->bt_lru_nr--;
-		bp->b_lru_flags |= _XBF_LRU_DISPOSE;
-	}
-	spin_unlock(&btp->bt_lru_lock);
+	freed = list_lru_walk_node(&btp->bt_lru, sc->nid, xfs_buftarg_isolate,
+				       &dispose, &nr_to_scan);
 
 	while (!list_empty(&dispose)) {
+		struct xfs_buf *bp;
 		bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
 		list_del_init(&bp->b_lru);
 		xfs_buf_rele(bp);
 	}
 
-	return btp->bt_lru_nr;
+	return freed;
+}
+
+static unsigned long
+xfs_buftarg_shrink_count(
+	struct shrinker		*shrink,
+	struct shrink_control	*sc)
+{
+	struct xfs_buftarg	*btp = container_of(shrink,
+					struct xfs_buftarg, bt_shrinker);
+	return list_lru_count_node(&btp->bt_lru, sc->nid);
 }
 
 void
@@ -1660,12 +1649,13 @@ xfs_alloc_buftarg(
 	if (!btp->bt_bdi)
 		goto error;
 
-	INIT_LIST_HEAD(&btp->bt_lru);
-	spin_lock_init(&btp->bt_lru_lock);
+	list_lru_init(&btp->bt_lru);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
+	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
+	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
+	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
 	register_shrinker(&btp->bt_shrinker);
 	return btp;
 
diff -puN fs/xfs/xfs_buf.h~xfs-convert-buftarg-lru-to-generic-code fs/xfs/xfs_buf.h
--- a/fs/xfs/xfs_buf.h~xfs-convert-buftarg-lru-to-generic-code
+++ a/fs/xfs/xfs_buf.h
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/uio.h>
+#include <linux/list_lru.h>
 
 /*
  *	Base types
@@ -92,9 +93,7 @@ typedef struct xfs_buftarg {
 
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
-	struct list_head	bt_lru;
-	spinlock_t		bt_lru_lock;
-	unsigned int		bt_lru_nr;
+	struct list_lru		bt_lru;
 } xfs_buftarg_t;
 
 struct xfs_buf;
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
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

