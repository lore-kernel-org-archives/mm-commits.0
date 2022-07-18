Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A713CCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiGRAUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiGRATJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6CF13F94
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB67A60F32
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9C7C3411E;
        Mon, 18 Jul 2022 00:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103491;
        bh=b90UI0ePvhSdEeV14qreO2CDxjiecPhe3OxNPPc4L0E=;
        h=Date:To:From:Subject:From;
        b=QJ8rD9evuHXovf4M010mlBbvxHTtr1wLBesTriWlR0DSsd/9kHuSyoCcDOveLaiz8
         zjiMGFQadaurUdIHDlcfyEyFdJSJ4ZiGJhs7qNN3rUW6C7LoOEEQX3p3Ro+VM0qU4/
         zi9g2BWEglDs9rLlcgZYwo41XbFWEcuevQpuEjeo=
Date:   Sun, 17 Jul 2022 17:18:10 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        rppt@linux.ibm.com, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-rename-pmd_order-to-pmd_table_order.patch removed from -mm tree
Message-Id: <20220718001811.0A9C7C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mips: rename PMD_ORDER to PMD_TABLE_ORDER
has been removed from the -mm tree.  Its filename was
     mips-rename-pmd_order-to-pmd_table_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mips: rename PMD_ORDER to PMD_TABLE_ORDER
Date: Sun, 3 Jul 2022 17:11:52 +0300

This is the order of the page table allocation, not the order of a PMD.

While at it remove unused defintion of _PMD_ORDER in asm-offsets.

Link: https://lkml.kernel.org/r/20220703141203.147893-4-rppt@kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgalloc.h    |    4 ++--
 arch/mips/include/asm/pgtable-32.h |    2 +-
 arch/mips/include/asm/pgtable-64.h |   18 +++++++++---------
 arch/mips/kernel/asm-offsets.c     |    3 ---
 4 files changed, 12 insertions(+), 15 deletions(-)

--- a/arch/mips/include/asm/pgalloc.h~mips-rename-pmd_order-to-pmd_table_order
+++ a/arch/mips/include/asm/pgalloc.h
@@ -67,12 +67,12 @@ static inline pmd_t *pmd_alloc_one(struc
 	pmd_t *pmd;
 	struct page *pg;
 
-	pg = alloc_pages(GFP_KERNEL_ACCOUNT, PMD_ORDER);
+	pg = alloc_pages(GFP_KERNEL_ACCOUNT, PMD_TABLE_ORDER);
 	if (!pg)
 		return NULL;
 
 	if (!pgtable_pmd_page_ctor(pg)) {
-		__free_pages(pg, PMD_ORDER);
+		__free_pages(pg, PMD_TABLE_ORDER);
 		return NULL;
 	}
 
--- a/arch/mips/include/asm/pgtable-32.h~mips-rename-pmd_order-to-pmd_table_order
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -82,7 +82,7 @@ extern int add_temporary_entry(unsigned
 
 #define PGD_ORDER	(__PGD_ORDER >= 0 ? __PGD_ORDER : 0)
 #define PUD_ORDER	aieeee_attempt_to_allocate_pud
-#define PMD_ORDER	aieeee_attempt_to_allocate_pmd
+#define PMD_TABLE_ORDER	aieeee_attempt_to_allocate_pmd
 #define PTE_ORDER	0
 
 #define PTRS_PER_PGD	(USER_PTRS_PER_PGD * 2)
--- a/arch/mips/include/asm/pgtable-64.h~mips-rename-pmd_order-to-pmd_table_order
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -51,12 +51,12 @@
 #define PMD_MASK	(~(PMD_SIZE-1))
 
 # ifdef __PAGETABLE_PUD_FOLDED
-# define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
+# define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_TABLE_ORDER - 3))
 # endif
 #endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
-#define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
+#define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_TABLE_ORDER - 3))
 #define PUD_SIZE	(1UL << PUD_SHIFT)
 #define PUD_MASK	(~(PUD_SIZE-1))
 #define PGDIR_SHIFT	(PUD_SHIFT + (PAGE_SHIFT + PUD_ORDER - 3))
@@ -91,13 +91,13 @@
 #  define PGD_ORDER		1
 #  define PUD_ORDER		aieeee_attempt_to_allocate_pud
 # endif
-#define PMD_ORDER		0
+#define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_8KB
 #define PGD_ORDER		0
 #define PUD_ORDER		aieeee_attempt_to_allocate_pud
-#define PMD_ORDER		0
+#define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_16KB
@@ -107,22 +107,22 @@
 #define PGD_ORDER               0
 #endif
 #define PUD_ORDER		aieeee_attempt_to_allocate_pud
-#define PMD_ORDER		0
+#define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_32KB
 #define PGD_ORDER		0
 #define PUD_ORDER		aieeee_attempt_to_allocate_pud
-#define PMD_ORDER		0
+#define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_64KB
 #define PGD_ORDER		0
 #define PUD_ORDER		aieeee_attempt_to_allocate_pud
 #ifdef CONFIG_MIPS_VA_BITS_48
-#define PMD_ORDER		0
+#define PMD_TABLE_ORDER		0
 #else
-#define PMD_ORDER		aieeee_attempt_to_allocate_pmd
+#define PMD_TABLE_ORDER		aieeee_attempt_to_allocate_pmd
 #endif
 #define PTE_ORDER		0
 #endif
@@ -132,7 +132,7 @@
 #define PTRS_PER_PUD	((PAGE_SIZE << PUD_ORDER) / sizeof(pud_t))
 #endif
 #ifndef __PAGETABLE_PMD_FOLDED
-#define PTRS_PER_PMD	((PAGE_SIZE << PMD_ORDER) / sizeof(pmd_t))
+#define PTRS_PER_PMD	((PAGE_SIZE << PMD_TABLE_ORDER) / sizeof(pmd_t))
 #endif
 #define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
 
--- a/arch/mips/kernel/asm-offsets.c~mips-rename-pmd_order-to-pmd_table_order
+++ a/arch/mips/kernel/asm-offsets.c
@@ -197,9 +197,6 @@ void output_mm_defines(void)
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
 	DEFINE(_PGD_ORDER, PGD_ORDER);
-#ifndef __PAGETABLE_PMD_FOLDED
-	DEFINE(_PMD_ORDER, PMD_ORDER);
-#endif
 	DEFINE(_PTE_ORDER, PTE_ORDER);
 	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

