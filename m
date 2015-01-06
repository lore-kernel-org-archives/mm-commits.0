From: akpm@linux-foundation.org
Subject: +
 mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:33:54 -0800
Message-ID: <54ac70e2.RpQIfC5v+iOytKzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbbAFXd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub
has been added to the -mm tree.  Its filename is
     mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch

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
Subject: mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub

Nobody uses it anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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
 include/linux/mm.h |    3 ---
 mm/filemap.c       |    1 -
 mm/filemap_xip.c   |    1 -
 mm/shmem.c         |    1 -
 18 files changed, 26 deletions(-)

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
@@ -3244,7 +3244,6 @@ static struct vm_operations_struct cifs_
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
@@ -285,9 +285,6 @@ struct vm_operations_struct {
 	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
 					unsigned long addr);
 #endif
-	/* called by sys_remap_file_pages() to populate non-linear mapping */
-	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
-			   unsigned long size, pgoff_t pgoff);
 };
 
 struct mmu_gather;
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

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

