Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D066C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiGRAVJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiGRATK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B4413F97
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E8D4B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD9C3411E;
        Mon, 18 Jul 2022 00:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103498;
        bh=fTtkKZGTneKIjhYNEyPnNFnAA9xx8/bAsetVSkOKvMI=;
        h=Date:To:From:Subject:From;
        b=NoyTVejqW0iiV3a8Gtgzi56PK+iNVxzOggsLpjIyRA3IgzDZZcNkPI5pGn8O/Th0y
         diRltXdBjxR72E+/DXXzDOw26U9ZVtRD7lC7df8pJvXEnR7L3su5rlO+d14nL4R2+u
         o2AGEYTL3qXlx983b2lRWoLbjr4rolXByhfH7ANU=
Date:   Sun, 17 Jul 2022 17:18:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-drop-definition-of-pmd_order.patch removed from -mm tree
Message-Id: <20220718001818.CBCD9C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: loongarch: drop definition of PMD_ORDER
has been removed from the -mm tree.  Its filename was
     loongarch-drop-definition-of-pmd_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: loongarch: drop definition of PMD_ORDER
Date: Sun, 3 Jul 2022 17:11:59 +0300

This is the order of the page table allocation, not the order of a PMD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-11-rppt@kernel.org
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

 arch/loongarch/include/asm/pgalloc.h |    4 ++--
 arch/loongarch/include/asm/pgtable.h |    7 +++----
 arch/loongarch/kernel/asm-offsets.c  |    3 ---
 3 files changed, 5 insertions(+), 9 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~loongarch-drop-definition-of-pmd_order
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -66,12 +66,12 @@ static inline pmd_t *pmd_alloc_one(struc
 	pmd_t *pmd;
 	struct page *pg;
 
-	pg = alloc_pages(GFP_KERNEL_ACCOUNT, PMD_ORDER);
+	pg = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!pg)
 		return NULL;
 
 	if (!pgtable_pmd_page_ctor(pg)) {
-		__free_pages(pg, PMD_ORDER);
+		__free_page(pg);
 		return NULL;
 	}
 
--- a/arch/loongarch/include/asm/pgtable.h~loongarch-drop-definition-of-pmd_order
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -23,7 +23,6 @@
 
 #define PGD_ORDER		0
 #define PUD_ORDER		0
-#define PMD_ORDER		0
 
 #if CONFIG_PGTABLE_LEVELS == 2
 #define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
@@ -31,12 +30,12 @@
 #define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
-#define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
+#define PGDIR_SHIFT	(PMD_SHIFT + (PAGE_SHIFT - 3))
 #elif CONFIG_PGTABLE_LEVELS == 4
 #define PMD_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #define PMD_SIZE	(1UL << PMD_SHIFT)
 #define PMD_MASK	(~(PMD_SIZE-1))
-#define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_ORDER - 3))
+#define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT - 3))
 #define PUD_SIZE	(1UL << PUD_SHIFT)
 #define PUD_MASK	(~(PUD_SIZE-1))
 #define PGDIR_SHIFT	(PUD_SHIFT + (PAGE_SHIFT + PUD_ORDER - 3))
@@ -52,7 +51,7 @@
 #define PTRS_PER_PUD	((PAGE_SIZE << PUD_ORDER) >> 3)
 #endif
 #if CONFIG_PGTABLE_LEVELS > 2
-#define PTRS_PER_PMD	((PAGE_SIZE << PMD_ORDER) >> 3)
+#define PTRS_PER_PMD	(PAGE_SIZE >> 3)
 #endif
 #define PTRS_PER_PTE	(PAGE_SIZE >> 3)
 
--- a/arch/loongarch/kernel/asm-offsets.c~loongarch-drop-definition-of-pmd_order
+++ a/arch/loongarch/kernel/asm-offsets.c
@@ -191,9 +191,6 @@ void output_mm_defines(void)
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
 	DEFINE(_PGD_ORDER, PGD_ORDER);
-#ifndef __PAGETABLE_PMD_FOLDED
-	DEFINE(_PMD_ORDER, PMD_ORDER);
-#endif
 	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


