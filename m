From: akpm@linux-foundation.org
Subject: + fsnotify-remove-destroy_list-from-fsnotify_mark.patch added to
 -mm tree
Date: Tue, 11 Nov 2014 14:29:43 -0800
Message-ID: <54628dd7.6U7HL2LQexplRY9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaKKW3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 17:29:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove destroy_list from fsnotify_mark
has been added to the -mm tree.  Its filename is
     fsnotify-remove-destroy_list-from-fsnotify_mark.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-remove-destroy_list-from-fsnotify_mark.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-remove-destroy_list-from-fsnotify_mark.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: remove destroy_list from fsnotify_mark

destroy_list is used to track marks which still need waiting for srcu
period end before they can be freed.  However by the time mark is added to
destroy_list it isn't in group's list of marks anymore and thus we can
reuse fsnotify_mark->g_list for queueing into destroy_list.  This saves
two pointers for each fsnotify_mark.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c                 |    8 ++++----
 include/linux/fsnotify_backend.h |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-remove-destroy_list-from-fsnotify_mark fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-remove-destroy_list-from-fsnotify_mark
+++ a/fs/notify/mark.c
@@ -150,7 +150,7 @@ void fsnotify_destroy_mark_locked(struct
 	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
+	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
 	/*
@@ -360,7 +360,7 @@ err:
 	spin_unlock(&mark->lock);
 
 	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
+	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
 
@@ -459,8 +459,8 @@ static int fsnotify_mark_destroy(void *i
 
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
@@ -226,7 +226,6 @@ struct fsnotify_mark {
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
 	unsigned int flags;		/* vfsmount or inode mark? */
-	struct list_head destroy_list;
 	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
 
_

Patches currently in -mm which might be from jack@suse.cz are

fanotify-fix-notification-of-groups-with-inode-mount-marks.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-free_list-list_head-from-fsnotify_mark.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
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
mm-add-strictlimit-knob-v2.patch

