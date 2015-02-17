From: akpm@linux-foundation.org
Subject: [merged]
 daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:33 -0800
Message-ID: <54e39f0d.0/AUiVCiFGqHfV+t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, ralf@linux-mips.org, rdunlap@infradead.org, rmk@arm.linux.org.uk, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax,ext2: replace the XIP page fault handler with the DAX page fault handler
has been removed from the -mm tree.  Its filename was
     daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax,ext2: replace the XIP page fault handler with the DAX page fault handler

Instead of calling aops->get_xip_mem from the fault handler, the
filesystem passes a get_block_t that is used to find the appropriate
blocks.

This requires that all architectures implement copy_user_page().  At the
time of writing, mips and arm do not.  Patches exist and are in progress.

[akpm@linux-foundation.org: remap_file_pages went away]
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |  241 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext2/file.c     |   34 +++++-
 include/linux/fs.h |    4 
 mm/filemap_xip.c   |  206 ------------------------------------
 4 files changed, 276 insertions(+), 209 deletions(-)

diff -puN fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler fs/dax.c
--- a/fs/dax.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler
+++ a/fs/dax.c
@@ -19,9 +19,13 @@
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
+#include <linux/highmem.h>
+#include <linux/memcontrol.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
+#include <linux/vmstat.h>
 
 int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 {
@@ -221,3 +225,240 @@ ssize_t dax_do_io(int rw, struct kiocb *
 	return retval;
 }
 EXPORT_SYMBOL_GPL(dax_do_io);
+
+/*
+ * The user has performed a load from a hole in the file.  Allocating
+ * a new page in the file would cause excessive storage usage for
+ * workloads with sparse files.  We allocate a page cache page instead.
+ * We'll kick it out of the page cache if it's ever written to,
+ * otherwise it will simply fall out of the page cache under memory
+ * pressure without ever having been dirtied.
+ */
+static int dax_load_hole(struct address_space *mapping, struct page *page,
+							struct vm_fault *vmf)
+{
+	unsigned long size;
+	struct inode *inode = mapping->host;
+	if (!page)
+		page = find_or_create_page(mapping, vmf->pgoff,
+						GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		return VM_FAULT_OOM;
+	/* Recheck i_size under page lock to avoid truncate race */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size) {
+		unlock_page(page);
+		page_cache_release(page);
+		return VM_FAULT_SIGBUS;
+	}
+
+	vmf->page = page;
+	return VM_FAULT_LOCKED;
+}
+
+static int copy_user_bh(struct page *to, struct buffer_head *bh,
+			unsigned blkbits, unsigned long vaddr)
+{
+	void *vfrom, *vto;
+	if (dax_get_addr(bh, &vfrom, blkbits) < 0)
+		return -EIO;
+	vto = kmap_atomic(to);
+	copy_user_page(vto, vfrom, vaddr, to);
+	kunmap_atomic(vto);
+	return 0;
+}
+
+static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
+			struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct address_space *mapping = inode->i_mapping;
+	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	void *addr;
+	unsigned long pfn;
+	pgoff_t size;
+	int error;
+
+	i_mmap_lock_read(mapping);
+
+	/*
+	 * Check truncate didn't happen while we were allocating a block.
+	 * If it did, this block may or may not be still allocated to the
+	 * file.  We can't tell the filesystem to free it because we can't
+	 * take i_mutex here.  In the worst case, the file still has blocks
+	 * allocated past the end of the file.
+	 */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (unlikely(vmf->pgoff >= size)) {
+		error = -EIO;
+		goto out;
+	}
+
+	error = bdev_direct_access(bh->b_bdev, sector, &addr, &pfn, bh->b_size);
+	if (error < 0)
+		goto out;
+	if (error < PAGE_SIZE) {
+		error = -EIO;
+		goto out;
+	}
+
+	if (buffer_unwritten(bh) || buffer_new(bh))
+		clear_page(addr);
+
+	error = vm_insert_mixed(vma, vaddr, pfn);
+
+ out:
+	i_mmap_unlock_read(mapping);
+
+	if (bh->b_end_io)
+		bh->b_end_io(bh, 1);
+
+	return error;
+}
+
+static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			get_block_t get_block)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct page *page;
+	struct buffer_head bh;
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	unsigned blkbits = inode->i_blkbits;
+	sector_t block;
+	pgoff_t size;
+	int error;
+	int major = 0;
+
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		return VM_FAULT_SIGBUS;
+
+	memset(&bh, 0, sizeof(bh));
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	bh.b_size = PAGE_SIZE;
+
+ repeat:
+	page = find_get_page(mapping, vmf->pgoff);
+	if (page) {
+		if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+			page_cache_release(page);
+			return VM_FAULT_RETRY;
+		}
+		if (unlikely(page->mapping != mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
+		}
+		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		if (unlikely(vmf->pgoff >= size)) {
+			/*
+			 * We have a struct page covering a hole in the file
+			 * from a read fault and we've raced with a truncate
+			 */
+			error = -EIO;
+			goto unlock_page;
+		}
+	}
+
+	error = get_block(inode, block, &bh, 0);
+	if (!error && (bh.b_size < PAGE_SIZE))
+		error = -EIO;		/* fs corruption? */
+	if (error)
+		goto unlock_page;
+
+	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
+		if (vmf->flags & FAULT_FLAG_WRITE) {
+			error = get_block(inode, block, &bh, 1);
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			major = VM_FAULT_MAJOR;
+			if (!error && (bh.b_size < PAGE_SIZE))
+				error = -EIO;
+			if (error)
+				goto unlock_page;
+		} else {
+			return dax_load_hole(mapping, page, vmf);
+		}
+	}
+
+	if (vmf->cow_page) {
+		struct page *new_page = vmf->cow_page;
+		if (buffer_written(&bh))
+			error = copy_user_bh(new_page, &bh, blkbits, vaddr);
+		else
+			clear_user_highpage(new_page, vaddr);
+		if (error)
+			goto unlock_page;
+		vmf->page = page;
+		if (!page) {
+			i_mmap_lock_read(mapping);
+			/* Check we didn't race with truncate */
+			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
+								PAGE_SHIFT;
+			if (vmf->pgoff >= size) {
+				i_mmap_unlock_read(mapping);
+				error = -EIO;
+				goto out;
+			}
+		}
+		return VM_FAULT_LOCKED;
+	}
+
+	/* Check we didn't race with a read fault installing a new page */
+	if (!page && major)
+		page = find_lock_page(mapping, vmf->pgoff);
+
+	if (page) {
+		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
+							PAGE_CACHE_SIZE, 0);
+		delete_from_page_cache(page);
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
+	error = dax_insert_mapping(inode, &bh, vma, vmf);
+
+ out:
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM | major;
+	/* -EBUSY is fine, somebody else faulted on the same PTE */
+	if ((error < 0) && (error != -EBUSY))
+		return VM_FAULT_SIGBUS | major;
+	return VM_FAULT_NOPAGE | major;
+
+ unlock_page:
+	if (page) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+	goto out;
+}
+
+/**
+ * dax_fault - handle a page fault on a DAX file
+ * @vma: The virtual memory area where the fault occurred
+ * @vmf: The description of the fault
+ * @get_block: The filesystem method used to translate file offsets to blocks
+ *
+ * When a page fault occurs, filesystems may call this helper in their
+ * fault handler for DAX files.
+ */
+int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			get_block_t get_block)
+{
+	int result;
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+
+	if (vmf->flags & FAULT_FLAG_WRITE) {
+		sb_start_pagefault(sb);
+		file_update_time(vma->vm_file);
+	}
+	result = do_dax_fault(vma, vmf, get_block);
+	if (vmf->flags & FAULT_FLAG_WRITE)
+		sb_end_pagefault(sb);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(dax_fault);
diff -puN fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler fs/ext2/file.c
--- a/fs/ext2/file.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler
+++ a/fs/ext2/file.c
@@ -25,6 +25,36 @@
 #include "xattr.h"
 #include "acl.h"
 
+#ifdef CONFIG_EXT2_FS_XIP
+static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return dax_fault(vma, vmf, ext2_get_block);
+}
+
+static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return dax_mkwrite(vma, vmf, ext2_get_block);
+}
+
+static const struct vm_operations_struct ext2_dax_vm_ops = {
+	.fault		= ext2_dax_fault,
+	.page_mkwrite	= ext2_dax_mkwrite,
+};
+
+static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!IS_DAX(file_inode(file)))
+		return generic_file_mmap(file, vma);
+
+	file_accessed(file);
+	vma->vm_ops = &ext2_dax_vm_ops;
+	vma->vm_flags |= VM_MIXEDMAP;
+	return 0;
+}
+#else
+#define ext2_file_mmap	generic_file_mmap
+#endif
+
 /*
  * Called when filp is released. This happens when all file descriptors
  * for a single struct file are closed. Note that different open() calls
@@ -70,7 +100,7 @@ const struct file_operations ext2_file_o
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
@@ -89,7 +119,7 @@ const struct file_operations ext2_xip_fi
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= xip_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
diff -puN include/linux/fs.h~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler include/linux/fs.h
--- a/include/linux/fs.h~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler
+++ a/include/linux/fs.h
@@ -51,6 +51,7 @@ struct swap_info_struct;
 struct seq_file;
 struct workqueue_struct;
 struct iov_iter;
+struct vm_fault;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -2590,9 +2591,10 @@ extern int nonseekable_open(struct inode
 ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, struct iov_iter *,
 		loff_t, get_block_t, dio_iodone_t, int flags);
 int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
+#define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
 
 #ifdef CONFIG_FS_XIP
-extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
diff -puN mm/filemap_xip.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler mm/filemap_xip.c
--- a/mm/filemap_xip.c~daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler
+++ a/mm/filemap_xip.c
@@ -23,212 +23,6 @@
 #include <asm/io.h>
 
 /*
- * We do use our own empty page to avoid interference with other users
- * of ZERO_PAGE(), such as /dev/zero
- */
-static DEFINE_MUTEX(xip_sparse_mutex);
-static seqcount_t xip_sparse_seq = SEQCNT_ZERO(xip_sparse_seq);
-static struct page *__xip_sparse_page;
-
-/* called under xip_sparse_mutex */
-static struct page *xip_sparse_page(void)
-{
-	if (!__xip_sparse_page) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
-
-		if (page)
-			__xip_sparse_page = page;
-	}
-	return __xip_sparse_page;
-}
-
-/*
- * __xip_unmap is invoked from xip_unmap and xip_write
- *
- * This function walks all vmas of the address_space and unmaps the
- * __xip_sparse_page when found at pgoff.
- */
-static void __xip_unmap(struct address_space * mapping, unsigned long pgoff)
-{
-	struct vm_area_struct *vma;
-	struct page *page;
-	unsigned count;
-	int locked = 0;
-
-	count = read_seqcount_begin(&xip_sparse_seq);
-
-	page = __xip_sparse_page;
-	if (!page)
-		return;
-
-retry:
-	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		pte_t *pte, pteval;
-		spinlock_t *ptl;
-		struct mm_struct *mm = vma->vm_mm;
-		unsigned long address = vma->vm_start +
-			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-
-		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-		pte = page_check_address(page, mm, address, &ptl, 1);
-		if (pte) {
-			/* Nuke the page table entry. */
-			flush_cache_page(vma, address, pte_pfn(*pte));
-			pteval = ptep_clear_flush(vma, address, pte);
-			page_remove_rmap(page);
-			dec_mm_counter(mm, MM_FILEPAGES);
-			BUG_ON(pte_dirty(pteval));
-			pte_unmap_unlock(pte, ptl);
-			/* must invalidate_page _before_ freeing the page */
-			mmu_notifier_invalidate_page(mm, address);
-			page_cache_release(page);
-		}
-	}
-	i_mmap_unlock_read(mapping);
-
-	if (locked) {
-		mutex_unlock(&xip_sparse_mutex);
-	} else if (read_seqcount_retry(&xip_sparse_seq, count)) {
-		mutex_lock(&xip_sparse_mutex);
-		locked = 1;
-		goto retry;
-	}
-}
-
-/*
- * xip_fault() is invoked via the vma operations vector for a
- * mapped memory region to read in file data during a page fault.
- *
- * This function is derived from filemap_fault, but used for execute in place
- */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct file *file = vma->vm_file;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	pgoff_t size;
-	void *xip_mem;
-	unsigned long xip_pfn;
-	struct page *page;
-	int error;
-
-	/* XXX: are VM_FAULT_ codes OK? */
-again:
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (vmf->pgoff >= size)
-		return VM_FAULT_SIGBUS;
-
-	error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 0,
-						&xip_mem, &xip_pfn);
-	if (likely(!error))
-		goto found;
-	if (error != -ENODATA)
-		return VM_FAULT_OOM;
-
-	/* sparse block */
-	if ((vma->vm_flags & (VM_WRITE | VM_MAYWRITE)) &&
-	    (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) &&
-	    (!(mapping->host->i_sb->s_flags & MS_RDONLY))) {
-		int err;
-
-		/* maybe shared writable, allocate new block */
-		mutex_lock(&xip_sparse_mutex);
-		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 1,
-							&xip_mem, &xip_pfn);
-		mutex_unlock(&xip_sparse_mutex);
-		if (error)
-			return VM_FAULT_SIGBUS;
-		/* unmap sparse mappings at pgoff from all other vmas */
-		__xip_unmap(mapping, vmf->pgoff);
-
-found:
-		/*
-		 * We must recheck i_size under i_mmap_rwsem to prevent races
-		 * with truncation
-		 */
-		i_mmap_lock_read(mapping);
-		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-							PAGE_CACHE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			i_mmap_unlock_read(mapping);
-			return VM_FAULT_SIGBUS;
-		}
-		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-							xip_pfn);
-		i_mmap_unlock_read(mapping);
-		if (err == -ENOMEM)
-			return VM_FAULT_OOM;
-		/*
-		 * err == -EBUSY is fine, we've raced against another thread
-		 * that faulted-in the same page
-		 */
-		if (err != -EBUSY)
-			BUG_ON(err);
-		return VM_FAULT_NOPAGE;
-	} else {
-		int err, ret = VM_FAULT_OOM;
-
-		mutex_lock(&xip_sparse_mutex);
-		write_seqcount_begin(&xip_sparse_seq);
-		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 0,
-							&xip_mem, &xip_pfn);
-		if (unlikely(!error)) {
-			write_seqcount_end(&xip_sparse_seq);
-			mutex_unlock(&xip_sparse_mutex);
-			goto again;
-		}
-		if (error != -ENODATA)
-			goto out;
-
-		/*
-		 * We must recheck i_size under i_mmap_rwsem to prevent races
-		 * with truncation
-		 */
-		i_mmap_lock_read(mapping);
-		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-							PAGE_CACHE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			ret = VM_FAULT_SIGBUS;
-			goto unlock;
-		}
-		/* not shared and writable, use xip_sparse_page() */
-		page = xip_sparse_page();
-		if (!page)
-			goto unlock;
-		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
-							page);
-		if (err == -ENOMEM)
-			goto unlock;
-
-		ret = VM_FAULT_NOPAGE;
-unlock:
-		i_mmap_unlock_read(mapping);
-out:
-		write_seqcount_end(&xip_sparse_seq);
-		mutex_unlock(&xip_sparse_mutex);
-
-		return ret;
-	}
-}
-
-static const struct vm_operations_struct xip_file_vm_ops = {
-	.fault	= xip_file_fault,
-	.page_mkwrite	= filemap_page_mkwrite,
-};
-
-int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
-{
-	BUG_ON(!file->f_mapping->a_ops->get_xip_mem);
-
-	file_accessed(file);
-	vma->vm_ops = &xip_file_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xip_file_mmap);
