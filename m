Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62C3FC2
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923489; cv=none; b=MgcI9Fmq+6Klr9tQz0tUFHnj0VyiZLT6vpAPenceGItzKVWf3h8+oRln5+sJ0nMc9ecn/3IfJ0zohCjS+3/HutNBBvMKNd0ZHCS1HLkHZz6Ves6g6XtVdExNKL/Znc+NoZXKJ8w2wGwIQ2xDymtVwUJ9lgjBa9LG5byFx8TRjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923489; c=relaxed/simple;
	bh=1DFtKtmn0jSQwHWZcl9rcR6kOqPcCpYDg5O8Szpzgrc=;
	h=Date:To:From:Subject:Message-Id; b=blPm1sKqmB7pDIlsbsETUB3tFZXH1lZF/WOQyS70hCwyLtmh+Y0e5VUmszE0d+rNo8FEhG3Xy//zMc+AWtHxYYbv9DKzRHynqxfTUr1HnNvsxbs9d1EnqvqZQE+dQyxqB6D/BjHrkOeg9eX5TP/JWQuDnbr4k4aMchrtwi5hp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ELRPO3ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ELRPO3ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9735C4CEE2;
	Wed, 19 Feb 2025 00:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923488;
	bh=1DFtKtmn0jSQwHWZcl9rcR6kOqPcCpYDg5O8Szpzgrc=;
	h=Date:To:From:Subject:From;
	b=ELRPO3ZKguT+T/INc/qXi3NX5wCyfCNWt+JF/INAwO9DtZMa9nR3rXnmLlI20ajIl
	 wZFHr3bGGsZqsGFYvXGHq5zCpI0Uk7N4KIVo2hNDUeDb4Hq1BX4he72P1+RRnlgvsd
	 A8GUinJryo27VEn5mcPG6l+ngVFuQzuOu4GDQyGc=
Date: Tue, 18 Feb 2025 16:04:48 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-setup-call-hugetlb_bootmem_alloc-early.patch added to mm-unstable branch
Message-Id: <20250219000448.C9735C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/setup: call hugetlb_bootmem_alloc early
has been added to the -mm mm-unstable branch.  Its filename is
     x86-setup-call-hugetlb_bootmem_alloc-early.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-setup-call-hugetlb_bootmem_alloc-early.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: x86/setup: call hugetlb_bootmem_alloc early
Date: Tue, 18 Feb 2025 18:16:48 +0000

Call hugetlb_bootmem_allloc in an earlier spot in setup, after
hugelb_cma_reserve.  This will make vmemmap preinit of the sections
covered by the allocated hugetlb pages possible.

Link: https://lkml.kernel.org/r/20250218181656.207178-21-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c~x86-setup-call-hugetlb_bootmem_alloc-early
+++ a/arch/x86/kernel/setup.c
@@ -1108,8 +1108,10 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
 		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+		hugetlb_bootmem_alloc();
+	}
 
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

