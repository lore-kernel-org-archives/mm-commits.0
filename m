Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09D73358BC
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765818997; cv=none; b=o8tEwLKQl9KUzbfohjqtvTnreh1nkHawHghMdhhnoOFIPgQEswox+gkHfHUK/VaOdVfE4sQHjE+fsr7zG89taCXk3SrL3aZEIHNi5Fj9aVjoRF6sVyzdTaXJAso5dBYpSFld6C69pBU43zHA4CG3QjvLqsLyMliHHLUizGhjxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765818997; c=relaxed/simple;
	bh=xk3D6Nymdmp3t+LDUI8rjzIi74AoaEvFIwCFkfaVHuc=;
	h=Date:To:From:Subject:Message-Id; b=qR3a7tTbKn70azC/gk8MPJB0dm6W2/7XJ6pIpwBW2ffmYPz9dEo/49W3lX0Q3O8uU4P7OdgqWjNKGvrK9AOur5O7mlX1jh0SBxX/uD8K1IevDlI9QW8CcFntWfjTXG9x/LiHQZUjBa/wai8rhXwW5q+TJYZyUYlqj91cKQAQE2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=faWEy0BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="faWEy0BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8CCC2BC87;
	Mon, 15 Dec 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765818996;
	bh=xk3D6Nymdmp3t+LDUI8rjzIi74AoaEvFIwCFkfaVHuc=;
	h=Date:To:From:Subject:From;
	b=faWEy0BBxfcPrmQnGuKnRgoBUh2w6z3ew8ep5E1+QUgIPIDPjeB61Pn1MBfZhjr8i
	 yRaGlGLfNBS+zM6GXFNrKMOHxstLWo23UzlZmAgqQIgEL9RGGUS5AKIE2CgzIvr6XH
	 ZUeXX0IwQJDsbF4SaYzS0MmfQUtRtBhW2rIci6Dk=
Date: Mon, 15 Dec 2025 09:16:35 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-config_arch_has_lazy_mmu_mode.patch added to mm-new branch
Message-Id: <20251215171636.3D8CCC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-config_arch_has_lazy_mmu_mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-config_arch_has_lazy_mmu_mode.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
Date: Mon, 15 Dec 2025 15:03:15 +0000

Architectures currently opt in for implementing lazy_mmu helpers by
defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.

In preparation for introducing a generic lazy_mmu layer that will require
storage in task_struct, let's switch to a cleaner approach: instead of
defining a macro, select a CONFIG option.

This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each arch
select it when it implements lazy_mmu helpers. 
__HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h> relies on
the new CONFIG instead.

On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is selected.
This creates some complications in arch/x86/boot/, because a few files
manually undefine PARAVIRT* options.  As a result <asm/paravirt.h> does
not define the lazy_mmu helpers, but this breaks the build as
<linux/pgtable.h> only defines them if !CONFIG_ARCH_HAS_LAZY_MMU_MODE. 
There does not seem to be a clean way out of this - let's just undefine
that new CONFIG too.

Link: https://lkml.kernel.org/r/20251215150323.2218608-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/pgtable.h                   |    1 -
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |    2 --
 arch/powerpc/platforms/Kconfig.cputype             |    1 +
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/asm/tlbflush_64.h               |    2 --
 arch/x86/Kconfig                                   |    1 +
 arch/x86/boot/compressed/misc.h                    |    1 +
 arch/x86/boot/startup/sme.c                        |    1 +
 arch/x86/include/asm/paravirt.h                    |    1 -
 include/linux/pgtable.h                            |    2 +-
 mm/Kconfig                                         |    7 +++++++
 12 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/arm64/include/asm/pgtable.h
@@ -80,7 +80,6 @@ static inline void queue_pte_barriers(vo
 	}
 }
 
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	/*
--- a/arch/arm64/Kconfig~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD
+	select ARCH_HAS_LAZY_MMU_MODE
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -24,8 +24,6 @@ DECLARE_PER_CPU(struct ppc64_tlb_batch,
 
 extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
 
-#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	struct ppc64_tlb_batch *batch;
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -93,6 +93,7 @@ config PPC_BOOK3S_64
 	select IRQ_WORK
 	select PPC_64S_HASH_MMU if !PPC_RADIX_MMU
 	select KASAN_VMALLOC if KASAN
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
--- a/arch/sparc/include/asm/tlbflush_64.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/sparc/include/asm/tlbflush_64.h
@@ -39,8 +39,6 @@ static inline void flush_tlb_range(struc
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
-#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
 void arch_flush_lazy_mmu_mode(void);
--- a/arch/sparc/Kconfig~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/sparc/Kconfig
@@ -112,6 +112,7 @@ config SPARC64
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select ARCH_SUPPORTS_SCHED_SMT if SMP
 	select ARCH_SUPPORTS_SCHED_MC  if SMP
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
--- a/arch/x86/boot/compressed/misc.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/x86/boot/compressed/misc.h
@@ -11,6 +11,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 #undef CONFIG_KASAN
 #undef CONFIG_KASAN_GENERIC
 
--- a/arch/x86/boot/startup/sme.c~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/x86/boot/startup/sme.c
@@ -24,6 +24,7 @@
 #undef CONFIG_PARAVIRT
 #undef CONFIG_PARAVIRT_XXL
 #undef CONFIG_PARAVIRT_SPINLOCKS
+#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 
 /*
  * This code runs before CPU feature bits are set. By default, the
--- a/arch/x86/include/asm/paravirt.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/x86/include/asm/paravirt.h
@@ -526,7 +526,6 @@ static inline void arch_end_context_swit
 	PVOP_VCALL1(cpu.end_context_switch, next);
 }
 
-#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	PVOP_VCALL0(mmu.lazy_mode.enter);
--- a/arch/x86/Kconfig~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/arch/x86/Kconfig
@@ -808,6 +808,7 @@ config PARAVIRT
 config PARAVIRT_XXL
 	bool
 	depends on X86_64
+	select ARCH_HAS_LAZY_MMU_MODE
 
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
--- a/include/linux/pgtable.h~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/include/linux/pgtable.h
@@ -235,7 +235,7 @@ static inline int pmd_dirty(pmd_t pmd)
  *
  * Nesting is not permitted and the mode cannot be used in interrupt context.
  */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#ifndef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void) {}
 static inline void arch_leave_lazy_mmu_mode(void) {}
 static inline void arch_flush_lazy_mmu_mode(void) {}
--- a/mm/Kconfig~mm-introduce-config_arch_has_lazy_mmu_mode
+++ a/mm/Kconfig
@@ -1464,6 +1464,13 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config ARCH_HAS_LAZY_MMU_MODE
+	bool
+	help
+	  The architecture uses the lazy MMU mode. This allows changes to
+	  MMU-related architectural state to be deferred until the mode is
+	  exited. See <linux/pgtable.h> for details.
+
 source "mm/damon/Kconfig"
 
 endmenu
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch

