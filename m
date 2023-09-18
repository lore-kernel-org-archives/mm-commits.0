Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C28CD13DA
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 16:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjIRQJY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjIRQJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 12:09:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7014F5B93
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 09:07:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6148C116AD;
        Mon, 18 Sep 2023 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695052337;
        bh=kpERd8SxZClF7mPEcdksvbleuySgirE8lst+TbzMLF8=;
        h=Date:To:From:Subject:From;
        b=z1WIoq7AjqE8s3nYXU5HOPUO1rNQx/Ig3KDz0BpmWmtCJ6Qp79gOSbcXPrP05aZ6o
         ksdJJKeTiz+BVGOfsQkSEf12Sy/+5yCVbWmI5x4Unxz2XSjR1DmsKbfWYbgxvEHxXf
         rGpwAt4UpVAGfepcmqeQGCNdrovYQQ9kkGFygT5A=
Date:   Mon, 18 Sep 2023 08:52:16 -0700
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
Subject: + riscv-extend-execmem_params-for-generated-code-allocations.patch added to mm-unstable branch
Message-Id: <20230918155216.D6148C116AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: extend execmem_params for generated code allocations
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-extend-execmem_params-for-generated-code-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-extend-execmem_params-for-generated-code-allocations.patch

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
Subject: riscv: extend execmem_params for generated code allocations
Date: Mon, 18 Sep 2023 10:29:50 +0300

The memory allocations for kprobes and BPF on RISC-V are not placed in the
modules area and these custom allocations are implemented with overrides
of alloc_insn_page() and bpf_jit_alloc_exec().

Slightly reorder execmem_params initialization to support both 32 and 64
bit variants, define EXECMEM_KPROBES and EXECMEM_BPF ranges in
riscv::execmem_params and drop overrides of alloc_insn_page() and
bpf_jit_alloc_exec().

Link: https://lkml.kernel.org/r/20230918072955.2507221-9-rppt@kernel.org
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

 arch/riscv/kernel/module.c         |   21 ++++++++++++++++++++-
 arch/riscv/kernel/probes/kprobes.c |   10 ----------
 arch/riscv/net/bpf_jit_core.c      |   13 -------------
 3 files changed, 20 insertions(+), 24 deletions(-)

--- a/arch/riscv/kernel/module.c~riscv-extend-execmem_params-for-generated-code-allocations
+++ a/arch/riscv/kernel/module.c
@@ -436,20 +436,39 @@ int apply_relocate_add(Elf_Shdr *sechdrs
 	return 0;
 }
 
-#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
+#ifdef CONFIG_MMU
 static struct execmem_params execmem_params __ro_after_init = {
 	.ranges = {
 		[EXECMEM_DEFAULT] = {
 			.pgprot = PAGE_KERNEL,
 			.alignment = 1,
 		},
+		[EXECMEM_KPROBES] = {
+			.pgprot = PAGE_KERNEL_READ_EXEC,
+			.alignment = 1,
+		},
+		[EXECMEM_BPF] = {
+			.pgprot = PAGE_KERNEL,
+			.alignment = 1,
+		},
 	},
 };
 
 struct execmem_params __init *execmem_arch_params(void)
 {
+#ifdef CONFIG_64BIT
 	execmem_params.ranges[EXECMEM_DEFAULT].start = MODULES_VADDR;
 	execmem_params.ranges[EXECMEM_DEFAULT].end = MODULES_END;
+#else
+	execmem_params.ranges[EXECMEM_DEFAULT].start = VMALLOC_START;
+	execmem_params.ranges[EXECMEM_DEFAULT].end = VMALLOC_END;
+#endif
+
+	execmem_params.ranges[EXECMEM_KPROBES].start = VMALLOC_START;
+	execmem_params.ranges[EXECMEM_KPROBES].end = VMALLOC_END;
+
+	execmem_params.ranges[EXECMEM_BPF].start = BPF_JIT_REGION_START;
+	execmem_params.ranges[EXECMEM_BPF].end = BPF_JIT_REGION_END;
 
 	return &execmem_params;
 }
--- a/arch/riscv/kernel/probes/kprobes.c~riscv-extend-execmem_params-for-generated-code-allocations
+++ a/arch/riscv/kernel/probes/kprobes.c
@@ -104,16 +104,6 @@ int __kprobes arch_prepare_kprobe(struct
 	return 0;
 }
 
-#ifdef CONFIG_MMU
-void *alloc_insn_page(void)
-{
-	return  __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
-				     GFP_KERNEL, PAGE_KERNEL_READ_EXEC,
-				     VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
-				     __builtin_return_address(0));
-}
-#endif
-
 /* install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
--- a/arch/riscv/net/bpf_jit_core.c~riscv-extend-execmem_params-for-generated-code-allocations
+++ a/arch/riscv/net/bpf_jit_core.c
@@ -218,19 +218,6 @@ u64 bpf_jit_alloc_exec_limit(void)
 	return BPF_JIT_REGION_SIZE;
 }
 
-void *bpf_jit_alloc_exec(unsigned long size)
-{
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
-}
-
-void bpf_jit_free_exec(void *addr)
-{
-	return vfree(addr);
-}
-
 void *bpf_arch_text_copy(void *dst, void *src, size_t len)
 {
 	int ret;
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

