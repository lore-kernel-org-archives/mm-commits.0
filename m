Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C89C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiGRAVP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiGRATN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABF4140A5
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9718B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A19C341C0;
        Mon, 18 Jul 2022 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103502;
        bh=90R7k5ob+8QtyYMpJSVKfRzz61zc8Az1MAk1F7pJ/vo=;
        h=Date:To:From:Subject:From;
        b=X/T8qABxKmU5L/T5xsr2ozk6BE4AHdtaeTE3Z0Kcwxnhm0dYl2WabYh948dNyBcHq
         KXxATaj26O838tjZZuH11nReGzyZSDE9ggORenL3V62Dk12rdams/GYFvGWqXIi8ec
         T2xiPLOd3mhyVQkeWmusA6HqsEROr9FVRGq8THvM=
Date:   Sun, 17 Jul 2022 17:18:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] parisc-rename-pgd_order-to-pgd_table_order.patch removed from -mm tree
Message-Id: <20220718001822.47A19C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: parisc: rename PGD_ORDER to PGD_TABLE_ORDER
has been removed from the -mm tree.  Its filename was
     parisc-rename-pgd_order-to-pgd_table_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


