Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB03C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2852075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027069;
	bh=rEvtmWEgZUouTJ82L7gESsqKdFKIATN876AjGp5wnjo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cicO+y6eMyGlZD7I/GZOTWVEs/fz8qwCrFDB+qZrgLW53QTfj2Ji6gLfAa/HDjJwf
	 lxz+27s5fiZKa2KQHo/b3kGM38TNqprL8IJblfnD9Cr7jjn6qor31YwxnAlhRHOT4/
	 JzjG9Fff/8bUrtNOg+oTU55uh0PL17foVvSNQ2lQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B858F206CD;
        Mon, 10 Aug 2020 02:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027068;
        bh=rEvtmWEgZUouTJ82L7gESsqKdFKIATN876AjGp5wnjo=;
        h=Date:From:To:Subject:From;
        b=qP9DVJTSnNgUcoOWhmK6tffYIbB34vyJpWu5TEzaHlB1od7uQ8Tepy9iSgt5Q4gum
         j9cSItnWmswnQ7Bht4MOj1CCuXqwaNBpY3V9uqtrGU1Xu87IyxGgd4uB7HAZzTyyT6
         +DV+usNc1Twfkf7zuGXXdD3sojxR/gqk1FXQGYWw=
Date:   Sun, 09 Aug 2020 19:37:47 -0700
From:   akpm@linux-foundation.org
To:     abdhalee@linux.vnet.ibm.com, arnd@arndb.de,
        christophe.leroy@csgroup.eu, geert@linux-m68k.org,
        jcmvbkbc@gmail.com, joro@8bytes.org, jroedel@suse.de,
        luto@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org, rppt@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        shorne@gmail.com, willy@infradead.org
Subject:  [merged]
 xtensa-switch-to-generic-version-of-pte-allocation.patch removed from -mm
 tree
Message-ID: <20200810023747.OXBDsRroj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: switch to generic version of pte allocation
has been removed from the -mm tree.  Its filename was
     xtensa-switch-to-generic-version-of-pte-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: xtensa: switch to generic version of pte allocation

xtensa clears PTEs during allocation of the page tables and pte_clear()
sets the PTE to a non-zero value.  Splitting ptes_clear() helper out of
pte_alloc_one() and pte_alloc_one_kernel() allows reuse of base generic
allocation methods (__pte_alloc_one() and __pte_alloc_one_kernel()) and
the common GFP mask for page table allocations.

The pte_free() and pte_free_kernel() implementations on xtensa are
identical to the generic ones and can be dropped.

[jcmvbkbc@gmail.com: xtensa: fix closing endif comment]
  Link: http://lkml.kernel.org/r/20200721024751.1257-1-jcmvbkbc@gmail.com
Link: http://lkml.kernel.org/r/20200627143453.31835-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
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
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/pgalloc.h |   41 ++++++++++++----------------
 1 file changed, 19 insertions(+), 22 deletions(-)

--- a/arch/xtensa/include/asm/pgalloc.h~xtensa-switch-to-generic-version-of-pte-allocation
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -8,9 +8,14 @@
 #ifndef _XTENSA_PGALLOC_H
 #define _XTENSA_PGALLOC_H
 
+#ifdef CONFIG_MMU
 #include <linux/highmem.h>
 #include <linux/slab.h>
 
+#define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
+#define __HAVE_ARCH_PTE_ALLOC_ONE
+#include <asm-generic/pgalloc.h>
+
 /*
  * Allocating and freeing a pmd is trivial: the 1-entry pmd is
  * inside the pgd, so has no extra memory associated with it.
@@ -33,45 +38,37 @@ static inline void pgd_free(struct mm_st
 	free_page((unsigned long)pgd);
 }
 
+static inline void ptes_clear(pte_t *ptep)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		pte_clear(NULL, 0, ptep + i);
+}
+
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
 	pte_t *ptep;
-	int i;
 
-	ptep = (pte_t *)__get_free_page(GFP_KERNEL);
+	ptep = (pte_t *)__pte_alloc_one_kernel(mm);
 	if (!ptep)
 		return NULL;
-	for (i = 0; i < 1024; i++)
-		pte_clear(NULL, 0, ptep + i);
+	ptes_clear(ptep);
 	return ptep;
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
-	pte_t *pte;
 	struct page *page;
 
-	pte = pte_alloc_one_kernel(mm);
-	if (!pte)
-		return NULL;
-	page = virt_to_page(pte);
-	if (!pgtable_pte_page_ctor(page)) {
-		__free_page(page);
+	page = __pte_alloc_one(mm, GFP_PGTABLE_USER);
+	if (!page)
 		return NULL;
-	}
+	ptes_clear(page_address(page));
 	return page;
 }
 
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_pte_page_dtor(pte);
-	__free_page(pte);
-}
 #define pmd_pgtable(pmd) pmd_page(pmd)
+#endif /* CONFIG_MMU */
 
 #endif /* _XTENSA_PGALLOC_H */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


