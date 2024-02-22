Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472E2CA47
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560223; cv=none; b=IDVqofqTgwLJR7ZZu5h3DaEQbSSh/GyFckdVAGusHuu0GcE0tfzNesZrivc68H3GZfeKjM1g+dVFrHO5YB+c2J2AMIof2Dx7OSNxeoFpQ1V06y1wEyprLt8WzUUxrMHrGJn/h4yJ8G8fOdVhmnYaf8KuhDWSDwmIWdk3aAkfA2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560223; c=relaxed/simple;
	bh=WbnpoWKtteAZNU0lvYWIdRfTWc9nLNmh8ReJDhaks6c=;
	h=Date:To:From:Subject:Message-Id; b=oJ6MoBKoiV/JTHhjL8R5JEfvsX6nf5K+LtRVir4c/U1YEkt8IL4z68zL9OsP2GVPHwU5Uulxa9KaTcqhU76MkQygoUGzerPk0u0C/cp8S4Gj0FtTutq61CxmShp6PloZs8Y5fItP6fwRVTobRYJBDadNKCXz9KtX29Fmfwmn5Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqk9le2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqk9le2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FDAC43394;
	Thu, 22 Feb 2024 00:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560223;
	bh=WbnpoWKtteAZNU0lvYWIdRfTWc9nLNmh8ReJDhaks6c=;
	h=Date:To:From:Subject:From;
	b=lqk9le2j4RBEdSb2GuRoDliA7MyHKzmh6aos5oC3EvCxnMzIzekiGXN/GldujZvzq
	 +R831E0s9u/On8SXHjqLa9qfDtjORLfdn8/J3YH8p85BAIXfUCFjezqliANCzMhXoh
	 9qR4+47jGMfIn4O5rJ/8Xlu54Bc3Mpv1LsKUd53I=
Date: Wed, 21 Feb 2024 16:03:42 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,jane.chu@oracle.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch removed from -mm tree
Message-Id: <20240222000343.14FDAC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: move page order check inside hugetlb_cma_reserve()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-page-order-check-inside-hugetlb_cma_reserve.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -7720,6 +7720,13 @@ void __init hugetlb_cma_reserve(int orde
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


