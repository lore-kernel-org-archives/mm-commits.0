Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01F5322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391362; cv=none; b=KAyf+GE2rer5gs2runx7+5iqvZ++hQ2eIb3V7/rrYYLif+CrmXK06Q4O9xjawjH0aFZVVCBR0SvTyX+uLMSYZkl9GTMxDdMtjvXga4CRYhmxsYbYjzgVZcnKU/g41KWhb5Yl8I48UWoww0C4PHP5y2QVum2XaUeSg3WHaZShPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391362; c=relaxed/simple;
	bh=bmY+wnb1mKulI/8avm+2+hqcXJSWxw90npwoDS0piGQ=;
	h=Date:To:From:Subject:Message-Id; b=JqwRG2KSJFoRgEVsFWhkFVyWKF9rlTHvJoUmzHA5mseqyMqeKXTjYYIimUiTz7oztwrLtdL0Dk6nd938CYeFQp1i5fvt0HcUSrvS07KgbLffqyJ8fp8rmAOTEo1qUEYNj7xUUoWa1vJGVqGaaDizgsLhReHn7WOK+s2kkL9IVWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bk7auezw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bk7auezw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A98DC4CEE3;
	Fri, 20 Jun 2025 03:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391362;
	bh=bmY+wnb1mKulI/8avm+2+hqcXJSWxw90npwoDS0piGQ=;
	h=Date:To:From:Subject:From;
	b=bk7auezwwmJ1Hf1Q48N1kws478BzbppkZXxvMk9+VLCSpt6/SwZj2E15ZKtfgL8E3
	 Fl0+Fqbtr3V2pV3lBfBVZiDK97dq+zAv/7QF2H9JdDOBPJzANsvr6cJdj/ySJ8CEzN
	 0J0+4RyWwbTubHIHl6By5El1AlfpH3ESQLXrc+Zs=
Date: Thu, 19 Jun 2025 20:49:21 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-further-init-files-to-mm-init-block.patch removed from -mm tree
Message-Id: <20250620034922.6A98DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add further init files to mm init block
has been removed from the -mm tree.  Its filename was
     maintainers-add-further-init-files-to-mm-init-block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

