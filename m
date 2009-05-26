From: akpm@linux-foundation.org
Subject: [wrecked] fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:39 -0700
Message-ID: <200905261934.n4QJYdif005753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756917AbZEZTez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:34:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fsnotify: fsnotify marks on inodes pin them in core
has been removed from the -mm tree.  Its filename was
     fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

