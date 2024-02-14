Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1D75D467
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707924148; cv=none; b=fJlNUCh0VzobuKdIYZ9MAA9qgS5Pykig4WSbHAG6Tju1fjmyMMALCB7Kyu2irfhRHBXSy66MjqUbjnXVxYjXYKQ6YxXA2vcxeFskqxCPDCXsJYTdlkwCabqg9umVCjp8HjNlf0FFRUHMVGXofztIL6QN/AkNJafx8WaZJkrm6TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707924148; c=relaxed/simple;
	bh=itLslMBA4v84qDYQh6tWO0yZUi9iY9CDQQdV0mFfrkM=;
	h=Date:To:From:Subject:Message-Id; b=bh1yuT2vRm9ucEoCnqQQfdunlLjpFIf1ZGT+Ffza7G4CsGI5kqt4go9vQ20Wo8x6FJUZf+Cw+thhtpLd99SDljIJ+qm7oAt7VprdmVX6ZOlRWZexNd4DOxUpmq7HFaYdRE+o+TwqKdnPBoTGWTIVnDqIU2j0gPpM9qrVu2Ij/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BNXW/rWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BNXW/rWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F18C433F1;
	Wed, 14 Feb 2024 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707924148;
	bh=itLslMBA4v84qDYQh6tWO0yZUi9iY9CDQQdV0mFfrkM=;
	h=Date:To:From:Subject:From;
	b=BNXW/rWTc8sFJlFeibELqFhexHGtiaATwftd1EbqcAb9cUCxQAZvYPEYkPCrsrhEz
	 5S2LYf26Z/6jZo3PUiWRpmMNh+2hJ/iHjAfwl+SzNcsVbcvMtfqowki7f0mPNW5Mhn
	 i6ZC0Me+fSYHXh8ghXXfciwIwXgmLOrkPNvPSIRw=
Date: Wed, 14 Feb 2024 07:22:27 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,jane.chu@oracle.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch added to mm-unstable branch
Message-Id: <20240214152228.57F18C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: move page order check inside hugetlb_cma_reserve()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/hugetlb: move page order check inside hugetlb_cma_reserve()
Date: Fri, 9 Feb 2024 11:12:21 +0530

All platforms could benefit from page order check against MAX_PAGE_ORDER
before allocating a CMA area for gigantic hugetlb pages.  Let's move this
check from individual platforms to generic hugetlb.

Link: https://lkml.kernel.org/r/20240209054221.1403364-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |    7 -------
 arch/powerpc/mm/hugetlbpage.c |    4 +---
 mm/hugetlb.c                  |    7 +++++++
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -45,13 +45,6 @@ void __init arm64_hugetlb_cma_reserve(vo
 	else
 		order = CONT_PMD_SHIFT - PAGE_SHIFT;
 
-	/*
-	 * HugeTLB CMA reservation is required for gigantic
-	 * huge pages which could not be allocated via the
-	 * page allocator. Just warn if there is any change
-	 * breaking this assumption.
-	 */
-	WARN_ON(order <= MAX_PAGE_ORDER);
 	hugetlb_cma_reserve(order);
 }
 #endif /* CONFIG_CMA */
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -614,8 +614,6 @@ void __init gigantic_hugetlb_cma_reserve
 		 */
 		order = mmu_psize_to_shift(MMU_PAGE_16G) - PAGE_SHIFT;
 
-	if (order) {
-		VM_WARN_ON(order <= MAX_PAGE_ORDER);
+	if (order)
 		hugetlb_cma_reserve(order);
-	}
 }
--- a/mm/hugetlb.c~mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve
+++ a/mm/hugetlb.c
@@ -7800,6 +7800,13 @@ void __init hugetlb_cma_reserve(int orde
 	bool node_specific_cma_alloc = false;
 	int nid;
 
+	/*
+	 * HugeTLB CMA reservation is required for gigantic
+	 * huge pages which could not be allocated via the
+	 * page allocator. Just warn if there is any change
+	 * breaking this assumption.
+	 */
+	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 	cma_reserve_called = true;
 
 	if (!hugetlb_cma_size)
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-memblock-add-memblock_rsrv_noinit-into-flagname-array.patch
mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch
mm-cma-add-sysfs-file-release_pages_success.patch
mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

