From: akpm@linux-foundation.org
Subject: + inotify-remove-debug-code.patch added to -mm tree
Date: Mon, 03 Dec 2007 21:35:18 -0800
Message-ID: <200712040535.lB45ZIFe002741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbXLDFfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 00:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jack@ucw.cz, rlove@google.com, ttb@tentacle.dhs.org, yanzheng@21cn.com


The patch titled
     inotify: remove debug code
has been added to the -mm tree.  Its filename is
     inotify-remove-debug-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
