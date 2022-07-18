Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36863CCA481
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiGRAUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiGRATJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEB913F8E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A80760F32
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3EBC3411E;
        Mon, 18 Jul 2022 00:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103490;
        bh=fpCbDijBS2c1TlcnueYLjMxs3QFFeNE+B9ZQiKGz2Q4=;
        h=Date:To:From:Subject:From;
        b=GEI0TR62qEeqlODYiTaySlmuZBgpOQmWyBWXiwOZw4nd9aZhcGwYY2i2o17C3KQmW
         1UiF4qSYk/TmitjA7BHsshSqTANeLp+8Boyh84MF0xHKF4cU6w4GGrKt4lyLvUZf9v
         cws1e5rwX+wFaeTmCURuaWjI5lyZzFDL8SvQ/Ulw=
Date:   Sun, 17 Jul 2022 17:18:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-drop-definition-of-pgd_order.patch removed from -mm tree
Message-Id: <20220718001809.DF3EBC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky: drop definition of PGD_ORDER
has been removed from the -mm tree.  Its filename was
     csky-drop-definition-of-pgd_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: csky: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:11:51 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-3-rppt@kernel.org
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

 arch/csky/include/asm/pgalloc.h |    2 +-
 arch/csky/include/asm/pgtable.h |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/csky/include/asm/pgalloc.h~csky-drop-definition-of-pgd_order
+++ a/arch/csky/include/asm/pgalloc.h
@@ -44,7 +44,7 @@ static inline pgd_t *pgd_alloc(struct mm
 	pgd_t *ret;
 	pgd_t *init;
 
-	ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
 	if (ret) {
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init((unsigned long *)ret);
--- a/arch/csky/include/asm/pgtable.h~csky-drop-definition-of-pgd_order
+++ a/arch/csky/include/asm/pgtable.h
@@ -18,9 +18,8 @@
 /*
  * C-SKY is two-level paging structure:
  */
-#define PGD_ORDER	0
 
-#define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
+#define PTRS_PER_PGD	(PAGE_SIZE / sizeof(pgd_t))
 #define PTRS_PER_PMD	1
 #define PTRS_PER_PTE	(PAGE_SIZE / sizeof(pte_t))
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


