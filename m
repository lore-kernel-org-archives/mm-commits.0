From: akpm@linux-foundation.org
Subject: + mm-implement-map_pages-for-page-cache.patch added to -mm tree
Date: Thu, 27 Feb 2014 14:21:27 -0800
Message-ID: <530fba67./kBLKCqzp+doDqRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaB0WV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 17:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, riel@redhat.com, quning@gmail.com, mgorman@suse.de, matthew.r.wilcox@intel.com, david@fromorbit.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-implement-map_pages-for-page-cache.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,david@fromorbit.com,matthew.r.wilcox@intel.com,mgorman@suse.de,quning@gmail.com,riel@redhat.com,torvalds@linux-foundation.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 14:21:27 -0800


The patch titled
     Subject: mm: implement ->map_pages for page cache
has been added to the -mm tree.  Its filename is
     mm-implement-map_pages-for-page-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-implement-map_pages-for-page-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-implement-map_pages-for-page-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: implement ->map_pages for page cache

filemap_map_pages() is generic implementation of ->map_pages() for
filesystems who uses page cache.

It should be safe to use filemap_map_pages() for ->map_pages() if
filesystem use filemap_fault() for ->fault().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ning Qu <quning@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c   |    2 +
 fs/btrfs/file.c    |    1 
 fs/cifs/file.c     |    1 
 fs/ext4/file.c     |    1 
 fs/f2fs/file.c     |    1 
 fs/fuse/file.c     |    1 
 fs/gfs2/file.c     |    1 
 fs/nfs/file.c      |    1 
 fs/nilfs2/file.c   |    1 
 fs/ubifs/file.c    |    1 
 fs/xfs/xfs_file.c  |    1 
 include/linux/mm.h |    1 
 mm/filemap.c       |   72 +++++++++++++++++++++++++++++++++++++++++++
 mm/nommu.c         |    6 +++
 14 files changed, 91 insertions(+)

diff -puN fs/9p/vfs_file.c~mm-implement-map_pages-for-page-cache fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/9p/vfs_file.c
@@ -832,6 +832,7 @@ static void v9fs_mmap_vm_close(struct vm
 
 static const struct vm_operations_struct v9fs_file_vm_ops = {
 	.fault = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
@@ -839,6 +840,7 @@ static const struct vm_operations_struct
 static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
 	.close = v9fs_mmap_vm_close,
 	.fault = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
diff -puN fs/btrfs/file.c~mm-implement-map_pages-for-page-cache fs/btrfs/file.c
--- a/fs/btrfs/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/btrfs/file.c
@@ -1993,6 +1993,7 @@ out:
 
 static const struct vm_operations_struct btrfs_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= btrfs_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN fs/cifs/file.c~mm-implement-map_pages-for-page-cache fs/cifs/file.c
--- a/fs/cifs/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/cifs/file.c
@@ -3125,6 +3125,7 @@ cifs_page_mkwrite(struct vm_area_struct
 
 static struct vm_operations_struct cifs_file_vm_ops = {
 	.fault = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = cifs_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
diff -puN fs/ext4/file.c~mm-implement-map_pages-for-page-cache fs/ext4/file.c
--- a/fs/ext4/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/ext4/file.c
@@ -200,6 +200,7 @@ ext4_file_write(struct kiocb *iocb, cons
 
 static const struct vm_operations_struct ext4_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite   = ext4_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN fs/f2fs/file.c~mm-implement-map_pages-for-page-cache fs/f2fs/file.c
--- a/fs/f2fs/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/f2fs/file.c
@@ -84,6 +84,7 @@ out:
 
 static const struct vm_operations_struct f2fs_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= f2fs_vm_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN fs/fuse/file.c~mm-implement-map_pages-for-page-cache fs/fuse/file.c
--- a/fs/fuse/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/fuse/file.c
@@ -1940,6 +1940,7 @@ static int fuse_page_mkwrite(struct vm_a
 static const struct vm_operations_struct fuse_file_vm_ops = {
 	.close		= fuse_vma_close,
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= fuse_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN fs/gfs2/file.c~mm-implement-map_pages-for-page-cache fs/gfs2/file.c
--- a/fs/gfs2/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/gfs2/file.c
@@ -494,6 +494,7 @@ out:
 
 static const struct vm_operations_struct gfs2_vm_ops = {
 	.fault = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = gfs2_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
diff -puN fs/nfs/file.c~mm-implement-map_pages-for-page-cache fs/nfs/file.c
--- a/fs/nfs/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/nfs/file.c
@@ -617,6 +617,7 @@ out:
 
 static const struct vm_operations_struct nfs_file_vm_ops = {
 	.fault = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = nfs_vm_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
diff -puN fs/nilfs2/file.c~mm-implement-map_pages-for-page-cache fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/nilfs2/file.c
@@ -134,6 +134,7 @@ static int nilfs_page_mkwrite(struct vm_
 
 static const struct vm_operations_struct nilfs_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= nilfs_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN fs/ubifs/file.c~mm-implement-map_pages-for-page-cache fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/ubifs/file.c
@@ -1538,6 +1538,7 @@ out_unlock:
 
 static const struct vm_operations_struct ubifs_file_vm_ops = {
 	.fault        = filemap_fault,
+	.map_pages = filemap_map_pages,
 	.page_mkwrite = ubifs_vm_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
diff -puN fs/xfs/xfs_file.c~mm-implement-map_pages-for-page-cache fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-implement-map_pages-for-page-cache
+++ a/fs/xfs/xfs_file.c
@@ -1465,6 +1465,7 @@ const struct file_operations xfs_dir_fil
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN include/linux/mm.h~mm-implement-map_pages-for-page-cache include/linux/mm.h
--- a/include/linux/mm.h~mm-implement-map_pages-for-page-cache
+++ a/include/linux/mm.h
@@ -1850,6 +1850,7 @@ extern void truncate_inode_pages_final(s
 
 /* generic vm_area_ops exported for stackable file systems */
 extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
+extern void filemap_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 /* mm/page-writeback.c */
diff -puN mm/filemap.c~mm-implement-map_pages-for-page-cache mm/filemap.c
--- a/mm/filemap.c~mm-implement-map_pages-for-page-cache
+++ a/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
+#include <linux/rmap.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -2061,6 +2062,76 @@ page_not_uptodate:
 }
 EXPORT_SYMBOL(filemap_fault);
 
+void filemap_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	loff_t size;
+	struct page *page;
+	unsigned long address = (unsigned long) vmf->virtual_address;
+	unsigned long addr;
+	pte_t *pte;
+
+	rcu_read_lock();
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, vmf->pgoff) {
+		if (iter.index > vmf->max_pgoff)
+			break;
+repeat:
+		page = radix_tree_deref_slot(slot);
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page))
+				break;
+			else
+				goto next;
+		}
+
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *slot)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		if (!PageUptodate(page) ||
+				PageReadahead(page) ||
+				PageHWPoison(page))
+			goto skip;
+		if (!trylock_page(page))
+			goto skip;
+
+		if (page->mapping != mapping || !PageUptodate(page))
+			goto unlock;
+
+		size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
+		if (page->index >= size	>> PAGE_CACHE_SHIFT)
+			goto unlock;
+
+		pte = vmf->pte + page->index - vmf->pgoff;
+		if (!pte_none(*pte))
+			goto unlock;
+
+		if (file->f_ra.mmap_miss > 0)
+			file->f_ra.mmap_miss--;
+		addr = address + (page->index - vmf->pgoff) * PAGE_SIZE;
+		do_set_pte(vma, addr, page, pte, false, false);
+		unlock_page(page);
+		goto next;
+unlock:
+		unlock_page(page);
+skip:
+		page_cache_release(page);
+next:
+		if (page->index == vmf->max_pgoff)
+			break;
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(filemap_map_pages);
+
 int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page = vmf->page;
@@ -2090,6 +2161,7 @@ EXPORT_SYMBOL(filemap_page_mkwrite);
 
 const struct vm_operations_struct generic_file_vm_ops = {
 	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= filemap_page_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
diff -puN mm/nommu.c~mm-implement-map_pages-for-page-cache mm/nommu.c
--- a/mm/nommu.c~mm-implement-map_pages-for-page-cache
+++ a/mm/nommu.c
@@ -1985,6 +1985,12 @@ int filemap_fault(struct vm_area_struct
 }
 EXPORT_SYMBOL(filemap_fault);
 
+void filemap_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	BUG();
+}
+EXPORT_SYMBOL(filemap_map_pages);
+
 int generic_file_remap_pages(struct vm_area_struct *vma, unsigned long addr,
 			     unsigned long size, pgoff_t pgoff)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch

