Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EBA6FB9
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750379394; cv=none; b=VcnGINZLN7o79ugQ5+DG7S2dEVJ+lFkoUv6NQ4luuSyjzM0dtobtLC2C7zd3GrTxxnLDWhRjoM8eTUWXaU7hyKNy7r1w56bGR2DLu5IpBfkJxs60f5bfdg+fAg8+LCPvEbhVDBXmDjFnZXkjLi6Eqy0taxx2vOHxTrlTT6WEkig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750379394; c=relaxed/simple;
	bh=6ZqBS/gJ+UiBG7uvUshXD0725sZqb1MzMH8R5VzNYIc=;
	h=Date:To:From:Subject:Message-Id; b=SDIF2Idl0435Jzuc7/uhR8xC3VPNCaabwIEWngvZO0WuKv3Ovz3qt0nlqG8DfdiMfaZYuhkQplfxYIyB9Pw/80uu1kZ5WTeWWeNJ+4WNXIL6QDsYcQOi4Ehp1yptLlH4+NpnUzZldIsjZdMKOJasE5hB73n8eKwDHR1MQ/+LyCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=deDp5gne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="deDp5gne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFC1C4CEEA;
	Fri, 20 Jun 2025 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750379393;
	bh=6ZqBS/gJ+UiBG7uvUshXD0725sZqb1MzMH8R5VzNYIc=;
	h=Date:To:From:Subject:From;
	b=deDp5gne67V7ipfueu674o0IVIDgwwO5dryZpJQ6lUWWR9xITpFfGJhe2UdgT8TaR
	 TQHHLx4OnNRYM/QiwCH8DOK8rboMkYIo4kKmuA0AyYOo4V5dUwXvDJbO9/pRtu36Fl
	 wW6hxZ3+sL0IMUauEjXBUSpgFT7eoeZ3BJqtUtYo=
Date: Thu, 19 Jun 2025 17:29:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch added to mm-unstable branch
Message-Id: <20250620002953.AFFC1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make comment consistent in vma_expand()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch

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
Subject: mm: make comment consistent in vma_expand()
Date: Thu, 19 Jun 2025 15:32:57 +0100

The VMA merge structure contains a pointer to mm_struct so we don't need
to determine it from an input VMA's vm_mm field.  Update the comment to
reflect this and make it consistent with vma_merge_new_range() and
vma_merge_existing_range().

Link: https://lkml.kernel.org/r/c54f45e3-a6ac-4749-93c0-cc9e3080ee37@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix
+++ a/mm/vma.c
@@ -1094,7 +1094,7 @@ struct vm_area_struct *vma_merge_new_ran
  * Returns: 0 on success.
  *
  * ASSUMPTIONS:
- * - The caller must hold a WRITE lock on vmg->target->mm->mmap_lock.
+ * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
  * - The caller must have set @vmg->target and @vmg->next.
  */
 int vma_expand(struct vma_merge_struct *vmg)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
maintainers-add-missing-files-to-mm-page-alloc-section.patch
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
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

