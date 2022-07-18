Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D3CC43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiGRAUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiGRATK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3540213FA6
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1FBCB80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848D8C385A5;
        Mon, 18 Jul 2022 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103495;
        bh=k5yTiMzwwnYTFzoH6wTPmplPu/ZR+muGCzghR4p+oYk=;
        h=Date:To:From:Subject:From;
        b=tmJdTFY9CEV0rHERK25fbQY8HVBtvE5BTr4Z6MwSDKd5U82PXQI0ZDSlx+RaNKw39
         OAnIgeT8oRhsIf67s7wW2sIfCwk6ZR+AOTctfq79Da393yvkpulY0Nvkh+2rvnTGYv
         H2HkKM0EawN5ssztIJKfCTiJCSw6nEyEfvhMadL4=
Date:   Sun, 17 Jul 2022 17:18:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-drop-definition-of-pte_order.patch removed from -mm tree
Message-Id: <20220718001815.848D8C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: drop definition of PTE_ORDER
has been removed from the -mm tree.  Its filename was
     nios2-drop-definition-of-pte_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: nios2: drop definition of PTE_ORDER
Date: Sun, 3 Jul 2022 17:11:56 +0300

This is the order of the page table allocation, not the order of a PTE. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-8-rppt@kernel.org
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

 arch/nios2/include/asm/pgtable.h |    3 +--
 arch/nios2/mm/init.c             |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/nios2/include/asm/pgtable.h~nios2-drop-definition-of-pte_order
+++ a/arch/nios2/include/asm/pgtable.h
@@ -53,10 +53,9 @@ struct mm_struct;
 #define PAGE_COPY MKP(0, 0, 1)
 
 #define PGD_ORDER	0
-#define PTE_ORDER	0
 
 #define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
-#define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
+#define PTRS_PER_PTE	(PAGE_SIZE / sizeof(pte_t))
 
 #define USER_PTRS_PER_PGD	\
 	(CONFIG_NIOS2_KERNEL_MMU_REGION_BASE / PGDIR_SIZE)
--- a/arch/nios2/mm/init.c~nios2-drop-definition-of-pte_order
+++ a/arch/nios2/mm/init.c
@@ -80,7 +80,7 @@ void __init mmu_init(void)
 
 #define __page_aligned(order) __aligned(PAGE_SIZE << (order))
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PGD_ORDER);
-pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __aligned(PAGE_SIZE);
 static struct page *kuser_page[1];
 
 static int alloc_kuser_page(void)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


