Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539D22F5332
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202288; cv=none; b=pNtx+A+vxf9Z0HfgM/yqimV2lHhzBP/11AwS0pDH6oSHKp5v2ZEbhqoNKljADWmKkUJnpCAXlrPYZNHvIhYKildeLk3uVCGgnG2FIhn50FaiPrbK6WkVQzN+nI0pYDDpaVj5doKrJHxvevu7vefoK77jaHPjwJHOhU6mpr4SE2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202288; c=relaxed/simple;
	bh=A3HLKCjSEf7gOjzDLQKd2eBI9y9FxHSjRcHv1pGB1Fg=;
	h=Date:To:From:Subject:Message-Id; b=mrxR5s7HnnhsXvXMch/kXH1Y3GsujDeL0uWMGNkz6wrsyHcUTQC12cPeqvntQEqfsyJtrVZnYQ3mmbbCRrTeQVT8l1L7hB0Jr4+cjSNiuBG5sv8XJXuH3FDH097Ficb4CMyYK3SfG20IWI+Aeg181jFB1y6e0M2E79fLWSbRhac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFKFuTLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFKFuTLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5227C4CEED;
	Tue, 17 Jun 2025 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750202287;
	bh=A3HLKCjSEf7gOjzDLQKd2eBI9y9FxHSjRcHv1pGB1Fg=;
	h=Date:To:From:Subject:From;
	b=JFKFuTLzC5lqdcsVq1R/g61pMMEm39+tD2G+eQ7LF0IzYsz4mt9I97ifMiSeXTVMm
	 K1NYAKCkkxmRG7ym/1RRwcGVAzbK6vWRIONkXcJeC6jWIv+Oro9rYAGRbrhQDKXpPb
	 UKLDxcW/E00PQyYXSRwDhw3dNsn8J62xh1UQrDXo=
Date: Tue, 17 Jun 2025 16:18:07 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-further-init-files-to-mm-init-block.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617231807.C5227C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add further init files to mm init block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-further-init-files-to-mm-init-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-further-init-files-to-mm-init-block.patch

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
Subject: MAINTAINERS: add further init files to mm init block
Date: Tue, 17 Jun 2025 18:45:38 +0100

These files comprise the bootmem info logic which is initialised on
startup and also memory tests that are run on startup and as such this
seems the most appropriate section for them.

Link: https://lkml.kernel.org/r/20250617174538.188977-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-further-init-files-to-mm-init-block
+++ a/MAINTAINERS
@@ -15680,8 +15680,11 @@ S:	Maintained
 F:	Documentation/core-api/boot-time-mm.rst
 F:	Documentation/core-api/kho/bindings/memblock/*
 F:	include/linux/memblock.h
+F:	mm/bootmem_info.c
 F:	mm/memblock.c
+F:	mm/memtest.c
 F:	mm/mm_init.c
+F:	mm/rodata_test.c
 F:	tools/testing/memblock/
 
 MEMORY ALLOCATION PROFILING
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
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

