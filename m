Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5A7CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjIRQJ6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjIRQJN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:09:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B238249EE
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:07:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A948C116A1;
        Mon, 18 Sep 2023 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695052310;
        bh=1Kyr75COxBlnI6fsBjh37oYMzqTnTLlRL9zJa7Mmmr4=;
        h=Date:To:From:Subject:From;
        b=CyniOmWP3QjksFks5VMJ21SNgknMsfvoo/3dC0V4vSbmV8t/3h4VhdE1Coool9a+L
         go7Ao6oqqe0JxNFIYAGVMOVQKI0TfBPwJ3kexNqaoSxIs8X2fss6OSlSEDO1ZA6fRX
         rBoCbda0SfQiqmzKYLu622zzXz9yr4rGzBI7aV4I=
Date:   Mon, 18 Sep 2023 08:51:49 -0700
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
Subject: + nios2-define-virtual-address-space-for-modules.patch added to mm-unstable branch
Message-Id: <20230918155150.1A948C116A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: define virtual address space for modules
has been added to the -mm mm-unstable branch.  Its filename is
     nios2-define-virtual-address-space-for-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nios2-define-virtual-address-space-for-modules.patch

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
Subject: nios2: define virtual address space for modules
Date: Mon, 18 Sep 2023 10:29:43 +0300

Patch series "mm: jit/text allocator", v3.


nios2 uses kmalloc() to implement module_alloc() because CALL26/PCREL26
cannot reach all of vmalloc address space.

Define module space as 32MiB below the kernel base and switch nios2 to use
vmalloc for module allocations.

Link: https://lkml.kernel.org/r/20230918072955.2507221-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230918072955.2507221-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Puranjay Mohan <puranjay12@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/pgtable.h |    5 ++++-
 arch/nios2/kernel/module.c       |   19 ++++---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

--- a/arch/nios2/include/asm/pgtable.h~nios2-define-virtual-address-space-for-modules
+++ a/arch/nios2/include/asm/pgtable.h
@@ -25,7 +25,10 @@
 #include <asm-generic/pgtable-nopmd.h>
 
 #define VMALLOC_START		CONFIG_NIOS2_KERNEL_MMU_REGION_BASE
-#define VMALLOC_END		(CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
+#define VMALLOC_END		(CONFIG_NIOS2_KERNEL_REGION_BASE - SZ_32M - 1)
+
+#define MODULES_VADDR		(CONFIG_NIOS2_KERNEL_REGION_BASE - SZ_32M)
+#define MODULES_END		(CONFIG_NIOS2_KERNEL_REGION_BASE - 1)
 
 struct mm_struct;
 
--- a/arch/nios2/kernel/module.c~nios2-define-virtual-address-space-for-modules
+++ a/arch/nios2/kernel/module.c
@@ -21,23 +21,12 @@
 
 #include <asm/cacheflush.h>
 
-/*
- * Modules should NOT be allocated with kmalloc for (obvious) reasons.
- * But we do it for now to avoid relocation issues. CALL26/PCREL26 cannot reach
- * from 0x80000000 (vmalloc area) to 0xc00000000 (kernel) (kmalloc returns
- * addresses in 0xc0000000)
- */
 void *module_alloc(unsigned long size)
 {
-	if (size == 0)
-		return NULL;
-	return kmalloc(size, GFP_KERNEL);
-}
-
-/* Free memory returned from module_alloc */
-void module_memfree(void *module_region)
-{
-	kfree(module_region);
+	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+				    GFP_KERNEL, PAGE_KERNEL_EXEC,
+				    VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
+				    __builtin_return_address(0));
 }
 
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
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

