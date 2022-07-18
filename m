Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70364C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiGRAUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiGRASx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:18:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF9A13F32
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CAA460F49
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE81C3411E;
        Mon, 18 Jul 2022 00:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103479;
        bh=dz+/YB0Aiu5/p193SscZ8Q/PcgJ3G54x3kSUsPtFHkY=;
        h=Date:To:From:Subject:From;
        b=PvLROB1zsepml8GoCqsJ7iZKZXe7Q4vbfaeljpEDdYsT/254c1oh1DGPuv4Onse3u
         7xiLFinC+m5OcXBGLEdfZcalGkwo0BH0xvvDl1eBKtv1s2/XuWuLyRDSdNR/Xod0fO
         rK+ZFGphUNMI01dBnKu0OXKFdO97QClKwLQPm1OY=
Date:   Sun, 17 Jul 2022 17:17:59 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        will@kernel.org, vgupta@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, shorne@gmail.com, sam@ravnborg.org,
        rth@twiddle.net, paul.walmsley@sifive.com, paulus@samba.org,
        palmer@dabbelt.com, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, linux@armlinux.org.uk,
        kernel@xen0n.name, jonas@southpole.se, jdike@addtoit.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de,
        hch@infradead.org, hca@linux.ibm.com, guoren@kernel.org,
        gor@linux.ibm.com, geert@linux-m68k.org, dinguyen@kernel.org,
        davem@davemloft.net, dalias@libc.org, chris@zankel.net,
        christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
        catalin.marinas@arm.com, bcain@quicinc.com, arnd@arndb.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220718001759.BBE81C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     m68k-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Mon, 11 Jul 2022 12:35:55 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220711070600.2378316-22-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig                        |    1 
 arch/m68k/include/asm/mcf_pgtable.h      |   59 ---------------------
 arch/m68k/include/asm/motorola_pgtable.h |   29 ----------
 arch/m68k/include/asm/sun3_pgtable.h     |   23 --------
 arch/m68k/mm/mcfmmu.c                    |   55 +++++++++++++++++++
 arch/m68k/mm/motorola.c                  |   29 ++++++++++
 arch/m68k/mm/sun3mmu.c                   |   20 +++++++
 7 files changed, 105 insertions(+), 111 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -86,65 +86,6 @@
 				 | CF_PAGE_READABLE \
 				 | CF_PAGE_DIRTY)
 
-/*
- * Page protections for initialising protection_map. See mm/mmap.c
- * for use. In general, the bit positions are xwr, and P-items are
- * private, the S-items are shared.
- */
-#define __P000		PAGE_NONE
-#define __P001		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE)
-#define __P010		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_WRITABLE)
-#define __P011		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE \
-				 | CF_PAGE_WRITABLE)
-#define __P100		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_EXEC)
-#define __P101		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE \
-				 | CF_PAGE_EXEC)
-#define __P110		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_WRITABLE \
-				 | CF_PAGE_EXEC)
-#define __P111		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE \
-				 | CF_PAGE_WRITABLE \
-				 | CF_PAGE_EXEC)
-
-#define __S000		PAGE_NONE
-#define __S001		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE)
-#define __S010		PAGE_SHARED
-#define __S011		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_SHARED \
-				 | CF_PAGE_READABLE)
-#define __S100		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_EXEC)
-#define __S101		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_READABLE \
-				 | CF_PAGE_EXEC)
-#define __S110		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_SHARED \
-				 | CF_PAGE_EXEC)
-#define __S111		__pgprot(CF_PAGE_VALID \
-				 | CF_PAGE_ACCESSED \
-				 | CF_PAGE_SHARED \
-				 | CF_PAGE_READABLE \
-				 | CF_PAGE_EXEC)
-
 #define PTE_MASK	PAGE_MASK
 #define CF_PAGE_CHG_MASK (PTE_MASK | CF_PAGE_ACCESSED | CF_PAGE_DIRTY)
 
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -76,35 +76,6 @@ extern unsigned long mm_cachebits;
 #define PAGE_READONLY	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED | mm_cachebits)
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | _PAGE_DIRTY | _PAGE_ACCESSED | mm_cachebits)
 
-/* Alternate definitions that are compile time constants, for
-   initializing protection_map.  The cachebits are fixed later.  */
-#define PAGE_NONE_C	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED_C	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED)
-#define PAGE_COPY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
-#define PAGE_READONLY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
-
-/*
- * The m68k can't do page protection for execute, and considers that the same are read.
- * Also, write permissions imply read permissions. This is the closest we can get..
- */
-#define __P000	PAGE_NONE_C
-#define __P001	PAGE_READONLY_C
-#define __P010	PAGE_COPY_C
-#define __P011	PAGE_COPY_C
-#define __P100	PAGE_READONLY_C
-#define __P101	PAGE_READONLY_C
-#define __P110	PAGE_COPY_C
-#define __P111	PAGE_COPY_C
-
-#define __S000	PAGE_NONE_C
-#define __S001	PAGE_READONLY_C
-#define __S010	PAGE_SHARED_C
-#define __S011	PAGE_SHARED_C
-#define __S100	PAGE_READONLY_C
-#define __S101	PAGE_READONLY_C
-#define __S110	PAGE_SHARED_C
-#define __S111	PAGE_SHARED_C
-
 #define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
 
 /*
--- a/arch/m68k/include/asm/sun3_pgtable.h~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -66,29 +66,6 @@
 				 | SUN3_PAGE_SYSTEM \
 				 | SUN3_PAGE_NOCACHE)
 
-/*
- * Page protections for initialising protection_map. The sun3 has only two
- * protection settings, valid (implying read and execute) and writeable. These
- * are as close as we can get...
- */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY
-#define __P101	PAGE_READONLY
-#define __P110	PAGE_COPY
-#define __P111	PAGE_COPY
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY
-#define __S101	PAGE_READONLY
-#define __S110	PAGE_SHARED
-#define __S111	PAGE_SHARED
-
 /* Use these fake page-protections on PMDs. */
 #define SUN3_PMD_VALID	(0x00000001)
 #define SUN3_PMD_MASK	(0x0000003F)
--- a/arch/m68k/Kconfig~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/Kconfig
@@ -7,6 +7,7 @@ config M68K
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_PREP_COHERENT if HAS_DMA && MMU && !COLDFIRE
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if HAS_DMA
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
 	select ARCH_NO_PREEMPT if !COLDFIRE
--- a/arch/m68k/mm/mcfmmu.c~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/mm/mcfmmu.c
@@ -234,3 +234,58 @@ void steal_context(void)
 	destroy_context(mm);
 }
 
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE),
+	[VM_WRITE]					= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_WRITABLE),
+	[VM_WRITE | VM_READ]				= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE |
+								   CF_PAGE_WRITABLE),
+	[VM_EXEC]					= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_EXEC),
+	[VM_EXEC | VM_READ]				= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE |
+								   CF_PAGE_EXEC),
+	[VM_EXEC | VM_WRITE]				= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_WRITABLE |
+								   CF_PAGE_EXEC),
+	[VM_EXEC | VM_WRITE | VM_READ]			=  __pgprot(CF_PAGE_VALID |
+								    CF_PAGE_ACCESSED |
+								    CF_PAGE_READABLE |
+								    CF_PAGE_WRITABLE |
+								    CF_PAGE_EXEC),
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE),
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE |
+								   CF_PAGE_SHARED),
+	[VM_SHARED | VM_EXEC]				= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_EXEC),
+	[VM_SHARED | VM_EXEC | VM_READ]			= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE |
+								   CF_PAGE_EXEC),
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_SHARED |
+								   CF_PAGE_EXEC),
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __pgprot(CF_PAGE_VALID |
+								   CF_PAGE_ACCESSED |
+								   CF_PAGE_READABLE |
+								   CF_PAGE_SHARED |
+								   CF_PAGE_EXEC)
+};
+DECLARE_VM_GET_PAGE_PROT
--- a/arch/m68k/mm/motorola.c~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/mm/motorola.c
@@ -383,6 +383,35 @@ static void __init map_node(int node)
 }
 
 /*
+ * Alternate definitions that are compile time constants, for
+ * initializing protection_map.  The cachebits are fixed later.
+ */
+#define PAGE_NONE_C	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
+#define PAGE_SHARED_C	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED)
+#define PAGE_COPY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
+#define PAGE_READONLY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
+
+static pgprot_t protection_map[16] __ro_after_init = {
+	[VM_NONE]					= PAGE_NONE_C,
+	[VM_READ]					= PAGE_READONLY_C,
+	[VM_WRITE]					= PAGE_COPY_C,
+	[VM_WRITE | VM_READ]				= PAGE_COPY_C,
+	[VM_EXEC]					= PAGE_READONLY_C,
+	[VM_EXEC | VM_READ]				= PAGE_READONLY_C,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY_C,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY_C,
+	[VM_SHARED]					= PAGE_NONE_C,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY_C,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED_C,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED_C,
+	[VM_SHARED | VM_EXEC]				= PAGE_READONLY_C,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READONLY_C,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED_C,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_C
+};
+DECLARE_VM_GET_PAGE_PROT
+
+/*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
  */
--- a/arch/m68k/mm/sun3mmu.c~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/mm/sun3mmu.c
@@ -95,3 +95,23 @@ void __init paging_init(void)
 
 
 }
+
+static const pgprot_t protection_map[16] = {
+	[VM_NONE]					= PAGE_NONE,
+	[VM_READ]					= PAGE_READONLY,
+	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE | VM_READ]				= PAGE_COPY,
+	[VM_EXEC]					= PAGE_READONLY,
+	[VM_EXEC | VM_READ]				= PAGE_READONLY,
+	[VM_EXEC | VM_WRITE]				= PAGE_COPY,
+	[VM_EXEC | VM_WRITE | VM_READ]			= PAGE_COPY,
+	[VM_SHARED]					= PAGE_NONE,
+	[VM_SHARED | VM_READ]				= PAGE_READONLY,
+	[VM_SHARED | VM_WRITE]				= PAGE_SHARED,
+	[VM_SHARED | VM_WRITE | VM_READ]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC]				= PAGE_READONLY,
+	[VM_SHARED | VM_EXEC | VM_READ]			= PAGE_READONLY,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= PAGE_SHARED,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED
+};
+DECLARE_VM_GET_PAGE_PROT
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


