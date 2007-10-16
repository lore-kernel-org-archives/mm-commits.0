From: akpm@linux-foundation.org
Subject: - reiserfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:59 -0700
Message-ID: <200710162032.l9GKWxoY014669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966206AbXJPVtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     reiserfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     reiserfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: convert to new aops
From: Vladimir Saveliev <vs@namesys.com>

Convert reiserfs to new aops

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |  176 +++++++++++++++++++++++++++++++++++++++---
 fs/reiserfs/ioctl.c |   10 +-
 fs/reiserfs/xattr.c |   16 ++-
 3 files changed, 183 insertions(+), 19 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-convert-to-new-aops fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-convert-to-new-aops
+++ a/fs/reiserfs/inode.c
@@ -17,11 +17,12 @@
 #include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
+#include <linux/swap.h>
 
-static int reiserfs_commit_write(struct file *f, struct page *page,
-				 unsigned from, unsigned to);
-static int reiserfs_prepare_write(struct file *f, struct page *page,
-				  unsigned from, unsigned to);
+int reiserfs_commit_write(struct file *f, struct page *page,
+			  unsigned from, unsigned to);
+int reiserfs_prepare_write(struct file *f, struct page *page,
+			   unsigned from, unsigned to);
 
 void reiserfs_delete_inode(struct inode *inode)
 {
@@ -2550,8 +2551,71 @@ static int reiserfs_writepage(struct pag
 	return reiserfs_write_full_page(page, wbc);
 }
 
-static int reiserfs_prepare_write(struct file *f, struct page *page,
-				  unsigned from, unsigned to)
+static int reiserfs_write_begin(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	struct inode *inode;
+	struct page *page;
+	pgoff_t index;
+	int ret;
+	int old_ref = 0;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	inode = mapping->host;
+	reiserfs_wait_on_write_block(inode->i_sb);
+	fix_tail_page_for_writing(page);
+	if (reiserfs_transaction_running(inode->i_sb)) {
+		struct reiserfs_transaction_handle *th;
+		th = (struct reiserfs_transaction_handle *)current->
+		    journal_info;
+		BUG_ON(!th->t_refcount);
+		BUG_ON(!th->t_trans_id);
+		old_ref = th->t_refcount;
+		th->t_refcount++;
+	}
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+				reiserfs_get_block);
+	if (ret && reiserfs_transaction_running(inode->i_sb)) {
+		struct reiserfs_transaction_handle *th = current->journal_info;
+		/* this gets a little ugly.  If reiserfs_get_block returned an
+		 * error and left a transacstion running, we've got to close it,
+		 * and we've got to free handle if it was a persistent transaction.
+		 *
+		 * But, if we had nested into an existing transaction, we need
+		 * to just drop the ref count on the handle.
+		 *
+		 * If old_ref == 0, the transaction is from reiserfs_get_block,
+		 * and it was a persistent trans.  Otherwise, it was nested above.
+		 */
+		if (th->t_refcount > old_ref) {
+			if (old_ref)
+				th->t_refcount--;
+			else {
+				int err;
+				reiserfs_write_lock(inode->i_sb);
+				err = reiserfs_end_persistent_transaction(th);
+				reiserfs_write_unlock(inode->i_sb);
+				if (err)
+					ret = err;
+			}
+		}
+	}
+	if (ret) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return ret;
+}
+
+int reiserfs_prepare_write(struct file *f, struct page *page,
+			   unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	int ret;
@@ -2604,8 +2668,100 @@ static sector_t reiserfs_aop_bmap(struct
 	return generic_block_bmap(as, block, reiserfs_bmap);
 }
 
-static int reiserfs_commit_write(struct file *f, struct page *page,
-				 unsigned from, unsigned to)
+static int reiserfs_write_end(struct file *file, struct address_space *mapping,
+			      loff_t pos, unsigned len, unsigned copied,
+			      struct page *page, void *fsdata)
+{
+	struct inode *inode = page->mapping->host;
+	int ret = 0;
+	int update_sd = 0;
+	struct reiserfs_transaction_handle *th;
+	unsigned start;
+
+
+	reiserfs_wait_on_write_block(inode->i_sb);
+	if (reiserfs_transaction_running(inode->i_sb))
+		th = current->journal_info;
+	else
+		th = NULL;
+
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	if (unlikely(copied < len)) {
+		if (!PageUptodate(page))
+			copied = 0;
+
+		page_zero_new_buffers(page, start + copied, start + len);
+	}
+	flush_dcache_page(page);
+
+	reiserfs_commit_page(inode, page, start, start + copied);
+
+	/* generic_commit_write does this for us, but does not update the
+	 ** transaction tracking stuff when the size changes.  So, we have
+	 ** to do the i_size updates here.
+	 */
+	pos += copied;
+	if (pos > inode->i_size) {
+		struct reiserfs_transaction_handle myth;
+		reiserfs_write_lock(inode->i_sb);
+		/* If the file have grown beyond the border where it
+		   can have a tail, unmark it as needing a tail
+		   packing */
+		if ((have_large_tails(inode->i_sb)
+		     && inode->i_size > i_block_size(inode) * 4)
+		    || (have_small_tails(inode->i_sb)
+			&& inode->i_size > i_block_size(inode)))
+			REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
+
+		ret = journal_begin(&myth, inode->i_sb, 1);
+		if (ret) {
+			reiserfs_write_unlock(inode->i_sb);
+			goto journal_error;
+		}
+		reiserfs_update_inode_transaction(inode);
+		inode->i_size = pos;
+		/*
+		 * this will just nest into our transaction.  It's important
+		 * to use mark_inode_dirty so the inode gets pushed around on the
+		 * dirty lists, and so that O_SYNC works as expected
+		 */
+		mark_inode_dirty(inode);
+		reiserfs_update_sd(&myth, inode);
+		update_sd = 1;
+		ret = journal_end(&myth, inode->i_sb, 1);
+		reiserfs_write_unlock(inode->i_sb);
+		if (ret)
+			goto journal_error;
+	}
+	if (th) {
+		reiserfs_write_lock(inode->i_sb);
+		if (!update_sd)
+			mark_inode_dirty(inode);
+		ret = reiserfs_end_persistent_transaction(th);
+		reiserfs_write_unlock(inode->i_sb);
+		if (ret)
+			goto out;
+	}
+
+      out:
+	unlock_page(page);
+	page_cache_release(page);
+	return ret == 0 ? copied : ret;
+
+      journal_error:
+	if (th) {
+		reiserfs_write_lock(inode->i_sb);
+		if (!update_sd)
+			reiserfs_update_sd(th, inode);
+		ret = reiserfs_end_persistent_transaction(th);
+		reiserfs_write_unlock(inode->i_sb);
+	}
+
+	goto out;
+}
+
+int reiserfs_commit_write(struct file *f, struct page *page,
+			  unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
@@ -2999,8 +3155,8 @@ const struct address_space_operations re
 	.releasepage = reiserfs_releasepage,
 	.invalidatepage = reiserfs_invalidatepage,
 	.sync_page = block_sync_page,
-	.prepare_write = reiserfs_prepare_write,
-	.commit_write = reiserfs_commit_write,
+	.write_begin = reiserfs_write_begin,
+	.write_end = reiserfs_write_end,
 	.bmap = reiserfs_aop_bmap,
 	.direct_IO = reiserfs_direct_IO,
 	.set_page_dirty = reiserfs_set_page_dirty,
diff -puN fs/reiserfs/ioctl.c~reiserfs-convert-to-new-aops fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~reiserfs-convert-to-new-aops
+++ a/fs/reiserfs/ioctl.c
@@ -128,6 +128,10 @@ long reiserfs_compat_ioctl(struct file *
 }
 #endif
 
+int reiserfs_commit_write(struct file *f, struct page *page,
+			  unsigned from, unsigned to);
+int reiserfs_prepare_write(struct file *f, struct page *page,
+			   unsigned from, unsigned to);
 /*
 ** reiserfs_unpack
 ** Function try to convert tail from direct item into indirect.
@@ -175,15 +179,13 @@ static int reiserfs_unpack(struct inode 
 	if (!page) {
 		goto out;
 	}
-	retval =
-	    mapping->a_ops->prepare_write(NULL, page, write_from, write_from);
+	retval = reiserfs_prepare_write(NULL, page, write_from, write_from);
 	if (retval)
 		goto out_unlock;
 
 	/* conversion can change page contents, must flush */
 	flush_dcache_page(page);
-	retval =
-	    mapping->a_ops->commit_write(NULL, page, write_from, write_from);
+	retval = reiserfs_commit_write(NULL, page, write_from, write_from);
 	REISERFS_I(inode)->i_flags |= i_nopack_mask;
 
       out_unlock:
diff -puN fs/reiserfs/xattr.c~reiserfs-convert-to-new-aops fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-convert-to-new-aops
+++ a/fs/reiserfs/xattr.c
@@ -426,6 +426,12 @@ static inline __u32 xattr_hash(const cha
 	return csum_partial(msg, len, 0);
 }
 
+int reiserfs_commit_write(struct file *f, struct page *page,
+			  unsigned from, unsigned to);
+int reiserfs_prepare_write(struct file *f, struct page *page,
+			   unsigned from, unsigned to);
+
+
 /* Generic extended attribute operations that can be used by xa plugins */
 
 /*
@@ -512,15 +518,15 @@ reiserfs_xattr_set(struct inode *inode, 
 			rxh->h_hash = cpu_to_le32(xahash);
 		}
 
-		err = mapping->a_ops->prepare_write(fp, page, page_offset,
-						    page_offset + chunk + skip);
+		err = reiserfs_prepare_write(fp, page, page_offset,
+					    page_offset + chunk + skip);
 		if (!err) {
 			if (buffer)
 				memcpy(data + skip, buffer + buffer_pos, chunk);
 			err =
-			    mapping->a_ops->commit_write(fp, page, page_offset,
-							 page_offset + chunk +
-							 skip);
+			    reiserfs_commit_write(fp, page, page_offset,
+						  page_offset + chunk +
+						  skip);
 		}
 		unlock_page(page);
 		reiserfs_put_page(page);
_

Patches currently in -mm which might be from vs@namesys.com are

origin.patch
fs-reiserfs-cleanups.patch
try-to-reap-reiserfs-pages-left-around-by-invalidatepage.patch
reiserfs-fix-kernel-panic-on-corrupted-directory.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
make-reiserfs-stop-using-struct-file-for-internal.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
