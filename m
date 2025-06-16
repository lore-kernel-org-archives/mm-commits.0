Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681422264D8
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115500; cv=none; b=JYpucc//uYz5BfpX1aOh6bClXtSnqbN6tQBvZ70uEdsjLd9MKNMPqRhu1AGzlNjS83I0LjHXeshakj9zkRHFVKFqRLsIsFPxds8T57hC/x2AEOsWU26xS+T7+ylBcaDv401c6XpXifboq0yPAplVzywQKqmJoDVIHty1ZqgEOIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115500; c=relaxed/simple;
	bh=d0UHmq0nBgg/UP9c0MMgPFCPvnr56n2gNEb/3egdGMM=;
	h=Date:To:From:Subject:Message-Id; b=pS3SuP68mlRoUm7Ekpq9pMF6ZTv+aLL+qYeZVj7OyR/SOTU+zBKRZ8ouGp5wOI1+jAPCP4j46aafSPwtiD14MHxeBnTV9XS/jB30PW5/95Y3BD7DRxypmJjksWq4rl0Y91q3hvZB0l5Yr58jFd4YZr9kugzgLlgfAK8neK50WaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zP3kcCtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zP3kcCtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB58C4CEEA;
	Mon, 16 Jun 2025 23:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115500;
	bh=d0UHmq0nBgg/UP9c0MMgPFCPvnr56n2gNEb/3egdGMM=;
	h=Date:To:From:Subject:From;
	b=zP3kcCtkCGTMlwHobZFPvdvhQFszCyDckP/EvDt4rv6e2sT9sAWolHqXYz9BNgIBY
	 uIDE4zSrSAF6mHrUR1MeVNRwW4dMYfjwjKJ4bFENCCEX/IyiWVJbW31W66PdhkM7Hh
	 OAwUJ6AYwzrEx+d8WbEjqhOiSBRZouN3PMY49gLU=
Date: Mon, 16 Jun 2025 16:11:39 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20250616231140.3AB58C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/ext4: transition from deprecated .mmap hook to .mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch

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
Subject: fs/ext4: transition from deprecated .mmap hook to .mmap_prepare
Date: Mon, 16 Jun 2025 20:33:24 +0100

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

Link: https://lkml.kernel.org/r/5abfe526032a6698fd1bcd074a74165cda7ea57c.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/ext4/file.c~fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare
+++ a/fs/ext4/file.c
@@ -804,9 +804,10 @@ static const struct vm_operations_struct
 	.page_mkwrite   = ext4_page_mkwrite,
 };
 
-static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
+static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
 {
 	int ret;
+	struct file *file = desc->file;
 	struct inode *inode = file->f_mapping->host;
 	struct dax_device *dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
 
@@ -821,15 +822,15 @@ static int ext4_file_mmap(struct file *f
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(vma->vm_flags, vma->vm_file, dax_dev))
+	if (!daxdev_mapping_supported(desc->vm_flags, file, dax_dev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
-		vma->vm_ops = &ext4_dax_vm_ops;
-		vm_flags_set(vma, VM_HUGEPAGE);
+		desc->vm_ops = &ext4_dax_vm_ops;
+		desc->vm_flags |= VM_HUGEPAGE;
 	} else {
-		vma->vm_ops = &ext4_file_vm_ops;
+		desc->vm_ops = &ext4_file_vm_ops;
 	}
 	return 0;
 }
@@ -968,7 +969,7 @@ const struct file_operations ext4_file_o
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
 #endif
-	.mmap		= ext4_file_mmap,
+	.mmap_prepare	= ext4_file_mmap_prepare,
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
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

