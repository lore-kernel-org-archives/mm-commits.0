From: akpm@linux-foundation.org
Subject: [merged] tmpfs-add-shmem_read_mapping_page_gfp.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:22 -0700
Message-ID: <201106282042.p5SKg4NC002965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab1F1UmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: add shmem_read_mapping_page_gfp
has been removed from the -mm tree.  Its filename was
     tmpfs-add-shmem_read_mapping_page_gfp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: add shmem_read_mapping_page_gfp
From: Hugh Dickins <hughd@google.com>

Although it is used (by i915) on nothing but tmpfs, read_cache_page_gfp()
is unsuited to tmpfs, because it inserts a page into pagecache before
calling the filesystem's ->readpage: tmpfs may have pages in swapcache
which only it knows how to locate and switch to filecache.

At present tmpfs provides a ->readpage method, and copes with this by
copying pages; but soon we can simplify it by removing its ->readpage. 
Provide shmem_read_mapping_page_gfp() now, ready for that transition,

Export shmem_read_mapping_page_gfp() and add it to list in shmem_fs.h,
with shmem_read_mapping_page() inline for the common mapping_gfp case.

(shmem_read_mapping_page_gfp or shmem_read_cache_page_gfp?  Generally the
read_mapping_page functions use the mapping's ->readpage, and the
read_cache_page functions use the supplied filler, so I think
read_cache_page_gfp was slightly misnamed.)

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   17 ++++++++++-------
 mm/shmem.c               |   23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+), 7 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-add-shmem_read_mapping_page_gfp include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-add-shmem_read_mapping_page_gfp
+++ a/include/linux/shmem_fs.h
@@ -3,15 +3,9 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/pagemap.h>
 #include <linux/percpu_counter.h>
 
-struct page;
-struct file;
-struct inode;
-struct super_block;
-struct user_struct;
-struct vm_area_struct;
-
 /* inode in-kernel data */
 
 #define SHMEM_NR_DIRECT 16
@@ -61,9 +55,18 @@ extern struct file *shmem_file_setup(con
 					loff_t size, unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
+					pgoff_t index, gfp_t gfp_mask);
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
 extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
 					struct page **pagep, swp_entry_t *ent);
 
+static inline struct page *shmem_read_mapping_page(
+				struct address_space *mapping, pgoff_t index)
+{
+	return shmem_read_mapping_page_gfp(mapping, index,
+					mapping_gfp_mask(mapping));
+}
+
 #endif
diff -puN mm/shmem.c~tmpfs-add-shmem_read_mapping_page_gfp mm/shmem.c
--- a/mm/shmem.c~tmpfs-add-shmem_read_mapping_page_gfp
+++ a/mm/shmem.c
@@ -3035,3 +3035,26 @@ int shmem_zero_setup(struct vm_area_stru
 	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
+
+/**
+ * shmem_read_mapping_page_gfp - read into page cache, using specified page allocation flags.
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @gfp:	the page allocator flags to use if allocating
+ *
+ * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
+ * with any new page allocations done using the specified allocation flags.
+ * But read_cache_page_gfp() uses the ->readpage() method: which does not
+ * suit tmpfs, since it may have pages in swapcache, and needs to find those
+ * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
+ *
+ * Provide a stub for those callers to start using now, then later
+ * flesh it out to call shmem_getpage() with additional gfp mask, when
+ * shmem_file_splice_read() is added and shmem_readpage() is removed.
+ */
+struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
+					 pgoff_t index, gfp_t gfp)
+{
+	return read_cache_page_gfp(mapping, index, gfp);
+}
+EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
_

Patches currently in -mm which might be from hughd@google.com are

mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

