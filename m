Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C8B1C01
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923455; cv=none; b=d5dzcVpaeNByURP0HVfgNq9uDONwcWhhjdOpjM4Hz2rWpYQlgGSGWN7xErVygRF5BOopQJoL6rCvEXuAx0koZqTNbjXu9K99bM6YUAPZDw75ZEPSZ/R1+Bg/vxr3lmDAH9DrsTcnDty/dX9h5S2E4Gb0ZXZxlzxS8gizdqWqJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923455; c=relaxed/simple;
	bh=B66sDriHhN4YqvHzefzkEpMHrF4lZ9+cPQgVnURKUy0=;
	h=Date:To:From:Subject:Message-Id; b=VDZWcdWdMq3zbFWNXw7U+y2jvlfDSPSwPzpxzvuT4DGlKjrvFqCe5J187RSOSumYwmaSHFMwk5UuPlfwXCpV8IxHJDYO4duuZitJHaHF/LkwMD3XjsJuUnSkTd2x7fvZQRbmh+ngzeB2I35X8Sk44IWiIlDESvdKa6B0evG4xzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kRCLNBXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kRCLNBXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D04C4CEE2;
	Wed, 19 Feb 2025 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923455;
	bh=B66sDriHhN4YqvHzefzkEpMHrF4lZ9+cPQgVnURKUy0=;
	h=Date:To:From:Subject:From;
	b=kRCLNBXJc7DrliXNYGhB26kQV0aD8OYOgDKWC3rhwe/KpTau2eWKWwLAfZt4Gfqzs
	 nzRSkGSxYIpJJmviZcWJ0bnpycEKwIAQvtKdjFmhwguSl7y/23jiuhJ9Lc8GXj8+o7
	 gldNoRJyg2a2gZT+jaUEwkQvXkcDtfL50KREsS24=
Date: Tue, 18 Feb 2025 16:04:14 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch added to mm-unstable branch
Message-Id: <20250219000415.34D04C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: make register_page_bootmem_memmap handle PTE mappings
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch

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
Subject: x86/mm: make register_page_bootmem_memmap handle PTE mappings
Date: Tue, 18 Feb 2025 18:16:36 +0000

register_page_bootmem_memmap expects that vmemmap pages handed to it are
PMD-mapped, and that the number of pages to call get_page_bootmem on is
PMD-aligned.

This is currently a correct assumption, but will no longer be true once
pre-HVO of hugetlb pages is implemented.

Make it handle PTE-mapped vmemmap pages and a nr_pages argument that is
not necessarily PAGES_PER_SECTION.

Link: https://lkml.kernel.org/r/20250218181656.207178-9-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 arch/x86/mm/init_64.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings
+++ a/arch/x86/mm/init_64.c
@@ -1610,11 +1610,14 @@ void register_page_bootmem_memmap(unsign
 		}
 		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
 
-		if (!boot_cpu_has(X86_FEATURE_PSE)) {
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			next = (addr + PAGE_SIZE) & PAGE_MASK;
+			continue;
+		}
+
+		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd))
-				continue;
 			get_page_bootmem(section_nr, pmd_page(*pmd),
 					 MIX_SECTION_INFO);
 
@@ -1625,12 +1628,7 @@ void register_page_bootmem_memmap(unsign
 					 SECTION_INFO);
 		} else {
 			next = pmd_addr_end(addr, end);
-
-			pmd = pmd_offset(pud, addr);
-			if (pmd_none(*pmd))
-				continue;
-
-			nr_pmd_pages = 1 << get_order(PMD_SIZE);
+			nr_pmd_pages = (next - addr) >> PAGE_SHIFT;
 			page = pmd_page(*pmd);
 			while (nr_pmd_pages--)
 				get_page_bootmem(section_nr, page++,
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

