Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC422655B
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115502; cv=none; b=tX7EtyRwljzkJQT6jQcF3owmW6yWiLWS5S8mpwbLIXQ3dtzW1D4cFtwuKJJpkYKaE9m7hRA7ui6J9ZuMjHGlstCG6BjsIeGMSqbAIqEMO5acGnj6pXSUzKC6RoTroXO4NMGRCu6XROazIGk/FBCMxGwRUA5RV69WMD4PboiF8Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115502; c=relaxed/simple;
	bh=H6StRUgoQTH3avp59pjsBkWez1R29JeUB1lOIrNx+as=;
	h=Date:To:From:Subject:Message-Id; b=WrATNr1Jt/ot+EaTRyWEIKy4iW3w8Uv+QYBWA8eONt2hW8FWHaaPVblSyYSMiq6s9ySxaajrJKg9LCtBMxaJ6TBldT64IM0Y40yJkXH5IALq0hXg1865wdcKx3DIl3VdmpjMve7Rkm4vqo4wIsbbMOQeMVNwyRblUeNnxzRMwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lCTZLeGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCTZLeGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AD9C4CEEA;
	Mon, 16 Jun 2025 23:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115502;
	bh=H6StRUgoQTH3avp59pjsBkWez1R29JeUB1lOIrNx+as=;
	h=Date:To:From:Subject:From;
	b=lCTZLeGqXd6G+rQThDBO9NnWiJ+89fyRXp5G5ymteLeFWiYbwilnsEzIy73fF+sq2
	 p8yqEKik0cQO5jgmPjYOFbga2PcgvbR/KHvihKSTlnA81Gjt1IjZJy1JaDpWD+jYXd
	 NQ3+7xPvSiO9ahphopaML5Ls/t4ku7CVKfUpAuYg=
Date: Mon, 16 Jun 2025 16:11:41 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20250616231142.35AD9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/xfs: transition from deprecated .mmap hook to .mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch

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
Subject: fs/xfs: transition from deprecated .mmap hook to .mmap_prepare
Date: Mon, 16 Jun 2025 20:33:25 +0100

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

Link: https://lkml.kernel.org/r/cba8b29ba5f225df8f63f50182d5f6e0fcf94456.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_file.c~fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare
+++ a/fs/xfs/xfs_file.c
@@ -1913,10 +1913,10 @@ static const struct vm_operations_struct
 };
 
 STATIC int
-xfs_file_mmap(
-	struct file		*file,
-	struct vm_area_struct	*vma)
+xfs_file_mmap_prepare(
+	struct vm_area_desc *desc)
 {
+	struct file		*file = desc->file;
 	struct inode		*inode = file_inode(file);
 	struct xfs_buftarg	*target = xfs_inode_buftarg(XFS_I(inode));
 
@@ -1924,14 +1924,14 @@ xfs_file_mmap(
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(vma->vm_flags, vma->vm_file,
+	if (!daxdev_mapping_supported(desc->vm_flags, file,
 				      target->bt_daxdev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
-	vma->vm_ops = &xfs_file_vm_ops;
+	desc->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(inode))
-		vm_flags_set(vma, VM_HUGEPAGE);
+		desc->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
@@ -1946,7 +1946,7 @@ const struct file_operations xfs_file_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
-	.mmap		= xfs_file_mmap,
+	.mmap_prepare	= xfs_file_mmap_prepare,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
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

