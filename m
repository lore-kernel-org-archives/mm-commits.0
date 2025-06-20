Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494931C863B
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391359; cv=none; b=FLY1hcTfQRiKAf+DCJKBacIMIS/YU8Ui2CfTh/NR0MyB/eTRIEGJ8m0weZBbWctfurgQ/1x3r7WbZlOyITZne6xFVZALGqq+tPQGf2v6HfVz7C8AES2mmVN10p0j7YGc7esYIlw/sTpoCkzzB43ocgDgJUKeY/MpXqkO0mi5Jm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391359; c=relaxed/simple;
	bh=n2z6lMR8/QndcJYCSsyInyOjh3Q0ZzWa1Hr4YTgwsZ8=;
	h=Date:To:From:Subject:Message-Id; b=kyFjheHIbgkbs3Jwx+GQFhqCZgPstb+kkxeRNtP7zM8R2p2byioQynqj/E6KTVYl4jncZzoogo5BVSV1w7949Mmwfkh9MHyJRRX38E56cH8nIPwyVlFu6HR5y0xEcxpb0RNQUyDXzV2RBbl+sxHl9Mmo40ixQCytakLFC7CojYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MMzJ+Q81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MMzJ+Q81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06FFC4CEE3;
	Fri, 20 Jun 2025 03:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391358;
	bh=n2z6lMR8/QndcJYCSsyInyOjh3Q0ZzWa1Hr4YTgwsZ8=;
	h=Date:To:From:Subject:From;
	b=MMzJ+Q81y9dPKvOxMrT8Orc2RnOqgvcY+OQa/RoA7S8Rr7cq/n+BKq1keh9e+KJ5z
	 FMjt4chGGFfvVxSfrnsroXgZAPXUypQXlxOGj/3nKdVFG37KH3xXfcxwy9kokgZDoU
	 Gf0yaFU057XsrudgQ+pvE5AxY1sPut9JQwsPU3Wo=
Date: Thu, 19 Jun 2025 20:49:18 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-missing-test-files-to-mm-gup-section.patch removed from -mm tree
Message-Id: <20250620034918.D06FFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing test files to mm gup section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-test-files-to-mm-gup-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing test files to mm gup section
Date: Mon, 16 Jun 2025 21:08:44 +0100

We previously overlooked GUP test files that sensibly should belong to the
GUP section, include them now.

Link: https://lkml.kernel.org/r/20250616200844.560225-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++++
 1 file changed, 4 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-test-files-to-mm-gup-section
+++ a/MAINTAINERS
@@ -15795,6 +15795,10 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
+F:	mm/gup_test.c
+F:	mm/gup_test.h
+F:	tools/testing/selftests/mm/gup_longterm.c
+F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
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

