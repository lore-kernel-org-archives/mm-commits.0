Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC509322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391366; cv=none; b=DkGWsRBQuGCzmGDFVFTy/3ltucCL8UzTjXOGTUqbzQdd0BoxvGlzRkH2XCsXuCpVdlJGu2oMt+qYMGqIusXm4RjF4oOVyiLnOIA/ZXt2UHhTZ6GhDksnxorlyziSe5bgKdXz+662eGX4SXwv2Jhv5TIPsKu/JDhDjZ4cHQejQkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391366; c=relaxed/simple;
	bh=U87uegfZ4HzUWsg7UPtF3KKFBrL0mhUxLoHep4SsFrQ=;
	h=Date:To:From:Subject:Message-Id; b=s3ITwVa0PfzgqKRGuaMyxjZMpv5MMkiA6ir6pR5+XO4jo7tKrzewq7wjUCDF6VIgl5ZH2jmnJ/zBITE1vLIEVMey/W8+c4KUvXpvog76VuBjbkCTABX9RhjNjTqGn6vAPtaEC7PI6HpWDNH3xDScN41SjeW6lYh8e1u4pR7U+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgRvf0OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgRvf0OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26EFC4CEE3;
	Fri, 20 Jun 2025 03:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391365;
	bh=U87uegfZ4HzUWsg7UPtF3KKFBrL0mhUxLoHep4SsFrQ=;
	h=Date:To:From:Subject:From;
	b=CgRvf0OClrugxKZ/N4F+50duL1tBG8fr8LOHPEWbPdkhUWql/RvJwIpaBrZtOtpgv
	 uW23gHrDISZmYMrZVE0lBuHnq6v8/50qOyWDmcgOjdO7KK1xToj77+iiYNQh9f1zAf
	 c6oKqTFBPLyR4CQNfhloPHsMyEnGm0HbCuL5Espw=
Date: Thu, 19 Jun 2025 20:49:25 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch removed from -mm tree
Message-Id: <20250620034925.C26EFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add memfd, shmem quota files to shmem section
has been removed from the -mm tree.  Its filename was
     maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

