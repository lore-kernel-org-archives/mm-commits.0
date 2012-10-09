From: akpm@linux-foundation.org
Subject: [merged] mm-kill-vma-flag-vm_can_nonlinear.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:00 -0700
Message-ID: <20121009180601.18D7D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62892 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:03 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660175ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill vma flag VM_CAN_NONLINEAR
has been removed from the -mm tree.  Its filename was
     mm-kill-vma-flag-vm_can_nonlinear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: kill vma flag VM_CAN_NONLINEAR

Move actual pte filling for non-linear file mappings into the new special
vma operation: ->remap_pages().

Filesystems must implement this method to get non-linear mapping support,
if it uses filemap_fault() then generic_file_remap_pages() can be used.

Now device drivers can implement this method and obtain nonlinear vma support.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>	#arch/tile
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/ashmem.c |    1 -
 fs/9p/vfs_file.c                 |    1 +
 fs/btrfs/file.c                  |    2 +-
 fs/ceph/addr.c                   |    2 +-
 fs/cifs/file.c                   |    1 +
 fs/ext4/file.c                   |    2 +-
 fs/fuse/file.c                   |    1 +
 fs/gfs2/file.c                   |    2 +-
 fs/nfs/file.c                    |    1 +
 fs/nilfs2/file.c                 |    2 +-
 fs/ocfs2/mmap.c                  |    2 +-
 fs/ubifs/file.c                  |    1 +
 fs/xfs/xfs_file.c                |    2 +-
 include/linux/fs.h               |    2 ++
 include/linux/mm.h               |    7 ++++---
 mm/filemap.c                     |    2 +-
 mm/filemap_xip.c                 |    3 ++-
 mm/fremap.c                      |   14 ++++++++------
 mm/mmap.c                        |    3 +--
 mm/nommu.c                       |    8 ++++++++
 mm/shmem.c                       |    3 +--
 21 files changed, 39 insertions(+), 23 deletions(-)

diff -puN drivers/staging/android/ashmem.c~mm-kill-vma-flag-vm_can_nonlinear drivers/staging/android/ashmem.c
--- a/drivers/staging/android/ashmem.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/drivers/staging/android/ashmem.c
@@ -332,7 +332,6 @@ static int ashmem_mmap(struct file *file
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = asma->file;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 
 out:
 	mutex_unlock(&ashmem_mutex);
diff -puN fs/9p/vfs_file.c~mm-kill-vma-flag-vm_can_nonlinear fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/9p/vfs_file.c
@@ -738,6 +738,7 @@ v9fs_cached_file_write(struct file *filp
 static const struct vm_operations_struct v9fs_file_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 
diff -puN fs/btrfs/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/btrfs/file.c
--- a/fs/btrfs/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/btrfs/file.c
@@ -1599,6 +1599,7 @@ out:
 static const struct vm_operations_struct btrfs_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite	= btrfs_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
@@ -1610,7 +1611,6 @@ static int btrfs_file_mmap(struct file	*
 
 	file_accessed(filp);
 	vma->vm_ops = &btrfs_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 
 	return 0;
 }
diff -puN fs/ceph/addr.c~mm-kill-vma-flag-vm_can_nonlinear fs/ceph/addr.c
--- a/fs/ceph/addr.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/ceph/addr.c
@@ -1224,6 +1224,7 @@ out:
 static struct vm_operations_struct ceph_vmops = {
 	.fault		= filemap_fault,
 	.page_mkwrite	= ceph_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 int ceph_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1234,6 +1235,5 @@ int ceph_mmap(struct file *file, struct 
 		return -ENOEXEC;
 	file_accessed(file);
 	vma->vm_ops = &ceph_vmops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
diff -puN fs/cifs/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/cifs/file.c
--- a/fs/cifs/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/cifs/file.c
@@ -3003,6 +3003,7 @@ cifs_page_mkwrite(struct vm_area_struct 
 static struct vm_operations_struct cifs_file_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = cifs_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/ext4/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/ext4/file.c
--- a/fs/ext4/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/ext4/file.c
@@ -207,6 +207,7 @@ ext4_file_write(struct kiocb *iocb, cons
 static const struct vm_operations_struct ext4_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite   = ext4_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
@@ -217,7 +218,6 @@ static int ext4_file_mmap(struct file *f
 		return -ENOEXEC;
 	file_accessed(file);
 	vma->vm_ops = &ext4_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
diff -puN fs/fuse/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/fuse/file.c
--- a/fs/fuse/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/fuse/file.c
@@ -1379,6 +1379,7 @@ static const struct vm_operations_struct
 	.close		= fuse_vma_close,
 	.fault		= filemap_fault,
 	.page_mkwrite	= fuse_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/gfs2/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/gfs2/file.c
--- a/fs/gfs2/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/gfs2/file.c
@@ -492,6 +492,7 @@ out:
 static const struct vm_operations_struct gfs2_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = gfs2_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 /**
@@ -526,7 +527,6 @@ static int gfs2_mmap(struct file *file, 
 			return error;
 	}
 	vma->vm_ops = &gfs2_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 
 	return 0;
 }
diff -puN fs/nfs/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/nfs/file.c
--- a/fs/nfs/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/nfs/file.c
@@ -578,6 +578,7 @@ out:
 static const struct vm_operations_struct nfs_file_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = nfs_vm_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 static int nfs_need_sync_write(struct file *filp, struct inode *inode)
diff -puN fs/nilfs2/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/nilfs2/file.c
@@ -135,13 +135,13 @@ static int nilfs_page_mkwrite(struct vm_
 static const struct vm_operations_struct nilfs_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite	= nilfs_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &nilfs_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
diff -puN fs/ocfs2/mmap.c~mm-kill-vma-flag-vm_can_nonlinear fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/ocfs2/mmap.c
@@ -173,6 +173,7 @@ out:
 static const struct vm_operations_struct ocfs2_file_vm_ops = {
 	.fault		= ocfs2_fault,
 	.page_mkwrite	= ocfs2_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
@@ -188,7 +189,6 @@ int ocfs2_mmap(struct file *file, struct
 	ocfs2_inode_unlock(file->f_dentry->d_inode, lock_level);
 out:
 	vma->vm_ops = &ocfs2_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
diff -puN fs/ubifs/file.c~mm-kill-vma-flag-vm_can_nonlinear fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/ubifs/file.c
@@ -1536,6 +1536,7 @@ out_unlock:
 static const struct vm_operations_struct ubifs_file_vm_ops = {
 	.fault        = filemap_fault,
 	.page_mkwrite = ubifs_vm_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 static int ubifs_file_mmap(struct file *file, struct vm_area_struct *vma)
diff -puN fs/xfs/xfs_file.c~mm-kill-vma-flag-vm_can_nonlinear fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/fs/xfs/xfs_file.c
@@ -940,7 +940,6 @@ xfs_file_mmap(
 	struct vm_area_struct *vma)
 {
 	vma->vm_ops = &xfs_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 
 	file_accessed(filp);
 	return 0;
@@ -1443,4 +1442,5 @@ const struct file_operations xfs_dir_fil
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite	= xfs_vm_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
diff -puN include/linux/fs.h~mm-kill-vma-flag-vm_can_nonlinear include/linux/fs.h
--- a/include/linux/fs.h~mm-kill-vma-flag-vm_can_nonlinear
+++ a/include/linux/fs.h
@@ -2552,6 +2552,8 @@ extern int sb_min_blocksize(struct super
 
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
+extern int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
+		unsigned long size, pgoff_t pgoff);
 extern int file_read_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsigned long, loff_t);
diff -puN include/linux/mm.h~mm-kill-vma-flag-vm_can_nonlinear include/linux/mm.h
--- a/include/linux/mm.h~mm-kill-vma-flag-vm_can_nonlinear
+++ a/include/linux/mm.h
@@ -105,7 +105,6 @@ extern unsigned int kobjsize(const void 
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
 #define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
-#define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
@@ -171,8 +170,7 @@ extern pgprot_t protection_map[16];
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
  * pgoff should be used in favour of virtual_address, if possible. If pgoff
- * is used, one may set VM_CAN_NONLINEAR in the vma->vm_flags to get nonlinear
- * mapping support.
+ * is used, one may implement ->remap_pages to get nonlinear mapping support.
  */
 struct vm_fault {
 	unsigned int flags;		/* FAULT_FLAG_xxx flags */
@@ -230,6 +228,9 @@ struct vm_operations_struct {
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
+	/* called by sys_remap_file_pages() to populate non-linear mapping */
+	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
+			   unsigned long size, pgoff_t pgoff);
 };
 
 struct mmu_gather;
diff -puN mm/filemap.c~mm-kill-vma-flag-vm_can_nonlinear mm/filemap.c
--- a/mm/filemap.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/filemap.c
@@ -1737,6 +1737,7 @@ EXPORT_SYMBOL(filemap_page_mkwrite);
 const struct vm_operations_struct generic_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite	= filemap_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
 };
 
 /* This is used for a general mmap of a disk file */
@@ -1749,7 +1750,6 @@ int generic_file_mmap(struct file * file
 		return -ENOEXEC;
 	file_accessed(file);
 	vma->vm_ops = &generic_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
diff -puN mm/filemap_xip.c~mm-kill-vma-flag-vm_can_nonlinear mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/filemap_xip.c
@@ -305,6 +305,7 @@ out:
 static const struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,
 	.page_mkwrite	= filemap_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
 };
 
 int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
@@ -313,7 +314,7 @@ int xip_file_mmap(struct file * file, st
 
 	file_accessed(file);
 	vma->vm_ops = &xip_file_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR | VM_MIXEDMAP;
+	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_file_mmap);
diff -puN mm/fremap.c~mm-kill-vma-flag-vm_can_nonlinear mm/fremap.c
--- a/mm/fremap.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/fremap.c
@@ -5,6 +5,7 @@
  *
  * started by Ingo Molnar, Copyright (C) 2002, 2003
  */
+#include <linux/export.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
@@ -80,9 +81,10 @@ out:
 	return err;
 }
 
-static int populate_range(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long addr, unsigned long size, pgoff_t pgoff)
+int generic_file_remap_pages(struct vm_area_struct *vma, unsigned long addr,
+			     unsigned long size, pgoff_t pgoff)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int err;
 
 	do {
@@ -95,9 +97,9 @@ static int populate_range(struct mm_stru
 		pgoff++;
 	} while (size);
 
-        return 0;
-
+	return 0;
 }
+EXPORT_SYMBOL(generic_file_remap_pages);
 
 /**
  * sys_remap_file_pages - remap arbitrary pages of an existing VM_SHARED vma
@@ -167,7 +169,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
 		goto out;
 
-	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
+	if (!vma->vm_ops->remap_pages)
 		goto out;
 
 	if (start < vma->vm_start || start + size > vma->vm_end)
@@ -228,7 +230,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	}
 
 	mmu_notifier_invalidate_range_start(mm, start, start + size);
-	err = populate_range(mm, vma, start, size, pgoff);
+	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
 	mmu_notifier_invalidate_range_end(mm, start, start + size);
 	if (!err && !(flags & MAP_NONBLOCK)) {
 		if (vma->vm_flags & VM_LOCKED) {
diff -puN mm/mmap.c~mm-kill-vma-flag-vm_can_nonlinear mm/mmap.c
--- a/mm/mmap.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/mmap.c
@@ -669,8 +669,7 @@ again:			remove_next = 1 + (end > next->
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	/* VM_CAN_NONLINEAR may get set later by f_op->mmap() */
-	if ((vma->vm_flags ^ vm_flags) & ~VM_CAN_NONLINEAR)
+	if (vma->vm_flags ^ vm_flags)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
diff -puN mm/nommu.c~mm-kill-vma-flag-vm_can_nonlinear mm/nommu.c
--- a/mm/nommu.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/nommu.c
@@ -1961,6 +1961,14 @@ int filemap_fault(struct vm_area_struct 
 }
 EXPORT_SYMBOL(filemap_fault);
 
+int generic_file_remap_pages(struct vm_area_struct *vma, unsigned long addr,
+			     unsigned long size, pgoff_t pgoff)
+{
+	BUG();
+	return 0;
+}
+EXPORT_SYMBOL(generic_file_remap_pages);
+
 static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long addr, void *buf, int len, int write)
 {
diff -puN mm/shmem.c~mm-kill-vma-flag-vm_can_nonlinear mm/shmem.c
--- a/mm/shmem.c~mm-kill-vma-flag-vm_can_nonlinear
+++ a/mm/shmem.c
@@ -1339,7 +1339,6 @@ static int shmem_mmap(struct file *file,
 {
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
@@ -2643,6 +2642,7 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+	.remap_pages	= generic_file_remap_pages,
 };
 
 static struct dentry *shmem_mount(struct file_system_type *fs_type,
@@ -2836,7 +2836,6 @@ int shmem_zero_setup(struct vm_area_stru
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
-	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

