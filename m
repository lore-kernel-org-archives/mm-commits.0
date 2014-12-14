From: akpm@linux-foundation.org
Subject: [merged] fsnotify-remove-destroy_list-from-fsnotify_mark.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:10:33 -0800
Message-ID: <548d0db9.qZgpBJkydjmnh1iX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaLNEK0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove destroy_list from fsnotify_mark
has been removed from the -mm tree.  Its filename was
     fsnotify-remove-destroy_list-from-fsnotify_mark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: remove destroy_list from fsnotify_mark

destroy_list is used to track marks which still need waiting for srcu
period end before they can be freed.  However by the time mark is added to
destroy_list it isn't in group's list of marks anymore and thus we can
reuse fsnotify_mark->g_list for queueing into destroy_list.  This saves
two pointers for each fsnotify_mark.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c                 |    8 ++++----
 include/linux/fsnotify_backend.h |    7 +++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-remove-destroy_list-from-fsnotify_mark fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-remove-destroy_list-from-fsnotify_mark
+++ a/fs/notify/mark.c
@@ -161,7 +161,7 @@ void fsnotify_destroy_mark_locked(struct
 	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
+	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
 	/*
@@ -370,7 +370,7 @@ err:
 	spin_unlock(&mark->lock);
 
 	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
+	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
 
@@ -469,8 +469,8 @@ static int fsnotify_mark_destroy(void *i
 
 		synchronize_srcu(&fsnotify_mark_srcu);
 
-		list_for_each_entry_safe(mark, next, &private_destroy_list, destroy_list) {
-			list_del_init(&mark->destroy_list);
+		list_for_each_entry_safe(mark, next, &private_destroy_list, g_list) {
+			list_del_init(&mark->g_list);
 			fsnotify_put_mark(mark);
 		}
 
diff -puN include/linux/fsnotify_backend.h~fsnotify-remove-destroy_list-from-fsnotify_mark include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-remove-destroy_list-from-fsnotify_mark
+++ a/include/linux/fsnotify_backend.h
@@ -212,7 +212,11 @@ struct fsnotify_mark {
 	 * in kernel that found and may be using this mark. */
 	atomic_t refcnt;		/* active things looking at this mark */
 	struct fsnotify_group *group;	/* group this mark is for */
-	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks */
+	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks
+					 * Also reused for queueing mark into
+					 * destroy_list when it's waiting for
+					 * the end of SRCU period before it can
+					 * be freed */
 	spinlock_t lock;		/* protect group and inode */
 	struct hlist_node obj_list;	/* list of marks for inode / vfsmount */
 	struct list_head free_list;	/* tmp list used when freeing this mark */
@@ -227,7 +231,6 @@ struct fsnotify_mark {
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
 	unsigned int flags;		/* vfsmount or inode mark? */
-	struct list_head destroy_list;
 	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

