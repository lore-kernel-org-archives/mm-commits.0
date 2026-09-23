Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DED42E437
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193711; cv=none; b=qUQAHmkQZc95SerXjn+3gFtQDq5VapD0tjlKR65JakQ7zOQtdy28SQ4m2tCod/QSGtIBm5F6Bmlx0leDrfARd0Y7M+x2pnJD4G+HKYynd6NCSn/XG/FkTLKNnn7R8DWqwDoqHLmDwEYvmaVyGXJM3ezjuv5dzMakjfFCM44U3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193711; c=relaxed/simple;
	bh=C7jFQSd9DVbtp/M3eK9kA9SWpmQ8wbVmnxHD5c++SOQ=;
	h=Date:To:From:Subject:Message-Id; b=lsRVTawlEsAIN+8D8v1Ds3sJsEXazg3lllmi/ti/bL69nEAJ4k/qfGHSHO3FaahTDDUCQ88wm4ukhsQIeTEJS+mdKjkD5YVStKTvM5iYpRHiDodNzLjlp2pf/JekjOqTXhzXu5ZGQIRSqUaed+WNRtRyrVcqOqsvTZSClOOlkl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OC2Eqmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OC2Eqmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EA11F000FF;
	Wed, 23 Sep 2026 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790193706;
	bh=Md6YfoABWj0WBoL+yBQ0zqZVz0hGKyPR//50GG+eYZI=;
	h=Date:To:From:Subject;
	b=0OC2Eqmtt2DYJUJhIq16Oh3qsN0pgXn42Cp8eCmuGPHMW7mcSLj67BWejdqOllNmt
	 xFKO5DpQjWZSi5OSSPnZtsvJ+IWaEO8AAIBNEfzkEfiTN+qpx71FWcUcW+EeZIZKts
	 ySDprdS90QGDQJweJ4/ivRWUmnfjlcDnmYxoWIiE=
Date: Wed, 23 Sep 2026 13:01:46 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch added to mm-unstable branch
Message-Id: <20260923200146.69EA11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
Date: Tue, 22 Sep 2026 16:35:36 +0100

Each of these architectures directly free page tables without routing
these changes through tlb_remove_ptdesc().

The use of tlb_remove_ptdesc() is required for
CONFIG_MMU_GATHER_RCU_TABLE_FREE to correctly free page tables under RCU,
so simply update these architectures to use these functions.

Since none of the architectures share page tables or do anything unusual,
nothing complicated is required here.

Therefore this is simply a mechanical change - convert __pud_free_tlb(),
__pmd_free_tlb() and __pte_free_tlb() to use tlb_remove_ptdesc() as
required.

At the point this is in place, all mmu_gather page table freeing is
performed under RCU, and thus MMU_GATHER_RCU_TABLE_FREE is selected for
each architecture.

Note that CONFIG_MMU_GATHER_RCU_TABLE_FREE is dependent on CONFIG_MMU for
xtensa to reflect the fact that nommu does not implement page table
gathering.

This forms part of an overall effort to switch every architecture to this
mode.

Link: https://lore.kernel.org/20260922-rcu-pagetable-freeing-v4-5-fe1ad1f1e303@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Guo Ren <guoren@kernel.org>
Cc: Brian Cain <bcain@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Simon Schuster <schuster.simon@siemens-energy.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 arch/arc/Kconfig                      |    1 +
 arch/arc/include/asm/pgalloc.h        |    6 +++---
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/include/asm/pgalloc.h |    2 +-
 arch/xtensa/Kconfig                   |    1 +
 arch/xtensa/include/asm/tlb.h         |    2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arc/include/asm/pgalloc.h~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/arc/include/asm/pgalloc.h
@@ -72,7 +72,7 @@ static inline void p4d_populate(struct m
 	set_p4d(p4dp, __p4d((unsigned long)pudp));
 }
 
-#define __pud_free_tlb(tlb, pmd, addr)  pud_free((tlb)->mm, pmd)
+#define __pud_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #endif
 
@@ -83,10 +83,10 @@ static inline void pud_populate(struct m
 	set_pud(pudp, __pud((unsigned long)pmdp));
 }
 
-#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #endif
 
-#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)  tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* _ASM_ARC_PGALLOC_H */
--- a/arch/arc/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/arc/Kconfig
@@ -47,6 +47,7 @@ config ARC
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA
 	select OF
 	select OF_EARLY_FLATTREE
--- a/arch/microblaze/include/asm/pgalloc.h~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -25,7 +25,7 @@ extern void __bad_pte(pmd_t *pmd);
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, (pte))
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #define pmd_populate(mm, pmd, pte) \
 			(pmd_val(*(pmd)) = (unsigned long)page_address(pte))
--- a/arch/microblaze/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/microblaze/Kconfig
@@ -41,6 +41,7 @@ config MICROBLAZE
 	select PCI_SYSCALL if PCI
 	select CPU_NO_EFFICIENT_FFS
 	select MMU_GATHER_NO_RANGE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSE_IRQ
 	select ZONE_DMA
 	select TRACE_IRQFLAGS_SUPPORT
--- a/arch/xtensa/include/asm/tlb.h~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/xtensa/include/asm/tlb.h
@@ -16,7 +16,7 @@
 
 #include <asm-generic/tlb.h>
 
-#define __pte_free_tlb(tlb, pte, address)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 void check_tlb_sanity(void);
 
--- a/arch/xtensa/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa
+++ a/arch/xtensa/Kconfig
@@ -55,6 +55,7 @@ config XTENSA
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_DOMAIN
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA
 	select PERF_USE_VMALLOC
 	select TRACE_IRQFLAGS_SUPPORT
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse-fix.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

