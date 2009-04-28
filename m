From: akpm@linux-foundation.org
Subject: + fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:19 -0700
Message-ID: <200904282028.n3SKSKjY021233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbZD1UcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: fsnotify marks on inodes pin them in core
has been added to the -mm tree.  Its filename is
     fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: fsnotify marks on inodes pin them in core
From: Eric Paris <eparis@redhat.com>

This patch pins any inodes with an fsnotify mark in core.  The idea is
that as soon as the mark is removed from the inode->fsnotify_mark_entries
list the inode will be iput.  In reality is doesn't quite work exactly
this way.  The igrab will happen when the mark is added to an inode, but
the iput will happen when the inode pointer is NULL'd inside the mark.

It's possible that 2 racing things will try to remove the mark from
explicit request and one might try to remove it because the inode was
deleted.  It's possible that the removal because of inode deletion will
remove the mark from the inode's list, but the removal by explicit request
will actually set entry->inode == NULL; and call the iput.  This is safe.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inode_mark.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/notify/inode_mark.c~fsnotify-fsnotify-marks-on-inodes-pin-them-in-core fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-fsnotify-marks-on-inodes-pin-them-in-core
+++ a/fs/notify/inode_mark.c
@@ -204,6 +204,8 @@ void fsnotify_destroy_mark_by_entry(stru
 	 */
 
 
+	iput(inode);
+
 	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
@@ -306,6 +308,10 @@ int fsnotify_add_mark(struct fsnotify_ma
 	struct fsnotify_mark_entry *lentry;
 	int ret = 0;
 
+	inode = igrab(inode);
+	if (unlikely(!inode))
+		return -EINVAL;
+
 	/*
 	 * LOCKING ORDER!!!!
 	 * entry->lock
@@ -337,6 +343,7 @@ int fsnotify_add_mark(struct fsnotify_ma
 
 	if (lentry) {
 		ret = -EEXIST;
+		iput(inode);
 		fsnotify_put_mark(lentry);
 	} else {
 		__fsnotify_update_child_dentry_flags(inode);
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
mutex-add-atomic_dec_and_mutex_lock.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

