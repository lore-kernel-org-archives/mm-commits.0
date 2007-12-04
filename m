From: akpm@linux-foundation.org
Subject: + inotify-fix-race.patch added to -mm tree
Date: Mon, 03 Dec 2007 21:35:07 -0800
Message-ID: <200712040535.lB45Z7AF002738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbXLDFfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jack@ucw.cz, rlove@google.com, ttb@tentacle.dhs.org, yanzheng@21cn.com


The patch titled
     inotify: fix race
has been added to the -mm tree.  Its filename is
     inotify-fix-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
reiser4.patch
