From: akpm@linux-foundation.org
Subject: + fs-new-inode-i_state-corruption-fix.patch added to -mm tree
Date: Wed, 04 Mar 2009 23:23:01 -0800
Message-ID: <200903050723.n257N1Oa024200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZCEHX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 02:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ext-adrian.hunter@nokia.com, jack@suse.cz, jorge@dti2.net, stable@kernel.org


The patch titled
     fs: new inode i_state corruption fix
has been added to the -mm tree.  Its filename is
     fs-new-inode-i_state-corruption-fix.patch

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
Subject: fs: new inode i_state corruption fix
From: Nick Piggin <npiggin@suse.de>

There was a report of a data corruption
http://lkml.org/lkml/2008/11/14/121.  There is a script included to
reproduce the problem.

During testing, I encountered a number of strange things with ext3, so I
tried ext2 to attempt to reduce complexity of the problem.  I found that
fsstress would quickly hang in wait_on_inode, waiting for I_LOCK to be
cleared, even though instrumentation showed that unlock_new_inode had
already been called for that inode.  This points to memory scribble, or
synchronisation problme.

i_state of I_NEW inodes is not protected by inode_lock because other
processes are not supposed to touch them until I_LOCK (and I_NEW) is
cleared.  Adding WARN_ON(inode->i_state & I_NEW) to sites where we modify
i_state revealed that generic_sync_sb_inodes is picking up new inodes from
the inode lists and passing them to __writeback_single_inode without
waiting for I_NEW.  Subsequently modifying i_state causes corruption.  In
my case it would look like this:

CPU0                            CPU1
unlock_new_inode()              __sync_single_inode()
 reg <- inode->i_state
 reg -> reg & ~(I_LOCK|I_NEW)   reg <- inode->i_state
 reg -> inode->i_state          reg -> reg | I_SYNC
                                reg -> inode->i_state

Non-atomic RMW on CPU1 overwrites CPU0 store and sets I_LOCK|I_NEW again.

Fix for this is rather than wait for I_NEW inodes, just skip over them:
inodes concurrently being created are not subject to data integrity
operations, and should not significantly contribute to dirty memory
either.

After this change, I'm unable to reproduce any of the added warnings or
hangs after ~1hour of running.  Previously, the new warnings would start
immediately and hang would happen in under 5 minutes.

I'm also testing on ext3 now, and so far no problems there either.  I
don't know whether this fixes the problem reported above, but it fixes a
real problem for me.

Cc: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Reported-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    9 ++++++++-
 fs/inode.c        |    7 +++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~fs-new-inode-i_state-corruption-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-new-inode-i_state-corruption-fix
+++ a/fs/fs-writeback.c
@@ -274,6 +274,7 @@ __sync_single_inode(struct inode *inode,
 	int ret;
 
 	BUG_ON(inode->i_state & I_SYNC);
+	WARN_ON(inode->i_state & I_NEW);
 
 	/* Set I_SYNC, reset I_DIRTY */
 	dirty = inode->i_state & I_DIRTY;
@@ -298,6 +299,7 @@ __sync_single_inode(struct inode *inode,
 	}
 
 	spin_lock(&inode_lock);
+	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
 		if (!(inode->i_state & I_DIRTY) &&
@@ -470,6 +472,11 @@ void generic_sync_sb_inodes(struct super
 			break;
 		}
 
+		if (inode->i_state & I_NEW) {
+			requeue_io(inode);
+			continue;
+		}
+
 		if (wbc->nonblocking && bdi_write_congested(bdi)) {
 			wbc->encountered_congestion = 1;
 			if (!sb_is_blkdev_sb(sb))
@@ -531,7 +538,7 @@ void generic_sync_sb_inodes(struct super
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping;
 
-			if (inode->i_state & (I_FREEING|I_WILL_FREE))
+			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 				continue;
 			mapping = inode->i_mapping;
 			if (mapping->nrpages == 0)
diff -puN fs/inode.c~fs-new-inode-i_state-corruption-fix fs/inode.c
--- a/fs/inode.c~fs-new-inode-i_state-corruption-fix
+++ a/fs/inode.c
@@ -359,6 +359,7 @@ static int invalidate_list(struct list_h
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
+			WARN_ON(inode->i_state & I_NEW);
 			inode->i_state |= I_FREEING;
 			count++;
 			continue;
@@ -460,6 +461,7 @@ static void prune_icache(int nr_to_scan)
 				continue;
 		}
 		list_move(&inode->i_list, &freeable);
+		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_FREEING;
 		nr_pruned++;
 	}
@@ -656,6 +658,7 @@ void unlock_new_inode(struct inode *inod
 	 * just created it (so there can be no old holders
 	 * that haven't tested I_LOCK).
 	 */
+	WARN_ON((inode->i_state & (I_LOCK|I_NEW)) != (I_LOCK|I_NEW));
 	inode->i_state &= ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
 }
@@ -1145,6 +1148,7 @@ void generic_delete_inode(struct inode *
 
 	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
+	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
@@ -1186,16 +1190,19 @@ static void generic_forget_inode(struct 
 			spin_unlock(&inode_lock);
 			return;
 		}
+		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state |= I_WILL_FREE;
 		spin_unlock(&inode_lock);
 		write_inode_now(inode, 1);
 		spin_lock(&inode_lock);
+		WARN_ON(inode->i_state & I_NEW);
 		inode->i_state &= ~I_WILL_FREE;
 		inodes_stat.nr_unused--;
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
 	list_del_init(&inode->i_sb_list);
+	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
 	spin_unlock(&inode_lock);
_

Patches currently in -mm which might be from npiggin@suse.de are

fs-new-inode-i_state-corruption-fix.patch
linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
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

