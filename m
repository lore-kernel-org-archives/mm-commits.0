Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F26EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjGJX3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjGJX3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1610898
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D9F61269
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E0FC433C7;
        Mon, 10 Jul 2023 23:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031781;
        bh=Y3v0ahKaggRI9uorZY+KOncwYs8OjbfNAWcE0GEsGU8=;
        h=Date:To:From:Subject:From;
        b=MeHTTKdu+nahyNIjh559PJ1TO6013fS8coiOWjB5DsexfHSdAb2WkZlLPryzjLfRN
         FNdrcSTY10pMk3JQnj6/vgXgXyAv8TpSbNK5K1cIh/v2KOMCGd6/Hcl6nkUhH5+JX7
         /8b1k1JY4vz6to/5vDpdrmi6A6Z1kRt2PYNMRo+c=
Date:   Mon, 10 Jul 2023 16:29:40 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-default-definition-of-set_ptes.patch added to mm-unstable branch
Message-Id: <20230710232941.03E0FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add default definition of set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-default-definition-of-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-default-definition-of-set_ptes.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add default definition of set_ptes()
Date: Mon, 10 Jul 2023 21:43:07 +0100

Most architectures can just define set_pte() and PFN_PTE_SHIFT to use this
definition.  It's also a handy spot to document the guarantees provided by
the MM.

Link: https://lkml.kernel.org/r/20230710204339.3554919-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/include/linux/pgtable.h~mm-add-default-definition-of-set_ptes
+++ a/include/linux/pgtable.h
@@ -180,6 +180,43 @@ static inline int pmd_young(pmd_t pmd)
 }
 #endif
 
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
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
+
+	for (;;) {
+		set_pte(ptep, pte);
+		if (--nr == 0)
+			break;
+		ptep++;
+		pte = __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+	}
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
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

