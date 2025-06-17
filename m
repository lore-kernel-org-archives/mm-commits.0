Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A182F5326
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750203608; cv=none; b=Au0KjdNWMq2BXUjD+6SCQAvxaub3Vnc8Q9hNtNdx+GLsPDGm3+oVHxaAJKTF/5ePDPuYu5tmInDwulSY9KluaBeTEFuOFxS8JZje+iCpfAbeboeNI5M0utvKFWou9w9qyPCSm1QdfqlejfIs3LzWmNk39NfvKBmJpR54Z+Xv9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750203608; c=relaxed/simple;
	bh=8nFgBEAZWeLIHTxWPp+LMnIPMfYpWMwaqd0KVVUJ8NM=;
	h=Date:To:From:Subject:Message-Id; b=kjdWgut4zJi6Zbe1ZLuwFsdfRw54CviO6pmZ+Mc7Q67XXcf8L1WBB/hGbifhvLSl3wJe9fPr6QFa69jAM7MzIjhAbZsCmi6z6zBZyfLOGDdbe8oqsbuK+AtmZ/fo41ifNaks+s3RcOVhYbJNaVwLJFqKZclPXhu4zghop1uNjmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YypQKj5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YypQKj5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B857EC4CEE3;
	Tue, 17 Jun 2025 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750203607;
	bh=8nFgBEAZWeLIHTxWPp+LMnIPMfYpWMwaqd0KVVUJ8NM=;
	h=Date:To:From:Subject:From;
	b=YypQKj5+aE+UxCMOoLaVYCxy620YOBbfMXh6srN9Sp5AP4433s8xz2pReyBrI5Ry+
	 qNC4MzcWNPv4XjeqhsdBfRONrUZFCUo7fxJfp76BEIkshYRBfsZAdZZ9PnTjVnMLsf
	 +X2WG4aPcNxJRZf1/xq/gclbYLBKGaK6d4Vj79dw=
Date: Tue, 17 Jun 2025 16:40:07 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-per_vma-lock-for-madv_dontneed-fix.patch added to mm-unstable branch
Message-Id: <20250617234007.B857EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: avoid any chance of uninitialised pointer deref
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-per_vma-lock-for-madv_dontneed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-per_vma-lock-for-madv_dontneed-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/madvise: avoid any chance of uninitialised pointer deref
Date: Tue, 17 Jun 2025 14:35:13 +0100

If we were to extend madvise() to support more operations under VMA lock,
we could potentially dereference prev to uninitialised state in
madvise_update_vma().

Avoid this by explicitly setting prev to vma before invoking the visit()
function.

This has no impact on behaviour, as all visitors compatible with a VMA
lock do not require prev to be set to the previous VMA and at any rate we
only examine a single VMA in VMA lock mode.

Link: https://lkml.kernel.org/r/309d22ca-6cd9-4601-8402-d441a07d9443@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/madvise.c~mm-use-per_vma-lock-for-madv_dontneed-fix
+++ a/mm/madvise.c
@@ -1320,6 +1320,8 @@ static int madvise_vma_behavior(struct v
 		return madvise_guard_remove(vma, prev, start, end);
 	}
 
+	/* We cannot provide prev in this lock mode. */
+	VM_WARN_ON_ONCE(arg->lock_mode == MADVISE_VMA_READ_LOCK);
 	anon_name = anon_vma_name(vma);
 	anon_vma_name_get(anon_name);
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
@@ -1536,6 +1538,7 @@ int madvise_walk_vmas(struct mm_struct *
 	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
 		vma = try_vma_read_lock(mm, madv_behavior, start, end);
 		if (vma) {
+			prev = vma;
 			error = visit(vma, &prev, start, end, arg);
 			vma_end_read(vma);
 			return error;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
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

