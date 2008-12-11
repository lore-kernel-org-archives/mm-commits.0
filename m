From: akpm@linux-foundation.org
Subject: + fs-sync_sb_inodes-fix.patch added to -mm tree
Date: Thu, 11 Dec 2008 13:07:30 -0800
Message-ID: <200812112107.mBBL7UM8018187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756747AbYLKVHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 16:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: sync_sb_inodes fix
has been added to the -mm tree.  Its filename is
     fs-sync_sb_inodes-fix.patch

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

linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-direct-io-starvation-improvement.patch
fs-remove-wb_sync_hold.patch
fs-sync_sb_inodes-fix.patch
fs-sys_sync-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-fsync-livelock-avoidance.patch
reiser4.patch

