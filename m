From: akpm@linux-foundation.org
Subject: + xfs-rework-buffer-dispose-list-tracking.patch added to -mm tree
Date: Thu, 06 Jun 2013 14:11:43 -0700
Message-ID: <51b0fb0f.Y8v+mYZedRSg36Ia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3FFVLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + xfs-rework-buffer-dispose-list-tracking.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:11:43 -0700


The patch titled
     Subject: xfs: rework buffer dispose list tracking
has been added to the -mm tree.  Its filename is
     xfs-rework-buffer-dispose-list-tracking.patch

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
Subject: xfs: rework buffer dispose list tracking

In converting the buffer lru lists to use the generic code, the locking
for marking the buffers as on the dispose list was lost.  This results in
confusion in LRU buffer tracking and acocunting, resulting in reference
counts being mucked up and filesystem beig unmountable.

To fix this, introduce an internal buffer spinlock to protect the state
field that holds the dispose list information.  Because there is now
locking needed around xfs_buf_lru_add/del, and they are used in exactly
one place each two lines apart, get rid of the wrappers and code the logic
directly in place.

Further, the LRU emptying code used on unmount is less than optimal. 
Convert it to use a dispose list as per a normal shrinker walk, and repeat
the walk that fills the dispose list until the LRU is empty.  Thi avoids
needing to drop and regain the LRU lock for every item being freed, and
allows the same logic as the shrinker isolate call to be used.  Simpler,
easier to understand.

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

 fs/xfs/xfs_buf.c |  125 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_buf.h |   12 ++--
 2 files changed, 79 insertions(+), 58 deletions(-)

diff -puN fs/xfs/xfs_buf.c~xfs-rework-buffer-dispose-list-tracking fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~xfs-rework-buffer-dispose-list-tracking
+++ a/fs/xfs/xfs_buf.c
@@ -80,37 +80,6 @@ xfs_buf_vmap_len(
 }
 
 /*
- * xfs_buf_lru_add - add a buffer to the LRU.
- *
- * The LRU takes a new reference to the buffer so that it will only be freed
- * once the shrinker takes the buffer off the LRU.
- */
-static void
-xfs_buf_lru_add(
-	struct xfs_buf	*bp)
-{
-	if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
-		bp->b_lru_flags &= ~_XBF_LRU_DISPOSE;
-		atomic_inc(&bp->b_hold);
-	}
-}
-
-/*
- * xfs_buf_lru_del - remove a buffer from the LRU
- *
- * The unlocked check is safe here because it only occurs when there are not
- * b_lru_ref counts left on the inode under the pag->pag_buf_lock. it is there
- * to optimise the shrinker removing the buffer from the LRU and calling
- * xfs_buf_free().
- */
-static void
-xfs_buf_lru_del(
-	struct xfs_buf	*bp)
-{
-	list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
-}
-
-/*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
  * reference count falls to zero. If the buffer is already on the LRU, we need
@@ -133,12 +102,14 @@ xfs_buf_stale(
 	 */
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
-	atomic_set(&(bp)->b_lru_ref, 0);
-	if (!(bp->b_lru_flags & _XBF_LRU_DISPOSE) &&
+	spin_lock(&bp->b_lock);
+	atomic_set(&bp->b_lru_ref, 0);
+	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
 	    (list_lru_del(&bp->b_target->bt_lru, &bp->b_lru)))
 		atomic_dec(&bp->b_hold);
 
 	ASSERT(atomic_read(&bp->b_hold) >= 1);
+	spin_unlock(&bp->b_lock);
 }
 
 static int
@@ -202,6 +173,7 @@ _xfs_buf_alloc(
 	INIT_LIST_HEAD(&bp->b_list);
 	RB_CLEAR_NODE(&bp->b_rbnode);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
+	spin_lock_init(&bp->b_lock);
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_flags = flags;
@@ -891,12 +863,33 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
-		if (!(bp->b_flags & XBF_STALE) &&
-			   atomic_read(&bp->b_lru_ref)) {
-			xfs_buf_lru_add(bp);
+		spin_lock(&bp->b_lock);
+		if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+			/*
+			 * If the buffer is added to the LRU take a new
+			 * reference to the buffer for the LRU and clear the
+			 * (now stale) dispose list state flag
+			 */
+			if (list_lru_add(&bp->b_target->bt_lru, &bp->b_lru)) {
+				bp->b_state &= ~XFS_BSTATE_DISPOSE;
+				atomic_inc(&bp->b_hold);
+			}
+			spin_unlock(&bp->b_lock);
 			spin_unlock(&pag->pag_buf_lock);
 		} else {
-			xfs_buf_lru_del(bp);
+			/*
+			 * most of the time buffers will already be removed from
+			 * the LRU, so optimise that case by checking for the
+			 * XFS_BSTATE_DISPOSE flag indicating the last list the
+			 * buffer was on was the disposal list
+			 */
+			if (!(bp->b_state & XFS_BSTATE_DISPOSE)) {
+				list_lru_del(&bp->b_target->bt_lru, &bp->b_lru);
+			} else {
+				ASSERT(list_empty(&bp->b_lru));
+			}
+			spin_unlock(&bp->b_lock);
+
 			ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 			rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
 			spin_unlock(&pag->pag_buf_lock);
@@ -1484,33 +1477,48 @@ xfs_buftarg_wait_rele(
 
 {
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
+	struct list_head	*dispose = arg;
 
 	if (atomic_read(&bp->b_hold) > 1) {
-		/* need to wait */
+		/* need to wait, so skip it this pass */
 		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
-		spin_unlock(lru_lock);
-		delay(100);
-	} else {
-		/*
-		 * clear the LRU reference count so the buffer doesn't get
-		 * ignored in xfs_buf_rele().
-		 */
-		atomic_set(&bp->b_lru_ref, 0);
-		spin_unlock(lru_lock);
-		xfs_buf_rele(bp);
+		return LRU_SKIP;
 	}
+	if (!spin_trylock(&bp->b_lock))
+		return LRU_SKIP;
 
-	spin_lock(lru_lock);
-	return LRU_RETRY;
+	/*
+	 * clear the LRU reference count so the buffer doesn't get
+	 * ignored in xfs_buf_rele().
+	 */
+	atomic_set(&bp->b_lru_ref, 0);
+	bp->b_state |= XFS_BSTATE_DISPOSE;
+	list_move(item, dispose);
+	spin_unlock(&bp->b_lock);
+	return LRU_REMOVED;
 }
 
 void
 xfs_wait_buftarg(
 	struct xfs_buftarg	*btp)
 {
-	while (list_lru_count(&btp->bt_lru))
+	LIST_HEAD(dispose);
+	int loop = 0;
+
+	/* loop until there is nothing left on the lru list. */
+	while (list_lru_count(&btp->bt_lru)) {
 		list_lru_walk(&btp->bt_lru, xfs_buftarg_wait_rele,
-			      NULL, LONG_MAX);
+			      &dispose, LONG_MAX);
+
+		while (!list_empty(&dispose)) {
+			struct xfs_buf *bp;
+			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
+			list_del_init(&bp->b_lru);
+			xfs_buf_rele(bp);
+		}
+		if (loop++ != 0)
+			delay(100);
+	}
 }
 
 static enum lru_status
@@ -1523,15 +1531,24 @@ xfs_buftarg_isolate(
 	struct list_head	*dispose = arg;
 
 	/*
+	 * we are inverting the lru lock/bp->b_lock here, so use a trylock.
+	 * If we fail to get the lock, just skip it.
+	 */
+	if (!spin_trylock(&bp->b_lock))
+		return LRU_SKIP;
+	/*
 	 * Decrement the b_lru_ref count unless the value is already
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0))
+	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
+	}
 
-	bp->b_lru_flags |= _XBF_LRU_DISPOSE;
+	bp->b_state |= XFS_BSTATE_DISPOSE;
 	list_move(item, dispose);
+	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
 }
 
diff -puN fs/xfs/xfs_buf.h~xfs-rework-buffer-dispose-list-tracking fs/xfs/xfs_buf.h
--- a/fs/xfs/xfs_buf.h~xfs-rework-buffer-dispose-list-tracking
+++ a/fs/xfs/xfs_buf.h
@@ -60,7 +60,6 @@ typedef enum {
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
 #define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
-#define _XBF_LRU_DISPOSE (1 << 24)/* buffer being discarded */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -79,8 +78,12 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }, \
-	{ _XBF_LRU_DISPOSE,	"LRU_DISPOSE" }
+	{ _XBF_COMPOUND,	"COMPOUND" }
+
+/*
+ * Internal state flags.
+ */
+#define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
 
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
@@ -136,7 +139,8 @@ typedef struct xfs_buf {
 	 * bt_lru_lock and not by b_sema
 	 */
 	struct list_head	b_lru;		/* lru list */
-	xfs_buf_flags_t		b_lru_flags;	/* internal lru status flags */
+	spinlock_t		b_lock;		/* internal state lock */
+	unsigned int		b_state;	/* internal state flags */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
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

