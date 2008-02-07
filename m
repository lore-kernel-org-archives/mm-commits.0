From: akpm@linux-foundation.org
Subject: - inotify-fix-race.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:50 -0800
Message-ID: <200802070023.m170NVq3006528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933128AbYBGAqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jack@ucw.cz, rlove@google.com, ttb@tentacle.dhs.org, yanzheng@21cn.com, mm-commits@vger.kernel.org


The patch titled
     inotify: fix race
has been removed from the -mm tree.  Its filename was
     inotify-fix-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: fix race
From: Nick Piggin <npiggin@suse.de>

There is a race between setting an inode's children's "parent watched" flag
when placing the first watch on a parent, and instantiating new children of
that parent: a child could miss having its flags set by
set_dentry_child_flags, but then inotify_d_instantiate might still see
!inotify_inode_watched.

The solution is to set_dentry_child_flags after adding the watch.  Locking is
taken care of, because both set_dentry_child_flags and inotify_d_instantiate
hold dcache_lock and child->d_locks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: Yan Zheng <yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/inotify.c~inotify-fix-race fs/inotify.c
--- a/fs/inotify.c~inotify-fix-race
+++ a/fs/inotify.c
@@ -627,6 +627,7 @@ s32 inotify_add_watch(struct inotify_han
 		      struct inode *inode, u32 mask)
 {
 	int ret = 0;
+	int newly_watched;
 
 	/* don't allow invalid bits: we don't want flags set */
 	mask &= IN_ALL_EVENTS | IN_ONESHOT;
@@ -653,12 +654,18 @@ s32 inotify_add_watch(struct inotify_han
 	 */
 	watch->inode = igrab(inode);
 
-	if (!inotify_inode_watched(inode))
-		set_dentry_child_flags(inode, 1);
-
 	/* Add the watch to the handle's and the inode's list */
+	newly_watched = !inotify_inode_watched(inode);
 	list_add(&watch->h_list, &ih->watches);
 	list_add(&watch->i_list, &inode->inotify_watches);
+	/*
+	 * Set child flags _after_ adding the watch, so there is no race
+	 * windows where newly instantiated children could miss their parent's
+	 * watched flag.
+	 */
+	if (newly_watched)
+		set_dentry_child_flags(inode, 1);
+
 out:
 	mutex_unlock(&ih->mutex);
 	mutex_unlock(&inode->inotify_mutex);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
