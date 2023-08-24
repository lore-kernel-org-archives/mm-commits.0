Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3110EE49B7
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244077AbjHXXV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbjHXXVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90B2CEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F8D664AEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C704AC433C7;
        Thu, 24 Aug 2023 23:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919278;
        bh=hAkjAa/bHjVI9xHrxg/g9SzLq8npbbaostXRvfBL26k=;
        h=Date:To:From:Subject:From;
        b=DIi3yRbI4PyofF88R1AvD6PzJ3u6VNw8ycFpZa3aVhhMHXCjxUvQYb/eG01pVRcN1
         x2qvK+XOoqb8yrKqKvUF0EjdBNzzTPGEH9FyNAhFNnM75AxklG1RFHaRB25+Ke6/nT
         rY6qJZSxlymxgH5+vBZUspv1gWuESLK047y66DyM=
Date:   Thu, 24 Aug 2023 16:21:18 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-default-definition-of-set_ptes.patch removed from -mm tree
Message-Id: <20230824232118.C704AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add default definition of set_ptes()
has been removed from the -mm tree.  Its filename was
     mm-add-default-definition-of-set_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add default definition of set_ptes()
Date: Wed, 2 Aug 2023 16:13:34 +0100

Most architectures can just define set_pte() and PFN_PTE_SHIFT to use this
definition.  It's also a handy spot to document the guarantees provided by
the MM.

Link: https://lkml.kernel.org/r/20230802151406.3735276-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   81 ++++++++++++++++++++++++++++----------
 1 file changed, 60 insertions(+), 21 deletions(-)

--- a/include/linux/pgtable.h~mm-add-default-definition-of-set_ptes
+++ a/include/linux/pgtable.h
@@ -182,6 +182,66 @@ static inline int pmd_young(pmd_t pmd)
 }
 #endif
 
+/*
+ * A facility to provide lazy MMU batching.  This allows PTE updates and
+ * page invalidations to be delayed until a call to leave lazy MMU mode
+ * is issued.  Some architectures may benefit from doing this, and it is
+ * beneficial for both shadow and direct mode hypervisors, which may batch
+ * the PTE updates which happen during this window.  Note that using this
+ * interface requires that read hazards be removed from the code.  A read
+ * hazard could result in the direct mode hypervisor case, since the actual
+ * write to the page tables may not yet have taken place, so reads though
+ * a raw PTE pointer after it has been modified are not guaranteed to be
+ * up to date.  This mode can only be entered and left under the protection of
+ * the page table locks for all page tables which may be modified.  In the UP
+ * case, this is required so that preemption is disabled, and in the SMP case,
+ * it must synchronize the delayed page table writes properly on other CPUs.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
+#endif
+
+#ifndef set_ptes
+#ifdef PFN_PTE_SHIFT
+/**
+ * set_ptes - Map consecutive pages to a contiguous range of addresses.
+ * @mm: Address space to map the pages into.
+ * @addr: Address to map the first page at.
+ * @ptep: Page table pointer for the first entry.
+ * @pte: Page table entry for the first page.
+ * @nr: Number of pages to map.
+ *
+ * May be overridden by the architecture, or the architecture can define
+ * set_pte() and PFN_PTE_SHIFT.
+ *
+ * Context: The caller holds the page table lock.  The pages all belong
+ * to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int nr)
+{
+	page_table_check_ptes_set(mm, ptep, pte, nr);
+
+	arch_enter_lazy_mmu_mode();
+	for (;;) {
+		set_pte(ptep, pte);
+		if (--nr == 0)
+			break;
+		ptep++;
+		pte = __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+	}
+	arch_leave_lazy_mmu_mode();
+}
+#ifndef set_pte_at
+#define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
+#endif
+#endif
+#else
+#define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
@@ -1052,27 +1112,6 @@ static inline pgprot_t pgprot_modify(pgp
 #endif
 
 /*
- * A facility to provide lazy MMU batching.  This allows PTE updates and
- * page invalidations to be delayed until a call to leave lazy MMU mode
- * is issued.  Some architectures may benefit from doing this, and it is
- * beneficial for both shadow and direct mode hypervisors, which may batch
- * the PTE updates which happen during this window.  Note that using this
- * interface requires that read hazards be removed from the code.  A read
- * hazard could result in the direct mode hypervisor case, since the actual
- * write to the page tables may not yet have taken place, so reads though
- * a raw PTE pointer after it has been modified are not guaranteed to be
- * up to date.  This mode can only be entered and left under the protection of
- * the page table locks for all page tables which may be modified.  In the UP
- * case, this is required so that preemption is disabled, and in the SMP case,
- * it must synchronize the delayed page table writes properly on other CPUs.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
-#endif
-
-/*
  * A facility to provide batching of the reload of page tables and
  * other process state with the actual context switch code for
  * paravirtualized guests.  By convention, only one of the batched
_

Patches currently in -mm which might be from willy@infradead.org are


