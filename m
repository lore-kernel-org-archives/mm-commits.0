Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FCC1DA2F
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2s/ModJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E62C433C7;
	Mon, 18 Dec 2023 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920208;
	bh=m4S+JS//o/oekMz2JT4zl8tN9ja5G6OGFKN2Ir1I/io=;
	h=Date:To:From:Subject:From;
	b=2s/ModJlA9FbneGECO70d04qMV6D/61j7odqvbn7bfgK/rJZYvNLA3aqQEF+7bWlx
	 kUyzyq8yFQORWU4VmS9iyI4o8MrKo/+ocR7uDW+N5C/fVd25OTkrFAyr8PMj4RAka8
	 yHkes6NbhQj5TzcvPtTPGxlcbpaTe8knmzFeH0LY=
Date: Mon, 18 Dec 2023 09:23:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch added to mm-unstable branch
Message-Id: <20231218172328.02E62C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: ptep_test_and_clear_young(): new layer to manage contig bit
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit.patch

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
Subject: arm64/mm: ptep_test_and_clear_young(): new layer to manage contig bit
Date: Mon, 18 Dec 2023 10:50:52 +0000

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

Link: https://lkml.kernel.org/r/20231218105100.172635-9-ryan.roberts@arm.com
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

 arch/arm64/include/asm/pgtable.h |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-ptep_test_and_clear_young-new-layer-to-manage-contig-bit
+++ a/arch/arm64/include/asm/pgtable.h
@@ -887,8 +887,9 @@ static inline bool pud_user_accessible_p
 /*
  * Atomic pte/pmd modifications.
  */
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int __ptep_test_and_clear_young(pte_t *ptep)
+static inline int __ptep_test_and_clear_young(struct vm_area_struct *vma,
+					      unsigned long address,
+					      pte_t *ptep)
 {
 	pte_t old_pte, pte;
 
@@ -903,18 +904,11 @@ static inline int __ptep_test_and_clear_
 	return pte_young(pte);
 }
 
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pte_t *ptep)
-{
-	return __ptep_test_and_clear_young(ptep);
-}
-
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 					 unsigned long address, pte_t *ptep)
 {
-	int young = ptep_test_and_clear_young(vma, address, ptep);
+	int young = __ptep_test_and_clear_young(vma, address, ptep);
 
 	if (young) {
 		/*
@@ -937,7 +931,7 @@ static inline int pmdp_test_and_clear_yo
 					    unsigned long address,
 					    pmd_t *pmdp)
 {
-	return ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
+	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -1123,6 +1117,8 @@ extern void ptep_modify_prot_commit(stru
 #define pte_clear				__pte_clear
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define ptep_get_and_clear			__ptep_get_and_clear
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+#define ptep_test_and_clear_young		__ptep_test_and_clear_young
 
 #endif /* !__ASSEMBLY__ */
 
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

