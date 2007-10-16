From: akpm@linux-foundation.org
Subject: - nfs-convert-to-new-aops.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:05 -0700
Message-ID: <200710162033.l9GKX5Ql014752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965383AbXJPVwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, bfields@fieldses.org, mm-commits@vger.kernel.org


The patch titled
     nfs: convert to new aops
has been removed from the -mm tree.  Its filename was
     nfs-convert-to-new-aops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: convert to new aops
From: Nick Piggin <npiggin@suse.de>

[akpm@linux-foundation.org: fix against git-nfs]
[peterz@infradead.org: fix against git-nfs]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c |   82 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 21 deletions(-)

diff -puN fs/nfs/file.c~nfs-convert-to-new-aops fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-convert-to-new-aops
+++ a/fs/nfs/file.c
@@ -306,27 +306,50 @@ nfs_fsync(struct file *file, struct dent
 }
 
 /*
- * This does the "real" work of the write. The generic routine has
- * allocated the page, locked it, done all the page alignment stuff
- * calculations etc. Now we should just copy the data from user
- * space and write it back to the real medium..
+ * This does the "real" work of the write. We must allocate and lock the
+ * page to be sent back to the generic routine, which then copies the
+ * data from user space.
  *
  * If the writer ends up delaying the write, the writer needs to
  * increment the page use counts until he is done with the page.
  */
-static int nfs_prepare_write(struct file *file, struct page *page, unsigned offset, unsigned to)
-{
-	return nfs_flush_incompatible(file, page);
+static int nfs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
+{
+	int ret;
+	pgoff_t index;
+	struct page *page;
+	index = pos >> PAGE_CACHE_SHIFT;
+
+	page = __grab_cache_page(mapping, index);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	ret = nfs_flush_incompatible(file, page);
+	if (ret) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	return ret;
 }
 
-static int nfs_commit_write(struct file *file, struct page *page, unsigned offset, unsigned to)
+static int nfs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	long status;
+	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+	int status;
 
 	lock_kernel();
-	status = nfs_updatepage(file, page, offset, to-offset);
+	status = nfs_updatepage(file, page, offset, copied);
 	unlock_kernel();
-	return status;
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	return status < 0 ? status : copied;
 }
 
 static void nfs_invalidate_page(struct page *page, unsigned long offset)
@@ -354,8 +377,8 @@ const struct address_space_operations nf
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.writepage = nfs_writepage,
 	.writepages = nfs_writepages,
-	.prepare_write = nfs_prepare_write,
-	.commit_write = nfs_commit_write,
+	.write_begin = nfs_write_begin,
+	.write_end = nfs_write_end,
 	.invalidatepage = nfs_invalidate_page,
 	.releasepage = nfs_release_page,
 #ifdef CONFIG_NFS_DIRECTIO
@@ -369,18 +392,35 @@ static int nfs_vm_page_mkwrite(struct vm
 	struct file *filp = vma->vm_file;
 	unsigned pagelen;
 	int ret = -EINVAL;
+	void *fsdata;
+	struct address_space *mapping;
+	loff_t offset;
 
 	lock_page(page);
-	if (page->mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping)
-		goto out_unlock;
+	mapping = page->mapping;
+	if (mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping) {
+		unlock_page(page);
+		return -EINVAL;
+	}
 	pagelen = nfs_page_length(page);
-	if (pagelen == 0)
-		goto out_unlock;
-	ret = nfs_prepare_write(filp, page, 0, pagelen);
-	if (!ret)
-		ret = nfs_commit_write(filp, page, 0, pagelen);
-out_unlock:
+	offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	unlock_page(page);
+
+	/*
+	 * we can use mapping after releasing the page lock, because:
+	 * we hold mmap_sem on the fault path, which should pin the vma
+	 * which should pin the file, which pins the dentry which should
+	 * hold a reference on inode.
+	 */
+
+	if (pagelen) {
+		struct page *page2 = NULL;
+		ret = nfs_write_begin(filp, mapping, offset, pagelen,
+			       	0, &page2, &fsdata);
+		if (!ret)
+			ret = nfs_write_end(filp, mapping, offset, pagelen,
+				       	pagelen, page2, fsdata);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
