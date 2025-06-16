Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2371B223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115507; cv=none; b=O8/az46zqa3SL8g/Q6pAGd8BNrQ/6zBdkQzTfogge2qUXGR554dowX+aIFeq3PB+eHDt0EQm66Wa4S0qCjPqE1vz37RCXibg6WzAyHt0DXMPmy/o54xysChFEi6hhvs1boqpo223w/AE/8y8QjKHrgk9dEIWmE0hO9AJdvqBoDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115507; c=relaxed/simple;
	bh=S5V4BpFAygLhn7uIPOTp5DMJdd84NOcymzG6OGCnTQY=;
	h=Date:To:From:Subject:Message-Id; b=axPros1YK6ZRYT6vXyp4ev+mjA3uHQk8Iq1F08Uq5W3Jn55SnzkzsliHR2UrNyQZ7olxOFIi1nt1jkGGGlCNqo2RtwIfZCOikY1+krR40dcZ81O3y/FCr+evMnb+LnVz54UkaHNBXBhRnuj6S6MUlXU94hSJaJ+GjP6j2ifYUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xJy+tX8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xJy+tX8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF13C4CEEA;
	Mon, 16 Jun 2025 23:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115506;
	bh=S5V4BpFAygLhn7uIPOTp5DMJdd84NOcymzG6OGCnTQY=;
	h=Date:To:From:Subject:From;
	b=xJy+tX8c8rZykG/pkckYleS+emcbnRQyUyRgiiYKiFP93K0F73KUkl7oy3uy/k63o
	 z8QqzqZMauWUtKRoU+jMRHaOfy7hsxD5Cq7SPF05CYqFN8M3bIKrEyZYFWxH46ViUQ
	 6kc1U3R5X9hXUsACEyTyHLeaxQh0I2uTjk5diKlo=
Date: Mon, 16 Jun 2025 16:11:46 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20250616231146.ACF13C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: convert simple use of generic_file_*_mmap() to .mmap_prepare()
has been added to the -mm mm-new branch.  Its filename is
     fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch

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
Subject: fs: convert simple use of generic_file_*_mmap() to .mmap_prepare()
Date: Mon, 16 Jun 2025 20:33:27 +0100

Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), the f_op->mmap() hook has been deprecated in favour of
f_op->mmap_prepare().

We have provided generic .mmap_prepare() equivalents, so update all file
systems that specify these directly in their file_operations structures.

This updates 9p, adfs, affs, bfs, fat, hfs, hfsplus, hostfs, hpfs, jffs2,
jfs, minix, omfs, ramfs and ufs file systems directly.

It updates generic_ro_fops which impacts qnx4, cramfs, befs, squashfs,
frebxfs, qnx6, efs, romfs, erofs and isofs file systems.

There are remaining file systems which use generic hooks in a less direct
way which we address in a subsequent commit.

Link: https://lkml.kernel.org/r/c7dc90e44a9e75e750939ea369290d6e441a18e6.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_file.c        |    2 +-
 fs/adfs/file.c          |    2 +-
 fs/affs/file.c          |    2 +-
 fs/bfs/file.c           |    2 +-
 fs/fat/file.c           |    2 +-
 fs/hfs/inode.c          |    2 +-
 fs/hfsplus/inode.c      |    2 +-
 fs/hostfs/hostfs_kern.c |    2 +-
 fs/hpfs/file.c          |    2 +-
 fs/jffs2/file.c         |    2 +-
 fs/jfs/file.c           |    2 +-
 fs/minix/file.c         |    2 +-
 fs/omfs/file.c          |    2 +-
 fs/ramfs/file-mmu.c     |    2 +-
 fs/read_write.c         |    2 +-
 fs/ufs/file.c           |    2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/9p/vfs_file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/9p/vfs_file.c
@@ -516,7 +516,7 @@ const struct file_operations v9fs_file_o
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
-	.mmap = generic_file_readonly_mmap,
+	.mmap_prepare = generic_file_readonly_mmap_prepare,
 	.splice_read = v9fs_file_splice_read,
 	.splice_write = iter_file_splice_write,
 	.fsync = v9fs_file_fsync,
--- a/fs/adfs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/adfs/file.c
@@ -25,7 +25,7 @@
 const struct file_operations adfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.fsync		= generic_file_fsync,
 	.write_iter	= generic_file_write_iter,
 	.splice_read	= filemap_splice_read,
--- a/fs/affs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/affs/file.c
@@ -999,7 +999,7 @@ const struct file_operations affs_file_o
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= affs_file_open,
 	.release	= affs_file_release,
 	.fsync		= affs_file_fsync,
--- a/fs/bfs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/bfs/file.c
@@ -27,7 +27,7 @@ const struct file_operations bfs_file_op
 	.llseek 	= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 };
 
--- a/fs/fat/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/fat/file.c
@@ -204,7 +204,7 @@ const struct file_operations fat_file_op
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.release	= fat_file_release,
 	.unlocked_ioctl	= fat_generic_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
--- a/fs/hfs/inode.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/hfs/inode.c
@@ -690,7 +690,7 @@ static const struct file_operations hfs_
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 	.fsync		= hfs_file_fsync,
 	.open		= hfs_file_open,
--- a/fs/hfsplus/inode.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/hfsplus/inode.c
@@ -366,7 +366,7 @@ static const struct file_operations hfsp
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
--- a/fs/hostfs/hostfs_kern.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/hostfs/hostfs_kern.c
@@ -382,7 +382,7 @@ static const struct file_operations host
 	.splice_write	= iter_file_splice_write,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.open		= hostfs_open,
 	.release	= hostfs_file_release,
 	.fsync		= hostfs_fsync,
--- a/fs/hpfs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/hpfs/file.c
@@ -255,7 +255,7 @@ const struct file_operations hpfs_file_o
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.release	= hpfs_file_release,
 	.fsync		= hpfs_file_fsync,
 	.splice_read	= filemap_splice_read,
--- a/fs/jffs2/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/jffs2/file.c
@@ -54,7 +54,7 @@ const struct file_operations jffs2_file_
  	.read_iter =	generic_file_read_iter,
  	.write_iter =	generic_file_write_iter,
 	.unlocked_ioctl=jffs2_ioctl,
-	.mmap =		generic_file_readonly_mmap,
+	.mmap_prepare =	generic_file_readonly_mmap_prepare,
 	.fsync =	jffs2_fsync,
 	.splice_read =	filemap_splice_read,
 	.splice_write = iter_file_splice_write,
--- a/fs/jfs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/jfs/file.c
@@ -143,7 +143,7 @@ const struct file_operations jfs_file_op
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= jfs_fsync,
--- a/fs/minix/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/minix/file.c
@@ -17,7 +17,7 @@ const struct file_operations minix_file_
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.fsync		= generic_file_fsync,
 	.splice_read	= filemap_splice_read,
 };
--- a/fs/omfs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/omfs/file.c
@@ -332,7 +332,7 @@ const struct file_operations omfs_file_o
 	.llseek = generic_file_llseek,
 	.read_iter = generic_file_read_iter,
 	.write_iter = generic_file_write_iter,
-	.mmap = generic_file_mmap,
+	.mmap_prepare = generic_file_mmap_prepare,
 	.fsync = generic_file_fsync,
 	.splice_read = filemap_splice_read,
 };
--- a/fs/ramfs/file-mmu.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/ramfs/file-mmu.c
@@ -41,7 +41,7 @@ static unsigned long ramfs_mmu_get_unmap
 const struct file_operations ramfs_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.fsync		= noop_fsync,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
--- a/fs/read_write.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/read_write.c
@@ -28,7 +28,7 @@
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
-	.mmap		= generic_file_readonly_mmap,
+	.mmap_prepare	= generic_file_readonly_mmap_prepare,
 	.splice_read	= filemap_splice_read,
 };
 
--- a/fs/ufs/file.c~fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare
+++ a/fs/ufs/file.c
@@ -38,7 +38,7 @@ const struct file_operations ufs_file_op
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
+	.mmap_prepare	= generic_file_mmap_prepare,
 	.open           = generic_file_open,
 	.fsync		= generic_file_fsync,
 	.splice_read	= filemap_splice_read,
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

