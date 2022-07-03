Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2CCCCA473
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiGCU2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiGCU2f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C78E4E
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C601B804A4
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF3DC341C6;
        Sun,  3 Jul 2022 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880112;
        bh=Z1mtyzJfVGUk6UdcdaC+k7NxPsF5iM7cyM9WpD5xoYE=;
        h=Date:To:From:Subject:From;
        b=GRNP9O+9Hst1FivryZGt1526vVcHLXh3PFVs8OFNqlQ0Klw5RgWyh2RC16lw9DvvP
         e2a8ordQuFXoMhBRmK5IYZtOGnbP7fcLZE/by0CzejhQPzFmuBJPE3UqCRdzg4X9P7
         fuDdYvmblJOlXS09b0D3Gapk8lV3eYo6zFdxRTIE=
Date:   Sun, 03 Jul 2022 13:28:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-drop-definition-of-pgd_order.patch added to mm-unstable branch
Message-Id: <20220703202832.5BF3DC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: drop definition of PGD_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-drop-definition-of-pgd_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-drop-definition-of-pgd_order.patch

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
Subject: loongarch: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:12:01 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-13-rppt@kernel.org
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

 arch/loongarch/include/asm/pgtable.h |    6 ++----
 arch/loongarch/kernel/asm-offsets.c  |    1 -
 arch/loongarch/mm/pgtable.c          |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~loongarch-drop-definition-of-pgd_order
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -21,8 +21,6 @@
 #include <asm-generic/pgtable-nop4d.h>
 #endif
 
-#define PGD_ORDER		0
-
 #if CONFIG_PGTABLE_LEVELS == 2
 #define PGDIR_SHIFT	(PAGE_SHIFT + (PAGE_SHIFT - 3))
 #elif CONFIG_PGTABLE_LEVELS == 3
@@ -43,9 +41,9 @@
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
-#define VA_BITS		(PGDIR_SHIFT + (PAGE_SHIFT + PGD_ORDER - 3))
+#define VA_BITS		(PGDIR_SHIFT + (PAGE_SHIFT - 3))
 
-#define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) >> 3)
+#define PTRS_PER_PGD	(PAGE_SIZE >> 3)
 #if CONFIG_PGTABLE_LEVELS > 3
 #define PTRS_PER_PUD	(PAGE_SIZE >> 3)
 #endif
--- a/arch/loongarch/kernel/asm-offsets.c~loongarch-drop-definition-of-pgd_order
+++ a/arch/loongarch/kernel/asm-offsets.c
@@ -190,7 +190,6 @@ void output_mm_defines(void)
 #endif
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
-	DEFINE(_PGD_ORDER, PGD_ORDER);
 	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
--- a/arch/loongarch/mm/pgtable.c~loongarch-drop-definition-of-pgd_order
+++ a/arch/loongarch/mm/pgtable.c
@@ -13,7 +13,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *ret, *init;
 
-	ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
 	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init((unsigned long)ret);
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

