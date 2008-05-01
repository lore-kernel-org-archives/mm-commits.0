From: akpm@linux-foundation.org
Subject: - reiser4-use-balance_dirty_pages_ratelimited_nr.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:31 -0700
Message-ID: <200805010923.m419NVDR030100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215AbYEAJYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use balance_dirty_pages_ratelimited_nr
has been removed from the -mm tree.  Its filename was
     reiser4-use-balance_dirty_pages_ratelimited_nr.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: use balance_dirty_pages_ratelimited_nr
From: Edward Shishkin <edward.shishkin@gmail.com>

Use balance_dirty_pages_ratelimited_nr() instead of
balance_dirty_pages_ratelimited() for all reiser4 page cluster operations.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/cluster.h            |   12 ++++++++++++
 fs/reiser4/plugin/file/cryptcompress.c |   16 +++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/plugin/cluster.h~reiser4-use-balance_dirty_pages_ratelimited_nr fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-use-balance_dirty_pages_ratelimited_nr
+++ a/fs/reiser4/plugin/cluster.h
@@ -188,6 +188,18 @@ static inline unsigned pbytes(pgoff_t in
 	return __mbp(i_size_read(inode), index);
 }
 
+/**
+ * number of pages occuped by @win->count bytes starting from
+ * @win->off at logical cluster defined by @win. This is exactly
+ * a number of pages to be modified and dirtied in any cluster operation.
+ */
+static inline pgoff_t win_count_to_nrpages(struct reiser4_slide * win)
+{
+	return ((win->off + win->count +
+		 (1UL << PAGE_CACHE_SHIFT) - 1) >> PAGE_CACHE_SHIFT) -
+		off_to_pg(win->off);
+}
+
 /* return true, if logical cluster is not occupied by the file */
 static inline int new_logical_cluster(struct cluster_handle * clust,
 				      struct inode *inode)
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-balance_dirty_pages_ratelimited_nr fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-balance_dirty_pages_ratelimited_nr
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1952,13 +1952,16 @@ static void put_hint_cluster(struct clus
 
 static int balance_dirty_page_cluster(struct cluster_handle * clust,
 				      struct inode *inode, loff_t off,
-				      loff_t to_file)
+				      loff_t to_file,
+				      int nr_dirtied)
 {
 	int result;
 	struct cryptcompress_info * info;
 
 	assert("edward-724", inode != NULL);
 	assert("edward-725", cryptcompress_inode_ok(inode));
+	assert("edward-1547",
+	       nr_dirtied != 0 && nr_dirtied <= cluster_nrpages(inode));
 
 	/* set next window params */
 	move_update_window(inode, clust, off, to_file);
@@ -1970,7 +1973,8 @@ static int balance_dirty_page_cluster(st
 	info = cryptcompress_inode_data(inode);
 
 	mutex_unlock(&info->checkin_mutex);
-	reiser4_throttle_write(inode);
+	reiser4_txn_restart_current();
+	balance_dirty_pages_ratelimited_nr(inode->i_mapping, nr_dirtied);
 	mutex_lock(&info->checkin_mutex);
 	return 0;
 }
@@ -2038,8 +2042,9 @@ static int write_hole(struct inode *inod
 		if (result)
 			return result;
 		put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
-		result =
-		    balance_dirty_page_cluster(clust, inode, file_off, to_file);
+		result = balance_dirty_page_cluster(clust,
+						    inode, file_off, to_file,
+						    win_count_to_nrpages(win));
 	} else
 		move_update_window(inode, clust, file_off, to_file);
 	return result;
@@ -2756,7 +2761,8 @@ static loff_t do_write_cryptcompress(str
 		buf   += win.count;
 		count -= win.count;
 
-		result = balance_dirty_page_cluster(&clust, inode, 0, count);
+		result = balance_dirty_page_cluster(&clust, inode, 0, count,
+						    win_count_to_nrpages(&win));
 		if (result)
 			goto err1;
 		assert("edward-755", hint->lh.owner == NULL);
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch

