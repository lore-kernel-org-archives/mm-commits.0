Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC53CCA473
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiGCU2c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiGCU23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9951153
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7FC611BD
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA76C341C6;
        Sun,  3 Jul 2022 20:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880102;
        bh=6eVaC8MrfYyejter/J+x+wRyg3aj/C/qagmb7T88NpM=;
        h=Date:To:From:Subject:From;
        b=tC+nLCm9o1IGl0u8kIALQZjZgKI5OgVsyrra4r6k2WOQtafUmWWtpkTmfXvG1o7nb
         0SXmFdIO1n72y3KMs3GHjKW0DVADEGd1CYcyDlvlw8tVpqNYVabPcFEhVYITjA8SvH
         /BYDH6gf0AgcZcePNjbKpZKe5UOV8DSQgE+Bbs5w=
Date:   Sun, 03 Jul 2022 13:28:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nios2-drop-definition-of-pgd_order.patch added to mm-unstable branch
Message-Id: <20220703202822.CDA76C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: drop definition of PGD_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     nios2-drop-definition-of-pgd_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nios2-drop-definition-of-pgd_order.patch

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
Subject: nios2: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:11:57 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-9-rppt@kernel.org
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

