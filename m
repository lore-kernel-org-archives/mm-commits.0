Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBDA5A853
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HDXZ7MPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B3C433C7;
	Mon, 18 Dec 2023 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920203;
	bh=7cuFfQD+sa/UZfWN35a/wDptaUfMOYp81XgrKn9+oF0=;
	h=Date:To:From:Subject:From;
	b=HDXZ7MPc9ufiSyi+yy01xGq+RBVM7b+KrdMG3W/H4Eo4hxnnQ5SzzBBjOg5Vtm0xL
	 YI99EKZ86iby027jAe3b7k3SUydhMiJqWuyxMsOIWGUTSurBqj7bSTpVdxkWZUJE3b
	 VbacDiNZ6Ci2ud3pqybYLOy5suuBDn2BB1HmRw7c=
Date: Mon, 18 Dec 2023 09:23:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch added to mm-unstable branch
Message-Id: <20231218172322.DD5B3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: pte_clear(): new layer to manage contig bit
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: pte_clear(): new layer to manage contig bit
Date: Mon, 18 Dec 2023 10:50:50 +0000

Create a new layer for the in-table PTE manipulation APIs.  For now, The
existing API is prefixed with double underscore to become the arch-private
API and the public API is just a simple wrapper that calls the private
API.

The public API implementation will subsequently be used to transparently
manipulate the contiguous bit where appropriate.  But since there are
already some contig-aware users (e.g.  hugetlb, kernel mapper), we must
first ensure those users use the private API directly so that the future
contig-bit manipulations in the public API do not interfere with those
existing uses.

Link: https://lkml.kernel.org/r/20231218105100.172635-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    3 ++-
 arch/arm64/mm/fixmap.c           |    2 +-
 arch/arm64/mm/hugetlbpage.c      |    2 +-
 arch/arm64/mm/mmu.c              |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-pte_clear-new-layer-to-manage-contig-bit
+++ a/arch/arm64/include/asm/pgtable.h
@@ -93,7 +93,7 @@ static inline pteval_t __phys_to_pte_val
 	__pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
 #define pte_none(pte)		(!pte_val(pte))
-#define pte_clear(mm, addr, ptep) \
+#define __pte_clear(mm, addr, ptep) \
 				__set_pte(ptep, __pte(0))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
@@ -1121,6 +1121,7 @@ extern void ptep_modify_prot_commit(stru
 
 #define set_pte					__set_pte
 #define set_ptes				__set_ptes
+#define pte_clear				__pte_clear
 
 #endif /* !__ASSEMBLY__ */
 
--- a/arch/arm64/mm/fixmap.c~arm64-mm-pte_clear-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/fixmap.c
@@ -123,7 +123,7 @@ void __set_fixmap(enum fixed_addresses i
 	if (pgprot_val(flags)) {
 		__set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, flags));
 	} else {
-		pte_clear(&init_mm, addr, ptep);
+		__pte_clear(&init_mm, addr, ptep);
 		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
 	}
 }
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-pte_clear-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -400,7 +400,7 @@ void huge_pte_clear(struct mm_struct *mm
 	ncontig = num_contig_ptes(sz, &pgsize);
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		pte_clear(mm, addr, ptep);
+		__pte_clear(mm, addr, ptep);
 }
 
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
--- a/arch/arm64/mm/mmu.c~arm64-mm-pte_clear-new-layer-to-manage-contig-bit
+++ a/arch/arm64/mm/mmu.c
@@ -859,7 +859,7 @@ static void unmap_hotplug_pte_range(pmd_
 			continue;
 
 		WARN_ON(!pte_present(pte));
-		pte_clear(&init_mm, addr, ptep);
+		__pte_clear(&init_mm, addr, ptep);
 		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 		if (free_mapped)
 			free_hotplug_page_range(pte_page(pte),
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-batch-copy-pte-ranges-during-fork.patch
mm-batch-clear-pte-ranges-during-zap_pte_range.patch
arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
arm64-mm-set_ptes-set_pte_at-new-layer-to-manage-contig-bit.patch
arm64-mm-pte_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get_and_clear-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_clear_flush_young-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_wrprotect-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_set_access_flags-new-layer-to-manage-contig-bit.patch
arm64-mm-ptep_get-new-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-helpers-to-optimize-fork.patch
arm64-mm-implement-clear_ptes-to-optimize-exit-munmap-dontneed.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

