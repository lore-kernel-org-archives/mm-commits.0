Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1881BC43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiGCU2c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiGCU2a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589B726FF
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECFAD611B7
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8CEC341C6;
        Sun,  3 Jul 2022 20:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880105;
        bh=Bf45l1iVbCNxSeVOw1FsztEMHt+YjuqWy0xQ3/MJLbc=;
        h=Date:To:From:Subject:From;
        b=Tf+0VjKZzHFFt8ckciQNLzXNUVUsz7U1xq1kzx9E6Tm1wjULr9IIEE8G1IpsswEIw
         hc2wiDPx4d2tosoGYALl5szKxG5I2b9GRvWixByMnkkxgT7h7v9dhwIa4OKKjCbW5Q
         y9R4fYs9aNON1PWA/6hMT1yEGvXwfQ8P9W4+JQiA=
Date:   Sun, 03 Jul 2022 13:28:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-drop-definition-of-pte_order.patch added to mm-unstable branch
Message-Id: <20220703202825.4A8CEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: drop definition of PTE_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-drop-definition-of-pte_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-drop-definition-of-pte_order.patch

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
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: loongarch: drop definition of PTE_ORDER
Date: Sun, 3 Jul 2022 17:11:58 +0300

This is the order of the page table allocation, not the order of a PTE. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    9 ++++-----
 arch/loongarch/kernel/asm-offsets.c  |    1 -
 arch/loongarch/mm/tlbex.S            |    6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~loongarch-drop-definition-of-pte_order
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -24,17 +24,16 @@
 #define PGD_ORDER		0
 #define PUD_ORDER		0
 #define PMD_ORDER		0
-#define PTE_ORDER		0
 
 #if CONFIG_PGTABLE_LEVELS == 2
-#define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT + PTE_ORDER - 3))
+#define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #elif CONFIG_PGTABLE_LEVELS == 3
-#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT + PTE_ORDER - 3))
+#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
 #define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
 #elif CONFIG_PGTABLE_LEVELS == 4
-#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT + PTE_ORDER - 3))
+#define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
 #define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
@@ -55,7 +54,7 @@
 #if CONFIG_PGTABLE_LEVELS > 2
 #define PTRS_PER_PMD	((PAGE_SIZE << PMD_ORDER) >> 3)
 #endif
-#define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) >> 3)
+#define PTRS_PER_PTE	(PAGE_SIZE >> 3)
 
 #define USER_PTRS_PER_PGD       ((TASK_SIZE64 / PGDIR_SIZE)?(TASK_SIZE64 / PGDIR_SIZE):1)
 
--- a/arch/loongarch/kernel/asm-offsets.c~loongarch-drop-definition-of-pte_order
+++ a/arch/loongarch/kernel/asm-offsets.c
@@ -194,7 +194,6 @@ void output_mm_defines(void)
 #ifndef __PAGETABLE_PMD_FOLDED
 	DEFINE(_PMD_ORDER, PMD_ORDER);
 #endif
-	DEFINE(_PTE_ORDER, PTE_ORDER);
 	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
--- a/arch/loongarch/mm/tlbex.S~loongarch-drop-definition-of-pte_order
+++ a/arch/loongarch/mm/tlbex.S
@@ -83,7 +83,7 @@ vmalloc_done_load:
 	bne	t0, $r0, tlb_huge_update_load
 
 	csrrd	t0, LOONGARCH_CSR_BADV
-	srli.d	t0, t0, (PAGE_SHIFT + PTE_ORDER)
+	srli.d	t0, t0, PAGE_SHIFT
 	andi	t0, t0, (PTRS_PER_PTE - 1)
 	slli.d	t0, t0, _PTE_T_LOG2
 	add.d	t1, ra, t0
@@ -247,7 +247,7 @@ vmalloc_done_store:
 	bne	t0, $r0, tlb_huge_update_store
 
 	csrrd	t0, LOONGARCH_CSR_BADV
-	srli.d	t0, t0, (PAGE_SHIFT + PTE_ORDER)
+	srli.d	t0, t0, PAGE_SHIFT
 	andi	t0, t0, (PTRS_PER_PTE - 1)
 	slli.d	t0, t0, _PTE_T_LOG2
 	add.d	t1, ra, t0
@@ -414,7 +414,7 @@ vmalloc_done_modify:
 	bne	t0, $r0, tlb_huge_update_modify
 
 	csrrd	t0, LOONGARCH_CSR_BADV
-	srli.d	t0, t0, (PAGE_SHIFT + PTE_ORDER)
+	srli.d	t0, t0, PAGE_SHIFT
 	andi	t0, t0, (PTRS_PER_PTE - 1)
 	slli.d	t0, t0, _PTE_T_LOG2
 	add.d	t1, ra, t0
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch

