Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60816C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DB50206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027067;
	bh=MjOFOGKtqUkmlCyRGO7LuAYpy1/+cUfuqG9vaRsPc/I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G/DwEzZbY1qcmxcEBQQCKmSOMIaVC9sWgvKw8DWrwOqgk1gVrXgK9QmiiIITcB5L7
	 dXI6xrIaYkD7KsNifPYFRhX+UK9iaYFk+600LuH7kp2NsfPADqbV5M1DDgcMIFnnDw
	 Jlk75prMXdUOMsq7m3m3gb5dbZxm4RSc5W7mEu6o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJChq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJChp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:45 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA589206C3;
        Mon, 10 Aug 2020 02:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027065;
        bh=MjOFOGKtqUkmlCyRGO7LuAYpy1/+cUfuqG9vaRsPc/I=;
        h=Date:From:To:Subject:From;
        b=ebho0Jjr1FwV3dIjO/fq8efRyjT1PQ4FHh+AKHlGqMq6yk4AQIULipkwzvhJHja+6
         eydnR+w8lgPwhAoeTK4t1ZWSILy+sXNrcMcZk3UR96D2nrZCktHaFO3Lwue6vLKm51
         QPe00lbeQC+PkMnPA7TmcvqoLspaFCIwmAdJVo1U=
Date:   Sun, 09 Aug 2020 19:37:44 -0700
From:   akpm@linux-foundation.org
To:     abdhalee@linux.vnet.ibm.com, arnd@arndb.de,
        christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de,
        luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        shorne@gmail.com, willy@infradead.org
Subject:  [merged]
 opeinrisc-switch-to-generic-version-of-pte-allocation.patch removed from
 -mm tree
Message-ID: <20200810023744.J9f69KvIn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: opeinrisc: switch to generic version of pte allocation
has been removed from the -mm tree.  Its filename was
     opeinrisc-switch-to-generic-version-of-pte-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: opeinrisc: switch to generic version of pte allocation

Replace pte_alloc_one(), pte_free() and pte_free_kernel() with the generic
implementation.  The only actual functional change is the addition of
__GFP_ACCOUT for the allocation of the user page tables.

The pte_alloc_one_kernel() is kept back because its implementation on
openrisc is different than the generic one.

Link: http://lkml.kernel.org/r/20200627143453.31835-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/pgalloc.h |   33 ++------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

--- a/arch/openrisc/include/asm/pgalloc.h~opeinrisc-switch-to-generic-version-of-pte-allocation
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -20,6 +20,9 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 
+#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
+#include <asm-generic/pgalloc.h>
+
 extern int mem_init_done;
 
 #define pmd_populate_kernel(mm, pmd, pte) \
@@ -61,38 +64,8 @@ extern inline pgd_t *pgd_alloc(struct mm
 }
 #endif
 
-static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	free_page((unsigned long)pgd);
-}
-
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-static inline struct page *pte_alloc_one(struct mm_struct *mm)
-{
-	struct page *pte;
-	pte = alloc_pages(GFP_KERNEL, 0);
-	if (!pte)
-		return NULL;
-	clear_page(page_address(pte));
-	if (!pgtable_pte_page_ctor(pte)) {
-		__free_page(pte);
-		return NULL;
-	}
-	return pte;
-}
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, struct page *pte)
-{
-	pgtable_pte_page_dtor(pte);
-	__free_page(pte);
-}
-
 #define __pte_free_tlb(tlb, pte, addr)	\
 do {					\
 	pgtable_pte_page_dtor(pte);	\
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


