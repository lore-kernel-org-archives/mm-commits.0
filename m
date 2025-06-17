Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91290295D85
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202437; cv=none; b=ryNwhyR94EZi0arXpu+nuFdZcCZgbP8HQKM1Xpo4LdAvqwjFw0AenBIqkAAROoGrfipRZmkbnevX107rzGb+Ku/gyWYBQ5pEIUMGayNl3FwfTwv1cZRCZ8IkpxR9uS89cM2bpUL3Qkrv+no5LsYqrdIiXIPzhvVFrYGH2dmmm/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202437; c=relaxed/simple;
	bh=EqVYm1iZzdkQDvrxqhTWXpDkep8oAB8EfP/z9iFzFZY=;
	h=Date:To:From:Subject:Message-Id; b=F3to2s6ns36L5hm7ENMZnOSE+7J4f2nlfSSIrmD+XzDGcRlQ+99qVCluyilsV1jZi5UYoqC+NRUlnYx9LYbezWxUwDJkrVJG0SSGc6isFED1JTi3ohqWurURwLaOILKSt1cIijCU2HpatmyrOtgJcBof0FvQZAkZBWX5w6TAqR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItWqu4oS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItWqu4oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FBCC4CEE3;
	Tue, 17 Jun 2025 23:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750202437;
	bh=EqVYm1iZzdkQDvrxqhTWXpDkep8oAB8EfP/z9iFzFZY=;
	h=Date:To:From:Subject:From;
	b=ItWqu4oSR+DsKC/YClNlm6kZagdGiyqupXXyr7GSHv09pp7MXmJiSNy1KpLe4A8kp
	 X5mCpECkrWuo+wk8r88yW3atKZvr2b+fkJ9F724i2jnSw4y55nqdTJ1cfSd+EtGJsY
	 mEZEJR0syD1+wPlJebk7C0dw9ObNC2zN5H1OoNvg=
Date: Tue, 17 Jun 2025 16:20:36 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617232037.26FBCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add memfd, shmem quota files to shmem section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add memfd, shmem quota files to shmem section
Date: Tue, 17 Jun 2025 17:13:59 +0100

These files seem best suited to shmem.

Link: https://lkml.kernel.org/r/20250617161359.166955-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-memfd-shmem-quota-files-to-shmem-section
+++ a/MAINTAINERS
@@ -15740,7 +15740,6 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
-F:	include/linux/memfd.h
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
@@ -25042,8 +25041,11 @@ M:	Hugh Dickins <hughd@google.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/memfd.h
 F:	include/linux/shmem_fs.h
+F:	mm/memfd.c
 F:	mm/shmem.c
+F:	mm/shmem_quota.c
 
 TOMOYO SECURITY MODULE
 M:	Kentaro Takeda <takedakn@nttdata.co.jp>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
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

