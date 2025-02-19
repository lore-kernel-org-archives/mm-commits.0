Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB3E1C01
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923448; cv=none; b=WrC4JKRyCOSmtTObXC/oKBRCYvyYu+7KCMg39bd8QNlAyWrMwixbQ8EGeaTI0egwdMpuvpv9lg1Xn3IOz2jWbSbNeGwUZJJfcYFcvT5E/NL/yQ0Esxd1/5H8VsDn8+fxRirunzHOzSSqtE2/P3PID1CNT4vk8Y1jx3bc8UKuiYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923448; c=relaxed/simple;
	bh=edggjgzLSisR8PSll/9nr8uBIVUclE774nwF0OCeX8A=;
	h=Date:To:From:Subject:Message-Id; b=Ci+1qTYktL4FN9jh1kei7r3o5vvgKu8hvVVjxAi4JaOOu5ABdWadB8oGQGR/jXySIl+AkEoo/g7m/nqc/pcqeMMw2x8aRwpCFqaCYCOU3w6Z483slgfpxoiY7+hXOai2433/EcCznajkTTLoXIa/UCU2CuzESW72GJPp2epSU5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GX0Iphls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GX0Iphls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57883C4CEE2;
	Wed, 19 Feb 2025 00:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923447;
	bh=edggjgzLSisR8PSll/9nr8uBIVUclE774nwF0OCeX8A=;
	h=Date:To:From:Subject:From;
	b=GX0Iphlse1ke6CoQD7txxd1wdRucOo9FeoJVkpurl88qmxAKBTW+ZuYX6xWmiK6B2
	 F8S4rWlshHfZZD57pvt/LQjW3RSKpaL1GM78sGaQyyDTpMxXNo48S+6IxfqHdGZvpx
	 ZMSvuMUsz5fvsIzHeDBS+iVtViNFD7msCYqc0+bE=
Date: Tue, 18 Feb 2025 16:04:06 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-redundant-__clearpagereserved.patch added to mm-unstable branch
Message-Id: <20250219000407.57883C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove redundant __ClearPageReserved
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-remove-redundant-__clearpagereserved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-redundant-__clearpagereserved.patch

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
Subject: mm/hugetlb: remove redundant __ClearPageReserved
Date: Tue, 18 Feb 2025 18:16:33 +0000

In hugetlb_folio_init_tail_vmemmap, the reserved flag is cleared for the
tail page just before it is zeroed out, which is redundant.  Remove the
__ClearPageReserved call.

Link: https://lkml.kernel.org/r/20250218181656.207178-6-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-__clearpagereserved
+++ a/mm/hugetlb.c
@@ -3198,7 +3198,6 @@ static void __init hugetlb_folio_init_ta
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__ClearPageReserved(folio_page(folio, pfn - head_pfn));
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
 		ret = page_ref_freeze(page, 1);
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

