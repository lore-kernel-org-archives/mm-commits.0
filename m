From: akpm@linux-foundation.org
Subject: + fs-avoid-i_new-inodes.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:17:36 -0700
Message-ID: <200903112017.n2BKHaX8031958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbZCKUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     fs: avoid I_NEW inodes
has been added to the -mm tree.  Its filename is
     fs-avoid-i_new-inodes.patch

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
Subject: fs: avoid I_NEW inodes
From: Nick Piggin <npiggin@suse.de>

To be on the safe side, it should be less fragile to exclude I_NEW inodes
from inode list scans by default (unless there is an important reason to
have them).

Normally they will get excluded (eg.  by zero refcount or writecount etc),
however it is a bit fragile for list walkers to know exactly what parts of
the inode state is set up and valid to test when in I_NEW.  So along these
lines, move I_NEW checks upward as well (sometimes taking I_FREEING etc
checks with them too -- this shouldn't be a problem should it?)

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c            |    2 +-
 fs/inode.c                  |    2 ++
 fs/notify/inotify/inotify.c |   16 ++++++++--------
 fs/quota/dquot.c            |   10 ++++++++--
 4 files changed, 19 insertions(+), 11 deletions(-)

diff -puN fs/drop_caches.c~fs-avoid-i_new-inodes fs/drop_caches.c
--- a/fs/drop_caches.c~fs-avoid-i_new-inodes
+++ a/fs/drop_caches.c
@@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
diff -puN fs/inode.c~fs-avoid-i_new-inodes fs/inode.c
--- a/fs/inode.c~fs-avoid-i_new-inodes
+++ a/fs/inode.c
@@ -366,6 +366,8 @@ static int invalidate_list(struct list_h
 		if (tmp == head)
 			break;
 		inode = list_entry(tmp, struct inode, i_sb_list);
+		if (inode->i_state & I_NEW)
+			continue;
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
diff -puN fs/notify/inotify/inotify.c~fs-avoid-i_new-inodes fs/notify/inotify/inotify.c
--- a/fs/notify/inotify/inotify.c~fs-avoid-i_new-inodes
+++ a/fs/notify/inotify/inotify.c
@@ -380,6 +380,14 @@ void inotify_unmount_inodes(struct list_
 		struct list_head *watches;
 
 		/*
+		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING,
+		 * I_WILL_FREE, or I_NEW which is fine because by that point
+		 * the inode cannot have any associated watches.
+		 */
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+			continue;
+
+		/*
 		 * If i_count is zero, the inode cannot have any watches and
 		 * doing an __iget/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
@@ -388,14 +396,6 @@ void inotify_unmount_inodes(struct list_
 		if (!atomic_read(&inode->i_count))
 			continue;
 
-		/*
-		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
-		 * I_WILL_FREE which is fine because by that point the inode
-		 * cannot have any associated watches.
-		 */
-		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
-			continue;
-
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 		/* In case inotify_remove_watch_locked() drops a reference. */
diff -puN fs/quota/dquot.c~fs-avoid-i_new-inodes fs/quota/dquot.c
--- a/fs/quota/dquot.c~fs-avoid-i_new-inodes
+++ a/fs/quota/dquot.c
@@ -823,12 +823,12 @@ static void add_dquot_ref(struct super_b
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+			continue;
 		if (!atomic_read(&inode->i_writecount))
 			continue;
 		if (!dqinit_needed(inode, type))
 			continue;
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
-			continue;
 
 		__iget(inode);
 		spin_unlock(&inode_lock);
@@ -915,6 +915,12 @@ static void remove_dquot_ref(struct supe
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		/*
+		 *  We have to scan also I_NEW inodes because they can already
+		 *  have quota pointer initialized. Luckily, we need to touch
+		 *  only quota pointers and these have separate locking
+		 *  (dqptr_sem).
+		 */
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
_

Patches currently in -mm which might be from npiggin@suse.de are

fs-new-inode-i_state-corruption-fix.patch
linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
fs-avoid-i_new-inodes.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

