Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB146CCA47F
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiGBAIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiGBAHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86EB4474F
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:07:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ADEDB8326E
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA13C3411E;
        Sat,  2 Jul 2022 00:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720467;
        bh=8niBArXWXYl6KuhNI0KN3W8Negu+9pX7+HXuu5s3IOU=;
        h=Date:To:From:Subject:From;
        b=PHPZDZWGAydZepQX+W0rjUJroM8V59wOghZpFzCp8v8Dp2bS1YiGfj+WSHf6xrBvp
         jIkPc28J4CfMyOKfj0elA8U1JYijk7JOTojLXw8eoQY8PKlFFbphXJLj5v2gM20AqA
         wbmhC7ulJ4n1cf5PbWU52FkNMJAGvjWSEEUz7T7k=
Date:   Fri, 01 Jul 2022 17:07:46 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-enable-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000747.3FA13C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-mm-enable-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-mm-enable-arch_has_vm_get_page_prot.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:25 +0530

This enables ARCH_HAS_VM_GET_PAGE_PROT on the platform and exports
standard vm_get_page_prot() implementation via DECLARE_VM_GET_PAGE_PROT,
which looks up a private and static protection_map[] array.  Subsequently
all __SXXX and __PXXX macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/20220630051630.1718927-22-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig                        |    1 
 arch/m68k/include/asm/mcf_pgtable.h      |   54 --------------------
 arch/m68k/include/asm/motorola_pgtable.h |   22 --------
 arch/m68k/include/asm/sun3_pgtable.h     |   17 ------
 arch/m68k/mm/mcfmmu.c                    |   55 +++++++++++++++++++++
 arch/m68k/mm/motorola.c                  |   20 +++++++
 arch/m68k/mm/sun3mmu.c                   |   20 +++++++
 7 files changed, 96 insertions(+), 93 deletions(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -91,60 +91,6 @@
  * for use. In general, the bit positions are xwr, and P-items are
  * private, the S-items are shared.
  */
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
@@ -83,28 +83,6 @@ extern unsigned long mm_cachebits;
 #define PAGE_COPY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
 #define PAGE_READONLY_C	__pgprot(_PAGE_PRESENT | _PAGE_RONLY | _PAGE_ACCESSED)
 
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
@@ -71,23 +71,6 @@
  * protection settings, valid (implying read and execute) and writeable. These
  * are as close as we can get...
  */
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
 
 /* Use these fake page-protections on PMDs. */
 #define SUN3_PMD_VALID	(0x00000001)
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
@@ -382,6 +382,26 @@ static void __init map_node(int node)
 #endif
 }
 
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
 /*
  * paging_init() continues the virtual memory environment setup which
  * was begun by the code in arch/head.S.
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

mm-mmap-build-protect-protection_map-with-__p000.patch
mm-mmap-define-declare_vm_get_page_prot.patch
powerpc-mm-move-protection_map-inside-the-platform.patch
sparc-mm-move-protection_map-inside-the-platform.patch
arm64-mm-move-protection_map-inside-the-platform.patch
x86-mm-move-protection_map-inside-the-platform.patch
mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
loongarch-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
xtensa-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch

