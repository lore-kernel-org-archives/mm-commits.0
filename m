Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6521CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiGRAVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiGRATN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1091401E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50074B80EBC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063ABC3411E;
        Mon, 18 Jul 2022 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103501;
        bh=E4VNHw6/6QR5ULaIe/nzY9RctZYvjgIUVtAai52xRo4=;
        h=Date:To:From:Subject:From;
        b=c60lQnQjLuU0NAOy0S41B1AB9D1fvXpktW8UN4FyezH6nCq0uKgK6E4bcr0D3Jv3h
         8aa0bfisMfBR0miXm9PdGxltD8kD5Wr+8yfLJKTHbRrUef/qgTDwOV25AFVDojSsEh
         2K2bPAmYHBizkI7d0JLy1qtxlfd59vHWZQWt4OpY=
Date:   Sun, 17 Jul 2022 17:18:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-drop-definition-of-pgd_order.patch removed from -mm tree
Message-Id: <20220718001821.063ABC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: loongarch: drop definition of PGD_ORDER
has been removed from the -mm tree.  Its filename was
     loongarch-drop-definition-of-pgd_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: loongarch: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:12:01 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

[rppt@linux.ibm.com: drop extra BLANK() line in arch/loongarch/kernel/asm-offsets.c]
  Link: https://lkml.kernel.org/r/20220705154708.181258-13-rppt@kernel.org
Link: https://lkml.kernel.org/r/20220703141203.147893-13-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Huacai Chen <chenhuacai@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    6 ++----
 arch/loongarch/kernel/asm-offsets.c  |    2 --
 arch/loongarch/mm/pgtable.c          |    2 +-
 3 files changed, 3 insertions(+), 7 deletions(-)

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
@@ -190,8 +190,6 @@ void output_mm_defines(void)
 #endif
 	DEFINE(_PTE_T_LOG2, PTE_T_LOG2);
 	BLANK();
-	DEFINE(_PGD_ORDER, PGD_ORDER);
-	BLANK();
 	DEFINE(_PMD_SHIFT, PMD_SHIFT);
 	DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
 	BLANK();
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


