Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8062919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560145; cv=none; b=Fs8dtY9xDg+U2bNYYsc6oIKqu6pCP1yJ6ysSfZQyh+AV/GKzPvNAFzkwhByuV2h7/qQP6rW4P7dEUBCrm3/YFdNzsCYGy1eBrRNOxh2gWK/VlE4qHEJ3HB+Q5UFGZLHqYjeE1CmrGWjSAcDpyLvC+cpO8btKJqoi44BaCkLx3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560145; c=relaxed/simple;
	bh=b8VDnQQlSes9iwm+DYRNaeOcLGpc2xLw9Si4CMv5P+c=;
	h=Date:To:From:Subject:Message-Id; b=bQBlGuknG6cFBT/84uR/XXzj+ap0eyfzXJeosVe4fdsPnzNhUuUpRA4d3Dh8LurS1BSSOb2VCQz0E+RPixWLWTG3kV35s2HQU91D2nGWvzqwGLnPW7YViVbaD70HV0LViPNMwe0r0iPZUNDG+mUcR/chkkN83e8wkl/8SbUMhxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TU2iS3AF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TU2iS3AF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0877DC433C7;
	Thu, 22 Feb 2024 00:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560145;
	bh=b8VDnQQlSes9iwm+DYRNaeOcLGpc2xLw9Si4CMv5P+c=;
	h=Date:To:From:Subject:From;
	b=TU2iS3AFD87em16yCEl29+jfMxPmqSM3SxZ0IAlDKqqkSLGWTzaq931VqNaFCBrJE
	 dTWDWqRzKadnt029S4DtQs8zMZeRvEHA8iHimyZzn8q9oVGoKujyFw6hTF4vGzVydQ
	 7CpwyYcj1a0RyTgs2j8y3GHYOQ6QEQL7nAwk3uk8=
Date: Wed, 21 Feb 2024 16:02:24 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tranmanphong@gmail.com,tglx@linutronix.de,svens@linux.ibm.com,steven.price@arm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,hpa@zytor.com,hca@linux.ibm.com,greg@kroah.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx.patch removed from -mm tree
Message-Id: <20240222000225.0877DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64, powerpc, riscv, s390, x86: ptdump: refactor CONFIG_DEBUG_WX
has been removed from the -mm tree.  Its filename was
     arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: arm64, powerpc, riscv, s390, x86: ptdump: refactor CONFIG_DEBUG_WX
Date: Tue, 30 Jan 2024 11:34:33 +0100

All architectures using the core ptdump functionality also implement
CONFIG_DEBUG_WX, and they all do it more or less the same way, with a
function called debug_checkwx() that is called by mark_rodata_ro(), which
is a substitute to ptdump_check_wx() when CONFIG_DEBUG_WX is set and a
no-op otherwise.

Refactor by centrally defining debug_checkwx() in linux/ptdump.h and call
debug_checkwx() immediately after calling mark_rodata_ro() instead of
calling it at the end of every mark_rodata_ro().

On x86_32, mark_rodata_ro() first checks __supported_pte_mask has _PAGE_NX
before calling debug_checkwx().  Now the check is inside the callee
ptdump_walk_pgd_level_checkwx().

On powerpc_64, mark_rodata_ro() bails out early before calling
ptdump_check_wx() when the MMU doesn't have KERNEL_RO feature.  The check
is now also done in ptdump_check_wx() as it is called outside
mark_rodata_ro().

Link: https://lkml.kernel.org/r/a59b102d7964261d31ead0316a9f18628e4e7a8e.1706610398.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Phong Tran <tranmanphong@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Price <steven.price@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/ptdump.h |    7 -------
 arch/arm64/mm/mmu.c             |    2 --
 arch/powerpc/mm/mmu_decl.h      |    6 ------
 arch/powerpc/mm/pgtable_32.c    |    4 ----
 arch/powerpc/mm/pgtable_64.c    |    3 ---
 arch/powerpc/mm/ptdump/ptdump.c |    3 +++
 arch/riscv/include/asm/ptdump.h |   22 ----------------------
 arch/riscv/mm/init.c            |    3 ---
 arch/riscv/mm/ptdump.c          |    1 -
 arch/s390/include/asm/ptdump.h  |   14 --------------
 arch/s390/mm/dump_pagetables.c  |    1 -
 arch/s390/mm/init.c             |    2 --
 arch/x86/include/asm/pgtable.h  |    3 +--
 arch/x86/mm/dump_pagetables.c   |    3 +++
 arch/x86/mm/init_32.c           |    2 --
 arch/x86/mm/init_64.c           |    2 --
 include/linux/ptdump.h          |    7 +++++++
 init/main.c                     |    2 ++
 18 files changed, 16 insertions(+), 71 deletions(-)

--- a/arch/arm64/include/asm/ptdump.h~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/arm64/include/asm/ptdump.h
@@ -29,13 +29,6 @@ void __init ptdump_debugfs_register(stru
 static inline void ptdump_debugfs_register(struct ptdump_info *info,
 					   const char *name) { }
 #endif
-void ptdump_check_wx(void);
 #endif /* CONFIG_PTDUMP_CORE */
 
-#ifdef CONFIG_DEBUG_WX
-#define debug_checkwx()	ptdump_check_wx()
-#else
-#define debug_checkwx()	do { } while (0)
-#endif
-
 #endif /* __ASM_PTDUMP_H */
--- a/arch/arm64/mm/mmu.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/arm64/mm/mmu.c
@@ -632,8 +632,6 @@ void mark_rodata_ro(void)
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
 	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
-
-	debug_checkwx();
 }
 
 static void __init map_kernel_segment(pgd_t *pgdp, void *va_start, void *va_end,
--- a/arch/powerpc/mm/mmu_decl.h~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/powerpc/mm/mmu_decl.h
@@ -171,12 +171,6 @@ static inline void mmu_mark_rodata_ro(vo
 void __init mmu_mapin_immr(void);
 #endif
 
-#ifdef CONFIG_DEBUG_WX
-void ptdump_check_wx(void);
-#else
-static inline void ptdump_check_wx(void) { }
-#endif
-
 static inline bool debug_pagealloc_enabled_or_kfence(void)
 {
 	return IS_ENABLED(CONFIG_KFENCE) || debug_pagealloc_enabled();
--- a/arch/powerpc/mm/pgtable_32.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -153,7 +153,6 @@ void mark_rodata_ro(void)
 
 	if (v_block_mapped((unsigned long)_stext + 1)) {
 		mmu_mark_rodata_ro();
-		ptdump_check_wx();
 		return;
 	}
 
@@ -166,9 +165,6 @@ void mark_rodata_ro(void)
 		   PFN_DOWN((unsigned long)_stext);
 
 	set_memory_ro((unsigned long)_stext, numpages);
-
-	// mark_initmem_nx() should have already run by now
-	ptdump_check_wx();
 }
 #endif
 
--- a/arch/powerpc/mm/pgtable_64.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -150,9 +150,6 @@ void mark_rodata_ro(void)
 		radix__mark_rodata_ro();
 	else
 		hash__mark_rodata_ro();
-
-	// mark_initmem_nx() should have already run by now
-	ptdump_check_wx();
 }
 
 void mark_initmem_nx(void)
--- a/arch/powerpc/mm/ptdump/ptdump.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -343,6 +343,9 @@ void ptdump_check_wx(void)
 		}
 	};
 
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !mmu_has_feature(MMU_FTR_KERNEL_RO))
+		return;
+
 	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
 
 	if (st.wx_pages)
--- a/arch/riscv/include/asm/ptdump.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2019 SiFive
- */
-
-#ifndef _ASM_RISCV_PTDUMP_H
-#define _ASM_RISCV_PTDUMP_H
-
-void ptdump_check_wx(void);
-
-#ifdef CONFIG_DEBUG_WX
-static inline void debug_checkwx(void)
-{
-	ptdump_check_wx();
-}
-#else
-static inline void debug_checkwx(void)
-{
-}
-#endif
-
-#endif /* _ASM_RISCV_PTDUMP_H */
--- a/arch/riscv/mm/init.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/riscv/mm/init.c
@@ -29,7 +29,6 @@
 #include <asm/io.h>
 #include <asm/numa.h>
 #include <asm/pgtable.h>
-#include <asm/ptdump.h>
 #include <asm/sections.h>
 #include <asm/soc.h>
 #include <asm/tlbflush.h>
@@ -723,8 +722,6 @@ void mark_rodata_ro(void)
 	if (IS_ENABLED(CONFIG_64BIT))
 		set_kernel_memory(lm_alias(__start_rodata), lm_alias(_data),
 				  set_memory_ro);
-
-	debug_checkwx();
 }
 #else
 static __init pgprot_t pgprot_from_va(uintptr_t va)
--- a/arch/riscv/mm/ptdump.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/riscv/mm/ptdump.c
@@ -9,7 +9,6 @@
 #include <linux/seq_file.h>
 #include <linux/ptdump.h>
 
-#include <asm/ptdump.h>
 #include <linux/pgtable.h>
 #include <asm/kasan.h>
 
--- a/arch/s390/include/asm/ptdump.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#ifndef _ASM_S390_PTDUMP_H
-#define _ASM_S390_PTDUMP_H
-
-void ptdump_check_wx(void);
-
-static inline void debug_checkwx(void)
-{
-	if (IS_ENABLED(CONFIG_DEBUG_WX))
-		ptdump_check_wx();
-}
-
-#endif /* _ASM_S390_PTDUMP_H */
--- a/arch/s390/mm/dump_pagetables.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/s390/mm/dump_pagetables.c
@@ -6,7 +6,6 @@
 #include <linux/mm.h>
 #include <linux/kfence.h>
 #include <linux/kasan.h>
-#include <asm/ptdump.h>
 #include <asm/kasan.h>
 #include <asm/abs_lowcore.h>
 #include <asm/nospec-branch.h>
--- a/arch/s390/mm/init.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/s390/mm/init.c
@@ -37,7 +37,6 @@
 #include <asm/pgalloc.h>
 #include <asm/ctlreg.h>
 #include <asm/kfence.h>
-#include <asm/ptdump.h>
 #include <asm/dma.h>
 #include <asm/abs_lowcore.h>
 #include <asm/tlb.h>
@@ -109,7 +108,6 @@ void mark_rodata_ro(void)
 
 	__set_memory_ro(__start_ro_after_init, __end_ro_after_init);
 	pr_info("Write protected read-only-after-init data: %luk\n", size >> 10);
-	debug_checkwx();
 }
 
 int set_memory_encrypted(unsigned long vaddr, int numpages)
--- a/arch/x86/include/asm/pgtable.h~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/x86/include/asm/pgtable.h
@@ -32,6 +32,7 @@ void ptdump_walk_pgd_level(struct seq_fi
 void ptdump_walk_pgd_level_debugfs(struct seq_file *m, struct mm_struct *mm,
 				   bool user);
 void ptdump_walk_pgd_level_checkwx(void);
+#define ptdump_check_wx ptdump_walk_pgd_level_checkwx
 void ptdump_walk_user_pgd_level_checkwx(void);
 
 /*
@@ -41,10 +42,8 @@ void ptdump_walk_user_pgd_level_checkwx(
 #define pgprot_decrypted(prot)	__pgprot(cc_mkdec(pgprot_val(prot)))
 
 #ifdef CONFIG_DEBUG_WX
-#define debug_checkwx()		ptdump_walk_pgd_level_checkwx()
 #define debug_checkwx_user()	ptdump_walk_user_pgd_level_checkwx()
 #else
-#define debug_checkwx()		do { } while (0)
 #define debug_checkwx_user()	do { } while (0)
 #endif
 
--- a/arch/x86/mm/dump_pagetables.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/x86/mm/dump_pagetables.c
@@ -433,6 +433,9 @@ void ptdump_walk_user_pgd_level_checkwx(
 
 void ptdump_walk_pgd_level_checkwx(void)
 {
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return;
+
 	ptdump_walk_pgd_level_core(NULL, &init_mm, INIT_PGD, true, false);
 }
 
--- a/arch/x86/mm/init_32.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/x86/mm/init_32.c
@@ -800,6 +800,4 @@ void mark_rodata_ro(void)
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 #endif
 	mark_nxdata_nx();
-	if (__supported_pte_mask & _PAGE_NX)
-		debug_checkwx();
 }
--- a/arch/x86/mm/init_64.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/arch/x86/mm/init_64.c
@@ -1412,8 +1412,6 @@ void mark_rodata_ro(void)
 				(void *)text_end, (void *)rodata_start);
 	free_kernel_image_pages("unused kernel image (rodata/data gap)",
 				(void *)rodata_end, (void *)_sdata);
-
-	debug_checkwx();
 }
 
 /*
--- a/include/linux/ptdump.h~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/include/linux/ptdump.h
@@ -19,5 +19,12 @@ struct ptdump_state {
 };
 
 void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd);
+void ptdump_check_wx(void);
+
+static inline void debug_checkwx(void)
+{
+	if (IS_ENABLED(CONFIG_DEBUG_WX))
+		ptdump_check_wx();
+}
 
 #endif /* _LINUX_PTDUMP_H */
--- a/init/main.c~arm64-powerpc-riscv-s390-x86-ptdump-refactor-config_debug_wx
+++ a/init/main.c
@@ -99,6 +99,7 @@
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
 #include <linux/randomize_kstack.h>
+#include <linux/ptdump.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1408,6 +1409,7 @@ static void mark_readonly(void)
 		 */
 		rcu_barrier();
 		mark_rodata_ro();
+		debug_checkwx();
 		rodata_test();
 	} else
 		pr_info("Kernel memory protection disabled.\n");
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


