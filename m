Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C7EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiBVDNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:13:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiBVDNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970346174
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A536B8184D
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15CCC340EC;
        Tue, 22 Feb 2022 03:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499590;
        bh=itpQgzSaQDd5xpDlhEseneWnSsmbwz/FvUXERIMnJH4=;
        h=Date:To:From:Subject:From;
        b=Oq8idGZdoRL/XjiX/imT+na6Oo438sm1yc9VZHyvb+jEaaUoIvpzj5jFJ5XG/aiB4
         q7ZpNh9c6I9ayBy9N3xg59DWH/I1YKra6WbIG7v2JkItII3WyUYrT75jXllX84/gHN
         nVtieXpzbpGmsLk+dBbBI8Ic/tqXc3nJLIDd+ZrA=
Date:   Mon, 21 Feb 2022 19:13:10 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031310.D15CCC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     m68k-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-mm-enable-arch_has_vm_get_page_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: m68k/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-9-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig                        |    1 
 arch/m68k/include/asm/mcf_pgtable.h      |   59 -----------
 arch/m68k/include/asm/motorola_pgtable.h |   22 ----
 arch/m68k/include/asm/sun3_pgtable.h     |   22 ----
 arch/m68k/mm/init.c                      |  104 +++++++++++++++++++++
 arch/m68k/mm/motorola.c                  |   48 +++++++++
 6 files changed, 150 insertions(+), 106 deletions(-)

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
@@ -66,28 +66,6 @@
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
 
 /* Use these fake page-protections on PMDs. */
 #define SUN3_PMD_VALID	(0x00000001)
--- a/arch/m68k/Kconfig~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/Kconfig
@@ -11,6 +11,7 @@ config M68K
 	select ARCH_NO_PREEMPT if !COLDFIRE
 	select ARCH_USE_MEMTEST if MMU_MOTOROLA
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select BINFMT_FLAT_ARGVP_ENVP_ON_STACK
 	select DMA_DIRECT_REMAP if HAS_DMA && MMU && !COLDFIRE
 	select GENERIC_ATOMIC64
--- a/arch/m68k/mm/init.c~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/mm/init.c
@@ -128,3 +128,107 @@ void __init mem_init(void)
 	memblock_free_all();
 	init_pointer_tables();
 }
+
+#ifdef CONFIG_COLDFIRE
+/*
+ * Page protections for initialising protection_map. See mm/mmap.c
+ * for use. In general, the bit positions are xwr, and P-items are
+ * private, the S-items are shared.
+ */
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return PAGE_NONE;
+	case VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE);
+	case VM_WRITE:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_WRITABLE);
+	case VM_WRITE | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_WRITABLE);
+	case VM_EXEC:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_EXEC);
+	case VM_EXEC | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_EXEC);
+	case VM_EXEC | VM_WRITE:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_WRITABLE | CF_PAGE_EXEC);
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_WRITABLE |
+				CF_PAGE_EXEC);
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE);
+	case VM_SHARED | VM_WRITE:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_SHARED);
+	case VM_SHARED | VM_EXEC:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_EXEC);
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_EXEC);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_SHARED | CF_PAGE_EXEC);
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(CF_PAGE_VALID | CF_PAGE_ACCESSED |
+				CF_PAGE_READABLE | CF_PAGE_SHARED |
+				CF_PAGE_EXEC);
+	default:
+		BUILD_BUG();
+	}
+}
+#endif
+
+#ifdef CONFIG_SUN3
+/*
+ * Page protections for initialising protection_map. The sun3 has only two
+ * protection settings, valid (implying read and execute) and writeable. These
+ * are as close as we can get...
+ */
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return PAGE_NONE;
+	case VM_READ:
+		return PAGE_READONLY;
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return PAGE_READONLY;
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	default:
+		BUILD_BUG();
+	}
+}
+#endif
+EXPORT_SYMBOL(vm_get_page_prot);
--- a/arch/m68k/mm/motorola.c~m68k-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/m68k/mm/motorola.c
@@ -400,12 +400,9 @@ void __init paging_init(void)
 
 	/* Fix the cache mode in the page descriptors for the 680[46]0.  */
 	if (CPU_IS_040_OR_060) {
-		int i;
 #ifndef mm_cachebits
 		mm_cachebits = _PAGE_CACHE040;
 #endif
-		for (i = 0; i < 16; i++)
-			pgprot_val(protection_map[i]) |= _PAGE_CACHE040;
 	}
 
 	min_addr = m68k_memory[0].addr;
@@ -483,3 +480,48 @@ void __init paging_init(void)
 	max_zone_pfn[ZONE_DMA] = memblock_end_of_DRAM();
 	free_area_init(max_zone_pfn);
 }
+
+/*
+ * The m68k can't do page protection for execute, and considers that
+ * the same are read. Also, write permissions imply read permissions.
+ * This is the closest we can get..
+ */
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	unsigned long cachebits = 0;
+
+	if (CPU_IS_040_OR_060)
+		cachebits = _PAGE_CACHE040;
+
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return __pgprot(pgprot_val(PAGE_NONE_C) | cachebits);
+	case VM_READ:
+		return __pgprot(pgprot_val(PAGE_READONLY_C) | cachebits);
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(PAGE_COPY_C) | cachebits);
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return __pgprot(pgprot_val(PAGE_READONLY_C) | cachebits);
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(PAGE_COPY_C) | cachebits);
+	case VM_SHARED:
+		return __pgprot(pgprot_val(PAGE_NONE_C) | cachebits);
+	case VM_SHARED | VM_READ:
+		return __pgprot(pgprot_val(PAGE_READONLY_C) | cachebits);
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(PAGE_SHARED_C) | cachebits);
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return __pgprot(pgprot_val(PAGE_READONLY_C) | cachebits);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(PAGE_SHARED_C) | cachebits);
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-merge-pte_mkhuge-call-into-arch_make_huge_pte.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-protection_map.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
extensa-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
nds32-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-generic-vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

