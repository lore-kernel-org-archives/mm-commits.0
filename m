From: akpm@linux-foundation.org
Subject: - gfs2-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:39 -0700
Message-ID: <200710162032.l9GKWdOo014620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966199AbXJPVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swhiteho@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     gfs2: convert to new aops
has been removed from the -mm tree.  Its filename was
     gfs2-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gfs2: convert to new aops
From: Steven Whitehouse <swhiteho@redhat.com>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_address.c |  211 ++++++++++++++++++++++++----------------
 1 file changed, 127 insertions(+), 84 deletions(-)

diff -puN fs/gfs2/ops_address.c~gfs2-convert-to-new-aops fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~gfs2-convert-to-new-aops
+++ a/fs/gfs2/ops_address.c
@@ -17,6 +17,7 @@
 #include <linux/mpage.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
+#include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
 
@@ -349,45 +350,49 @@ out_unlock:
 }
 
 /**
- * gfs2_prepare_write - Prepare to write a page to a file
+ * gfs2_write_begin - Begin to write to a file
  * @file: The file to write to
- * @page: The page which is to be prepared for writing
- * @from: From (byte range within page)
- * @to: To (byte range within page)
+ * @mapping: The mapping in which to write
+ * @pos: The file offset at which to start writing
+ * @len: Length of the write
+ * @flags: Various flags
+ * @pagep: Pointer to return the page
+ * @fsdata: Pointer to return fs data (unused by GFS2)
  *
  * Returns: errno
  */
 
-static int gfs2_prepare_write(struct file *file, struct page *page,
-			      unsigned from, unsigned to)
+static int gfs2_write_begin(struct file *file, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata)
 {
-	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
-	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(mapping->host);
 	unsigned int data_blocks, ind_blocks, rblocks;
 	int alloc_required;
 	int error = 0;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + from;
-	loff_t end = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 	struct gfs2_alloc *al;
-	unsigned int write_len = to - from;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + len;
+	struct page *page;
 
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_ATIME|LM_FLAG_TRY_1CB, &ip->i_gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_ATIME, &ip->i_gh);
 	error = gfs2_glock_nq_atime(&ip->i_gh);
-	if (unlikely(error)) {
-		if (error == GLR_TRYFAILED) {
-			unlock_page(page);
-			error = AOP_TRUNCATED_PAGE;
-			yield();
-		}
+	if (unlikely(error))
 		goto out_uninit;
-	}
 
-	gfs2_write_calc_reserv(ip, write_len, &data_blocks, &ind_blocks);
+	error = -ENOMEM;
+	page = __grab_cache_page(mapping, index);
+	*pagep = page;
+	if (!page)
+		goto out_unlock;
+
+	gfs2_write_calc_reserv(ip, len, &data_blocks, &ind_blocks);
 
-	error = gfs2_write_alloc_required(ip, pos, write_len, &alloc_required);
+	error = gfs2_write_alloc_required(ip, pos, len, &alloc_required);
 	if (error)
-		goto out_unlock;
+		goto out_putpage;
 
 
 	ip->i_alloc.al_requested = 0;
@@ -420,7 +425,7 @@ static int gfs2_prepare_write(struct fil
 		goto out_trans_fail;
 
 	if (gfs2_is_stuffed(ip)) {
-		if (end > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
+		if (pos + len > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode)) {
 			error = gfs2_unstuff_dinode(ip, page);
 			if (error == 0)
 				goto prepare_write;
@@ -443,6 +448,10 @@ out_qunlock:
 out_alloc_put:
 			gfs2_alloc_put(ip);
 		}
+out_putpage:
+		page_cache_release(page);
+		if (pos + len > ip->i_inode.i_size)
+			vmtruncate(&ip->i_inode, ip->i_inode.i_size);
 out_unlock:
 		gfs2_glock_dq_m(1, &ip->i_gh);
 out_uninit:
@@ -478,65 +487,117 @@ static void adjust_fs_space(struct inode
 }
 
 /**
- * gfs2_commit_write - Commit write to a file
+ * gfs2_stuffed_write_end - Write end for stuffed files
+ * @inode: The inode
+ * @dibh: The buffer_head containing the on-disk inode
+ * @pos: The file position
+ * @len: The length of the write
+ * @copied: How much was actually copied by the VFS
+ * @page: The page
+ *
+ * This copies the data from the page into the inode block after
+ * the inode data structure itself.
+ *
+ * Returns: errno
+ */
+static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
+				  loff_t pos, unsigned len, unsigned copied,
+				  struct page *page)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	u64 to = pos + copied;
+	void *kaddr;
+	unsigned char *buf = dibh->b_data + sizeof(struct gfs2_dinode);
+	struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
+
+	BUG_ON((pos + len) > (dibh->b_size - sizeof(struct gfs2_dinode)));
+	kaddr = kmap_atomic(page, KM_USER0);
+	memcpy(buf + pos, kaddr + pos, copied);
+	memset(kaddr + pos + copied, 0, len - copied);
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	unlock_page(page);
+	page_cache_release(page);
+
+	if (inode->i_size < to) {
+		i_size_write(inode, to);
+		ip->i_di.di_size = inode->i_size;
+		di->di_size = cpu_to_be64(inode->i_size);
+		mark_inode_dirty(inode);
+	}
+
+	if (inode == sdp->sd_rindex)
+		adjust_fs_space(inode);
+
+	brelse(dibh);
+	gfs2_trans_end(sdp);
+	gfs2_glock_dq(&ip->i_gh);
+	gfs2_holder_uninit(&ip->i_gh);
+	return copied;
+}
+
+/**
+ * gfs2_write_end
  * @file: The file to write to
- * @page: The page containing the data
- * @from: From (byte range within page)
- * @to: To (byte range within page)
+ * @mapping: The address space to write to
+ * @pos: The file position
+ * @len: The length of the data
+ * @copied:
+ * @page: The page that has been written
+ * @fsdata: The fsdata (unused in GFS2)
+ *
+ * The main write_end function for GFS2. We have a separate one for
+ * stuffed files as they are slightly different, otherwise we just
+ * put our locking around the VFS provided functions.
  *
  * Returns: errno
  */
 
-static int gfs2_commit_write(struct file *file, struct page *page,
-			     unsigned from, unsigned to)
+static int gfs2_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned len, unsigned copied,
+			  struct page *page, void *fsdata)
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error = -EOPNOTSUPP;
 	struct buffer_head *dibh;
 	struct gfs2_alloc *al = &ip->i_alloc;
 	struct gfs2_dinode *di;
+	unsigned int from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned int to = from + len;
+	int ret;
 
-	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_locked_by_me(ip->i_gl)))
-                goto fail_nounlock;
+	BUG_ON(gfs2_glock_is_locked_by_me(ip->i_gl) == 0);
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		goto fail_endtrans;
+	ret = gfs2_meta_inode_buffer(ip, &dibh);
+	if (unlikely(ret)) {
+		unlock_page(page);
+		page_cache_release(page);
+		goto failed;
+	}
 
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	di = (struct gfs2_dinode *)dibh->b_data;
 
-	if (gfs2_is_stuffed(ip)) {
-		u64 file_size;
-		void *kaddr;
-
-		file_size = ((u64)page->index << PAGE_CACHE_SHIFT) + to;
+	if (gfs2_is_stuffed(ip))
+		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
 
-		kaddr = kmap_atomic(page, KM_USER0);
-		memcpy(dibh->b_data + sizeof(struct gfs2_dinode) + from,
-		       kaddr + from, to - from);
-		kunmap_atomic(kaddr, KM_USER0);
+	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
+		gfs2_page_add_databufs(ip, page, from, to);
 
-		SetPageUptodate(page);
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
 
-		if (inode->i_size < file_size) {
-			i_size_write(inode, file_size);
+	if (likely(ret >= 0)) {
+		copied = ret;
+		if  ((pos + copied) > inode->i_size) {
+			di = (struct gfs2_dinode *)dibh->b_data;
+			ip->i_di.di_size = inode->i_size;
+			di->di_size = cpu_to_be64(inode->i_size);
 			mark_inode_dirty(inode);
 		}
-	} else {
-		if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED ||
-		    gfs2_is_jdata(ip))
-			gfs2_page_add_databufs(ip, page, from, to);
-		error = generic_commit_write(file, page, from, to);
-		if (error)
-			goto fail;
-	}
-
-	if (ip->i_di.di_size < inode->i_size) {
-		ip->i_di.di_size = inode->i_size;
-		di->di_size = cpu_to_be64(inode->i_size);
 	}
 
 	if (inode == sdp->sd_rindex)
@@ -544,33 +605,15 @@ static int gfs2_commit_write(struct file
 
 	brelse(dibh);
 	gfs2_trans_end(sdp);
+failed:
 	if (al->al_requested) {
 		gfs2_inplace_release(ip);
 		gfs2_quota_unlock(ip);
 		gfs2_alloc_put(ip);
 	}
-	unlock_page(page);
-	gfs2_glock_dq_m(1, &ip->i_gh);
-	lock_page(page);
-	gfs2_holder_uninit(&ip->i_gh);
-	return 0;
-
-fail:
-	brelse(dibh);
-fail_endtrans:
-	gfs2_trans_end(sdp);
-	if (al->al_requested) {
-		gfs2_inplace_release(ip);
-		gfs2_quota_unlock(ip);
-		gfs2_alloc_put(ip);
-	}
-	unlock_page(page);
-	gfs2_glock_dq_m(1, &ip->i_gh);
-	lock_page(page);
+	gfs2_glock_dq(&ip->i_gh);
 	gfs2_holder_uninit(&ip->i_gh);
-fail_nounlock:
-	ClearPageUptodate(page);
-	return error;
+	return ret;
 }
 
 /**
@@ -799,8 +842,8 @@ const struct address_space_operations gf
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
-	.prepare_write = gfs2_prepare_write,
-	.commit_write = gfs2_commit_write,
+	.write_begin = gfs2_write_begin,
+	.write_end = gfs2_write_end,
 	.set_page_dirty = gfs2_set_page_dirty,
 	.bmap = gfs2_bmap,
 	.invalidatepage = gfs2_invalidatepage,
_

Patches currently in -mm which might be from swhiteho@redhat.com are

origin.patch
menuconfig-transform-nls-and-dlm-menus.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
gfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
