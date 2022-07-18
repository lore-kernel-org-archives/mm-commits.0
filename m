Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EA1C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiGRAVP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiGRATN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB63140A6
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA266B80EE8
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E7AC341CD;
        Mon, 18 Jul 2022 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103503;
        bh=q7p8OYdvs5rvW4Xx2V0p4bYPy/1o97aUmOEOUu2bSug=;
        h=Date:To:From:Subject:From;
        b=STeLAOPvlnj0Z6Zzk3idCzXnRdQUvdXiCPtsBViLhPyKzHpKcXFL4ScOoXjLk8gh4
         cQaCQH0/R5BrRdudDdmHXe5eG4ka4LmsnRYf6zUsKhPkU7GtcT7cQXGvHPibCT+7gN
         3oCUP5TJtpGLrcmUajCgxJx5imZRgn+lP+Mkb0A8=
Date:   Sun, 17 Jul 2022 17:18:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-drop-definition-of-pgd_order.patch removed from -mm tree
Message-Id: <20220718001823.61E7AC341CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xtensa: drop definition of PGD_ORDER
has been removed from the -mm tree.  Its filename was
     xtensa-drop-definition-of-pgd_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: xtensa: drop definition of PGD_ORDER
Date: Sun, 3 Jul 2022 17:12:03 +0300

This is the order of the page table allocation, not the order of a PGD. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-15-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Helge Deller <deller@gmx.de>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |    2 +-
 arch/xtensa/include/asm/pgtable.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-drop-definition-of-pgd_order
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -29,7 +29,7 @@
 static inline pgd_t*
 pgd_alloc(struct mm_struct *mm)
 {
-	return (pgd_t*) __get_free_pages(GFP_KERNEL | __GFP_ZERO, PGD_ORDER);
+	return (pgd_t*) __get_free_page(GFP_KERNEL | __GFP_ZERO);
 }
 
 static inline void ptes_clear(pte_t *ptep)
--- a/arch/xtensa/include/asm/pgtable.h~xtensa-drop-definition-of-pgd_order
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -57,7 +57,6 @@
 #define PTRS_PER_PTE		1024
 #define PTRS_PER_PTE_SHIFT	10
 #define PTRS_PER_PGD		1024
-#define PGD_ORDER		0
 #define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
 #define FIRST_USER_PGD_NR	(FIRST_USER_ADDRESS >> PGDIR_SHIFT)
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


