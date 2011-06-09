From: akpm@linux-foundation.org
Subject: + tmpfs-add-shmem_read_mapping_page_gfp.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:25 -0700
Message-ID: <201106092242.p59MgPaI005033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916Ab1FIWrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hch@infradead.org


The patch titled
     tmpfs: add shmem_read_mapping_page_gfp
has been added to the -mm tree.  Its filename is
     tmpfs-add-shmem_read_mapping_page_gfp.patch

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

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

