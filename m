Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D58223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115494; cv=none; b=fMafMkjKSUx1kKSx43TJO6i8qgk81ND1FTaLxYuWZaKdcXtaXQcRRNLUY47CYMVdXCh9ZxOFeZJulrTZBsIsh7HOClGcb8n1rg6D+aohAB0NvwkdujzGMHBgcAJ0+zavdMBn/lKlLn6aspNx3Rz5PMHlLPnAQ/iw4j2fTOFgmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115494; c=relaxed/simple;
	bh=T7fTVmeok3DT3g4hZYs84NQ8JJHJyhpRDSI95YslJv0=;
	h=Date:To:From:Subject:Message-Id; b=svVX35ZlbPS5+YUiQR2FFYlAiFU/0jxnB9J/FRxBwENFnBVgo/YBHOZE1PNbOHGe4ulPbmheDvQYsY32Ocaa7XCMLhEuK1gM28Z6CzXMKl35uYmXr2AAJsdTghVFPISmv74IU6ud2y4x5PvcsCGLS+iZeg/ESoJKHmhkyp7LW3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b9CJvVAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b9CJvVAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E8BC4CEEA;
	Mon, 16 Jun 2025 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115494;
	bh=T7fTVmeok3DT3g4hZYs84NQ8JJHJyhpRDSI95YslJv0=;
	h=Date:To:From:Subject:From;
	b=b9CJvVAQ4BMHfC3VrXdYeVrFv1r6osHAbnYOlh3GpPZew5T+90zkHHIHf/b6pMQWb
	 7sj8X5Oy1gO181GEcsce/5fHO+4WSe5W/qn1tOIjV3ml4QilpsMDFfO2ZJjaYrcoD9
	 T0yH68rvdZ1vAdvaFzIsGMfqrfYOMUkX+hiuvOuU=
Date: Mon, 16 Jun 2025 16:11:33 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-consistently-use-file_has_valid_mmap_hooks-helper.patch added to mm-new branch
Message-Id: <20250616231134.03E8BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: consistently use file_has_valid_mmap_hooks() helper
has been added to the -mm mm-new branch.  Its filename is
     fs-consistently-use-file_has_valid_mmap_hooks-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-consistently-use-file_has_valid_mmap_hooks-helper.patch

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
Subject: fs: consistently use file_has_valid_mmap_hooks() helper
Date: Mon, 16 Jun 2025 20:33:22 +0100

Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), the f_op->mmap() hook has been deprecated in favour of
f_op->mmap_prepare().

Additionally, commit bb666b7c2707 ("mm: add mmap_prepare() compatibility
layer for nested file systems") permits the use of the .mmap_prepare()
hook even in nested filesystems like overlayfs.

There are a number of places where we check only for f_op->mmap - this is
incorrect now mmap_prepare exists, so update all of these to use the
general helper file_has_valid_mmap_hooks().

Most notably, this updates the elf logic to allow for the ability to
execute binaries on filesystems which have the .mmap_prepare hook, but
additionally we update nested filesystems.

Link: https://lkml.kernel.org/r/b68145b609532e62bab603dd9686faa6562046ec.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/backing-file.c     |    2 +-
 fs/binfmt_elf.c       |    4 ++--
 fs/binfmt_elf_fdpic.c |    2 +-
 fs/coda/file.c        |    2 +-
 fs/ecryptfs/file.c    |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/backing-file.c~fs-consistently-use-file_has_valid_mmap_hooks-helper
+++ a/fs/backing-file.c
@@ -333,7 +333,7 @@ int backing_file_mmap(struct file *file,
 	if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)))
 		return -EIO;
 
-	if (!file->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(file))
 		return -ENODEV;
 
 	vma_set_file(vma, file);
--- a/fs/binfmt_elf.c~fs-consistently-use-file_has_valid_mmap_hooks-helper
+++ a/fs/binfmt_elf.c
@@ -646,7 +646,7 @@ static unsigned long load_elf_interp(str
 	if (!elf_check_arch(interp_elf_ex) ||
 	    elf_check_fdpic(interp_elf_ex))
 		goto out;
-	if (!interpreter->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(interpreter))
 		goto out;
 
 	total_size = total_mapping_size(interp_elf_phdata,
@@ -848,7 +848,7 @@ static int load_elf_binary(struct linux_
 		goto out;
 	if (elf_check_fdpic(elf_ex))
 		goto out;
-	if (!bprm->file->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(bprm->file))
 		goto out;
 
 	elf_phdata = load_elf_phdrs(elf_ex, bprm->file);
--- a/fs/binfmt_elf_fdpic.c~fs-consistently-use-file_has_valid_mmap_hooks-helper
+++ a/fs/binfmt_elf_fdpic.c
@@ -109,7 +109,7 @@ static int is_elf(struct elfhdr *hdr, st
 		return 0;
 	if (!elf_check_arch(hdr))
 		return 0;
-	if (!file->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(file))
 		return 0;
 	return 1;
 }
--- a/fs/coda/file.c~fs-consistently-use-file_has_valid_mmap_hooks-helper
+++ a/fs/coda/file.c
@@ -160,7 +160,7 @@ coda_file_mmap(struct file *coda_file, s
 	size_t count;
 	int ret;
 
-	if (!host_file->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(host_file))
 		return -ENODEV;
 
 	if (WARN_ON(coda_file != vma->vm_file))
--- a/fs/ecryptfs/file.c~fs-consistently-use-file_has_valid_mmap_hooks-helper
+++ a/fs/ecryptfs/file.c
@@ -193,7 +193,7 @@ static int ecryptfs_mmap(struct file *fi
 	 * natively.  If FILESYSTEM_MAX_STACK_DEPTH > 2 or ecryptfs
 	 * allows recursive mounting, this will need to be extended.
 	 */
-	if (!lower_file->f_op->mmap)
+	if (!file_has_valid_mmap_hooks(lower_file))
 		return -ENODEV;
 	return generic_file_mmap(file, vma);
 }
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

