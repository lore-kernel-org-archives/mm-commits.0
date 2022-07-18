Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E0AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiGRAUq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiGRATK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9D1400E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 084EFB80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A536C3411E;
        Mon, 18 Jul 2022 00:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103496;
        bh=eM9Lbp3LLmtNwmGj2YV7Vu3sxMPycCxe/oB+C/dUCi0=;
        h=Date:To:From:Subject:From;
        b=Myd6KRlIkwZ4tGK8meagXpi1dg3P57gyn2dGeWhH96CxyiQ1sLWIyocrgcxiomwAK
         bKekGg9wN9gh85vxfi65VIHrLfUgiVBldjXe9a8xSNyyf1ffzPclCPw/EVrRJ5Z6tI
         MY7dqcfHnH1x2ODK7bqvdovOrwJGtuaTlCqdF3I0=
Date:   Sun, 17 Jul 2022 17:18:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-drop-definition-of-pgd_order.patch removed from -mm tree
Message-Id: <20220718001816.9A536C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: drop definition of PGD_ORDER
has been removed from the -mm tree.  Its filename was
     nios2-drop-definition-of-pgd_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: nios2: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:11:57 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
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

 arch/nios2/include/asm/pgtable.h |    4 +---
 arch/nios2/mm/init.c             |    3 +--
 arch/nios2/mm/pgtable.c          |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/nios2/include/asm/pgtable.h~nios2-drop-definition-of-pgd_order
+++ a/arch/nios2/include/asm/pgtable.h
@@ -52,9 +52,7 @@ struct mm_struct;
 
 #define PAGE_COPY MKP(0, 0, 1)
 
-#define PGD_ORDER	0
-
-#define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
+#define PTRS_PER_PGD	(PAGE_SIZE / sizeof(pgd_t))
 #define PTRS_PER_PTE	(PAGE_SIZE / sizeof(pte_t))
 
 #define USER_PTRS_PER_PGD	\
--- a/arch/nios2/mm/init.c~nios2-drop-definition-of-pgd_order
+++ a/arch/nios2/mm/init.c
@@ -78,8 +78,7 @@ void __init mmu_init(void)
 	flush_tlb_all();
 }
 
-#define __page_aligned(order) __aligned(PAGE_SIZE << (order))
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PGD_ORDER);
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __aligned(PAGE_SIZE);
 pte_t invalid_pte_table[PTRS_PER_PTE] __aligned(PAGE_SIZE);
 static struct page *kuser_page[1];
 
--- a/arch/nios2/mm/pgtable.c~nios2-drop-definition-of-pgd_order
+++ a/arch/nios2/mm/pgtable.c
@@ -54,7 +54,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret, *init;
 
-	ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
 	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init(ret);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


