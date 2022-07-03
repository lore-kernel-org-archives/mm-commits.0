Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0B0C43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiGCU2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiGCU2R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A24B53
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05EABB80B1D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995BFC341C6;
        Sun,  3 Jul 2022 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880091;
        bh=N6OgU35I79MwaabIyitz9wrVyI6pTK5YR49JnrjJyJY=;
        h=Date:To:From:Subject:From;
        b=MN0zafW+oL9P5fNxKmuhM5e5HICk5C1TBvcgCRkAZpnT/j6KEVLTrKNEzJeNlfTk3
         L7dx/s1GsAC3vKMd3nWrBnyw4b5brqKsTTE77FUIekmVqG7vb/TvPLOK1VDDYb4ksE
         uES+SHdFUyM8CGqV21bhxN4AsRFZhTZORor2b2Y4=
Date:   Sun, 03 Jul 2022 13:28:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-rename-pud_order-to-pud_table_order.patch added to mm-unstable branch
Message-Id: <20220703202811.995BFC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mips: rename PUD_ORDER to PUD_TABLE_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     mips-rename-pud_order-to-pud_table_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-rename-pud_order-to-pud_table_order.patch

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
Subject: mips: rename PUD_ORDER to PUD_TABLE_ORDER
Date: Sun, 3 Jul 2022 17:11:53 +0300

This is the order of the page table allocation, not the order of a PUD.

Link: https://lkml.kernel.org/r/20220703141203.147893-5-rppt@kernel.org
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

 arch/mips/include/asm/pgalloc.h    |    2 +-
 arch/mips/include/asm/pgtable-32.h |    2 +-
 arch/mips/include/asm/pgtable-64.h |   16 ++++++++--------
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/mips/include/asm/pgalloc.h~mips-rename-pud_order-to-pud_table_order
+++ a/arch/mips/include/asm/pgalloc.h
@@ -91,7 +91,7 @@ static inline pud_t *pud_alloc_one(struc
 {
 	pud_t *pud;
 
-	pud = (pud_t *) __get_free_pages(GFP_KERNEL, PUD_ORDER);
+	pud = (pud_t *) __get_free_pages(GFP_KERNEL, PUD_TABLE_ORDER);
 	if (pud)
 		pud_init((unsigned long)pud, (unsigned long)invalid_pmd_table);
 	return pud;
--- a/arch/mips/include/asm/pgtable-32.h~mips-rename-pud_order-to-pud_table_order
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -81,7 +81,7 @@ extern int add_temporary_entry(unsigned
 #endif
 
 #define PGD_ORDER	(__PGD_ORDER >= 0 ? __PGD_ORDER : 0)
-#define PUD_ORDER	aieeee_attempt_to_allocate_pud
+#define PUD_TABLE_ORDER	aieeee_attempt_to_allocate_pud
 #define PMD_TABLE_ORDER	aieeee_attempt_to_allocate_pmd
 #define PTE_ORDER	0
 
--- a/arch/mips/include/asm/pgtable-64.h~mips-rename-pud_order-to-pud_table_order
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -59,7 +59,7 @@
 #define PUD_SHIFT	(PMD_SHIFT + (PAGE_SHIFT + PMD_TABLE_ORDER - 3))
 #define PUD_SIZE	(1UL << PUD_SHIFT)
 #define PUD_MASK	(~(PUD_SIZE-1))
-#define PGDIR_SHIFT	(PUD_SHIFT + (PAGE_SHIFT + PUD_ORDER - 3))
+#define PGDIR_SHIFT	(PUD_SHIFT + (PAGE_SHIFT + PUD_TABLE_ORDER - 3))
 #endif
 
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
@@ -86,17 +86,17 @@
 #ifdef CONFIG_PAGE_SIZE_4KB
 # ifdef CONFIG_MIPS_VA_BITS_48
 #  define PGD_ORDER		0
-#  define PUD_ORDER		0
+#  define PUD_TABLE_ORDER		0
 # else
 #  define PGD_ORDER		1
-#  define PUD_ORDER		aieeee_attempt_to_allocate_pud
+#  define PUD_TABLE_ORDER		aieeee_attempt_to_allocate_pud
 # endif
 #define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_8KB
 #define PGD_ORDER		0
-#define PUD_ORDER		aieeee_attempt_to_allocate_pud
+#define PUD_TABLE_ORDER		aieeee_attempt_to_allocate_pud
 #define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
@@ -106,19 +106,19 @@
 #else
 #define PGD_ORDER               0
 #endif
-#define PUD_ORDER		aieeee_attempt_to_allocate_pud
+#define PUD_TABLE_ORDER		aieeee_attempt_to_allocate_pud
 #define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_32KB
 #define PGD_ORDER		0
-#define PUD_ORDER		aieeee_attempt_to_allocate_pud
+#define PUD_TABLE_ORDER		aieeee_attempt_to_allocate_pud
 #define PMD_TABLE_ORDER		0
 #define PTE_ORDER		0
 #endif
 #ifdef CONFIG_PAGE_SIZE_64KB
 #define PGD_ORDER		0
-#define PUD_ORDER		aieeee_attempt_to_allocate_pud
+#define PUD_TABLE_ORDER		aieeee_attempt_to_allocate_pud
 #ifdef CONFIG_MIPS_VA_BITS_48
 #define PMD_TABLE_ORDER		0
 #else
@@ -129,7 +129,7 @@
 
 #define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
 #ifndef __PAGETABLE_PUD_FOLDED
-#define PTRS_PER_PUD	((PAGE_SIZE << PUD_ORDER) / sizeof(pud_t))
+#define PTRS_PER_PUD	((PAGE_SIZE << PUD_TABLE_ORDER) / sizeof(pud_t))
 #endif
 #ifndef __PAGETABLE_PMD_FOLDED
 #define PTRS_PER_PMD	((PAGE_SIZE << PMD_TABLE_ORDER) / sizeof(pmd_t))
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

