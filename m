Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F25E223DD5
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115492; cv=none; b=qmcluIPl9RBsCFqCqrANQI8hAZmg/e2djJPxSaT+tuPrMXrQvEy44BQ59iaSk0ocou2uRjz7mL1wME9P1POG0/t9JvVYRbQc2cgOWNlJN2UQAh88Bh2qORt9t0mt1q57CZ9YnuEmUvZRGvKZVIbiHbsW+58WiEqumX8B89khkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115492; c=relaxed/simple;
	bh=B80asNu1NL4RhZPqFKcc+GbWLquAhgOLlTCQzQPCpyA=;
	h=Date:To:From:Subject:Message-Id; b=KX9tmFbrq0Ov70Y6gc1RmlMvKQDdr1d+wfCy7NJLlUkJsXXSq3Euh/pbDY0c5Ur/31V4KDZj4o7C0hGLfC7N643iu3+MyPFJr68XvX3416ckWSDVSH1lFH7kWInLbczoy9gqdPuP3igRrrGROLhJE4YBkI30ZWTEuRs7KKhxmQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1yfDk3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1yfDk3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14714C4CEEA;
	Mon, 16 Jun 2025 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115492;
	bh=B80asNu1NL4RhZPqFKcc+GbWLquAhgOLlTCQzQPCpyA=;
	h=Date:To:From:Subject:From;
	b=I1yfDk3zq3O1FjOAaJY+nWqRKJBaVIqxjXZ3LFLafiaRweWyU7TAjCzsPiH3lvMMg
	 mOEpA1Zgnh+BD30JDtxtY2FWRCpF8b2Mms4oqp92op4FQ+WwvM//54zzLjmDiaexFr
	 rc26J/+GYKQPRZz4MbwoNXCI8nUtyKtR4+rCSBQw=
Date: Mon, 16 Jun 2025 16:11:31 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-use-file_has_valid_mmap_hooks-helper.patch added to mm-new branch
Message-Id: <20250616231132.14714C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/nommu: use file_has_valid_mmap_hooks() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-use-file_has_valid_mmap_hooks-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-use-file_has_valid_mmap_hooks-helper.patch

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
Subject: mm/nommu: use file_has_valid_mmap_hooks() helper
Date: Mon, 16 Jun 2025 20:33:21 +0100

Since commit c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file
callback"), the f_op->mmap() hook has been deprecated in favour of
f_op->mmap_prepare().

Therefore, update the check for file operations supporting mmap() by using
the file_has_valid_mmap_hooks() helper function, which checks for either
f_op->mmap or f_op->mmap_prepare rather than checking only for f_op->mmap
directly.

Link: https://lkml.kernel.org/r/5f120b644b5890d1b50202d0f0d4c9f0d6b62873.1750099179.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-use-file_has_valid_mmap_hooks-helper
+++ a/mm/nommu.c
@@ -719,7 +719,7 @@ static int validate_mmap_request(struct
 
 	if (file) {
 		/* files must support mmap */
-		if (!file->f_op->mmap)
+		if (!file_has_valid_mmap_hooks(file))
 			return -ENODEV;
 
 		/* work out if what we've got could possibly be shared
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

