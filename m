Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB4C223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115504; cv=none; b=IEs0bf1mIlRZBKXbgBDkHh8npn0R6GPMTdrb0NHaPaixoSQ3VdcJOVW/mtFFa/aSVJ4twaOPaeECG2Bam5CC+LqhxB+Sxl6TiqhIDUAbTvrfJWgUphiWClsGd30jdRXYmY+Swz5Nsg3z1rChuQTFibTFbd/hH7PbM320n8ylqlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115504; c=relaxed/simple;
	bh=oD/NXSroIlZ+G+N4WJhXeZBxmIpq9BHG5J274PiZ5uI=;
	h=Date:To:From:Subject:Message-Id; b=eu/xf5RO9AJm+kooxIsLQ1Am5j+AMVNqBXBJTrhx9U2i4Rqg2W/dTkSaEozU84ppcLQxDUYGNgJdrlJEM2A/D6L1Hj8q/c/+Kb7Mfryxni8T78XjsrlxuDiWx8JUy02eN48pB55qUdUGmG/EleBbglyCwqJrjJgMOsGMz9FVdPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AEWmia0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AEWmia0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30044C4CEEA;
	Mon, 16 Jun 2025 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115504;
	bh=oD/NXSroIlZ+G+N4WJhXeZBxmIpq9BHG5J274PiZ5uI=;
	h=Date:To:From:Subject:From;
	b=AEWmia0jN1QVnZEEcdHipmPXTfYT+cC2IxPls+89ejbNCsm0Te9RtcI8RKp5OnB9A
	 R9QsaXuJ8ifk+PqI6EdvJjToRrgQ2CKaZfvMAHUtHVlsMYalew0MOxbsuWRdieJw22
	 ZZoXMZVEwl3CZIbYRqpdTx/VmZrBlXfFnizwhqMI=
Date: Mon, 16 Jun 2025 16:11:43 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch added to mm-new branch
Message-Id: <20250616231144.30044C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: introduce generic_file_*_mmap_prepare() helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch

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
Subject: mm/filemap: introduce generic_file_*_mmap_prepare() helpers
Date: Mon, 16 Jun 2025 20:33:26 +0100

Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), the f_op->mmap() hook has been deprecated in favour of
f_op->mmap_prepare().

The generic mmap handlers are very simple, so we can very easily convert
these in advance of converting file systems which use them.

This patch does so.

Link: https://lkml.kernel.org/r/30622c1f0b98c66840bc8c02668bda276a810b70.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 ++++--
 mm/filemap.c       |   29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

--- a/include/linux/fs.h~mm-filemap-introduce-generic_file__mmap_prepare-helpers
+++ a/include/linux/fs.h
@@ -3395,8 +3395,10 @@ extern void inode_add_lru(struct inode *
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);
 
-extern int generic_file_mmap(struct file *, struct vm_area_struct *);
-extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
+int generic_file_mmap(struct file *, struct vm_area_struct *);
+int generic_file_mmap_prepare(struct vm_area_desc *desc);
+int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
+int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 int generic_write_checks_count(struct kiocb *iocb, loff_t *count);
 extern int generic_write_check_limits(struct file *file, loff_t pos,
--- a/mm/filemap.c~mm-filemap-introduce-generic_file__mmap_prepare-helpers
+++ a/mm/filemap.c
@@ -3847,6 +3847,18 @@ int generic_file_mmap(struct file *file,
 	return 0;
 }
 
+int generic_file_mmap_prepare(struct vm_area_desc *desc)
+{
+	struct file *file = desc->file;
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->read_folio)
+		return -ENOEXEC;
+	file_accessed(file);
+	desc->vm_ops = &generic_file_vm_ops;
+	return 0;
+}
+
 /*
  * This is for filesystems which do not implement ->writepage.
  */
@@ -3856,6 +3868,13 @@ int generic_file_readonly_mmap(struct fi
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
+
+int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
+{
+	if (is_shared_maywrite(desc->vm_flags))
+		return -EINVAL;
+	return generic_file_mmap_prepare(desc);
+}
 #else
 vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
 {
@@ -3865,15 +3884,25 @@ int generic_file_mmap(struct file *file,
 {
 	return -ENOSYS;
 }
+int generic_file_mmap_prepare(struct vm_area_desc *desc)
+{
+	return -ENOSYS;
+}
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -ENOSYS;
 }
+int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_MMU */
 
 EXPORT_SYMBOL(filemap_page_mkwrite);
 EXPORT_SYMBOL(generic_file_mmap);
+EXPORT_SYMBOL(generic_file_mmap_prepare);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
+EXPORT_SYMBOL(generic_file_readonly_mmap_prepare);
 
 static struct folio *do_read_cache_folio(struct address_space *mapping,
 		pgoff_t index, filler_t filler, struct file *file, gfp_t gfp)
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

