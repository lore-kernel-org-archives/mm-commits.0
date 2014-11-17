From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-fix-notification-of-groups-with-inode-mount-marks.patch removed
 from -mm tree
Date: Mon, 17 Nov 2014 12:50:55 -0800
Message-ID: <546a5faf.cgnb0x2FPNZAb1PQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaKQUu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix notification of groups with inode & mount marks
has been removed from the -mm tree.  Its filename was
     fanotify-fix-notification-of-groups-with-inode-mount-marks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: fix notification of groups with inode & mount marks

fsnotify() needs to merge inode and mount marks lists when notifying
groups about events so that ignore masks from inode marks are reflected in
mount mark notifications and groups are notified in proper order
(according to priorities).  Currently the sorting of the lists done by
fsnotify_add_inode_mark() / fsnotify_add_vfsmount_mark() and fsnotify()
differed which resulted ignore masks not being used in some cases.

Fix the problem by always using the same comparison function when sorting
/ merging the mark lists.

Thanks to Heinrich Schuchardt for improvements of my patch.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=87721
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Tested-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c      |   36 +++++++++++++++++++++---------------
 fs/notify/fsnotify.h      |    4 ++++
 fs/notify/inode_mark.c    |    8 +++-----
 fs/notify/mark.c          |   36 ++++++++++++++++++++++++++++++++++++
 fs/notify/vfsmount_mark.c |    8 +++-----
 5 files changed, 67 insertions(+), 25 deletions(-)

diff -puN fs/notify/fsnotify.c~fanotify-fix-notification-of-groups-with-inode-mount-marks fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fanotify-fix-notification-of-groups-with-inode-mount-marks
+++ a/fs/notify/fsnotify.c
@@ -229,8 +229,16 @@ int fsnotify(struct inode *to_tell, __u3
 					      &fsnotify_mark_srcu);
 	}
 
+	/*
+	 * We need to merge inode & vfsmount mark lists so that inode mark
+	 * ignore masks are properly reflected for mount mark notifications.
+	 * That's why this traversal is so complicated...
+	 */
 	while (inode_node || vfsmount_node) {
-		inode_group = vfsmount_group = NULL;
+		inode_group = NULL;
+		inode_mark = NULL;
+		vfsmount_group = NULL;
+		vfsmount_mark = NULL;
 
 		if (inode_node) {
 			inode_mark = hlist_entry(srcu_dereference(inode_node, &fsnotify_mark_srcu),
@@ -244,21 +252,19 @@ int fsnotify(struct inode *to_tell, __u3
 			vfsmount_group = vfsmount_mark->group;
 		}
 
-		if (inode_group > vfsmount_group) {
-			/* handle inode */
-			ret = send_to_group(to_tell, inode_mark, NULL, mask,
-					    data, data_is, cookie, file_name);
-			/* we didn't use the vfsmount_mark */
-			vfsmount_group = NULL;
-		} else if (vfsmount_group > inode_group) {
-			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask,
-					    data, data_is, cookie, file_name);
-			inode_group = NULL;
-		} else {
-			ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
-					    mask, data, data_is, cookie,
-					    file_name);
+		if (inode_group && vfsmount_group) {
+			int cmp = fsnotify_compare_groups(inode_group,
+							  vfsmount_group);
+			if (cmp > 0) {
+				inode_group = NULL;
+				inode_mark = NULL;
+			} else if (cmp < 0) {
+				vfsmount_group = NULL;
+				vfsmount_mark = NULL;
+			}
 		}
+		ret = send_to_group(to_tell, inode_mark, vfsmount_mark, mask,
+				    data, data_is, cookie, file_name);
 
 		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
 			goto out;
diff -puN fs/notify/fsnotify.h~fanotify-fix-notification-of-groups-with-inode-mount-marks fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fanotify-fix-notification-of-groups-with-inode-mount-marks
+++ a/fs/notify/fsnotify.h
@@ -12,6 +12,10 @@ extern void fsnotify_flush_notify(struct
 /* protects reads of inode and vfsmount marks list */
 extern struct srcu_struct fsnotify_mark_srcu;
 
+/* compare two groups for sorting of marks lists */
+extern int fsnotify_compare_groups(struct fsnotify_group *a,
+				   struct fsnotify_group *b);
+
 extern void fsnotify_set_inode_mark_mask_locked(struct fsnotify_mark *fsn_mark,
 						__u32 mask);
 /* add a mark to an inode */
diff -puN fs/notify/inode_mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks
+++ a/fs/notify/inode_mark.c
@@ -194,6 +194,7 @@ int fsnotify_add_inode_mark(struct fsnot
 {
 	struct fsnotify_mark *lmark, *last = NULL;
 	int ret = 0;
+	int cmp;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
 
@@ -219,11 +220,8 @@ int fsnotify_add_inode_mark(struct fsnot
 			goto out;
 		}
 
-		if (mark->group->priority < lmark->group->priority)
-			continue;
-
-		if ((mark->group->priority == lmark->group->priority) &&
-		    (mark->group < lmark->group))
+		cmp = fsnotify_compare_groups(lmark->group, mark->group);
+		if (cmp < 0)
 			continue;
 
 		hlist_add_before_rcu(&mark->i.i_list, &lmark->i.i_list);
diff -puN fs/notify/mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks fs/notify/mark.c
--- a/fs/notify/mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks
+++ a/fs/notify/mark.c
@@ -210,6 +210,42 @@ void fsnotify_set_mark_ignored_mask_lock
 }
 
 /*
+ * Sorting function for lists of fsnotify marks.
+ *
+ * Fanotify supports different notification classes (reflected as priority of
+ * notification group). Events shall be passed to notification groups in
+ * decreasing priority order. To achieve this marks in notification lists for
+ * inodes and vfsmounts are sorted so that priorities of corresponding groups
+ * are descending.
+ *
+ * Furthermore correct handling of the ignore mask requires processing inode
+ * and vfsmount marks of each group together. Using the group address as
+ * further sort criterion provides a unique sorting order and thus we can
+ * merge inode and vfsmount lists of marks in linear time and find groups
+ * present in both lists.
+ *
+ * A return value of 1 signifies that b has priority over a.
+ * A return value of 0 signifies that the two marks have to be handled together.
+ * A return value of -1 signifies that a has priority over b.
+ */
+int fsnotify_compare_groups(struct fsnotify_group *a, struct fsnotify_group *b)
+{
+	if (a == b)
+		return 0;
+	if (!a)
+		return 1;
+	if (!b)
+		return -1;
+	if (a->priority < b->priority)
+		return 1;
+	if (a->priority > b->priority)
+		return -1;
+	if (a < b)
+		return 1;
+	return -1;
+}
+
+/*
  * Attach an initialized mark to a given group and fs object.
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group.
diff -puN fs/notify/vfsmount_mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~fanotify-fix-notification-of-groups-with-inode-mount-marks
+++ a/fs/notify/vfsmount_mark.c
@@ -153,6 +153,7 @@ int fsnotify_add_vfsmount_mark(struct fs
 	struct mount *m = real_mount(mnt);
 	struct fsnotify_mark *lmark, *last = NULL;
 	int ret = 0;
+	int cmp;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 
@@ -178,11 +179,8 @@ int fsnotify_add_vfsmount_mark(struct fs
 			goto out;
 		}
 
-		if (mark->group->priority < lmark->group->priority)
-			continue;
-
-		if ((mark->group->priority == lmark->group->priority) &&
-		    (mark->group < lmark->group))
+		cmp = fsnotify_compare_groups(lmark->group, mark->group);
+		if (cmp < 0)
 			continue;
 
 		hlist_add_before_rcu(&mark->m.m_list, &lmark->m.m_list);
_

Patches currently in -mm which might be from jack@suse.cz are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

