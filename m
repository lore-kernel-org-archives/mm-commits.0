From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-sync.patch added to -mm tree
Date: Tue, 22 Dec 2015 14:46:54 -0800
Message-ID: <5679d2de.9SwY8DE1hD4xXqfx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbLVWq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 17:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, adilger.kernel@dilger.ca, bfields@fieldses.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.com, jlayton@poochiereds.net, matthew.r.wilcox@intel.com, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add support for fsync/sync
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-sync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |  158 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/dax.h |    2 
 mm/filemap.c        |    3 
 3 files changed, 157 insertions(+), 6 deletions(-)

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
@@ -324,6 +325,143 @@ static int copy_user_bh(struct page *to,
 	return 0;
 }
 
+static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
+		void __pmem *addr, bool pmd_entry, bool dirty)
+{
+	struct radix_tree_root *page_tree = &mapping->page_tree;
+	int error = 0;
+	void *entry;
+
+	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	spin_lock_irq(&mapping->tree_lock);
+	entry = radix_tree_lookup(page_tree, index);
+
+	if (entry) {
+		if (!pmd_entry || RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+			goto dirty;
+		radix_tree_delete(&mapping->page_tree, index);
+		mapping->nrdax--;
+	}
+
+	if (!addr) {
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
+	} else if (RADIX_DAX_TYPE(addr)) {
+		WARN_ONCE(1, "%s: invalid address %p\n", __func__, addr);
+		goto unlock;
+	}
+
+	error = radix_tree_insert(page_tree, index,
+			RADIX_DAX_ENTRY(addr, pmd_entry));
+	if (error)
+		goto unlock;
+
+	mapping->nrdax++;
+ dirty:
+	if (dirty)
+		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
+ unlock:
+	spin_unlock_irq(&mapping->tree_lock);
+	return error;
+}
+
+static void dax_writeback_one(struct address_space *mapping, pgoff_t index,
+		void *entry)
+{
+	struct radix_tree_root *page_tree = &mapping->page_tree;
+	int type = RADIX_DAX_TYPE(entry);
+	struct radix_tree_node *node;
+	void **slot;
+
+	if (type != RADIX_DAX_PTE && type != RADIX_DAX_PMD) {
+		WARN_ON_ONCE(1);
+		return;
+	}
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
+	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
+
+	if (type == RADIX_DAX_PMD)
+		wb_cache_pmem(RADIX_DAX_ADDR(entry), PMD_SIZE);
+	else
+		wb_cache_pmem(RADIX_DAX_ADDR(entry), PAGE_SIZE);
+ unlock:
+	spin_unlock_irq(&mapping->tree_lock);
+}
+
+/*
+ * Flush the mapping to the persistent domain within the byte range of [start,
+ * end]. This is required by data integrity operations to ensure file data is
+ * on persistent storage prior to completion of the operation.
+ */
+void dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+		loff_t end)
+{
+	struct inode *inode = mapping->host;
+	pgoff_t indices[PAGEVEC_SIZE];
+	pgoff_t start_page, end_page;
+	struct pagevec pvec;
+	void *entry;
+	int i;
+
+	if (inode->i_blkbits != PAGE_SHIFT) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	rcu_read_lock();
+	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
+	rcu_read_unlock();
+
+	/* see if the start of our range is covered by a PMD entry */
+	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
+		start &= PMD_MASK;
+
+	start_page = start >> PAGE_CACHE_SHIFT;
+	end_page = end >> PAGE_CACHE_SHIFT;
+
+	tag_pages_for_writeback(mapping, start_page, end_page);
+
+	pagevec_init(&pvec, 0);
+	while (1) {
+		pvec.nr = find_get_entries_tag(mapping, start_page,
+				PAGECACHE_TAG_TOWRITE, PAGEVEC_SIZE,
+				pvec.pages, indices);
+
+		if (pvec.nr == 0)
+			break;
+
+		for (i = 0; i < pvec.nr; i++)
+			dax_writeback_one(mapping, indices[i], pvec.pages[i]);
+	}
+	wmb_pmem();
+}
+EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
+
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -364,7 +502,11 @@ static int dax_insert_mapping(struct ino
 	dax_unmap_atomic(bdev, &dax);
 
 	error = vm_insert_mixed(vma, vaddr, dax.pfn);
+	if (error)
+		goto out;
 
+	error = dax_radix_entry(mapping, vmf->pgoff, addr, false,
+			vmf->flags & FAULT_FLAG_WRITE);
  out:
 	i_mmap_unlock_read(mapping);
 
@@ -487,6 +629,7 @@ int __dax_fault(struct vm_area_struct *v
 		delete_from_page_cache(page);
 		unlock_page(page);
 		page_cache_release(page);
+		page = NULL;
 	}
 
 	/*
@@ -590,7 +733,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	struct block_device *bdev;
 	pgoff_t size, pgoff;
 	sector_t block;
-	int result = 0;
+	int error, result = 0;
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
@@ -739,6 +882,12 @@ int __dax_pmd_fault(struct vm_area_struc
 				(unsigned long long) dax.sector);
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
 				dax.pfn, write);
+		if (write) {
+			error = dax_radix_entry(mapping, pgoff, kaddr, true,
+					true);
+			if (error)
+				goto fallback;
+		}
 	}
 
  out:
@@ -790,15 +939,12 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
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
+	dax_radix_entry(file->f_mapping, vmf->pgoff, NULL, false, true);
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
+void dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
+		loff_t end);
 #endif
diff -puN mm/filemap.c~dax-add-support-for-fsync-sync mm/filemap.c
--- a/mm/filemap.c~dax-add-support-for-fsync-sync
+++ a/mm/filemap.c
@@ -482,6 +482,9 @@ int filemap_write_and_wait_range(struct
 {
 	int err = 0;
 
+	if (dax_mapping(mapping) && mapping->nrdax)
+		dax_writeback_mapping_range(mapping, lstart, lend);
+
 	if (mapping->nrpages) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mm-dax-fix-livelock-allow-dax-pmd-mappings-to-become-writeable.patch
pmem-add-wb_cache_pmem-to-the-pmem-api.patch
dax-support-dirty-dax-entries-in-radix-tree.patch
mm-add-find_get_entries_tag.patch
dax-add-support-for-fsync-sync.patch
ext2-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
ext4-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch
xfs-call-dax_pfn_mkwrite-for-dax-fsync-msync.patch

