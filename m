Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0258C43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiGCU2N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiGCU2L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2EAD
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C97C6118A
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF30CC341C6;
        Sun,  3 Jul 2022 20:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880088;
        bh=WVlEu66MupP7T87UBQEEGvaZali+JIGAr4FYNS0JdNQ=;
        h=Date:To:From:Subject:From;
        b=Ic9m/qcOr96BcxCsU1VAB5YLZa4jDHht/o6vbgyV7lAkD2thH2OjXNyHH+ZmLBRxL
         Zfej4G0wvn9i+uzn85+3w+KUTc54Akw2AsAKfl94b2HSD+MKpNTQBLb7rxXgwK8mbm
         t8Dy1nPDnv1J/xbI2G7i/FV5W3KXCEmGHaNnjPlo=
Date:   Sun, 03 Jul 2022 13:28:08 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        rppt@linux.ibm.com, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-rename-pmd_order-to-pmd_table_order.patch added to mm-unstable branch
Message-Id: <20220703202808.BF30CC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: rename PMD_ORDER to PMD_TABLE_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     mips-rename-pmd_order-to-pmd_table_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-rename-pmd_order-to-pmd_table_order.patch

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
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch
mm-add-folios_put.patch
mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
mips-rename-pmd_order-to-pmd_table_order.patch

