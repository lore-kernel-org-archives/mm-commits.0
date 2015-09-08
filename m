From: akpm@linux-foundation.org
Subject: [merged] fsnotify-document-mark-locking.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 11:01:36 -0700
Message-ID: <55ef2280.cU2ljvQx7j7mOB/b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: document mark locking
has been removed from the -mm tree.  Its filename was
     fsnotify-document-mark-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fsnotify: document mark locking

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fsnotify_backend.h |   50 +++++++++++++++++------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff -puN include/linux/fsnotify_backend.h~fsnotify-document-mark-locking include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-document-mark-locking
+++ a/include/linux/fsnotify_backend.h
@@ -195,40 +195,50 @@ struct fsnotify_group {
 #define FSNOTIFY_EVENT_INODE	2
 
 /*
- * a mark is simply an object attached to an in core inode which allows an
+ * A mark is simply an object attached to an in core inode which allows an
  * fsnotify listener to indicate they are either no longer interested in events
  * of a type matching mask or only interested in those events.
  *
- * these are flushed when an inode is evicted from core and may be flushed
- * when the inode is modified (as seen by fsnotify_access).  Some fsnotify users
- * (such as dnotify) will flush these when the open fd is closed and not at
- * inode eviction or modification.
+ * These are flushed when an inode is evicted from core and may be flushed
+ * when the inode is modified (as seen by fsnotify_access).  Some fsnotify
+ * users (such as dnotify) will flush these when the open fd is closed and not
+ * at inode eviction or modification.
+ *
+ * Text in brackets is showing the lock(s) protecting modifications of a
+ * particular entry. obj_lock means either inode->i_lock or
+ * mnt->mnt_root->d_lock depending on the mark type.
  */
 struct fsnotify_mark {
-	__u32 mask;			/* mask this mark is for */
-	/* we hold ref for each i_list and g_list.  also one ref for each 'thing'
+	/* Mask this mark is for [mark->lock, group->mark_mutex] */
+	__u32 mask;
+	/* We hold one for presence in g_list. Also one ref for each 'thing'
 	 * in kernel that found and may be using this mark. */
-	atomic_t refcnt;		/* active things looking at this mark */
-	struct fsnotify_group *group;	/* group this mark is for */
-	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks
-					 * Also reused for queueing mark into
-					 * destroy_list when it's waiting for
-					 * the end of SRCU period before it can
-					 * be freed */
-	spinlock_t lock;		/* protect group and inode */
-	struct hlist_node obj_list;	/* list of marks for inode / vfsmount */
-	struct list_head free_list;	/* tmp list used when freeing this mark */
-	union {
+	atomic_t refcnt;
+	/* Group this mark is for. Set on mark creation, stable until last ref
+	 * is dropped */
+	struct fsnotify_group *group;
+	/* List of marks by group->i_fsnotify_marks. Also reused for queueing
+	 * mark into destroy_list when it's waiting for the end of SRCU period
+	 * before it can be freed. [group->mark_mutex] */
+	struct list_head g_list;
+	/* Protects inode / mnt pointers, flags, masks */
+	spinlock_t lock;
+	/* List of marks for inode / vfsmount [obj_lock] */
+	struct hlist_node obj_list;
+	/* tmp list used when freeing this mark */
+	struct list_head free_list;
+	union {	/* Object pointer [mark->lock, group->mark_mutex] */
 		struct inode *inode;	/* inode this mark is associated with */
 		struct vfsmount *mnt;	/* vfsmount this mark is associated with */
 	};
-	__u32 ignored_mask;		/* events types to ignore */
+	/* Events types to ignore [mark->lock, group->mark_mutex] */
+	__u32 ignored_mask;
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT		0x02
 #define FSNOTIFY_MARK_FLAG_OBJECT_PINNED	0x04
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
-	unsigned int flags;		/* vfsmount or inode mark? */
+	unsigned int flags;		/* flags [mark->lock] */
 	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
 
_

Patches currently in -mm which might be from jack@suse.com are


