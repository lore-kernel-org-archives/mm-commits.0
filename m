Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0594D412276
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521187; cv=none; b=DfijlvXn6pTHpi0vHs6hL2wt/HURBZqJHUDW6bQWDKzANDan/Ym0ueIxjzCRhV5Y1X6FJ3tR1YOeDP8nM70doZ073RFTFrSOo/4WvjQRcmsBAN3wOfKGMssKeHZ2DW41KJVKMpw802v8I6OD7gqibnT3aekZbDZWIjWw4E+vXLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521187; c=relaxed/simple;
	bh=gEix4kgVRs9deLn4NkgE9ulqX/0zZwm4Ril4RTwyRHY=;
	h=Date:To:From:Subject:Message-Id; b=EFYWTuB9HR699jfhyRZswH7achZ8W9BpIDEuMB/zN0ziAnQvNdLuLRAYy7qpRSHwDhRKfEj9XkkNbV9ABI0D+2oYI6hm/ZPWtOW/QiJOUHVQpRX1/zem6gT+QALe9VKUH2/sQxgvv0WP54uJALZFNpSh265Jx8rps0ZTMQxlbzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CEilppZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CEilppZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9971F00ACF;
	Fri, 31 Jul 2026 18:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521183;
	bh=3DklWWuN4U7iaOsgzkzJv/GyuUkFG43f6d3pC5kF2f4=;
	h=Date:To:From:Subject;
	b=CEilppZAnMTbR3qp1PSx0o/H5YXhHBxtFWeFTOkt20M/Kf5yFwHBtwEE2pxXJDKzc
	 i9IYh7QagTVY0o509V8EfiwR0e5N2kug7twVpnhON6joyNrtYMdv+OaSsLN85G2NME
	 MXXmXY6CXwsqmhEcgvLqY4GYJDNGsHG8DjP7d450=
Date: Fri, 31 Jul 2026 11:06:22 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-remove-setup_bootmem_node-and-plat_mem_setup.patch added to mm-new branch
Message-Id: <20260731180623.4D9971F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: remove setup_bootmem_node() and plat_mem_setup()
has been added to the -mm mm-new branch.  Its filename is
     sh-remove-setup_bootmem_node-and-plat_mem_setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-remove-setup_bootmem_node-and-plat_mem_setup.patch

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
Subject: sh: remove setup_bootmem_node() and plat_mem_setup()
Date: Sun, 10 May 2026 16:55:40 +0300

setup_bootmem_node() and plat_mem_setup() were needed to setup NUMA
"nodes" for URAM memory ranges.  Since there is no NUMA support anymore,
these functions are not needed.

Remove them.

Link: https://lore.kernel.org/20260510135546.13554-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    5 -----
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    4 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    4 ----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |   17 -----------------
 arch/sh/mm/init.c                      |    7 -------
 7 files changed, 49 deletions(-)

--- a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
@@ -381,8 +381,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* TODO: Register Node 1 */
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -658,9 +658,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0x055f0000, 0x05610000);
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -1239,7 +1239,3 @@ void __init plat_irq_setup_pins(int mode
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -600,9 +600,3 @@ void __init plat_irq_setup_pins(int mode
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0xe55f0000, 0xe5610000);
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -783,10 +783,6 @@ void __init plat_irq_setup_pins(int mode
 	}
 }
 
-void __init plat_mem_setup(void)
-{
-}
-
 static int __init sh7786_devices_setup(void)
 {
 	int ret, irq;
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -377,20 +377,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	unsigned int nid = 1;
-
-	/* Register CPU#0 URAM space as Node 1 */
-	setup_bootmem_node(nid++, 0x145f0000, 0x14610000);	/* CPU0 */
-
-#if 0
-	/* XXX: Not yet.. */
-	setup_bootmem_node(nid++, 0x14df0000, 0x14e10000);	/* CPU1 */
-	setup_bootmem_node(nid++, 0x155f0000, 0x15610000);	/* CPU2 */
-	setup_bootmem_node(nid++, 0x15df0000, 0x15e10000);	/* CPU3 */
-#endif
-
-	setup_bootmem_node(nid++, 0x16000000, 0x16020000);	/* CSM */
-}
--- a/arch/sh/mm/init.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/mm/init.c
@@ -38,11 +38,6 @@ void __init generic_mem_init(void)
 	memblock_add(__MEMORY_START, __MEMORY_SIZE);
 }
 
-void __init __weak plat_mem_setup(void)
-{
-	/* Nothing to see here, move along. */
-}
-
 #ifdef CONFIG_MMU
 static pte_t *__get_pte_phys(unsigned long addr)
 {
@@ -209,8 +204,6 @@ static void __init do_init_bootmem(void)
 		__add_active_range(0, start_pfn, end_pfn);
 
 	node_set_online(0);
-
-	plat_mem_setup();
 }
 
 static void __init early_reserve_mem(void)
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

