Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECDAC43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiGCU2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiGCU2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7D0111E
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73CE1611B6
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83E5C341C6;
        Sun,  3 Jul 2022 20:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880114;
        bh=mJXf3tS0BgHjcoF7uJ5szXTKvq8caqsUqO0J2A6nYEI=;
        h=Date:To:From:Subject:From;
        b=A/lg4mKYhq6ZZTda6g0OiKS3L+6+xqKJ/7Z2IDEUx9LJ4IMRshvbwhMmGD5boWZR/
         LAzDyC5Y4veMI1j5XvsVO62AcKZFVpNfMoxLSH5Xg5TLDxIhvQylAFTmIInD9/Fi/E
         NqS3sj6TYPjGjLByL+IY2XaOcU755qUIkz8HPWd0=
Date:   Sun, 03 Jul 2022 13:28:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-rename-pgd_order-to-pgd_table_order.patch added to mm-unstable branch
Message-Id: <20220703202834.C83E5C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: rename PGD_ORDER to PGD_TABLE_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     parisc-rename-pgd_order-to-pgd_table_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-rename-pgd_order-to-pgd_table_order.patch

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
Subject: parisc: rename PGD_ORDER to PGD_TABLE_ORDER
Date: Sun, 3 Jul 2022 17:12:02 +0300

This is the order of the page table allocation, not the order of a PGD.

Link: https://lkml.kernel.org/r/20220703141203.147893-14-rppt@kernel.org
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

 arch/parisc/include/asm/pgalloc.h |    6 +++---
 arch/parisc/include/asm/pgtable.h |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/parisc/include/asm/pgalloc.h~parisc-rename-pgd_order-to-pgd_table_order
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -20,18 +20,18 @@ static inline pgd_t *pgd_alloc(struct mm
 {
 	pgd_t *pgd;
 
-	pgd = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	pgd = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_TABLE_ORDER);
 	if (unlikely(pgd == NULL))
 		return NULL;
 
-	memset(pgd, 0, PAGE_SIZE << PGD_ORDER);
+	memset(pgd, 0, PAGE_SIZE << PGD_TABLE_ORDER);
 
 	return pgd;
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	free_pages((unsigned long)pgd, PGD_ORDER);
+	free_pages((unsigned long)pgd, PGD_TABLE_ORDER);
 }
 
 #if CONFIG_PGTABLE_LEVELS == 3
--- a/arch/parisc/include/asm/pgtable.h~parisc-rename-pgd_order-to-pgd_table_order
+++ a/arch/parisc/include/asm/pgtable.h
@@ -118,9 +118,9 @@ extern void __update_cache(pte_t pte);
 
 #if CONFIG_PGTABLE_LEVELS == 3
 #define PMD_TABLE_ORDER	1
-#define PGD_ORDER	0
+#define PGD_TABLE_ORDER	0
 #else
-#define PGD_ORDER	1
+#define PGD_TABLE_ORDER	1
 #endif
 
 /* Definitions for 3rd level (we use PLD here for Page Lower directory
@@ -144,10 +144,10 @@ extern void __update_cache(pte_t pte);
 
 /* Definitions for 1st level */
 #define PGDIR_SHIFT	(PLD_SHIFT + BITS_PER_PTE + BITS_PER_PMD)
-#if (PGDIR_SHIFT + PAGE_SHIFT + PGD_ORDER - BITS_PER_PGD_ENTRY) > BITS_PER_LONG
+#if (PGDIR_SHIFT + PAGE_SHIFT + PGD_TABLE_ORDER - BITS_PER_PGD_ENTRY) > BITS_PER_LONG
 #define BITS_PER_PGD	(BITS_PER_LONG - PGDIR_SHIFT)
 #else
-#define BITS_PER_PGD	(PAGE_SHIFT + PGD_ORDER - BITS_PER_PGD_ENTRY)
+#define BITS_PER_PGD	(PAGE_SHIFT + PGD_TABLE_ORDER - BITS_PER_PGD_ENTRY)
 #endif
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
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

