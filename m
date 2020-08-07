Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8CDC433E3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2E222CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781355;
	bh=1Ig4RehoHuoccqQrfVl0xTQN5UF60fiYe1h00zAkXW4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rDOFeppR3YvbKpWqlK+g3Pfqp8pBOvebwPRBvWpQUO6jzEbZqYzza0Pe4SSlKe86C
	 AHeI5FwqIHr+vBKB9PBZURONMHDw9wM1K4nnmtDGsAXAa1+noixafmhsEYPpq66pFX
	 DOaULppMFeEuYfbEJJLCI63K/I4XJ62Mg1u7O8Co=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHGGWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgHGGWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA73A22C9F;
        Fri,  7 Aug 2020 06:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781353;
        bh=1Ig4RehoHuoccqQrfVl0xTQN5UF60fiYe1h00zAkXW4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YwQOeEbYKyO+K5v+iS6T5RX8fSr6Ey17hG91bs4AzvbtNSD/ooy8n7PsFSCRkJV2S
         AKeJ0MBMOCNFT5JwEgn48XrkLqkciaY498gjDx9Dk112vs67WkgCODic7kRSE+i6kl
         YkTdd4+QaYNuD3H6N2hihiN4CXn1fFhJ1tllSLFQ=
Date:   Thu, 06 Aug 2020 23:22:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abdhalee@linux.vnet.ibm.com, akpm@linux-foundation.org,
        arnd@arndb.de, christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de,
        linux-mm@kvack.org, luto@kernel.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        rppt@linux.ibm.com, sathnaga@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shorne@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 097/163] opeinrisc: switch to generic version of
 pte allocation
Message-ID: <20200807062232.OczdEdm4i%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
