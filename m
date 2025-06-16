Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19543223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115498; cv=none; b=STRvrjuQMTL3prVPd2jd6UrWzSBaDHsp60K6b/C0AmVzsVZFqCpa6AhtSKp3gCf/hSaoDXcMDBPrZUUdfuk/6wLaLqYsDTOGa7wGevNbTRbKL6F4WkEZRcHyIfw7QFpXgX9NajyPg1TXsp+CcJLlVruem7DbzsHPBDOzpB9hlFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115498; c=relaxed/simple;
	bh=o/iRkO1a0qlB/uMNTsxUC8l+XSve4DraFeWuob6wl2E=;
	h=Date:To:From:Subject:Message-Id; b=F5VAEvAmT4iofOl9y+i6723h7daviLWsKw/LbuqURJUurtYg050ARiX6M1XTtkdnZCpY8TM/FVNO604gp+Gv4SbeWX8QbzS6HQ0FT4Fd75mOjikbtLjOecoTUhwOedPwGSMrlmkk/rwOZpFvQZqFbx3CFsifd5EHIS8lTeQIYzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C54z2XIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C54z2XIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B89CC4CEEA;
	Mon, 16 Jun 2025 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115497;
	bh=o/iRkO1a0qlB/uMNTsxUC8l+XSve4DraFeWuob6wl2E=;
	h=Date:To:From:Subject:From;
	b=C54z2XIyfYRbq5lsYzPWm48IwinyWZBJrrKD7DArIQojE4U+mi927zcgjypBb6jK8
	 vcitRUJ2PveDqWgf6On/nNBOd+Xec7CPyJQ8SfOrTMy50jDCRvHg8+3zsHD19/ByGl
	 S3WQJbD/T7sVXnBJvf5PzSX9c/+E4KBBMG1DybXo=
Date: Mon, 16 Jun 2025 16:11:36 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch added to mm-new branch
Message-Id: <20250616231137.7B89CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: make it possible to check dev dax support without a VMA
has been added to the -mm mm-new branch.  Its filename is
     fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch

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
Subject: fs/dax: make it possible to check dev dax support without a VMA
Date: Mon, 16 Jun 2025 20:33:23 +0100

This is a prerequisite for adapting those filesystems to use the
.mmap_prepare() hook for mmap()'ing which invoke this check as this hook
does not have access to a VMA pointer.

To effect this, change the signature of daxdev_mapping_supported() and
update its callers (ext4 and xfs mmap()'ing hook code).

Link: https://lkml.kernel.org/r/b09de1e8544384074165d92d048e80058d971286.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c      |    2 +-
 fs/xfs/xfs_file.c   |    3 ++-
 include/linux/dax.h |   16 +++++++++-------
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/fs/ext4/file.c~fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma
+++ a/fs/ext4/file.c
@@ -821,7 +821,7 @@ static int ext4_file_mmap(struct file *f
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(vma, dax_dev))
+	if (!daxdev_mapping_supported(vma->vm_flags, vma->vm_file, dax_dev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
--- a/fs/xfs/xfs_file.c~fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma
+++ a/fs/xfs/xfs_file.c
@@ -1924,7 +1924,8 @@ xfs_file_mmap(
 	 * We don't support synchronous mappings for non-DAX files and
 	 * for DAX files if underneath dax_device is not synchronous.
 	 */
-	if (!daxdev_mapping_supported(vma, target->bt_daxdev))
+	if (!daxdev_mapping_supported(vma->vm_flags, vma->vm_file,
+				      target->bt_daxdev))
 		return -EOPNOTSUPP;
 
 	file_accessed(file);
--- a/include/linux/dax.h~fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma
+++ a/include/linux/dax.h
@@ -65,12 +65,13 @@ size_t dax_recovery_write(struct dax_dev
 /*
  * Check if given mapping is supported by the file / underlying device.
  */
-static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
-					     struct dax_device *dax_dev)
+static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
+					    struct file *file,
+					    struct dax_device *dax_dev)
 {
-	if (!(vma->vm_flags & VM_SYNC))
+	if (!(vm_flags & VM_SYNC))
 		return true;
-	if (!IS_DAX(file_inode(vma->vm_file)))
+	if (!IS_DAX(file_inode(file)))
 		return false;
 	return dax_synchronous(dax_dev);
 }
@@ -110,10 +111,11 @@ static inline void set_dax_nomc(struct d
 static inline void set_dax_synchronous(struct dax_device *dax_dev)
 {
 }
-static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
-				struct dax_device *dax_dev)
+static inline bool daxdev_mapping_supported(vm_flags_t vm_flags,
+					    struct file *file,
+					    struct dax_device *dax_dev)
 {
-	return !(vma->vm_flags & VM_SYNC);
+	return !(vm_flags & VM_SYNC);
 }
 static inline size_t dax_recovery_write(struct dax_device *dax_dev,
 		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
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

