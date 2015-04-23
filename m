From: akpm@linux-foundation.org
Subject: + powerpc-mm-tracking-vdso-remap.patch added to -mm tree
Date: Thu, 23 Apr 2015 15:29:13 -0700
Message-ID: <55397239.318Nm1ku2dnM+TsG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031119AbbDWW3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, benh@kernel.crashing.org, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mingo@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: tracking vDSO remap
has been added to the -mm tree.  Its filename is
     powerpc-mm-tracking-vdso-remap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-tracking-vdso-remap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-tracking-vdso-remap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: powerpc/mm: tracking vDSO remap

Some processes (CRIU) are moving the vDSO area using the mremap system
call.  As a consequence the kernel reference to the vDSO base address is
no more valid and the signal return frame built once the vDSO has been
moved is not pointing to the new sigreturn address.

This patch handles vDSO remapping and unmapping.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/mm-arch-hooks.h |   13 +++++++++++
 arch/powerpc/include/asm/mmu_context.h   |   23 ++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/include/asm/mm-arch-hooks.h~powerpc-mm-tracking-vdso-remap arch/powerpc/include/asm/mm-arch-hooks.h
--- a/arch/powerpc/include/asm/mm-arch-hooks.h~powerpc-mm-tracking-vdso-remap
+++ a/arch/powerpc/include/asm/mm-arch-hooks.h
@@ -12,4 +12,17 @@
 #ifndef _ASM_POWERPC_MM_ARCH_HOOKS_H
 #define _ASM_POWERPC_MM_ARCH_HOOKS_H
 
+static inline void arch_remap(struct mm_struct *mm,
+			      unsigned long old_start, unsigned long old_end,
+			      unsigned long new_start, unsigned long new_end)
+{
+	/*
+	 * mremap() doesn't allow moving multiple vmas so we can limit the
+	 * check to old_start == vdso_base.
+	 */
+	if (old_start == mm->context.vdso_base)
+		mm->context.vdso_base = new_start;
+}
+#define arch_remap arch_remap
+
 #endif /* _ASM_POWERPC_MM_ARCH_HOOKS_H */
diff -puN arch/powerpc/include/asm/mmu_context.h~powerpc-mm-tracking-vdso-remap arch/powerpc/include/asm/mmu_context.h
--- a/arch/powerpc/include/asm/mmu_context.h~powerpc-mm-tracking-vdso-remap
+++ a/arch/powerpc/include/asm/mmu_context.h
@@ -8,7 +8,6 @@
 #include <linux/spinlock.h>
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
-#include <asm-generic/mm_hooks.h>
 #include <asm/cputhreads.h>
 
 /*
@@ -109,5 +108,27 @@ static inline void enter_lazy_tlb(struct
 #endif
 }
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+}
+
+static inline void arch_unmap(struct mm_struct *mm,
+			      struct vm_area_struct *vma,
+			      unsigned long start, unsigned long end)
+{
+	if (start <= mm->context.vdso_base && mm->context.vdso_base < end)
+		mm->context.vdso_base = 0;
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch

