Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809F4498B7
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2WDLD01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1964C433C7;
	Mon, 18 Dec 2023 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702920221;
	bh=yplF5+eIUSCJo1qzoRvr/FX9rSxPgBDLNcwJaCy7+wU=;
	h=Date:To:From:Subject:From;
	b=g2WDLD01TOUXdOmy7o+JGJNqfKplu5DGZS61fWKcN6SuyybCXXakd6cAin5ZV0jFd
	 L6vTW/kLnvncDwfGwglFtPtn9X6VGH7T6N70BXAjGjs2vkMVw1RszmXbfF9XzVvgCG
	 oKt+cTI5o680pc92nXxOeHbjiHRE8bWEY84COYDI=
Date: Mon, 18 Dec 2023 09:23:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuzenghui@huawei.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vincenzo.frascino@arm.com,suzuki.poulose@arm.com,shy828301@gmail.com,ryabinin.a.a@gmail.com,oliver.upton@linux.dev,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,glider@google.com,dvyukov@google.com,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch added to mm-unstable branch
Message-Id: <20231218172340.E1964C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: split __flush_tlb_range() to elide trailing DSB
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch

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
Subject: arm64/mm: split __flush_tlb_range() to elide trailing DSB
Date: Mon, 18 Dec 2023 10:50:57 +0000

Split __flush_tlb_range() into __flush_tlb_range_nosync() +
__flush_tlb_range(), in the same way as the existing flush_tlb_page()
arrangement.  This allows calling __flush_tlb_range_nosync() to elide the
trailing DSB.  Forthcoming "contpte" code will take advantage of this when
clearing the young bit from a contiguous range of ptes.

Link: https://lkml.kernel.org/r/20231218105100.172635-14-ryan.roberts@arm.com
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

 arch/arm64/include/asm/tlbflush.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/tlbflush.h~arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb
+++ a/arch/arm64/include/asm/tlbflush.h
@@ -399,7 +399,7 @@ do {									\
 #define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
 	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
 
-static inline void __flush_tlb_range(struct vm_area_struct *vma,
+static inline void __flush_tlb_range_nosync(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
@@ -431,10 +431,19 @@ static inline void __flush_tlb_range(str
 	else
 		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
 
-	dsb(ish);
 	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
 }
 
+static inline void __flush_tlb_range(struct vm_area_struct *vma,
+				     unsigned long start, unsigned long end,
+				     unsigned long stride, bool last_level,
+				     int tlb_level)
+{
+	__flush_tlb_range_nosync(vma, start, end, stride,
+				 last_level, tlb_level);
+	dsb(ish);
+}
+
 static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
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

