Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0740C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiGRAUs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiGRATK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49A014018
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F9560F47
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36D1C341CA;
        Mon, 18 Jul 2022 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103497;
        bh=jVME2EBdNvFGM5gtsxZASf5hyldVC/eJ/4hYm6ARfBk=;
        h=Date:To:From:Subject:From;
        b=tbUwvlcsbc3Z3Njz3eZ3jYkKoZX0Un7CEOh8ckup53+jVbEzvt5yMlfdgY6AnLNMC
         L5xcplDF4lGxbGeyNF4RHJpweZXy3fNumdo9gGwcldnhevRkmgt+5IFOMEPVMKyFfD
         SqVGXnN9i3FeK5RHCUW5BQOy8jFzseGqHFUZ1a/Y=
Date:   Sun, 17 Jul 2022 17:18:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-drop-definition-of-pte_order.patch removed from -mm tree
Message-Id: <20220718001817.B36D1C341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: loongarch: drop definition of PTE_ORDER
has been removed from the -mm tree.  Its filename was
     loongarch-drop-definition-of-pte_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


