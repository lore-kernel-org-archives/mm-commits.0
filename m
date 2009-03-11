From: akpm@linux-foundation.org
Subject: + mm-page_mkwrite-change-prototype-to-match-fault.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:55:34 -0700
Message-ID: <200903112055.n2BKtZXR002939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbZCKVA1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 17:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, dedekind@infradead.org, felixb@sgi.com, joel.becker@oracle.com, mfasheh@suse.com, miklos@szeredi.hu, swhiteho@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     mm: page_mkwrite change prototype to match fault
has been added to the -mm tree.  Its filename is
     mm-page_mkwrite-change-prototype-to-match-fault.patch

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
Subject: mm: page_mkwrite change prototype to match fault
From: Nick Piggin <npiggin@suse.de>

Change the page_mkwrite prototype to take a struct vm_fault, and return
VM_FAULT_xxx flags.  There should be no functional change.

This makes it possible to return much more detailed error information to
the VM (and also can provide more information eg.  virtual_address to the
driver, which might be important in some special cases).

This is required for a subsequent fix.  And will also make it easier to
merge page_mkwrite() with fault() in future.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Felix Blyakher <felixb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 +-
 drivers/video/fb_defio.c          |    3 ++-
 fs/btrfs/ctree.h                  |    2 +-
 fs/btrfs/inode.c                  |    5 ++++-
 fs/buffer.c                       |    6 +++++-
 fs/ext4/ext4.h                    |    2 +-
 fs/ext4/inode.c                   |    5 ++++-
 fs/fuse/file.c                    |    3 ++-
 fs/gfs2/ops_file.c                |    5 ++++-
 fs/nfs/file.c                     |    5 ++++-
 fs/ocfs2/mmap.c                   |    6 ++++--
 fs/ubifs/file.c                   |    9 ++++++---
 fs/xfs/linux-2.6/xfs_file.c       |    4 ++--
 include/linux/buffer_head.h       |    2 +-
 include/linux/mm.h                |    3 ++-
 mm/memory.c                       |   26 ++++++++++++++++++++++----
 16 files changed, 65 insertions(+), 23 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-page_mkwrite-change-prototype-to-match-fault Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/Documentation/filesystems/Locking
@@ -505,7 +505,7 @@ prototypes:
 	void (*open)(struct vm_area_struct*);
 	void (*close)(struct vm_area_struct*);
 	int (*fault)(struct vm_area_struct*, struct vm_fault *);
-	int (*page_mkwrite)(struct vm_area_struct *, struct page *);
+	int (*page_mkwrite)(struct vm_area_struct *, struct vm_fault *);
 	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
diff -puN drivers/video/fb_defio.c~mm-page_mkwrite-change-prototype-to-match-fault drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/drivers/video/fb_defio.c
@@ -85,8 +85,9 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
 
 /* vm_ops->page_mkwrite handler */
 static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
-				  struct page *page)
+				  struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct fb_info *info = vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *cur;
diff -puN fs/btrfs/ctree.h~mm-page_mkwrite-change-prototype-to-match-fault fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/btrfs/ctree.h
@@ -2051,7 +2051,7 @@ int btrfs_merge_bio_hook(struct page *pa
 unsigned long btrfs_force_ra(struct address_space *mapping,
 			      struct file_ra_state *ra, struct file *file,
 			      pgoff_t offset, pgoff_t last_index);
-int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_delete_inode(struct inode *inode);
 void btrfs_put_inode(struct inode *inode);
diff -puN fs/btrfs/inode.c~mm-page_mkwrite-change-prototype-to-match-fault fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/btrfs/inode.c
@@ -4292,8 +4292,9 @@ static void btrfs_invalidatepage(struct 
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  */
-int btrfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = fdentry(vma->vm_file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -4362,6 +4363,8 @@ again:
 out_unlock:
 	unlock_page(page);
 out:
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
diff -puN fs/buffer.c~mm-page_mkwrite-change-prototype-to-match-fault fs/buffer.c
--- a/fs/buffer.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/buffer.c
@@ -2459,9 +2459,10 @@ int block_commit_write(struct page *page
  * unlock the page.
  */
 int
-block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
+block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		   get_block_t get_block)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long end;
 	loff_t size;
@@ -2486,6 +2487,9 @@ block_page_mkwrite(struct vm_area_struct
 		ret = block_commit_write(page, 0, end);
 
 out_unlock:
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
+
 	unlock_page(page);
 	return ret;
 }
diff -puN fs/ext4/ext4.h~mm-page_mkwrite-change-prototype-to-match-fault fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/ext4/ext4.h
@@ -1090,7 +1090,7 @@ extern int ext4_meta_trans_blocks(struct
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
-extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t ext4_get_reserved_space(struct inode *inode);
 
 /* ioctl.c */
diff -puN fs/ext4/inode.c~mm-page_mkwrite-change-prototype-to-match-fault fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/ext4/inode.c
@@ -5196,8 +5196,9 @@ static int ext4_bh_unmapped(handle_t *ha
 	return !buffer_mapped(bh);
 }
 
-int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	loff_t size;
 	unsigned long len;
 	int ret = -EINVAL;
@@ -5249,6 +5250,8 @@ int ext4_page_mkwrite(struct vm_area_str
 		goto out_unlock;
 	ret = 0;
 out_unlock:
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
 	up_read(&inode->i_alloc_sem);
 	return ret;
 }
diff -puN fs/fuse/file.c~mm-page_mkwrite-change-prototype-to-match-fault fs/fuse/file.c
--- a/fs/fuse/file.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/fuse/file.c
@@ -1234,8 +1234,9 @@ static void fuse_vma_close(struct vm_are
  * - sync(2)
  * - try_to_free_pages() with order > PAGE_ALLOC_COSTLY_ORDER
  */
-static int fuse_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	/*
 	 * Don't use page->mapping as it may become NULL from a
 	 * concurrent truncate.
diff -puN fs/gfs2/ops_file.c~mm-page_mkwrite-change-prototype-to-match-fault fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/gfs2/ops_file.c
@@ -337,8 +337,9 @@ static int gfs2_allocate_page_backing(st
  * blocks allocated on disk to back that page.
  */
 
-static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -411,6 +412,8 @@ out_unlock:
 	gfs2_glock_dq(&gh);
 out:
 	gfs2_holder_uninit(&gh);
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
diff -puN fs/nfs/file.c~mm-page_mkwrite-change-prototype-to-match-fault fs/nfs/file.c
--- a/fs/nfs/file.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/nfs/file.c
@@ -483,8 +483,9 @@ const struct address_space_operations nf
  * writable, implying that someone is about to modify the page through a
  * shared-writable mapping
  */
-static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct file *filp = vma->vm_file;
 	struct dentry *dentry = filp->f_path.dentry;
 	unsigned pagelen;
@@ -518,6 +519,8 @@ static int nfs_vm_page_mkwrite(struct vm
 		ret = pagelen;
 out_unlock:
 	unlock_page(page);
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
diff -puN fs/ocfs2/mmap.c~mm-page_mkwrite-change-prototype-to-match-fault fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/ocfs2/mmap.c
@@ -154,8 +154,9 @@ out:
 	return ret;
 }
 
-static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct buffer_head *di_bh = NULL;
 	sigset_t blocked, oldset;
@@ -196,7 +197,8 @@ out:
 	ret2 = ocfs2_vm_op_unblock_sigs(&oldset);
 	if (ret2 < 0)
 		mlog_errno(ret2);
-
+	if (ret)
+		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
 
diff -puN fs/ubifs/file.c~mm-page_mkwrite-change-prototype-to-match-fault fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/ubifs/file.c
@@ -1434,8 +1434,9 @@ static int ubifs_releasepage(struct page
  * mmap()d file has taken write protection fault and is being made
  * writable. UBIFS must ensure page is budgeted for.
  */
-static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct timespec now = ubifs_current_time(inode);
@@ -1447,7 +1448,7 @@ static int ubifs_vm_page_mkwrite(struct 
 	ubifs_assert(!(inode->i_sb->s_flags & MS_RDONLY));
 
 	if (unlikely(c->ro_media))
-		return -EROFS;
+		return VM_FAULT_SIGBUS; /* -EROFS */
 
 	/*
 	 * We have not locked @page so far so we may budget for changing the
@@ -1480,7 +1481,7 @@ static int ubifs_vm_page_mkwrite(struct 
 		if (err == -ENOSPC)
 			ubifs_warn("out of space for mmapped file "
 				   "(inode number %lu)", inode->i_ino);
-		return err;
+		return VM_FAULT_SIGBUS;
 	}
 
 	lock_page(page);
@@ -1520,6 +1521,8 @@ static int ubifs_vm_page_mkwrite(struct 
 out_unlock:
 	unlock_page(page);
 	ubifs_release_budget(c, &req);
+	if (err)
+		err = VM_FAULT_SIGBUS;
 	return err;
 }
 
diff -puN fs/xfs/linux-2.6/xfs_file.c~mm-page_mkwrite-change-prototype-to-match-fault fs/xfs/linux-2.6/xfs_file.c
--- a/fs/xfs/linux-2.6/xfs_file.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/fs/xfs/linux-2.6/xfs_file.c
@@ -234,9 +234,9 @@ xfs_file_mmap(
 STATIC int
 xfs_vm_page_mkwrite(
 	struct vm_area_struct	*vma,
-	struct page		*page)
+	struct vm_fault		*vmf)
 {
-	return block_page_mkwrite(vma, page, xfs_get_blocks);
+	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
 const struct file_operations xfs_file_operations = {
diff -puN include/linux/buffer_head.h~mm-page_mkwrite-change-prototype-to-match-fault include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/include/linux/buffer_head.h
@@ -223,7 +223,7 @@ int cont_write_begin(struct file *, stru
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
-int block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
+int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
diff -puN include/linux/mm.h~mm-page_mkwrite-change-prototype-to-match-fault include/linux/mm.h
--- a/include/linux/mm.h~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/include/linux/mm.h
@@ -135,6 +135,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 #define FAULT_FLAG_RETRY	0x04	/* Retry major fault */
+#define FAULT_FLAG_MKWRITE	0x08	/* Fault was mkwrite of existing pte */
 
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping that is
@@ -187,7 +188,7 @@ struct vm_operations_struct {
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
-	int (*page_mkwrite)(struct vm_area_struct *vma, struct page *page);
+	int (*page_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 	/* called by access_process_vm when get_user_pages() fails, typically
 	 * for use by special VMAs that can switch between memory and hardware
diff -puN mm/memory.c~mm-page_mkwrite-change-prototype-to-match-fault mm/memory.c
--- a/mm/memory.c~mm-page_mkwrite-change-prototype-to-match-fault
+++ a/mm/memory.c
@@ -1945,6 +1945,15 @@ static int do_wp_page(struct mm_struct *
 		 * get_user_pages(.write=1, .force=1).
 		 */
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
+			struct vm_fault vmf;
+			int tmp;
+
+			vmf.virtual_address = (void __user *)(address &
+								PAGE_MASK);
+			vmf.pgoff = old_page->index;
+			vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
+			vmf.page = old_page;
+
 			/*
 			 * Notify the address space that the page is about to
 			 * become writable so that it can prohibit this or wait
@@ -1956,8 +1965,12 @@ static int do_wp_page(struct mm_struct *
 			page_cache_get(old_page);
 			pte_unmap_unlock(page_table, ptl);
 
-			if (vma->vm_ops->page_mkwrite(vma, old_page) < 0)
+			tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
+			if (unlikely(tmp &
+					(VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+				ret = tmp;
 				goto unwritable_page;
+			}
 
 			/*
 			 * Since we dropped the lock we need to revalidate
@@ -2106,7 +2119,7 @@ oom:
 
 unwritable_page:
 	page_cache_release(old_page);
-	return VM_FAULT_SIGBUS;
+	return ret;
 }
 
 /*
@@ -2657,9 +2670,14 @@ static int __do_fault(struct mm_struct *
 			 * to become writable
 			 */
 			if (vma->vm_ops->page_mkwrite) {
+				int tmp;
+
 				unlock_page(page);
-				if (vma->vm_ops->page_mkwrite(vma, page) < 0) {
-					ret = VM_FAULT_SIGBUS;
+				vmf.flags |= FAULT_FLAG_MKWRITE;
+				tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
+				if (unlikely(tmp &
+					  (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+					ret = tmp;
 					anon = 1; /* no anon but release vmf.page */
 					goto out_unlocked;
 				}
_

Patches currently in -mm which might be from npiggin@suse.de are

fs-new-inode-i_state-corruption-fix.patch
linux-next.patch
slqb-use-correct-name-for-rcu-callback.patch
slqb-cleanup-for-concatenating-kmlist.patch
fs-avoid-i_new-inodes.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
mm-page_mkwrite-change-prototype-to-match-fault.patch
fs-fix-page_mkwrite-error-cases-in-core-code-and-btrfs.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

