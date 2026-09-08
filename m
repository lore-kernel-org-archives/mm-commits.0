Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14546D08C
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 21:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788902186; cv=none; b=ZHHRUHWieLD6DR3V79nO5MaTcELP953fp5W2RTRAQ3/yjG+1kVFLbumq2pY2qKEDTdcqQWzbxMmNkmoZsD7DJbP+k2Ko07/ne956GrBJ3pcuWVGMLk+nqi/KAAH/34jVb9Rc9fngzyYxcazw8TWte/7yKRxeKsh1u/ixZM4/8ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788902186; c=relaxed/simple;
	bh=e5AOw2QVqLPLMBBKLBzKb5siHwsWsTaWN4htl70S0/M=;
	h=Date:To:From:Subject:Message-Id; b=LSn8Ym2irwgc2d0FlmNLYvT3SGE8KkaVrurOunwnNkmnMCOjz7R9tf8mhQo9S6fVLmlLurSusPEVUChnUA5qcZUPFh58dZoETaQLr18U/5VQYca9iuruwG9vRrTTvIMTolt0bapoqXKCLQZzHGONRGyMYM+yHCRNnbVMs6OPs1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oafWuuGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oafWuuGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6CF1F00A3A;
	Tue,  8 Sep 2026 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788902184;
	bh=u5RQRDy6Xd0oKvM/v4cq/hwbh1xK1zaI99gJlNxOGSM=;
	h=Date:To:From:Subject;
	b=oafWuuGHVoQxjdQLhBPLhql418zN9oYM1pXcexP3G7mPss0A4F9MDzd6qS9pQm3F0
	 sK7A+LuYpkf0f9LziFpqJ0V87N43ApVIIce7mKHllJiG+rcF1koxBis1AMNwt1d1y3
	 Oh/5/Z+U+tN8rVN5iiWHMhqHS2M1CuRZ2e9C0s1M=
Date: Tue, 08 Sep 2026 14:16:23 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch added to mm-new branch
Message-Id: <20260908211623.DA6CF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
has been added to the -mm mm-new branch.  Its filename is
     mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
Date: Tue, 08 Sep 2026 13:32:13 +0100

Commit a0ad5496b2b3 ("arm: mm: enable HAVE_RCU_TABLE_FREE logic") enabled
CONFIG_MMU_GATHER_RCU_TABLE_FREE (then named HAVE_RCU_TABLE_FREE) for SMP
arm architectures with LPAE enabled.

Regardless of whether CONFIG_ARM_LPAE is enabled or not, the same page
table freeing functions __pte_free_tlb() and __pmd_free_tlb() are used.

Non-LPAE PMD page tables are folded into the PGD and freed by pgd_free()
(PGD freeing is not part of mmu_gather page table freeing in any case), so
this is a noop in this case.

Since commit 358d1c39c82a ("arm: convert various functions to use
ptdescs") both LPAE and non-LPAE PTE page table freeing uses
tlb_remove_ptdesc().

Thus all page table freeing is performed under RCU with
CONFIG_MMU_GATHER_RCU_TABLE_FREE enabled for LPAE and non-LPAE and thus it
need not be gated on LPAE.

A UP arm system can set CONFIG_PREEMPT_RCU, so a future pure RCU page
table walker requires MMU_GATHER_RCU_TABLE_FREE to be enabled on UP as
well, even if concurrent GUP fast is not possible there.

Therefore, it is both safe and desirable to set
CONFIG_MMU_GATHER_RCU_TABLE_FREE for all MMU arm architectures (nommu does
not perform mmu_gather operations).

This forms part of an overall effort to switch every architecture to this
mode.

Link: https://lore.kernel.org/20260908-rcu-pagetable-freeing-v2-4-1f60b64e878e@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig~mm-enable-mmu_gather_rcu_table_free-for-mmu-arm
+++ a/arch/arm/Kconfig
@@ -134,7 +134,7 @@ config ARM
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
 	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
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

