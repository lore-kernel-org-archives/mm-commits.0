From: akpm@linux-foundation.org
Subject: [merged] writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:56:50 -0800
Message-ID: <20121212195650.CAD5A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:34386 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2LLT4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:56:51 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so117327yen.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:56:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, fengguang.wu@intel.com, vtrivedi018@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: remove nr_pages_dirtied arg from balance_dirty_pages_ratelimited_nr()
has been removed from the -mm tree.  Its filename was
     writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: writeback: remove nr_pages_dirtied arg from balance_dirty_pages_ratelimited_nr()

There is no reason to pass the nr_pages_dirtied argument, because
nr_pages_dirtied value from the caller is unused in
balance_dirty_pages_ratelimited_nr().

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c        |    8 ++++----
 fs/btrfs/file.c           |    3 +--
 fs/btrfs/ioctl.c          |    2 +-
 fs/ocfs2/file.c           |    5 +----
 fs/splice.c               |    5 +----
 include/linux/writeback.h |    9 +--------
 mm/page-writeback.c       |   11 +++++------
 7 files changed, 14 insertions(+), 29 deletions(-)

diff -puN fs/btrfs/disk-io.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/fs/btrfs/disk-io.c
@@ -3416,8 +3416,8 @@ void btrfs_btree_balance_dirty(struct bt
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
 	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
+		balance_dirty_pages_ratelimited(
+				   root->fs_info->btree_inode->i_mapping);
 	}
 	return;
 }
@@ -3437,8 +3437,8 @@ void __btrfs_btree_balance_dirty(struct 
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
 	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
+		balance_dirty_pages_ratelimited(
+				   root->fs_info->btree_inode->i_mapping);
 	}
 	return;
 }
diff -puN fs/btrfs/file.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr fs/btrfs/file.c
--- a/fs/btrfs/file.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/fs/btrfs/file.c
@@ -1346,8 +1346,7 @@ static noinline ssize_t __btrfs_buffered
 
 		cond_resched();
 
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-						   dirty_pages);
+		balance_dirty_pages_ratelimited(inode->i_mapping);
 		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
 			btrfs_btree_balance_dirty(root, 1);
 
diff -puN fs/btrfs/ioctl.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/fs/btrfs/ioctl.c
@@ -1225,7 +1225,7 @@ int btrfs_defrag_file(struct inode *inod
 		}
 
 		defrag_count += ret;
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping, ret);
+		balance_dirty_pages_ratelimited(inode->i_mapping);
 		mutex_unlock(&inode->i_mutex);
 
 		if (newer_than) {
diff -puN fs/ocfs2/file.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/fs/ocfs2/file.c
@@ -2513,18 +2513,15 @@ static ssize_t ocfs2_file_splice_write(s
 		ret = sd.num_spliced;
 
 	if (ret > 0) {
-		unsigned long nr_pages;
 		int err;
 
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
 		err = generic_write_sync(out, *ppos, ret);
 		if (err)
 			ret = err;
 		else
 			*ppos += ret;
 
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	return ret;
diff -puN fs/splice.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr fs/splice.c
--- a/fs/splice.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/fs/splice.c
@@ -1024,17 +1024,14 @@ generic_file_splice_write(struct pipe_in
 		ret = sd.num_spliced;
 
 	if (ret > 0) {
-		unsigned long nr_pages;
 		int err;
 
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
 		err = generic_write_sync(out, *ppos, ret);
 		if (err)
 			ret = err;
 		else
 			*ppos += ret;
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+		balance_dirty_pages_ratelimited(mapping);
 	}
 	sb_end_write(inode->i_sb);
 
diff -puN include/linux/writeback.h~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/include/linux/writeback.h
@@ -161,14 +161,7 @@ void __bdi_update_bandwidth(struct backi
 			    unsigned long start_time);
 
 void page_writeback_init(void);
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied);
-
-static inline void
-balance_dirty_pages_ratelimited(struct address_space *mapping)
-{
-	balance_dirty_pages_ratelimited_nr(mapping, 1);
-}
+void balance_dirty_pages_ratelimited(struct address_space *mapping);
 
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
diff -puN mm/page-writeback.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr
+++ a/mm/page-writeback.c
@@ -1069,7 +1069,7 @@ static void bdi_update_bandwidth(struct 
 }
 
 /*
- * After a task dirtied this many pages, balance_dirty_pages_ratelimited_nr()
+ * After a task dirtied this many pages, balance_dirty_pages_ratelimited()
  * will look to see if it needs to start dirty throttling.
  *
  * If dirty_poll_interval is too low, big NUMA machines will call the expensive
@@ -1436,9 +1436,8 @@ static DEFINE_PER_CPU(int, bdp_ratelimit
 DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
 
 /**
- * balance_dirty_pages_ratelimited_nr - balance dirty memory state
+ * balance_dirty_pages_ratelimited - balance dirty memory state
  * @mapping: address_space which was dirtied
- * @nr_pages_dirtied: number of pages which the caller has just dirtied
  *
  * Processes which are dirtying memory should call in here once for each page
  * which was newly dirtied.  The function will periodically check the system's
@@ -1449,8 +1448,7 @@ DEFINE_PER_CPU(int, dirty_throttle_leaks
  * limit we decrease the ratelimiting by a lot, to prevent individual processes
  * from overshooting the limit by (ratelimit_pages) each.
  */
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied)
+void balance_dirty_pages_ratelimited(struct address_space *mapping)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ratelimit;
@@ -1484,6 +1482,7 @@ void balance_dirty_pages_ratelimited_nr(
 	 */
 	p = &__get_cpu_var(dirty_throttle_leaks);
 	if (*p > 0 && current->nr_dirtied < ratelimit) {
+		unsigned long nr_pages_dirtied;
 		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
 		*p -= nr_pages_dirtied;
 		current->nr_dirtied += nr_pages_dirtied;
@@ -1493,7 +1492,7 @@ void balance_dirty_pages_ratelimited_nr(
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		balance_dirty_pages(mapping, current->nr_dirtied);
 }
-EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
+EXPORT_SYMBOL(balance_dirty_pages_ratelimited);
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
fat-notify-when-discard-is-not-supported.patch

