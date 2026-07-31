Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516CD34D384
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521193; cv=none; b=bI5hr78vLlreZvouerqRsWpKx8arqksJgOV9zV0opgKL3sdHjAz7FCGfUJjy6tYJizdGHc+2zWTZPehJWYb9BeusQOslSH2traMfmot4kv4lqAZy4iOpdFmFxQ/TkfcidL5Cs5oG81E3vWlEOQoG9o+nriGPWLdM2wtcEM7PvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521193; c=relaxed/simple;
	bh=va9+9PKXOnr+lDroSoNkxV/4iohKWnV58/t7oJfgtyQ=;
	h=Date:To:From:Subject:Message-Id; b=JaHASTZLEyeYhJEbkP4GNq/YDS2wJFeDAZD7rhURrDcEPABpEeJ5my52DPg6Vg+7aPYlg6cw6ch3e5pT8Eg89gKuq2qH+j0vIUX+xdoWocYZKqf54ZEkEHafGnzZAR1KfgwdWDZiRZ2JZ5wmobN3DDDigwC0GC4Wh0n1hMEWt1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QCpIGf8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QCpIGf8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22B61F00AC4;
	Fri, 31 Jul 2026 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521191;
	bh=qGNl+15HnDjD4dKmP5zd2+zzffhb+zkhhgRrVOsbkro=;
	h=Date:To:From:Subject;
	b=QCpIGf8HNjFehCaHK4ixKpEz6+UipwujTLeYnU4PwIFxEZPezezENVJp6fUv7lwy3
	 yJfsXdHNS09phE9VlzZtMG/n0pBE11a52GRyaf/UV88B8UQ1DkzLjYHRWhKvGPKNH+
	 snNGa2EYvhpGLVI0KDS9VdboPSnWNA3l9yN6QZSA=
Date: Fri, 31 Jul 2026 11:06:31 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-drop-include-asm-mmzoneh.patch added to mm-new branch
Message-Id: <20260731180631.B22B61F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: drop include/asm/mmzone.h
has been added to the -mm mm-new branch.  Its filename is
     sh-drop-include-asm-mmzoneh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-drop-include-asm-mmzoneh.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop include/asm/mmzone.h
Date: Sun, 10 May 2026 16:55:42 +0300

include/asm/mmzone.h was required for declarations of NUMA related
functionality.

The only function declared there that's not related to NUMA is
__add_active_range().

Move __add_active_range() declaration to include/asm/setup.h and drop
include/asm/mmzone.h

Link: https://lore.kernel.org/20260510135546.13554-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/mmzone.h           |   42 -----------------------
 arch/sh/include/asm/setup.h            |    3 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    1 
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |    1 
 arch/sh/kernel/setup.c                 |    2 -
 arch/sh/mm/init.c                      |    1 
 11 files changed, 3 insertions(+), 52 deletions(-)

diff --git a/arch/sh/include/asm/mmzone.h a/arch/sh/include/asm/mmzone.h
deleted file mode 100644
--- a/arch/sh/include/asm/mmzone.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_SH_MMZONE_H
-#define __ASM_SH_MMZONE_H
-
-#ifdef CONFIG_NUMA
-#include <linux/numa.h>
-
-static inline int pfn_to_nid(unsigned long pfn)
-{
-	int nid;
-
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
-		if (pfn >= node_start_pfn(nid) && pfn <= node_end_pfn(nid))
-			break;
-
-	return nid;
-}
-
-static inline struct pglist_data *pfn_to_pgdat(unsigned long pfn)
-{
-	return NODE_DATA(pfn_to_nid(pfn));
-}
-
-/* arch/sh/mm/numa.c */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end);
-#else
-static inline void
-setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-}
-#endif /* CONFIG_NUMA */
-
-/* Platform specific mem init */
-void __init plat_mem_setup(void);
-
-/* arch/sh/kernel/setup.c */
-void __init __add_active_range(unsigned int nid, unsigned long start_pfn,
-			       unsigned long end_pfn);
-/* arch/sh/mm/init.c */
-void __init allocate_pgdat(unsigned int nid);
-
-#endif /* __ASM_SH_MMZONE_H */
--- a/arch/sh/include/asm/setup.h~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/include/asm/setup.h
@@ -24,4 +24,7 @@ void check_for_initrd(void);
 void per_cpu_trap_init(void);
 void sh_fdt_init(phys_addr_t dt_phys);
 
+void __add_active_range(unsigned int nid, unsigned long start_pfn,
+			unsigned long end_pfn);
+
 #endif /* _SH_SETUP_H */
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -16,7 +16,6 @@
 #include <linux/usb/m66592.h>
 
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/siu.h>
 #include <asm/platform_early.h>
 
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
@@ -17,7 +17,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/sh7723.h>
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7724.c
@@ -24,7 +24,6 @@
 #include <asm/cacheflush.h>
 #include <asm/suspend.h>
 #include <asm/clock.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 #include <cpu/dma-register.h>
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -21,7 +21,6 @@
 #include <cpu/dma-register.h>
 #include <cpu/sh7757.h>
 
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif2_platform_data = {
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -13,7 +13,6 @@
 #include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 #include <cpu/dma-register.h>
 
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -22,7 +22,6 @@
 #include <linux/sh_intc.h>
 #include <linux/usb/ohci_pdriver.h>
 #include <cpu/dma-register.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 static struct plat_sci_port scif0_platform_data = {
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -13,7 +13,6 @@
 #include <linux/sh_timer.h>
 #include <linux/sh_intc.h>
 #include <cpu/shx3.h>
-#include <asm/mmzone.h>
 #include <asm/platform_early.h>
 
 /*
--- a/arch/sh/kernel/setup.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/kernel/setup.c
@@ -23,7 +23,6 @@
 #include <linux/smp.h>
 #include <linux/err.h>
 #include <linux/crash_dump.h>
-#include <linux/mmzone.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -41,7 +40,6 @@
 #include <asm/clock.h>
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/processor.h>
 #include <asm/sparsemem.h>
 #include <asm/platform_early.h>
--- a/arch/sh/mm/init.c~sh-drop-include-asm-mmzoneh
+++ a/arch/sh/mm/init.c
@@ -20,7 +20,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <asm/mmu_context.h>
-#include <asm/mmzone.h>
 #include <asm/kexec.h>
 #include <asm/tlb.h>
 #include <asm/cacheflush.h>
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

