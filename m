From: akpm@linux-foundation.org
Subject: [merged]
 mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:21:52 -0800
Message-ID: <54dbb9e0.BkLnnah3q/YKDQJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbBKUVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub
has been removed from the -mm tree.  Its filename was
     mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub

Nobody uses it anymore.

[akpm@linux-foundation.org: fix filemap_xip.c]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c   |    2 --
 fs/btrfs/file.c    |    1 -
 fs/ceph/addr.c     |    1 -
 fs/cifs/file.c     |    1 -
 fs/ext4/file.c     |    1 -
 fs/f2fs/file.c     |    1 -
 fs/fuse/file.c     |    1 -
 fs/gfs2/file.c     |    1 -
 fs/nfs/file.c      |    1 -
 fs/nilfs2/file.c   |    1 -
 fs/ocfs2/mmap.c    |    1 -
 fs/ubifs/file.c    |    1 -
 fs/xfs/xfs_file.c  |    1 -
 include/linux/fs.h |    6 ------
 include/linux/mm.h |    4 ----
 mm/filemap.c       |    1 -
 mm/filemap_xip.c   |    1 -
 mm/shmem.c         |    1 -
 18 files changed, 27 deletions(-)

diff -puN fs/9p/vfs_file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/9p/vfs_file.c
@@ -831,7 +831,6 @@ static const struct vm_operations_struct
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
@@ -839,7 +838,6 @@ static const struct vm_operations_struct
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 
diff -puN fs/btrfs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/btrfs/file.c
--- a/fs/btrfs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/btrfs/file.c
@@ -2081,7 +2081,6 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= btrfs_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
diff -puN fs/ceph/addr.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/ceph/addr.c
@@ -1569,7 +1569,6 @@ out:
 static struct vm_operations_struct ceph_vmops = {
 	.fault		= ceph_filemap_fault,
 	.page_mkwrite	= ceph_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 int ceph_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/cifs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/cifs/file.c
--- a/fs/cifs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/cifs/file.c
@@ -3248,7 +3248,6 @@ static struct vm_operations_struct cifs_
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = cifs_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/ext4/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/ext4/file.c
--- a/fs/ext4/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/ext4/file.c
@@ -195,7 +195,6 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite   = ext4_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/f2fs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/f2fs/file.c
--- a/fs/f2fs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/f2fs/file.c
@@ -92,7 +92,6 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= f2fs_vm_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int get_parent_ino(struct inode *inode, nid_t *pino)
diff -puN fs/fuse/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/fuse/file.c
--- a/fs/fuse/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/fuse/file.c
@@ -2062,7 +2062,6 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= fuse_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/gfs2/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/gfs2/file.c
--- a/fs/gfs2/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/gfs2/file.c
@@ -498,7 +498,6 @@ static const struct vm_operations_struct
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = gfs2_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 /**
diff -puN fs/nfs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/nfs/file.c
--- a/fs/nfs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/nfs/file.c
@@ -646,7 +646,6 @@ static const struct vm_operations_struct
 	.fault = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = nfs_vm_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 static int nfs_need_sync_write(struct file *filp, struct inode *inode)
diff -puN fs/nilfs2/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/nilfs2/file.c
@@ -128,7 +128,6 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= nilfs_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/ocfs2/mmap.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/ocfs2/mmap.c
@@ -173,7 +173,6 @@ out:
 static const struct vm_operations_struct ocfs2_file_vm_ops = {
 	.fault		= ocfs2_fault,
 	.page_mkwrite	= ocfs2_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/ubifs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/ubifs/file.c
@@ -1536,7 +1536,6 @@ static const struct vm_operations_struct
 	.fault        = filemap_fault,
 	.map_pages = filemap_map_pages,
 	.page_mkwrite = ubifs_vm_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 static int ubifs_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/xfs/xfs_file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/fs/xfs/xfs_file.c
@@ -1384,5 +1384,4 @@ static const struct vm_operations_struct
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
diff -puN include/linux/fs.h~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub include/linux/fs.h
--- a/include/linux/fs.h~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/include/linux/fs.h
@@ -2481,12 +2481,6 @@ extern int sb_min_blocksize(struct super
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
-static inline int generic_file_remap_pages(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long size, pgoff_t pgoff)
-{
-	BUG();
-	return 0;
-}
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff -puN include/linux/mm.h~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/include/linux/mm.h
@@ -285,10 +285,6 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr);
 #endif
-	/* called by sys_remap_file_pages() to populate non-linear mapping */
-	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
-			   unsigned long size, pgoff_t pgoff);
-
 	/*
 	 * Called by vm_normal_page() for special PTEs to find the
 	 * page for @addr.  This is useful if the default behavior
diff -puN mm/filemap.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub mm/filemap.c
--- a/mm/filemap.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/mm/filemap.c
@@ -2087,7 +2087,6 @@ const struct vm_operations_struct generi
 	.fault		= filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= filemap_page_mkwrite,
-	.remap_pages	= generic_file_remap_pages,
 };
 
 /* This is used for a general mmap of a disk file */
diff -puN mm/filemap_xip.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/mm/filemap_xip.c
@@ -301,7 +301,6 @@ out:
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
 	.page_mkwrite	= filemap_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
 };
 
 int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
diff -puN mm/shmem.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub mm/shmem.c
--- a/mm/shmem.c~mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub
+++ a/mm/shmem.c
@@ -3201,7 +3201,6 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
-	.remap_pages	= generic_file_remap_pages,
 };
 
 static struct dentry *shmem_mount(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-account-pmd-page-tables-to-the-process-fix.patch
mm-account-pmd-page-tables-to-the-process-fix-2.patch
mm-account-pmd-page-tables-to-the-process-fix-3.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

