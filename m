Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F1235057
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384629; cv=none; b=FP20g2j8VR9B1QOTVBFhqS4V2+XhT1gPUIwYarb3hSOnnUdq0NuErduzNqnRPEeB1X3NmVFUV53KH2MBiVuceCVqOoj707Z/YMP84BLgEBrrw2A4G2U6H0JGukrygEytYAgGQcemfKIBhTHQSfJpTSAAO1DPxAtT/qXwXbhexoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384629; c=relaxed/simple;
	bh=NYws91OHinPDUMg5VjJM5meSlOc+HODAe4aZhVPLeh4=;
	h=Date:To:From:Subject:Message-Id; b=uWotw8Utji8zd3eLe2grsXEXY1imlRd3lkFlDL4I+ZYpFPVvYBqLrp40q/jSzjD+cNrOjlhpBqSKZwvggXq0d1wrTnPFsz/PrhGiDUU/iE+ewplgCRrzLpj2J3AeWq5QrMKCb6hXzHTfGTAx/CMh/ITWXF41l3kd7ynscWdBELg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6DC/G8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6DC/G8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C724EC4CEF1;
	Tue,  9 Sep 2025 02:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384628;
	bh=NYws91OHinPDUMg5VjJM5meSlOc+HODAe4aZhVPLeh4=;
	h=Date:To:From:Subject:From;
	b=H6DC/G8BCs8O+Z8LM1580653+Qwa28RnEZvz+LyVXEUxSXRrszgNCXrqjm6uOKTQn
	 /6hrmpL83qhsk8WZH/GLNFtMzU/Cx2hlm2Cr5/PJv58JH2Ln7fkrokzpsWVj22pA6Z
	 cImCoZiGB1gFN3U4S9y7BO/QEOqbahhT+Vw4xCCM=
Date: Mon, 08 Sep 2025 19:23:48 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-arch_flush_lazy_mmu_mode.patch added to mm-new branch
Message-Id: <20250909022348.C724EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove arch_flush_lazy_mmu_mode()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-arch_flush_lazy_mmu_mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-arch_flush_lazy_mmu_mode.patch

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
Subject: mm: remove arch_flush_lazy_mmu_mode()
Date: Mon, 8 Sep 2025 08:39:25 +0100

Patch series "Nesting support for lazy MMU mode", v2.

When the lazy MMU mode was introduced eons ago, it wasn't made clear
whether such a sequence was legal:

	arch_enter_lazy_mmu_mode()
	...
		arch_enter_lazy_mmu_mode()
		...
		arch_leave_lazy_mmu_mode()
	...
	arch_leave_lazy_mmu_mode()

It seems fair to say that nested calls to
arch_{enter,leave}_lazy_mmu_mode() were not expected, and most
architectures never explicitly supported it.

Ryan Roberts' series from March [1] attempted to prevent nesting from ever
occurring, and mostly succeeded.  Unfortunately, a corner case
(DEBUG_PAGEALLOC) may still cause nesting to occur on arm64.  Ryan
proposed [2] to address that corner case at the generic level but this
approach received pushback; [3] then attempted to solve the issue on arm64
only, but it was deemed too fragile.

It feels generally fragile to rely on lazy_mmu sections not to nest,
because callers of various standard mm functions do not know if the
function uses lazy_mmu itself.  This series therefore performs a U-turn
and adds support for nested lazy_mmu sections, on all architectures.

The main change enabling nesting is patch 2, following the approach
suggested by Catalin Marinas [4]: have enter() return some state and the
matching leave() take that state.  In this series, the state is only used
to handle nesting, but it could be used for other purposes such as
restoring context modified by enter(); the proposed kpkeys framework would
be an immediate user [5].


This patch (of 7):

This function has only ever been used in arch/x86, so there is no need for
other architectures to implement it.  Remove it from linux/pgtable.h and
all architectures besides x86.

The arm64 implementation is not empty but it is only called from
arch_leave_lazy_mmu_mode(), so we can simply fold it there.

Link: https://lkml.kernel.org/r/20250908073931.4159362-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20250908073931.4159362-2-kevin.brodsky@arm.com
Link: https://lore.kernel.org/all/20250303141542.3371656-1-ryan.roberts@arm.com/ [1]
Link: https://lore.kernel.org/all/20250530140446.2387131-1-ryan.roberts@arm.com/ [2]
Link: https://lore.kernel.org/all/20250606135654.178300-1-ryan.roberts@arm.com/ [3]
Link: https://lore.kernel.org/all/aEhKSq0zVaUJkomX@arm.com/ [4]
Link: https://lore.kernel.org/linux-hardening/20250815085512.2182322-19-kevin.brodsky@arm.com/ [5]
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h                   |    9 +--------
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |    2 --
 arch/sparc/include/asm/tlbflush_64.h               |    1 -
 arch/x86/include/asm/pgtable.h                     |    3 ++-
 include/linux/pgtable.h                            |    1 -
 5 files changed, 3 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-remove-arch_flush_lazy_mmu_mode
+++ a/arch/arm64/include/asm/pgtable.h
@@ -101,21 +101,14 @@ static inline void arch_enter_lazy_mmu_m
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
-static inline void arch_flush_lazy_mmu_mode(void)
+static inline void arch_leave_lazy_mmu_mode(void)
 {
 	if (in_interrupt())
 		return;
 
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
-}
-
-static inline void arch_leave_lazy_mmu_mode(void)
-{
-	if (in_interrupt())
-		return;
 
-	arch_flush_lazy_mmu_mode();
 	clear_thread_flag(TIF_LAZY_MMU);
 }
 
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h~mm-remove-arch_flush_lazy_mmu_mode
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -55,8 +55,6 @@ static inline void arch_leave_lazy_mmu_m
 	preempt_enable();
 }
 
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
-
 extern void hash__tlbiel_all(unsigned int action);
 
 extern void flush_hash_page(unsigned long vpn, real_pte_t pte, int psize,
--- a/arch/sparc/include/asm/tlbflush_64.h~mm-remove-arch_flush_lazy_mmu_mode
+++ a/arch/sparc/include/asm/tlbflush_64.h
@@ -44,7 +44,6 @@ void flush_tlb_kernel_range(unsigned lon
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
--- a/arch/x86/include/asm/pgtable.h~mm-remove-arch_flush_lazy_mmu_mode
+++ a/arch/x86/include/asm/pgtable.h
@@ -117,7 +117,8 @@ extern pmdval_t early_pmd_flags;
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
-#define arch_end_context_switch(prev)	do {} while(0)
+#define arch_end_context_switch(prev)	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif	/* CONFIG_PARAVIRT_XXL */
 
 static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
--- a/include/linux/pgtable.h~mm-remove-arch_flush_lazy_mmu_mode
+++ a/include/linux/pgtable.h
@@ -234,7 +234,6 @@ static inline int pmd_dirty(pmd_t pmd)
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
 #define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
 #ifndef pte_batch_hint
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-remove-arch_flush_lazy_mmu_mode.patch
mm-introduce-local-state-for-lazy_mmu-sections.patch
arm64-mm-fully-support-nested-lazy_mmu-sections.patch
x86-xen-support-nested-lazy_mmu-sections-again.patch
powerpc-mm-support-nested-lazy_mmu-sections.patch
sparc-mm-support-nested-lazy_mmu-sections.patch
mm-update-lazy_mmu-documentation.patch

