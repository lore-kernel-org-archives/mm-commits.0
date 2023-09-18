Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218F0CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjIRQ0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjIRQJN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:09:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD249D9
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:07:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46502C433CB;
        Mon, 18 Sep 2023 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695052324;
        bh=SEFJvN7TSHVHa/ewEOVsAnoH0WDaZxf90pemaD3aTuo=;
        h=Date:To:From:Subject:From;
        b=aPP0reBU5x313yJttfkXAzeg8p5yp1OQOnYmIcDuym5aGjXvmId+XexKMHS/SIXbZ
         zkgZ0GiIhjtKUwvXC1hfUXNoIVgPdCrU/kMe/eraCh8aVsxYfq+Uhm5SsOU4CMwYAk
         ViDoy84wRRfzAva7d068z8A+kl+tsdm5Wxb17x5o=
Date:   Mon, 18 Sep 2023 08:52:03 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tglx@linutronix.de, song@kernel.org,
        rostedt@goodmis.org, rick.p.edgecombe@intel.com,
        puranjay12@gmail.com, palmer@dabbelt.com,
        naveen.n.rao@linux.ibm.com, nadav.amit@gmail.com,
        mpe@ellerman.id.au, mcgrof@kernel.org, mark.rutland@arm.com,
        linux@armlinux.org.uk, kent.overstreet@linux.dev,
        hca@linux.ibm.com, dinguyen@kernel.org, deller@gmx.de,
        davem@davemloft.net, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bjorn@kernel.org,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch added to mm-unstable branch
Message-Id: <20230918155204.46502C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/execmem, arch: convert remaining overrides of module_alloc to execmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/execmem, arch: convert remaining overrides of module_alloc to execmem
Date: Mon, 18 Sep 2023 10:29:46 +0300

Extend execmem parameters to accommodate more complex overrides of
module_alloc() by architectures.

This includes specification of a fallback range required by arm, arm64 and
powerpc and support for allocation of KASAN shadow required by arm64, s390
and x86.

The core implementation of execmem_alloc() takes care of suppressing
warnings when the initial allocation fails but there is a fallback range
defined.

Link: https://lkml.kernel.org/r/20230918072955.2507221-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/module.c     |   36 ++++++++++--------
 arch/arm64/kernel/module.c   |   57 ++++++++++++----------------
 arch/powerpc/kernel/module.c |   52 +++++++++++++-------------
 arch/s390/kernel/module.c    |   48 +++++++++---------------
 arch/x86/kernel/module.c     |   66 ++++++++++-----------------------
 include/linux/execmem.h      |   14 +++++++
 mm/execmem.c                 |   43 ++++++++++++++++++++-
 7 files changed, 165 insertions(+), 151 deletions(-)

--- a/arch/arm64/kernel/module.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/arch/arm64/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/random.h>
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
+#include <linux/execmem.h>
 
 #include <asm/alternative.h>
 #include <asm/insn.h>
@@ -108,46 +109,38 @@ static int __init module_init_limits(voi
 
 	return 0;
 }
-subsys_initcall(module_init_limits);
 
-void *module_alloc(unsigned long size)
+static struct execmem_params execmem_params __ro_after_init = {
+	.ranges = {
+		[EXECMEM_DEFAULT] = {
+			.flags = EXECMEM_KASAN_SHADOW,
+			.alignment = MODULE_ALIGN,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
-	void *p = NULL;
+	struct execmem_range *r = &execmem_params.ranges[EXECMEM_DEFAULT];
 
-	/*
-	 * Where possible, prefer to allocate within direct branch range of the
-	 * kernel such that no PLTs are necessary.
-	 */
-	if (module_direct_base) {
-		p = __vmalloc_node_range(size, MODULE_ALIGN,
-					 module_direct_base,
-					 module_direct_base + SZ_128M,
-					 GFP_KERNEL | __GFP_NOWARN,
-					 PAGE_KERNEL, 0, NUMA_NO_NODE,
-					 __builtin_return_address(0));
-	}
+	module_init_limits();
 
-	if (!p && module_plt_base) {
-		p = __vmalloc_node_range(size, MODULE_ALIGN,
-					 module_plt_base,
-					 module_plt_base + SZ_2G,
-					 GFP_KERNEL | __GFP_NOWARN,
-					 PAGE_KERNEL, 0, NUMA_NO_NODE,
-					 __builtin_return_address(0));
-	}
+	r->pgprot = PAGE_KERNEL;
 
-	if (!p) {
-		pr_warn_ratelimited("%s: unable to allocate memory\n",
-				    __func__);
-	}
+	if (module_direct_base) {
+		r->start = module_direct_base;
+		r->end = module_direct_base + SZ_128M;
 
-	if (p && (kasan_alloc_module_shadow(p, size, GFP_KERNEL) < 0)) {
-		vfree(p);
-		return NULL;
+		if (module_plt_base) {
+			r->fallback_start = module_plt_base;
+			r->fallback_end = module_plt_base + SZ_2G;
+		}
+	} else if (module_plt_base) {
+		r->start = module_plt_base;
+		r->end = module_plt_base + SZ_2G;
 	}
 
-	/* Memory is intended to be executable, reset the pointer tag. */
-	return kasan_reset_tag(p);
+	return &execmem_params;
 }
 
 enum aarch64_reloc_op {
--- a/arch/arm/kernel/module.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/arch/arm/kernel/module.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
+#include <linux/execmem.h>
 
 #include <asm/sections.h>
 #include <asm/smp_plat.h>
@@ -34,23 +35,28 @@
 #endif
 
 #ifdef CONFIG_MMU
-void *module_alloc(unsigned long size)
+static struct execmem_params execmem_params __ro_after_init = {
+	.ranges = {
+		[EXECMEM_DEFAULT] = {
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
+	struct execmem_range *r = &execmem_params.ranges[EXECMEM_DEFAULT];
+
+	r->pgprot = PAGE_KERNEL_EXEC;
+
+	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
+		r->fallback_start = VMALLOC_START;
+		r->fallback_end = VMALLOC_END;
+	}
 
-	/* Silence the initial allocation */
-	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS))
-		gfp_mask |= __GFP_NOWARN;
-
-	p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				gfp_mask, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
-	if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || p)
-		return p;
-	return __vmalloc_node_range(size, 1,  VMALLOC_START, VMALLOC_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
+	return &execmem_params;
 }
 #endif
 
--- a/arch/powerpc/kernel/module.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/arch/powerpc/kernel/module.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/bug.h>
+#include <linux/execmem.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
 #include <asm/firmware.h>
@@ -89,39 +90,38 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-static __always_inline void *
-__module_alloc(unsigned long size, unsigned long start, unsigned long end, bool nowarn)
+static struct execmem_params execmem_params __ro_after_init = {
+	.ranges = {
+		[EXECMEM_DEFAULT] = {
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
 	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
-	gfp_t gfp = GFP_KERNEL | (nowarn ? __GFP_NOWARN : 0);
-
-	/*
-	 * Don't do huge page allocations for modules yet until more testing
-	 * is done. STRICT_MODULE_RWX may require extra work to support this
-	 * too.
-	 */
-	return __vmalloc_node_range(size, 1, start, end, gfp, prot,
-				    VM_FLUSH_RESET_PERMS,
-				    NUMA_NO_NODE, __builtin_return_address(0));
-}
+	struct execmem_range *range = &execmem_params.ranges[EXECMEM_DEFAULT];
 
-void *module_alloc(unsigned long size)
-{
 #ifdef MODULES_VADDR
 	unsigned long limit = (unsigned long)_etext - SZ_32M;
-	void *ptr = NULL;
-
-	BUILD_BUG_ON(TASK_SIZE > MODULES_VADDR);
 
 	/* First try within 32M limit from _etext to avoid branch trampolines */
-	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit)
-		ptr = __module_alloc(size, limit, MODULES_END, true);
-
-	if (!ptr)
-		ptr = __module_alloc(size, MODULES_VADDR, MODULES_END, false);
-
-	return ptr;
+	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
+		range->start = limit;
+		range->end = MODULES_END;
+		range->fallback_start = MODULES_VADDR;
+		range->fallback_end = MODULES_END;
+	} else {
+		range->start = MODULES_VADDR;
+		range->end = MODULES_END;
+	}
 #else
-	return __module_alloc(size, VMALLOC_START, VMALLOC_END, false);
+	range->start = VMALLOC_START;
+	range->end = VMALLOC_END;
 #endif
+
+	range->pgprot = prot;
+
+	return &execmem_params;
 }
--- a/arch/s390/kernel/module.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/arch/s390/kernel/module.c
@@ -37,41 +37,29 @@
 
 #define PLT_ENTRY_SIZE 22
 
-static unsigned long get_module_load_offset(void)
+static struct execmem_params execmem_params __ro_after_init = {
+	.ranges = {
+		[EXECMEM_DEFAULT] = {
+			.flags = EXECMEM_KASAN_SHADOW,
+			.alignment = MODULE_ALIGN,
+			.pgprot = PAGE_KERNEL,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
-	static DEFINE_MUTEX(module_kaslr_mutex);
-	static unsigned long module_load_offset;
+	unsigned long module_load_offset = 0;
+	unsigned long start;
 
-	if (!kaslr_enabled())
-		return 0;
-	/*
-	 * Calculate the module_load_offset the first time this code
-	 * is called. Once calculated it stays the same until reboot.
-	 */
-	mutex_lock(&module_kaslr_mutex);
-	if (!module_load_offset)
+	if (kaslr_enabled())
 		module_load_offset = get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
-	mutex_unlock(&module_kaslr_mutex);
-	return module_load_offset;
-}
 
-void *module_alloc(unsigned long size)
-{
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
+	start = MODULES_VADDR + module_load_offset;
+	execmem_params.ranges[EXECMEM_DEFAULT].start = start;
+	execmem_params.ranges[EXECMEM_DEFAULT].end = MODULES_END;
 
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				 MODULES_VADDR + get_module_load_offset(),
-				 MODULES_END, gfp_mask, PAGE_KERNEL,
-				 VM_FLUSH_RESET_PERMS | VM_DEFER_KMEMLEAK,
-				 NUMA_NO_NODE, __builtin_return_address(0));
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
-	}
-	return p;
+	return &execmem_params;
 }
 
 #ifdef CONFIG_FUNCTION_TRACER
--- a/arch/x86/kernel/module.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/arch/x86/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
 #include <linux/random.h>
 #include <linux/memory.h>
+#include <linux/execmem.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -36,55 +37,30 @@ do {							\
 } while (0)
 #endif
 
-#ifdef CONFIG_RANDOMIZE_BASE
-static unsigned long module_load_offset;
+static struct execmem_params execmem_params __ro_after_init = {
+	.ranges = {
+		[EXECMEM_DEFAULT] = {
+			.flags = EXECMEM_KASAN_SHADOW,
+			.alignment = MODULE_ALIGN,
+		},
+	},
+};
 
-/* Mutex protects the module_load_offset. */
-static DEFINE_MUTEX(module_kaslr_mutex);
-
-static unsigned long int get_module_load_offset(void)
+struct execmem_params __init *execmem_arch_params(void)
 {
-	if (kaslr_enabled()) {
-		mutex_lock(&module_kaslr_mutex);
-		/*
-		 * Calculate the module_load_offset the first time this
-		 * code is called. Once calculated it stays the same until
-		 * reboot.
-		 */
-		if (module_load_offset == 0)
-			module_load_offset =
-				get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
-		mutex_unlock(&module_kaslr_mutex);
-	}
-	return module_load_offset;
-}
-#else
-static unsigned long int get_module_load_offset(void)
-{
-	return 0;
-}
-#endif
-
-void *module_alloc(unsigned long size)
-{
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
+	unsigned long module_load_offset = 0;
+	unsigned long start;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				 MODULES_VADDR + get_module_load_offset(),
-				 MODULES_END, gfp_mask, PAGE_KERNEL,
-				 VM_FLUSH_RESET_PERMS | VM_DEFER_KMEMLEAK,
-				 NUMA_NO_NODE, __builtin_return_address(0));
-
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
-	}
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_enabled())
+		module_load_offset =
+			get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
+
+	start = MODULES_VADDR + module_load_offset;
+	execmem_params.ranges[EXECMEM_DEFAULT].start = start;
+	execmem_params.ranges[EXECMEM_DEFAULT].end = MODULES_END;
+	execmem_params.ranges[EXECMEM_DEFAULT].pgprot = PAGE_KERNEL;
 
-	return p;
+	return &execmem_params;
 }
 
 #ifdef CONFIG_X86_32
--- a/include/linux/execmem.h~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/include/linux/execmem.h
@@ -33,18 +33,32 @@ enum execmem_type {
 };
 
 /**
+ * enum execmem_module_flags - options for executable memory allocations
+ * @EXECMEM_KASAN_SHADOW:	allocate kasan shadow
+ */
+enum execmem_range_flags {
+	EXECMEM_KASAN_SHADOW	= (1 << 0),
+};
+
+/**
  * struct execmem_range - definition of a memory range suitable for code and
  *			  related data allocations
  * @start:	address space start
  * @end:	address space end (inclusive)
+ * @fallback_start:	start of the range for fallback allocations
+ * @fallback_end:	end of the range for fallback allocations (inclusive)
  * @pgprot:	permissions for memory in this address space
  * @alignment:	alignment required for text allocations
+ * @flags:	options for memory allocations for this range
  */
 struct execmem_range {
 	unsigned long   start;
 	unsigned long   end;
+	unsigned long   fallback_start;
+	unsigned long   fallback_end;
 	pgprot_t        pgprot;
 	unsigned int	alignment;
+	enum execmem_range_flags flags;
 };
 
 /**
--- a/mm/execmem.c~mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem
+++ a/mm/execmem.c
@@ -11,12 +11,46 @@ static void *execmem_alloc(size_t size,
 {
 	unsigned long start = range->start;
 	unsigned long end = range->end;
+	unsigned long fallback_start = range->fallback_start;
+	unsigned long fallback_end = range->fallback_end;
 	unsigned int align = range->alignment;
 	pgprot_t pgprot = range->pgprot;
+	bool kasan = range->flags & EXECMEM_KASAN_SHADOW;
+	unsigned long vm_flags  = VM_FLUSH_RESET_PERMS;
+	bool fallback  = !!fallback_start;
+	gfp_t gfp_flags = GFP_KERNEL;
+	void *p;
+
+	if (PAGE_ALIGN(size) > (end - start))
+		return NULL;
+
+	if (kasan)
+		vm_flags |= VM_DEFER_KMEMLEAK;
+
+	if (fallback)
+		gfp_flags |= __GFP_NOWARN;
+
+	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
+				 pgprot, vm_flags, NUMA_NO_NODE,
+				 __builtin_return_address(0));
+
+	if (!p && fallback) {
+		start = fallback_start;
+		end = fallback_end;
+		gfp_flags = GFP_KERNEL;
+
+		p = __vmalloc_node_range(size, align, start, end, gfp_flags,
+					 pgprot, vm_flags, NUMA_NO_NODE,
+					 __builtin_return_address(0));
+	}
+
+	if (p && kasan &&
+	    (kasan_alloc_module_shadow(p, size, GFP_KERNEL) < 0)) {
+		vfree(p);
+		return NULL;
+	}
 
-	return __vmalloc_node_range(size, align, start, end,
-				   GFP_KERNEL, pgprot, VM_FLUSH_RESET_PERMS,
-				   NUMA_NO_NODE, __builtin_return_address(0));
+	return kasan_reset_tag(p);
 }
 
 void *execmem_text_alloc(enum execmem_type type, size_t size)
@@ -66,6 +100,9 @@ static void execmem_init_missing(struct
 			r->alignment = default_range->alignment;
 			r->start = default_range->start;
 			r->end = default_range->end;
+			r->flags = default_range->flags;
+			r->fallback_start = default_range->fallback_start;
+			r->fallback_end = default_range->fallback_end;
 		}
 	}
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

nios2-define-virtual-address-space-for-modules.patch
mm-introduce-execmem_text_alloc-and-execmem_free.patch
mm-execmem-arch-convert-simple-overrides-of-module_alloc-to-execmem.patch
mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch
modules-execmem-drop-module_alloc.patch
mm-execmem-introduce-execmem_data_alloc.patch
arm64-execmem-extend-execmem_params-for-generated-code-allocations.patch
riscv-extend-execmem_params-for-generated-code-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations.patch
arch-make-execmem-setup-available-regardless-of-config_modules.patch
x86-ftrace-enable-dynamic-ftrace-without-config_modules.patch
kprobes-remove-dependency-on-config_modules.patch
bpf-remove-config_bpf_jit-dependency-on-config_modules-of.patch

