Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128B92264B3
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115522; cv=none; b=ZSSR/Xjl/RDNbZqmjMtHofvhwAuF8mXjfAY6MwT23m6vlSVI3n6d/0btFo6CK0WdsKYmjm+5sKftlW2qyElBr3w1DIq5Yyxf4v6+CcnLNHEmTvmwrlVSJanHbeQQ7FW0zwKBHDAPB03LmwMvkKbTRbGX737cYbw+hF5DZ92/g24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115522; c=relaxed/simple;
	bh=54jinsUbib1USzFPudIHND2GgsnHFMGgQVo0PLoesUA=;
	h=Date:To:From:Subject:Message-Id; b=Yp4/iESxe7il3GQBYY9Pw31bfifdJdieB6WNndts20Y7Oh49fjPX1+YOdoV45DNvIlrQ+3RXONxFK1iix1Th0S7LT1or5fh6n05Bmq6Dz5zURVukgZEc8N6aDyP+wUU54NxhnVNkRRn3VKPq1PVH8qenTqPfJ+HP/CQKSpl8Iqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKMnJzLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKMnJzLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D746AC4CEEA;
	Mon, 16 Jun 2025 23:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115521;
	bh=54jinsUbib1USzFPudIHND2GgsnHFMGgQVo0PLoesUA=;
	h=Date:To:From:Subject:From;
	b=FKMnJzLw3Gg1POzA3mjJ1P8UTMwpT5fUSVQw1AcnuquvmPCN6mz7CGxcgi7NaanUu
	 IniI0LOFVw77gRByPdIHiklBlXpZwqcz7qVMlCc/c1ukmE7kOIUYqZ1B7Yd1PznIMd
	 ErBg92QUsk3KW/yuUJm1fM0MxDdYM1obDoEhIHbU=
Date: Mon, 16 Jun 2025 16:12:01 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch added to mm-new branch
Message-Id: <20250616231201.D746AC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: replace mmap hook with .mmap_prepare for simple mappings
has been added to the -mm mm-new branch.  Its filename is
     fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fs: replace mmap hook with .mmap_prepare for simple mappings
Date: Mon, 16 Jun 2025 20:33:29 +0100

Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), the f_op->mmap() hook has been deprecated in favour of
f_op->mmap_prepare().

This callback is invoked in the mmap() logic far earlier, so error
handling can be performed more safely without complicated and bug-prone
state unwinding required should an error arise.

This hook also avoids passing a pointer to a not-yet-correctly-established
VMA avoiding any issues with referencing this data structure.

It rather provides a pointer to the new struct vm_area_desc descriptor
type which contains all required state and allows easy setting of required
parameters without any consideration needing to be paid to locking or
reference counts.

Note that nested filesystems like overlayfs are compatible with an
.mmap_prepare() callback since commit bb666b7c2707 ("mm: add
mmap_prepare() compatibility layer for nested file systems").

In this patch we apply this change to file systems with relatively simple
mmap() hook logic - exfat, ceph, f2fs, bcachefs, zonefs, btrfs, ocfs2,
orangefs, nilfs2, romfs, ramfs and aio.

Link: https://lkml.kernel.org/r/f528ac4f35b9378931bd800920fee53fc0c5c74d.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c              |    8 ++++----
 fs/bcachefs/fs.c      |    8 ++++----
 fs/btrfs/file.c       |    7 ++++---
 fs/ceph/addr.c        |    5 +++--
 fs/ceph/file.c        |    2 +-
 fs/ceph/super.h       |    2 +-
 fs/exfat/file.c       |    7 ++++---
 fs/f2fs/file.c        |    7 ++++---
 fs/nilfs2/file.c      |    8 ++++----
 fs/ocfs2/file.c       |    4 ++--
 fs/ocfs2/mmap.c       |    5 +++--
 fs/ocfs2/mmap.h       |    2 +-
 fs/orangefs/file.c    |   10 ++++++----
 fs/ramfs/file-nommu.c |   12 ++++++------
 fs/romfs/mmap-nommu.c |    6 +++---
 fs/zonefs/file.c      |   10 ++++++----
 16 files changed, 56 insertions(+), 47 deletions(-)

--- a/fs/aio.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/aio.c
@@ -392,15 +392,15 @@ static const struct vm_operations_struct
 #endif
 };
 
-static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
+static int aio_ring_mmap_prepare(struct vm_area_desc *desc)
 {
-	vm_flags_set(vma, VM_DONTEXPAND);
-	vma->vm_ops = &aio_ring_vm_ops;
+	desc->vm_flags |= VM_DONTEXPAND;
+	desc->vm_ops = &aio_ring_vm_ops;
 	return 0;
 }
 
 static const struct file_operations aio_ring_fops = {
-	.mmap = aio_ring_mmap,
+	.mmap_prepare = aio_ring_mmap_prepare,
 };
 
 #if IS_ENABLED(CONFIG_MIGRATION)
--- a/fs/bcachefs/fs.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/bcachefs/fs.c
@@ -1553,11 +1553,11 @@ static const struct vm_operations_struct
 	.page_mkwrite   = bch2_page_mkwrite,
 };
 
-static int bch2_mmap(struct file *file, struct vm_area_struct *vma)
+static int bch2_mmap_prepare(struct vm_area_desc *desc)
 {
-	file_accessed(file);
+	file_accessed(desc->file);
 
-	vma->vm_ops = &bch_vm_ops;
+	desc->vm_ops = &bch_vm_ops;
 	return 0;
 }
 
@@ -1740,7 +1740,7 @@ static const struct file_operations bch_
 	.llseek		= bch2_llseek,
 	.read_iter	= bch2_read_iter,
 	.write_iter	= bch2_write_iter,
-	.mmap		= bch2_mmap,
+	.mmap_prepare	= bch2_mmap_prepare,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fsync		= bch2_fsync,
 	.splice_read	= filemap_splice_read,
--- a/fs/btrfs/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/btrfs/file.c
@@ -1978,15 +1978,16 @@ static const struct vm_operations_struct
 	.page_mkwrite	= btrfs_page_mkwrite,
 };
 
-static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
+static int btrfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *filp = desc->file;
 	struct address_space *mapping = filp->f_mapping;
 
 	if (!mapping->a_ops->read_folio)
 		return -ENOEXEC;
 
 	file_accessed(filp);
-	vma->vm_ops = &btrfs_file_vm_ops;
+	desc->vm_ops = &btrfs_file_vm_ops;
 
 	return 0;
 }
@@ -3765,7 +3766,7 @@ const struct file_operations btrfs_file_
 	.splice_read	= filemap_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.splice_write	= iter_file_splice_write,
-	.mmap		= btrfs_file_mmap,
+	.mmap_prepare	= btrfs_file_mmap_prepare,
 	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
 	.get_unmapped_area = thp_get_unmapped_area,
--- a/fs/ceph/addr.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ceph/addr.c
@@ -2330,13 +2330,14 @@ static const struct vm_operations_struct
 	.page_mkwrite	= ceph_page_mkwrite,
 };
 
-int ceph_mmap(struct file *file, struct vm_area_struct *vma)
+int ceph_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct address_space *mapping = file->f_mapping;
 
 	if (!mapping->a_ops->read_folio)
 		return -ENOEXEC;
-	vma->vm_ops = &ceph_vmops;
+	desc->vm_ops = &ceph_vmops;
 	return 0;
 }
 
--- a/fs/ceph/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ceph/file.c
@@ -3170,7 +3170,7 @@ const struct file_operations ceph_file_f
 	.llseek = ceph_llseek,
 	.read_iter = ceph_read_iter,
 	.write_iter = ceph_write_iter,
-	.mmap = ceph_mmap,
+	.mmap_prepare = ceph_mmap_prepare,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
 	.setlease = simple_nosetlease,
--- a/fs/ceph/super.h~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ceph/super.h
@@ -1286,7 +1286,7 @@ extern void __ceph_touch_fmode(struct ce
 /* addr.c */
 extern const struct address_space_operations ceph_aops;
 extern const struct netfs_request_ops ceph_netfs_ops;
-extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
+int ceph_mmap_prepare(struct vm_area_desc *desc);
 extern int ceph_uninline_data(struct file *file);
 extern int ceph_pool_perm_check(struct inode *inode, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
--- a/fs/exfat/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/exfat/file.c
@@ -683,13 +683,14 @@ static const struct vm_operations_struct
 	.page_mkwrite	= exfat_page_mkwrite,
 };
 
-static int exfat_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int exfat_file_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	if (unlikely(exfat_forced_shutdown(file_inode(file)->i_sb)))
 		return -EIO;
 
 	file_accessed(file);
-	vma->vm_ops = &exfat_file_vm_ops;
+	desc->vm_ops = &exfat_file_vm_ops;
 	return 0;
 }
 
@@ -710,7 +711,7 @@ const struct file_operations exfat_file_
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = exfat_compat_ioctl,
 #endif
-	.mmap		= exfat_file_mmap,
+	.mmap_prepare	= exfat_file_mmap_prepare,
 	.fsync		= exfat_file_fsync,
 	.splice_read	= exfat_splice_read,
 	.splice_write	= iter_file_splice_write,
--- a/fs/f2fs/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/f2fs/file.c
@@ -532,8 +532,9 @@ static loff_t f2fs_llseek(struct file *f
 	return -EINVAL;
 }
 
-static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int f2fs_file_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
 
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
@@ -543,7 +544,7 @@ static int f2fs_file_mmap(struct file *f
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
-	vma->vm_ops = &f2fs_file_vm_ops;
+	desc->vm_ops = &f2fs_file_vm_ops;
 
 	f2fs_down_read(&F2FS_I(inode)->i_sem);
 	set_inode_flag(inode, FI_MMAP_FILE);
@@ -5376,7 +5377,7 @@ const struct file_operations f2fs_file_o
 	.iopoll		= iocb_bio_iopoll,
 	.open		= f2fs_file_open,
 	.release	= f2fs_release_file,
-	.mmap		= f2fs_file_mmap,
+	.mmap_prepare	= f2fs_file_mmap_prepare,
 	.flush		= f2fs_file_flush,
 	.fsync		= f2fs_sync_file,
 	.fallocate	= f2fs_fallocate,
--- a/fs/nilfs2/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/nilfs2/file.c
@@ -125,10 +125,10 @@ static const struct vm_operations_struct
 	.page_mkwrite	= nilfs_page_mkwrite,
 };
 
-static int nilfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int nilfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	file_accessed(file);
-	vma->vm_ops = &nilfs_file_vm_ops;
+	file_accessed(desc->file);
+	desc->vm_ops = &nilfs_file_vm_ops;
 	return 0;
 }
 
@@ -144,7 +144,7 @@ const struct file_operations nilfs_file_
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
 #endif	/* CONFIG_COMPAT */
-	.mmap		= nilfs_file_mmap,
+	.mmap_prepare	= nilfs_file_mmap_prepare,
 	.open		= generic_file_open,
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
--- a/fs/ocfs2/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ocfs2/file.c
@@ -2800,7 +2800,7 @@ const struct inode_operations ocfs2_spec
  */
 const struct file_operations ocfs2_fops = {
 	.llseek		= ocfs2_file_llseek,
-	.mmap		= ocfs2_mmap,
+	.mmap_prepare	= ocfs2_mmap_prepare,
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_file_release,
 	.open		= ocfs2_file_open,
@@ -2850,7 +2850,7 @@ const struct file_operations ocfs2_dops
  */
 const struct file_operations ocfs2_fops_no_plocks = {
 	.llseek		= ocfs2_file_llseek,
-	.mmap		= ocfs2_mmap,
+	.mmap_prepare	= ocfs2_mmap_prepare,
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_file_release,
 	.open		= ocfs2_file_open,
--- a/fs/ocfs2/mmap.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ocfs2/mmap.c
@@ -159,8 +159,9 @@ static const struct vm_operations_struct
 	.page_mkwrite	= ocfs2_page_mkwrite,
 };
 
-int ocfs2_mmap(struct file *file, struct vm_area_struct *vma)
+int ocfs2_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	int ret = 0, lock_level = 0;
 
 	ret = ocfs2_inode_lock_atime(file_inode(file),
@@ -171,7 +172,7 @@ int ocfs2_mmap(struct file *file, struct
 	}
 	ocfs2_inode_unlock(file_inode(file), lock_level);
 out:
-	vma->vm_ops = &ocfs2_file_vm_ops;
+	desc->vm_ops = &ocfs2_file_vm_ops;
 	return 0;
 }
 
--- a/fs/ocfs2/mmap.h~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ocfs2/mmap.h
@@ -2,6 +2,6 @@
 #ifndef OCFS2_MMAP_H
 #define OCFS2_MMAP_H
 
-int ocfs2_mmap(struct file *file, struct vm_area_struct *vma);
+int ocfs2_mmap_prepare(struct vm_area_desc *desc);
 
 #endif  /* OCFS2_MMAP_H */
--- a/fs/orangefs/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/orangefs/file.c
@@ -398,8 +398,9 @@ static const struct vm_operations_struct
 /*
  * Memory map a region of a file.
  */
-static int orangefs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int orangefs_file_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
 	int ret;
 
 	ret = orangefs_revalidate_mapping(file_inode(file));
@@ -410,10 +411,11 @@ static int orangefs_file_mmap(struct fil
 		     "orangefs_file_mmap: called on %pD\n", file);
 
 	/* set the sequential readahead hint */
-	vm_flags_mod(vma, VM_SEQ_READ, VM_RAND_READ);
+	desc->vm_flags |= VM_SEQ_READ;
+	desc->vm_flags &= ~VM_RAND_READ;
 
 	file_accessed(file);
-	vma->vm_ops = &orangefs_file_vm_ops;
+	desc->vm_ops = &orangefs_file_vm_ops;
 	return 0;
 }
 
@@ -574,7 +576,7 @@ const struct file_operations orangefs_fi
 	.read_iter	= orangefs_file_read_iter,
 	.write_iter	= orangefs_file_write_iter,
 	.lock		= orangefs_lock,
-	.mmap		= orangefs_file_mmap,
+	.mmap_prepare	= orangefs_file_mmap_prepare,
 	.open		= generic_file_open,
 	.splice_read    = orangefs_file_splice_read,
 	.splice_write   = iter_file_splice_write,
--- a/fs/ramfs/file-nommu.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/ramfs/file-nommu.c
@@ -28,7 +28,7 @@ static unsigned long ramfs_nommu_get_unm
 						   unsigned long len,
 						   unsigned long pgoff,
 						   unsigned long flags);
-static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
+static int ramfs_nommu_mmap_prepare(struct vm_area_desc *desc);
 
 static unsigned ramfs_mmap_capabilities(struct file *file)
 {
@@ -38,7 +38,7 @@ static unsigned ramfs_mmap_capabilities(
 
 const struct file_operations ramfs_file_operations = {
 	.mmap_capabilities	= ramfs_mmap_capabilities,
-	.mmap			= ramfs_nommu_mmap,
+	.mmap_prepare		= ramfs_nommu_mmap_prepare,
 	.get_unmapped_area	= ramfs_nommu_get_unmapped_area,
 	.read_iter		= generic_file_read_iter,
 	.write_iter		= generic_file_write_iter,
@@ -262,12 +262,12 @@ out:
 /*
  * set up a mapping for shared memory segments
  */
-static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
+static int ramfs_nommu_mmap_prepare(struct vm_area_desc *desc)
 {
-	if (!is_nommu_shared_mapping(vma->vm_flags))
+	if (!is_nommu_shared_mapping(desc->vm_flags))
 		return -ENOSYS;
 
-	file_accessed(file);
-	vma->vm_ops = &generic_file_vm_ops;
+	file_accessed(desc->file);
+	desc->vm_ops = &generic_file_vm_ops;
 	return 0;
 }
--- a/fs/romfs/mmap-nommu.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/romfs/mmap-nommu.c
@@ -61,9 +61,9 @@ static unsigned long romfs_get_unmapped_
  * permit a R/O mapping to be made directly through onto an MTD device if
  * possible
  */
-static int romfs_mmap(struct file *file, struct vm_area_struct *vma)
+static int romfs_mmap_prepare(struct vm_area_desc *desc)
 {
-	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
+	return is_nommu_shared_mapping(desc->vm_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned romfs_mmap_capabilities(struct file *file)
@@ -79,7 +79,7 @@ const struct file_operations romfs_ro_fo
 	.llseek			= generic_file_llseek,
 	.read_iter		= generic_file_read_iter,
 	.splice_read		= filemap_splice_read,
-	.mmap			= romfs_mmap,
+	.mmap_prepare		= romfs_mmap_prepare,
 	.get_unmapped_area	= romfs_get_unmapped_area,
 	.mmap_capabilities	= romfs_mmap_capabilities,
 };
--- a/fs/zonefs/file.c~fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings
+++ a/fs/zonefs/file.c
@@ -312,8 +312,10 @@ static const struct vm_operations_struct
 	.page_mkwrite	= zonefs_filemap_page_mkwrite,
 };
 
-static int zonefs_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int zonefs_file_mmap_prepare(struct vm_area_desc *desc)
 {
+	struct file *file = desc->file;
+
 	/*
 	 * Conventional zones accept random writes, so their files can support
 	 * shared writable mappings. For sequential zone files, only read
@@ -321,11 +323,11 @@ static int zonefs_file_mmap(struct file
 	 * ordering between msync() and page cache writeback.
 	 */
 	if (zonefs_inode_is_seq(file_inode(file)) &&
-	    (vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	    (desc->vm_flags & VM_SHARED) && (desc->vm_flags & VM_MAYWRITE))
 		return -EINVAL;
 
 	file_accessed(file);
-	vma->vm_ops = &zonefs_file_vm_ops;
+	desc->vm_ops = &zonefs_file_vm_ops;
 
 	return 0;
 }
@@ -850,7 +852,7 @@ const struct file_operations zonefs_file
 	.open		= zonefs_file_open,
 	.release	= zonefs_file_release,
 	.fsync		= zonefs_file_fsync,
-	.mmap		= zonefs_file_mmap,
+	.mmap_prepare	= zonefs_file_mmap_prepare,
 	.llseek		= zonefs_file_llseek,
 	.read_iter	= zonefs_file_read_iter,
 	.write_iter	= zonefs_file_write_iter,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch
mm-nommu-use-file_has_valid_mmap_hooks-helper.patch
fs-consistently-use-file_has_valid_mmap_hooks-helper.patch
fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch
fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch
fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch
fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare.patch
fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

