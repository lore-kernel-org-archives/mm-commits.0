Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D957436C
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923445; cv=none; b=byrDgXyQhiyiaRo5ehY4xaGfPVFKL4nmpyCKR2hQ4/O3FMaPA1rFwGx/FjGs3G25bbY2eWZrDdeL4F1y15DtlO4z7i2yyXvMVmCmTBy3//CN4XXa6HZzXlT+7YmAH85S973bZT6/N8KyhWSBTgp//L9k7ruNtj/kB5E2BXbfJNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923445; c=relaxed/simple;
	bh=5TLZJ+mMJU1hNOagzFNdrXY7LSgrb+/PR5WPZ3uVZ68=;
	h=Date:To:From:Subject:Message-Id; b=fJYMOD8E2XIR7v+oYbvbYIsS8EBW/T7kGN0cViN7TAC9i2KjV9BR4akpnYN/y0w4yS1mnNMqQrydAP4Vx4xZf39JgGWz2Cr3uOtmPtWb0dFowWkLg8fXv5ke1KLUQVfCYbi0p11/ruT8xcMz6MMzshzXig1cghteNEIim3yquHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O5eNnCfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O5eNnCfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45348C4CEE2;
	Wed, 19 Feb 2025 00:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923445;
	bh=5TLZJ+mMJU1hNOagzFNdrXY7LSgrb+/PR5WPZ3uVZ68=;
	h=Date:To:From:Subject:From;
	b=O5eNnCfVjBourHCiQATtk91hlHHjBysBZjuVn9QZTHwQQzGVGJM2Z1riltx+2fcPo
	 MFzq4Lnadjg6l/pu8VzZXO5UUyVhmoVBvlnKjGOWwM65yrrx/J8WEFl9i1D3fN8vGC
	 YWg89Ng2BOZcAAOxxgCSso0cHQmyZ97vUBfQ943w=
Date: Tue, 18 Feb 2025 16:04:04 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-cma_declare_contiguous_multi.patch added to mm-unstable branch
Message-Id: <20250219000405.45348C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, hugetlb: use cma_declare_contiguous_multi
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-cma_declare_contiguous_multi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-cma_declare_contiguous_multi.patch

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
Subject: mm, hugetlb: use cma_declare_contiguous_multi
Date: Tue, 18 Feb 2025 18:16:32 +0000

hugetlb_cma is fine with using multiple CMA ranges, as long as it can get
its gigantic pages allocated from them.  So, use
cma_declare_contiguous_multi to allow for multiple ranges, increasing the
chances of getting what we want on systems with gaps in physical memory.

Link: https://lkml.kernel.org/r/20250218181656.207178-5-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-cma_declare_contiguous_multi
+++ a/mm/hugetlb.c
@@ -7738,9 +7738,8 @@ void __init hugetlb_cma_reserve(int orde
 		 * may be returned to CMA allocator in the case of
 		 * huge page demotion.
 		 */
-		res = cma_declare_contiguous_nid(0, size, 0,
-					PAGE_SIZE << order,
-					HUGETLB_PAGE_ORDER, false, name,
+		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
+					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
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

