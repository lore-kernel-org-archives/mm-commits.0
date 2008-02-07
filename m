From: akpm@linux-foundation.org
Subject: - inotify-remove-debug-code.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:52 -0800
Message-ID: <200802070023.m170NX0V006532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935157AbYBGAqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jack@ucw.cz, rlove@google.com, ttb@tentacle.dhs.org, yanzheng@21cn.com, mm-commits@vger.kernel.org


The patch titled
     inotify: remove debug code
has been removed from the -mm tree.  Its filename was
     inotify-remove-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: remove debug code
From: Nick Piggin <npiggin@suse.de>

The inotify debugging code is supposed to verify that the
DCACHE_INOTIFY_PARENT_WATCHED scalability optimisation does not result in
notifications getting lost nor extra needless locking generated.

Unfortunately there are also some races in the debugging code.  And it isn't
very good at finding problems anyway.  So remove it for now.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: Yan Zheng <yanzheng@21cn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c  |    3 ---
 fs/inotify.c |   17 +++++------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff -puN fs/dcache.c~inotify-remove-debug-code fs/dcache.c
--- a/fs/dcache.c~inotify-remove-debug-code
+++ a/fs/dcache.c
@@ -1408,9 +1408,6 @@ void d_delete(struct dentry * dentry)
 	if (atomic_read(&dentry->d_count) == 1) {
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
-
-		/* remove this and other inotify debug checks after 2.6.18 */
-		dentry->d_flags &= ~DCACHE_INOTIFY_PARENT_WATCHED;
 		return;
 	}
 
diff -puN fs/inotify.c~inotify-remove-debug-code fs/inotify.c
--- a/fs/inotify.c~inotify-remove-debug-code
+++ a/fs/inotify.c
@@ -168,20 +168,14 @@ static void set_dentry_child_flags(struc
 		struct dentry *child;
 
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
-			if (!child->d_inode) {
-				WARN_ON(child->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
+			if (!child->d_inode)
 				continue;
-			}
+
 			spin_lock(&child->d_lock);
-			if (watched) {
-				WARN_ON(child->d_flags &
-						DCACHE_INOTIFY_PARENT_WATCHED);
+			if (watched)
 				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
-			} else {
-				WARN_ON(!(child->d_flags &
-					DCACHE_INOTIFY_PARENT_WATCHED));
-				child->d_flags&=~DCACHE_INOTIFY_PARENT_WATCHED;
-			}
+			else
+				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
 	}
@@ -253,7 +247,6 @@ void inotify_d_instantiate(struct dentry
 	if (!inode)
 		return;
 
-	WARN_ON(entry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED);
 	spin_lock(&entry->d_lock);
 	parent = entry->d_parent;
 	if (parent->d_inode && inotify_inode_watched(parent->d_inode))
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
