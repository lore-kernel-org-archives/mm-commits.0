Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A72C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9706264F07
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCQXEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCQXEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:04:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FEC064F53;
        Wed, 17 Mar 2021 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616022251;
        bh=tOMOEFcmOVJykS/T85VB7D+7TGZ8au/FBtydRpot0fE=;
        h=Date:From:To:Subject:From;
        b=sylPRvZ/qYmKIf+u5azfDQVK7L/g1cp9ucsTN+/DWAFp8d3ytQWoIyxemA8h0PHl6
         SYaTZinxTpyWyzmoNu6F6fRy3IKgcPAkVLoo6fLlu84bvZqpAKtwFcUdaIdQJ1hChk
         bAav/srTG2TdYa7yxfwGycPuFHC39NOSfasbTY2A=
Date:   Wed, 17 Mar 2021 16:04:09 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, dingtianhong@huawei.com,
        hch@lst.de, hpa@zytor.com, linmiaohe@huawei.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        tglx@linutronix.de, urezki@gmail.com, will@kernel.org
Subject:  + powerpc-64s-radix-enable-huge-vmalloc-mappings.patch
 added to -mm tree
Message-ID: <20210317230409.lwgpE5sEv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/64s/radix: enable huge vmalloc mappings
has been added to the -mm tree.  Its filename is
     powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-64s-radix-enable-huge-vmalloc-mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc/64s/radix: enable huge vmalloc mappings

This reduces TLB misses by nearly 30x on a `git diff` workload on a 2-node
POWER9 (59,800 -> 2,100) and reduces CPU cycles by 0.54%, due to vfs
hashes being allocated with 2MB pages.

Link: https://lkml.kernel.org/r/20210317062402.533919-15-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +
 arch/powerpc/Kconfig                            |    1 
 arch/powerpc/kernel/module.c                    |   22 +++++++++++---
 3 files changed, 21 insertions(+), 4 deletions(-)

--- a/arch/powerpc/Kconfig~powerpc-64s-radix-enable-huge-vmalloc-mappings
+++ a/arch/powerpc/Kconfig
@@ -181,6 +181,7 @@ config PPC
 	select GENERIC_GETTIMEOFDAY
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if PPC_BOOK3S_64 && PPC_RADIX_MMU
+	select HAVE_ARCH_HUGE_VMALLOC		if HAVE_ARCH_HUGE_VMAP
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN			if PPC32 && PPC_PAGE_SHIFT <= 14
 	select HAVE_ARCH_KASAN_VMALLOC		if PPC32 && PPC_PAGE_SHIFT <= 14
--- a/arch/powerpc/kernel/module.c~powerpc-64s-radix-enable-huge-vmalloc-mappings
+++ a/arch/powerpc/kernel/module.c
@@ -8,6 +8,7 @@
 #include <linux/moduleloader.h>
 #include <linux/err.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/bug.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
@@ -87,13 +88,26 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-#ifdef MODULES_VADDR
 void *module_alloc(unsigned long size)
 {
+	unsigned long start = VMALLOC_START;
+	unsigned long end = VMALLOC_END;
+
+#ifdef MODULES_VADDR
 	BUILD_BUG_ON(TASK_SIZE > MODULES_VADDR);
+	start = MODULES_VADDR;
+	end = MODULES_END;
+#endif
 
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
+	/*
+	 * Don't do huge page allocations for modules yet until more testing
+	 * is done. STRICT_MODULE_RWX may require extra work to support this
+	 * too.
+	 */
+
+	return __vmalloc_node_range(size, 1, start, end, GFP_KERNEL,
+				    PAGE_KERNEL_EXEC,
+				    VM_NO_HUGE_VMAP | VM_FLUSH_RESET_PERMS,
+				    NUMA_NO_NODE,
 				    __builtin_return_address(0));
 }
-#endif
--- a/Documentation/admin-guide/kernel-parameters.txt~powerpc-64s-radix-enable-huge-vmalloc-mappings
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3243,6 +3243,8 @@
 
 	nohugeiomap	[KNL,X86,PPC,ARM64] Disable kernel huge I/O mappings.
 
+	nohugevmalloc	[PPC] Disable kernel huge vmalloc mappings.
+
 	nosmt		[KNL,S390] Disable symmetric multithreading (SMT).
 			Equivalent to smt=1.
 
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

