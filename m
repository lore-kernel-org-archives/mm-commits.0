From: akpm@linux-foundation.org
Subject: - fs-sync_sb_inodes-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:41 -0800
Message-ID: <200901072214.n07MEfkR014582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761627AbZAGWOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: sync_sb_inodes fix
has been removed from the -mm tree.  Its filename was
     fs-sync_sb_inodes-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: sync_sb_inodes fix
From: Nick Piggin <npiggin@suse.de>

Fix data integrity semantics required by sys_sync, by iterating over all
inodes and waiting for any writeback pages after the initial writeout. 
Comments explain the exact problem.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   60 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff -puN fs/fs-writeback.c~fs-sync_sb_inodes-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-sync_sb_inodes-fix
+++ a/fs/fs-writeback.c
@@ -440,6 +440,7 @@ void generic_sync_sb_inodes(struct super
 				struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
+	int sync = wbc->sync_mode == WB_SYNC_ALL;
 
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
@@ -516,7 +517,49 @@ void generic_sync_sb_inodes(struct super
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
-	spin_unlock(&inode_lock);
+
+	if (sync) {
+		struct inode *inode, *old_inode = NULL;
+
+		/*
+		 * Data integrity sync. Must wait for all pages under writeback,
+		 * because there may have been pages dirtied before our sync
+		 * call, but which had writeout started before we write it out.
+		 * In which case, the inode may not be on the dirty list, but
+		 * we still have to wait for that writeout.
+		 */
+		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+			struct address_space *mapping;
+
+			if (inode->i_state & (I_FREEING|I_WILL_FREE))
+				continue;
+			mapping = inode->i_mapping;
+			if (mapping->nrpages == 0)
+				continue;
+			__iget(inode);
+			spin_unlock(&inode_lock);
+			/*
+			 * We hold a reference to 'inode' so it couldn't have
+			 * been removed from s_inodes list while we dropped the
+			 * inode_lock.  We cannot iput the inode now as we can
+			 * be holding the last reference and we cannot iput it
+			 * under inode_lock. So we keep the reference and iput
+			 * it later.
+			 */
+			iput(old_inode);
+			old_inode = inode;
+
+			filemap_fdatawait(mapping);
+
+			cond_resched();
+
+			spin_lock(&inode_lock);
+		}
+		spin_unlock(&inode_lock);
+		iput(old_inode);
+	} else
+		spin_unlock(&inode_lock);
+
 	return;		/* Leave any unwritten inodes on s_io */
 }
 EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
@@ -596,13 +639,16 @@ void sync_inodes_sb(struct super_block *
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
-	unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
-	unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
 
-	wbc.nr_to_write = nr_dirty + nr_unstable +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
-			nr_dirty + nr_unstable;
-	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
+	if (!wait) {
+		unsigned long nr_dirty = global_page_state(NR_FILE_DIRTY);
+		unsigned long nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+
+		wbc.nr_to_write = nr_dirty + nr_unstable +
+			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+	} else
+		wbc.nr_to_write = LONG_MAX; /* doesn't actually matter */
+
 	sync_sb_inodes(sb, &wbc);
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

