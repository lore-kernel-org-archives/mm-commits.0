From: akpm@linux-foundation.org
Subject: - reiser4-fix-write_extent.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:03:57 -0800
Message-ID: <200703060203.l2623wZG008790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46767 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965706AbXCFCEC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix write_extent
has been removed from the -mm tree.  Its filename was
     reiser4-fix-write_extent.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: reiser4: fix write_extent
From: Edward Shishkin <edward@namesys.com>

. Fix reiser4_write_extent():
   1) handling incomplete writes missed in reiser4-temp-fix.patch
   2) bugs in the case of returned errors


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |   64 ++++++++++++---------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-write_extent fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-write_extent
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -941,15 +941,15 @@ static int write_extent_reserve_space(st
  * reiser4_write_extent - write method of extent item plugin
  * @file: file to write to
  * @buf: address of user-space buffer
- * @write_amount: number of bytes to write
- * @off: position in file to write to
+ * @count: number of bytes to write
+ * @pos: position in file to write to
  *
  */
 ssize_t reiser4_write_extent(struct file *file, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	int have_to_update_extent;
-	int nr_pages;
+	int nr_pages, nr_dirty;
 	struct page *page;
 	jnode *jnodes[WRITE_GRANULARITY + 1];
 	struct inode *inode;
@@ -958,7 +958,7 @@ ssize_t reiser4_write_extent(struct file
 	int i;
 	int to_page, page_off;
 	size_t left, written;
-	int result;
+	int result = 0;
 
 	inode = file->f_dentry->d_inode;
 	if (write_extent_reserve_space(inode))
@@ -972,10 +972,12 @@ ssize_t reiser4_write_extent(struct file
 
 	BUG_ON(get_current_context()->trans->atom != NULL);
 
+	left = count;
 	index = *pos >> PAGE_CACHE_SHIFT;
 	/* calculate number of pages which are to be written */
       	end = ((*pos + count - 1) >> PAGE_CACHE_SHIFT);
 	nr_pages = end - index + 1;
+	nr_dirty = 0;
 	assert("", nr_pages <= WRITE_GRANULARITY + 1);
 
 	/* get pages and jnodes */
@@ -983,22 +985,17 @@ ssize_t reiser4_write_extent(struct file
 		page = find_or_create_page(inode->i_mapping, index + i,
 					   reiser4_ctx_gfp_mask_get());
 		if (page == NULL) {
-			while(i --) {
-				unlock_page(jnode_page(jnodes[i]));
-				page_cache_release(jnode_page(jnodes[i]));
-			}
-			return RETERR(-ENOMEM);
+			nr_pages = i;
+			result = RETERR(-ENOMEM);
+			goto out;
 		}
-
 		jnodes[i] = jnode_of_page(page);
 		if (IS_ERR(jnodes[i])) {
 			unlock_page(page);
 			page_cache_release(page);
-			while (i --) {
-				jput(jnodes[i]);
-				page_cache_release(jnode_page(jnodes[i]));
-			}
-			return RETERR(-ENOMEM);
+			nr_pages = i;
+			result = RETERR(-ENOMEM);
+			goto out;
 		}
 		/* prevent jnode and page from disconnecting */
 		JF_SET(jnodes[i], JNODE_WRITE_PREPARED);
@@ -1009,7 +1006,6 @@ ssize_t reiser4_write_extent(struct file
 
 	have_to_update_extent = 0;
 
-	left = count;
 	page_off = (*pos & (PAGE_CACHE_SIZE - 1));
 	for (i = 0; i < nr_pages; i ++) {
 		to_page = PAGE_CACHE_SIZE - page_off;
@@ -1050,14 +1046,26 @@ ssize_t reiser4_write_extent(struct file
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 		}
-
-		written = filemap_copy_from_user(page, page_off, buf, to_page);
+		written = filemap_copy_from_user_atomic(page, page_off, buf,
+							to_page);
+		if (written != to_page)
+			/* Do it the slow way */
+			written = filemap_copy_from_user_nonatomic(page,
+								   page_off,
+								   buf,
+								   to_page);
+		if (unlikely(written != to_page)) {
+			unlock_page(page);
+			result = RETERR(-EFAULT);
+			break;
+		}
 		flush_dcache_page(page);
 		reiser4_set_page_dirty_internal(page);
 		unlock_page(page);
+		nr_dirty ++;
+
 		mark_page_accessed(page);
 		SetPageUptodate(page);
-		page_cache_release(page);
 
 		if (jnodes[i]->blocknr == 0)
 			have_to_update_extent ++;
@@ -1067,27 +1075,29 @@ ssize_t reiser4_write_extent(struct file
 		left -= to_page;
 		BUG_ON(get_current_context()->trans->atom != NULL);
 	}
-
 	if (have_to_update_extent) {
-		update_extents(file, jnodes, nr_pages, *pos);
+		update_extents(file, jnodes, nr_dirty, *pos);
 	} else {
-		for (i = 0; i < nr_pages; i ++) {
+		for (i = 0; i < nr_dirty; i ++) {
+			int ret;
 			spin_lock_jnode(jnodes[i]);
-			result = reiser4_try_capture(jnodes[i],
+			ret = reiser4_try_capture(jnodes[i],
 						     ZNODE_WRITE_LOCK, 0);
-			BUG_ON(result != 0);
+			BUG_ON(ret != 0);
 			jnode_make_dirty_locked(jnodes[i]);
 			spin_unlock_jnode(jnodes[i]);
 		}
 	}
-
+ out:
 	for (i = 0; i < nr_pages; i ++) {
+		page_cache_release(jnode_page(jnodes[i]));
 		JF_CLR(jnodes[i], JNODE_WRITE_PREPARED);
 		jput(jnodes[i]);
 	}
+	/* the only errors handled so far is ENOMEM and
+	   EFAULT on copy_from_user  */
 
-	/* the only error handled so far is EFAULT on copy_from_user  */
-	return (count - left) ? (count - left) : -EFAULT;
+	return (count - left) ? (count - left) : result;
 }
 
 static inline void zero_page(struct page *page)
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
