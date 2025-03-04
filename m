Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A42136347
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056534; cv=none; b=Fv2UP8j2sfeD68SUR9xrl03TISm/HjYBhpwe0GA6cGEy+L1U9wLES1hO+AaFKHGsZr6dylPD3Lgqg4h7sBgcZgyo0Z8MXGpWR+KCvnNeA//WfRJkcAjWTXh0s2g09bLS+ELsyIlAWZ/kV7si45V3C+1W3uFekxUPRvXXV926178=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056534; c=relaxed/simple;
	bh=I7Vuk5J/wKUZhyhvhrePKcrPuzmLVFrF6VxjvEGvplI=;
	h=Date:To:From:Subject:Message-Id; b=Tmi9iHTfRAQsFczKTxJo3yZFCQBeW00sPZXLyhcyxAH+2LuoS1hw95fAS9na0HLSewIgbzCllBNw2d1zWrtzQOjNKXvvA1cMWAQIGYy7Vj3XHaIpE9nVaPN9xWIGh6vcypWIkVBj16v6fUoOMB5+nAqc3JjbQe1OX0wXIQg6f30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hHe/Klpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hHe/Klpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0287C4CEE8;
	Tue,  4 Mar 2025 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056534;
	bh=I7Vuk5J/wKUZhyhvhrePKcrPuzmLVFrF6VxjvEGvplI=;
	h=Date:To:From:Subject:From;
	b=hHe/KlpyMoFD6GNiXI139LDifwAATCKG3opYF1I91oTEoW+FsRHj5cSBrvgnAik1Q
	 HbTd1EZnmtLumQy/1xv7Tz3LC8u2xGQC1baNzodBFa2INcSOK8hKnu9Zcohgm6xC3J
	 ILqC50jXH2uhVOLm2jA5VKEJSAcwl7+/zqCcdO94=
Date: Mon, 03 Mar 2025 18:48:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch added to mm-unstable branch
Message-Id: <20250304024853.F0287C4CEE8@smtp.kernel.org>
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
Date: Fri, 28 Feb 2025 18:29:09 +0000

register_page_bootmem_memmap expects that vmemmap pages handed to it are
PMD-mapped, and that the number of pages to call get_page_bootmem on is
PMD-aligned.

This is currently a correct assumption, but will no longer be true once
pre-HVO of hugetlb pages is implemented.

Make it handle PTE-mapped vmemmap pages and a nr_pages argument that is
not necessarily PAGES_PER_SECTION.

Link: https://lkml.kernel.org/r/20250228182928.2645936-9-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
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
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

