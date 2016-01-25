From: akpm@linux-foundation.org
Subject: [merged] dax-add-support-for-fsync-sync.patch removed from -mm
 tree
Date: Mon, 25 Jan 2016 10:58:44 -0800
Message-ID: <56a67064.K/n9VI43H9qWVLuo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbcAYS6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 13:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add support for fsync/sync
has been removed from the -mm tree.  Its filename was
     dax-add-support-for-fsync-sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: add support for fsync/sync

To properly handle fsync/msync in an efficient way DAX needs to track
dirty pages so it is able to flush them durably to media on demand.

The tracking of dirty pages is done via the radix tree in struct
address_space.  This radix tree is already used by the page writeback
infrastructure for tracking dirty pages associated with an open file, and
it already has support for exceptional (non struct page*) entries.  We
build upon these features to add exceptional entries to the radix tree for
DAX dirty PMD or PTE pages at fault time.

[dan.j.williams@intel.com: fix dax_pmd_dbg build warning]
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |  274 +++++++++++++++++++++++++++++++++++++++---
 include/linux/dax.h |    2 
 mm/filemap.c        |    6 
 3 files changed, 266 insertions(+), 16 deletions(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-sync fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-sync
+++ a/fs/dax.c
@@ -24,6 +24,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/pagevec.h>
 #include <linux/pmem.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
@@ -324,6 +325,199 @@ static int copy_user_bh(struct page *to,
 	return 0;
 }
 
+#define NO_SECTOR -1
+#define DAX_PMD_INDEX(page_index) (page_index & (PMD_MASK >> PAGE_CACHE_SHIFT))
+
+static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
+		sector_t sector, bool pmd_entry, bool dirty)
+{
+	struct radix_tree_root *page_tree = &mapping->page_tree;
+	pgoff_t pmd_index = DAX_PMD_INDEX(index);
+	int type, error = 0;
+	void *entry;
+
+	WARN_ON_ONCE(pmd_entry && !dirty);
+	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	spin_lock_irq(&mapping->tree_lock);
+
+	entry = radix_tree_lookup(page_tree, pmd_index);
+	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
+		index = pmd_index;
+		goto dirty;
+	}
+
+	entry = radix_tree_lookup(page_tree, index);
+	if (entry) {
+		type = RADIX_DAX_TYPE(entry);
+		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
+					type != RADIX_DAX_PMD)) {
+			error = -EIO;
+			goto unlock;
+		}
+
+		if (!pmd_entry || type == RADIX_DAX_PMD)
+			goto dirty;
+
+		/*
+		 * We only insert dirty PMD entries into the radix tree.  This
+		 * means we don't need to worry about removing a dirty PTE
+		 * entry and inserting a clean PMD entry, thus reducing the
+		 * range we would flush with a follow-up fsync/msync call.
+		 */
+		radix_tree_delete(&mapping->page_tree, index);
+		mapping->nrexceptional--;
+	}
+
+	if (sector == NO_SECTOR) {
+		/*
+		 * This can happen during correct operation if our pfn_mkwrite
+		 * fault raced against a hole punch operation.  If this
+		 * happens the pte that was hole punched will have been
+		 * unmapped and the radix tree entry will have been removed by
+		 * the time we are called, but the call will still happen.  We
+		 * will return all the way up to wp_pfn_shared(), where the
+		 * pte_same() check will fail, eventually causing page fault
+		 * to be retried by the CPU.
+		 */
+		goto unlock;
+	}
+
+	error = radix_tree_insert(page_tree, index,
+			RADIX_DAX_ENTRY(sector, pmd_entry));
+	if (error)
+		goto unlock;
+
+	mapping->nrexceptional++;
+ dirty:
+	if (dirty)
+		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
+ unlock:
+	spin_unlock_irq(&mapping->tree_lock);
+	return error;
+}
+
+static int dax_writeback_one(struct block_device *bdev,
+		struct address_space *mapping, pgoff_t index, void *entry)
+{
+	struct radix_tree_root *page_tree = &mapping->page_tree;
+	int type = RADIX_DAX_TYPE(entry);
+	struct radix_tree_node *node;
+	struct blk_dax_ctl dax;
+	void **slot;
+	int ret = 0;
+
+	spin_lock_irq(&mapping->tree_lock);
+	/*
+	 * Regular page slots are stabilized by the page lock even
+	 * without the tree itself locked.  These unlocked entries
+	 * need verification under the tree lock.
+	 */
+	if (!__radix_tree_lookup(page_tree, index, &node, &slot))
+		goto unlock;
+	if (*slot != entry)
+		goto unlock;
+
+	/* another fsync thread may have already written back this entry */
+	if (!radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
+		goto unlock;
+
+	if (WARN_ON_ONCE(type != RADIX_DAX_PTE && type != RADIX_DAX_PMD)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
+	dax.sector = RADIX_DAX_SECTOR(entry);
+	dax.size = (type == RADIX_DAX_PMD ? PMD_SIZE : PAGE_SIZE);
+	spin_unlock_irq(&mapping->tree_lock);
+
+	/*
+	 * We cannot hold tree_lock while calling dax_map_atomic() because it
+	 * eventually calls cond_resched().
+	 */
+	ret = dax_map_atomic(bdev, &dax);
+	if (ret < 0)
+		return ret;
+
+	if (WARN_ON_ONCE(ret < dax.size)) {
+		ret = -EIO;
+		goto unmap;
+	}
+
+	wb_cache_pmem(dax.addr, dax.size);
+
+	spin_lock_irq(&mapping->tree_lock);
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+	spin_unlock_irq(&mapping->tree_lock);
+ unmap:
+	dax_unmap_atomic(bdev, &dax);
+	return ret;
+
+ unlock:
+	spin_unlock_irq(&mapping->tree_lock);
+	return ret;
+}
+
+/*
+ * Flush the mapping to the persistent domain within the byte range of [start,
+ * end]. This is required by data integrity operations to ensure file data is
+ * on persistent storage prior to completion of the operation.
+ */
+int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+		loff_t end)
+{
+	struct inode *inode = mapping->host;
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	pgoff_t start_index, end_index, pmd_index;
+	pgoff_t indices[PAGEVEC_SIZE];
+	struct pagevec pvec;
+	bool done = false;
+	int i, ret = 0;
+	void *entry;
+
+	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
+		return -EIO;
+
+	start_index = start >> PAGE_CACHE_SHIFT;
+	end_index = end >> PAGE_CACHE_SHIFT;
+	pmd_index = DAX_PMD_INDEX(start_index);
+
+	rcu_read_lock();
+	entry = radix_tree_lookup(&mapping->page_tree, pmd_index);
+	rcu_read_unlock();
+
+	/* see if the start of our range is covered by a PMD entry */
+	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+		start_index = pmd_index;
+
+	tag_pages_for_writeback(mapping, start_index, end_index);
+
+	pagevec_init(&pvec, 0);
+	while (!done) {
+		pvec.nr = find_get_entries_tag(mapping, start_index,
+				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
+				pvec.pages, indices);
+
+		if (pvec.nr == 0)
+			break;
+
+		for (i = 0; i < pvec.nr; i++) {
+			if (indices[i] > end_index) {
+				done = true;
+				break;
+			}
+
+			ret = dax_writeback_one(bdev, mapping, indices[i],
+					pvec.pages[i]);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	wmb_pmem();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
+
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -363,6 +557,11 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
+	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
+			vmf->flags & FAULT_FLAG_WRITE);
+	if (error)
+		goto out;
+
 	error = vm_insert_mixed(vma, vaddr, dax.pfn);
 
  out:
@@ -487,6 +686,7 @@ int __dax_fault(struct vm_area_struct *v
 		delete_from_page_cache(page);
 		unlock_page(page);
 		page_cache_release(page);
+		page = NULL;
 	}
 
 	/*
@@ -589,9 +789,9 @@ int __dax_pmd_fault(struct vm_area_struc
 	bool write = flags & FAULT_FLAG_WRITE;
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
-	loff_t lstart, lend;
 	sector_t block;
-	int result = 0;
+	int error, result = 0;
+	bool alloc = false;
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
@@ -629,10 +829,17 @@ int __dax_pmd_fault(struct vm_area_struc
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-	if (get_block(inode, block, &bh, write) != 0)
+
+	if (get_block(inode, block, &bh, 0) != 0)
 		return VM_FAULT_SIGBUS;
+
+	if (!buffer_mapped(&bh) && write) {
+		if (get_block(inode, block, &bh, 1) != 0)
+			return VM_FAULT_SIGBUS;
+		alloc = true;
+	}
+
 	bdev = bh.b_bdev;
-	i_mmap_lock_read(mapping);
 
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
@@ -641,15 +848,20 @@ int __dax_pmd_fault(struct vm_area_struc
 	 */
 	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
 		dax_pmd_dbg(&bh, address, "allocated block too small");
-		goto fallback;
+		return VM_FAULT_FALLBACK;
+	}
+
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (alloc) {
+		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
+
+		truncate_pagecache_range(inode, lstart, lend);
 	}
 
-	/* make sure no process has any zero pages covering this hole */
-	lstart = pgoff << PAGE_SHIFT;
-	lend = lstart + PMD_SIZE - 1; /* inclusive */
-	i_mmap_unlock_read(mapping);
-	unmap_mapping_range(mapping, lstart, PMD_SIZE, 0);
-	truncate_inode_pages_range(mapping, lstart, lend);
 	i_mmap_lock_read(mapping);
 
 	/*
@@ -733,6 +945,31 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
+		/*
+		 * For PTE faults we insert a radix tree entry for reads, and
+		 * leave it clean.  Then on the first write we dirty the radix
+		 * tree entry via the dax_pfn_mkwrite() path.  This sequence
+		 * allows the dax_pfn_mkwrite() call to be simpler and avoid a
+		 * call into get_block() to translate the pgoff to a sector in
+		 * order to be able to create a new radix tree entry.
+		 *
+		 * The PMD path doesn't have an equivalent to
+		 * dax_pfn_mkwrite(), though, so for a read followed by a
+		 * write we traverse all the way through __dax_pmd_fault()
+		 * twice.  This means we can just skip inserting a radix tree
+		 * entry completely on the initial read and just wait until
+		 * the write to insert a dirty entry.
+		 */
+		if (write) {
+			error = dax_radix_entry(mapping, pgoff, dax.sector,
+					true, true);
+			if (error) {
+				dax_pmd_dbg(&bh, address,
+						"PMD radix insertion failed");
+				goto fallback;
+			}
+		}
+
 		dev_dbg(part_to_dev(bdev->bd_part),
 				"%s: %s addr: %lx pfn: %lx sect: %llx\n",
 				__func__, current->comm, address,
@@ -791,15 +1028,20 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
  * dax_pfn_mkwrite - handle first write to DAX page
  * @vma: The virtual memory area where the fault occurred
  * @vmf: The description of the fault
- *
  */
 int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+	struct file *file = vma->vm_file;
 
-	sb_start_pagefault(sb);
-	file_update_time(vma->vm_file);
-	sb_end_pagefault(sb);
+	/*
+	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
+	 * RADIX_DAX_PTE entry already exists in the radix tree from a
+	 * previous call to __dax_fault().  We just want to look up that PTE
+	 * entry using vmf->pgoff and make sure the dirty tag is set.  This
+	 * saves us from having to make a call to get_block() here to look
+	 * up the sector.
+	 */
+	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
diff -puN include/linux/dax.h~dax-add-support-for-fsync-sync include/linux/dax.h
--- a/include/linux/dax.h~dax-add-support-for-fsync-sync
+++ a/include/linux/dax.h
@@ -41,4 +41,6 @@ static inline bool dax_mapping(struct ad
 {
 	return mapping->host && IS_DAX(mapping->host);
 }
+int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+		loff_t end);
 #endif
diff -puN mm/filemap.c~dax-add-support-for-fsync-sync mm/filemap.c
--- a/mm/filemap.c~dax-add-support-for-fsync-sync
+++ a/mm/filemap.c
@@ -482,6 +482,12 @@ int filemap_write_and_wait_range(struct
 {
 	int err = 0;
 
+	if (dax_mapping(mapping) && mapping->nrexceptional) {
+		err = dax_writeback_mapping_range(mapping, lstart, lend);
+		if (err)
+			return err;
+	}
+
 	if (mapping->nrpages) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


