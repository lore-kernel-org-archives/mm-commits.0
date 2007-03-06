From: akpm@linux-foundation.org
Subject: - reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:03:13 -0800
Message-ID: <200703060203.l2623E7e008774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXCFCDT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: update comments, fix write and truncate cryptcompress
has been removed from the -mm tree.  Its filename was
     reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: update comments, fix write and truncate cryptcompress
From: Edward Shishkin <edward@namesys.com>

. Addressing the following todo items:
  1) akpm wrote: <wonders what formatted and unformatted nodes
     are> A brief glossary might help.
  2) akpm wrote:  reiser4_invalidate_pages() is a mix of reiser4
     things and of things-which-the-vfs-is-supposed-to-do. It is
     uncommented and I am unable to work out why it was necessary
     to do this, and hence what we can do about it.
. Update comments in page_cache.c
. Fix missed modifications performed by generic_write_checks()
. Fix missed unmap_mapping_range() when truncating a cryptcompress
  file

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/page_cache.c                |   99 ++++++++++++++---------
 fs/reiser4/plugin/cluster.h            |    3 
 fs/reiser4/plugin/file/cryptcompress.c |   69 ++++------------
 fs/reiser4/plugin/item/ctail.c         |    3 
 4 files changed, 89 insertions(+), 85 deletions(-)

diff -puN fs/reiser4/page_cache.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress
+++ a/fs/reiser4/page_cache.c
@@ -2,6 +2,26 @@
  * reiser4/README */
 
 /* Memory pressure hooks. Fake inodes handling. */
+
+/*   GLOSSARY
+
+   . Formatted and unformatted nodes.
+     Elements of reiser4 balanced tree to store data and metadata.
+     Unformatted nodes are pointed to by extent pointers. Such nodes
+     are used to store data of large objects. Unlike unformatted nodes,
+     formatted ones have associated format described by node4X plugin.
+
+   . Jnode (or journal node)
+     The in-memory header which is used to track formatted and unformatted
+     nodes, bitmap nodes, etc. In particular, jnodes are used to track
+     transactional information associated with each block(see reiser4/jnode.c
+     for details).
+
+   . Znode
+     The in-memory header which is used to track formatted nodes. Contains
+     embedded jnode (see reiser4/znode.c for details).
+*/
+
 /* We store all file system meta data (and data, of course) in the page cache.
 
    What does this mean? In stead of using bread/brelse we create special
@@ -32,8 +52,8 @@
    1. when jnode-to-page mapping is established (by jnode_attach_page()), page
    reference counter is increased.
 
-   2. when jnode-to-page mapping is destroyed (by jnode_detach_page() and
-   page_detach_jnode()), page reference counter is decreased.
+   2. when jnode-to-page mapping is destroyed (by page_clear_jnode(), page
+   reference counter is decreased.
 
    3. on jload() reference counter on jnode page is increased, page is
    kmapped and `referenced'.
@@ -592,37 +612,9 @@ void reiser4_drop_page(struct page *page
 	unlock_page(page);
 }
 
-/* this is called by truncate_jnodes_range which in its turn is always called
-   after truncate_mapping_pages_range. Therefore, here jnode can not have
-   page. New pages can not be created because truncate_jnodes_range goes under
-   exclusive access on file obtained, where as new page creation requires
-   non-exclusive access obtained */
-static void invalidate_unformatted(jnode * node)
-{
-	struct page *page;
-
-	spin_lock_jnode(node);
-	page = node->pg;
-	if (page) {
-		loff_t from, to;
-
-		page_cache_get(page);
-		spin_unlock_jnode(node);
-		/* FIXME: use truncate_complete_page instead */
-		from = page_offset(page);
-		to = from + PAGE_CACHE_SIZE - 1;
-		truncate_inode_pages_range(page->mapping, from, to);
-		page_cache_release(page);
-	} else {
-		JF_SET(node, JNODE_HEARD_BANSHEE);
-		reiser4_uncapture_jnode(node);
-		unhash_unformatted_jnode(node);
-	}
-}
-
 #define JNODE_GANG_SIZE (16)
 
-/* find all eflushed jnodes from range specified and invalidate them */
+/* find all jnodes from range specified and invalidate them */
 static int
 truncate_jnodes_range(struct inode *inode, pgoff_t from, pgoff_t count)
 {
@@ -632,6 +624,14 @@ truncate_jnodes_range(struct inode *inod
 	unsigned long index;
 	unsigned long end;
 
+	if (inode_file_plugin(inode) ==
+	    file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID))
+		/* No need to get rid of jnodes here: if the single jnode of
+		   page cluster did not have page, then it was found and killed
+		   before in
+		   truncate_page_cluster_cryptcompress()->jput()->jput_final(),
+		   otherwise it will be dropped by reiser4_invalidatepage() */
+		return 0;
 	truncated_jnodes = 0;
 
 	info = reiser4_inode_data(inode);
@@ -666,7 +666,18 @@ truncate_jnodes_range(struct inode *inod
 			node = gang[i];
 			if (node != NULL) {
 				index = max(index, index_jnode(node));
-				invalidate_unformatted(node);
+				spin_lock_jnode(node);
+				assert("edward-1457", node->pg == NULL);
+				/* this is always called after
+				   truncate_inode_pages_range(). Therefore, here
+				   jnode can not have page. New pages can not be
+				   created because truncate_jnodes_range goes
+				   under exclusive access on file obtained,
+				   where as new page creation requires
+				   non-exclusive access obtained */
+				JF_SET(node, JNODE_HEARD_BANSHEE);
+				reiser4_uncapture_jnode(node);
+				unhash_unformatted_jnode(node);
 				truncated_jnodes++;
 				jput(node);
 			} else
@@ -678,9 +689,27 @@ truncate_jnodes_range(struct inode *inod
 	return truncated_jnodes;
 }
 
-void
-reiser4_invalidate_pages(struct address_space *mapping, pgoff_t from,
-			 unsigned long count, int even_cows)
+/* Truncating files in reiser4: problems and solutions.
+
+   VFS calls fs's truncate after it has called truncate_inode_pages()
+   to get rid of pages corresponding to part of file being truncated.
+   In reiser4 it may cause existence of unallocated extents which do
+   not have jnodes. Flush code does not expect that. Solution of this
+   problem is straightforward. As vfs's truncate is implemented using
+   setattr operation, it seems reasonable to have ->setattr() that
+   will cut file body. However, flush code also does not expect dirty
+   pages without parent items, so it is impossible to cut all items,
+   then truncate all pages in two steps. We resolve this problem by
+   cutting items one-by-one. Each such fine-grained step performed
+   under longterm znode lock calls at the end ->kill_hook() method of
+   a killed item to remove its binded pages and jnodes.
+
+   The following function is a common part of mentioned kill hooks.
+   Also, this is called before tail-to-extent conversion (to not manage
+   few copies of the data).
+*/
+void reiser4_invalidate_pages(struct address_space *mapping, pgoff_t from,
+			      unsigned long count, int even_cows)
 {
 	loff_t from_bytes, count_bytes;
 
diff -puN fs/reiser4/plugin/cluster.h~reiser4-update-comments-fix-write-and-truncate-cryptcompress fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-update-comments-fix-write-and-truncate-cryptcompress
+++ a/fs/reiser4/plugin/cluster.h
@@ -261,7 +261,8 @@ int find_disk_cluster(reiser4_cluster_t 
 		      znode_lock_mode mode);
 int flush_cluster_pages(reiser4_cluster_t *, jnode *, struct inode *);
 int reiser4_deflate_cluster(reiser4_cluster_t *, struct inode *);
-void truncate_page_cluster(struct inode *inode, cloff_t start);
+void truncate_page_cluster_cryptcompress(struct inode *inode, cloff_t start,
+					 int even_cows);
 void invalidate_hint_cluster(reiser4_cluster_t * clust);
 void put_hint_cluster(reiser4_cluster_t * clust, struct inode *inode,
 		      znode_lock_mode mode);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2365,25 +2365,10 @@ prepare_page_cluster(struct inode *inode
 		grab_cluster_pages(inode, clust));
 }
 
-static void __truncate_page_cluster(struct inode * inode, cloff_t index)
-{
-	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS) &&
-	    index == 0)
-		return;
-	truncate_inode_pages_range(inode->i_mapping,
-				   clust_to_off(index, inode),
-				   clust_to_off(index,
-						inode) +
-				   inode_cluster_size(inode) - 1);
-	assert("edward-1201",
-	       ergo(!reiser4_inode_get_flag(inode,
-					    REISER4_FILE_CONV_IN_PROGRESS),
-		    jnode_truncate_ok(inode, index)));
-}
-
 /* Truncate all pages of the cluster of index @index.
    This is called by ->kill_hook() method of item plugin */
-void truncate_page_cluster(struct inode *inode, cloff_t index)
+void truncate_page_cluster_cryptcompress(struct inode *inode, cloff_t index,
+					 int even_cows)
 {
 	int i;
 	int found = 0;
@@ -2443,7 +2428,17 @@ void truncate_page_cluster(struct inode 
 	/* put pages found here */
 	forget_cluster_pages(pages, found);
  truncate:
-	__truncate_page_cluster(inode, index);
+	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS) &&
+	    index == 0)
+		return;
+	reiser4_invalidate_pages(inode->i_mapping,
+				 clust_to_pg(index, inode),
+				 cluster_nrpages(inode),
+				 even_cows);
+	assert("edward-1201",
+	       ergo(!reiser4_inode_get_flag(inode,
+					    REISER4_FILE_CONV_IN_PROGRESS),
+		    jnode_truncate_ok(inode, index)));
 	return;
 }
 
@@ -2777,7 +2772,7 @@ write_cryptcompress_flow(struct file *fi
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
 			    size_t count, loff_t *off, int *conv)
 {
-	ssize_t result = 0;
+	ssize_t result;
 	struct inode *inode;
 	reiser4_context *ctx;
   	loff_t pos = *off;
@@ -2796,23 +2791,22 @@ ssize_t write_cryptcompress(struct file 
 
   	down(&reiser4_inode_data(inode)->mutex_write);
 
-	result = generic_write_checks(file, off, &count, 0);
+	result = generic_write_checks(file, &pos, &count, 0);
   	if (unlikely(result != 0))
-		goto unlock;
+		goto out;
   	if (unlikely(count == 0))
-		goto unlock;
-
+		goto out;
 	down_write(&info->lock);
 	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
   	if (*conv == 0)
   		up_write(&info->lock);
- unlock:
-  	up(&reiser4_inode_data(inode)->mutex_write);
+
   	if (result < 0)
 		goto out;
   	/* update position in a file */
   	*off = pos + result;
  out:
+	up(&reiser4_inode_data(inode)->mutex_write);
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
 	return result;
@@ -3678,9 +3672,8 @@ int delete_object_cryptcompress(struct i
 }
 
 /* plugin->u.file.setattr method
-   see plugin.h for description */
-int setattr_cryptcompress(struct dentry *dentry,	/* Object to change attributes */
-			  struct iattr *attr /* change description */ )
+   This implements actual truncate (see comments in reiser4/page_cache.c) */
+int setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
 {
 	int result;
 	struct inode *inode;
@@ -3690,26 +3683,6 @@ int setattr_cryptcompress(struct dentry 
 	if (result)
 		return result;
 	if (attr->ia_valid & ATTR_SIZE) {
-		/* EDWARD-FIXME-HANS: VS-FIXME-HANS:
-		   Q: this case occurs when? truncate?
-		   A: yes
-
-		   Q: If so, why isn't this code in truncate itself instead of here?
-
-		   A: because vfs calls fs's truncate after it has called truncate_inode_pages to get rid of pages
-		   corresponding to part of file being truncated. In reiser4 it may cause existence of unallocated
-		   extents which do not have jnodes. Flush code does not expect that. Solution of this problem is
-		   straightforward. As vfs's truncate is implemented using setattr operation (common implementaion of
-		   which calls truncate_inode_pages and fs's truncate in case when size of file changes) - it seems
-		   reasonable to have reiser4_setattr which will take care of removing pages, jnodes and extents
-		   simultaneously in case of truncate.
-		   Q: do you think implementing truncate using setattr is ugly,
-		   and vfs needs improving, or is there some sense in which this is a good design?
-
-		   A: VS-FIXME-HANS:
-		 */
-
-		/* truncate does reservation itself and requires exclusive access obtained */
 		if (inode->i_size != attr->ia_size) {
 			reiser4_context *ctx;
 			loff_t old_size;
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-update-comments-fix-write-and-truncate-cryptcompress
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -372,7 +372,8 @@ kill_hook_ctail(const coord_t * coord, p
 			/* disk cluster is killed */
 			cloff_t start =
 			    off_to_clust(get_key_offset(&key), inode);
-			truncate_page_cluster(inode, start);
+			truncate_page_cluster_cryptcompress(inode, start,
+							kdata->params.truncate);
 			inode_sub_bytes(inode, inode_cluster_size(inode));
 		}
 	}
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
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
