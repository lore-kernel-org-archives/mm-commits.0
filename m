Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFABEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjGJXa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjGJXa5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F37B1
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C4E61260
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DE4C433C7;
        Mon, 10 Jul 2023 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031853;
        bh=HcOfXljBpazW8BraYpTvhmZcEkkDxyjITAY4KPnrGjg=;
        h=Date:To:From:Subject:From;
        b=TlinO6wuIYJG0shfuWaA3ywdtkhTMPLPTgjUStnn/XumwNa3M3m+G2aCswegeZpn2
         vmimXfpwbvgjFjZ+gwKM4nWFvkKt8/sD99Z66Vyo25V4CGoas1w4RNUNqeAXmbyK6A
         lCqOowcHPeyP4+4BuNnAfgNFqN1Tf2zKL1eVOkMw=
Date:   Mon, 10 Jul 2023 16:30:52 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, rppt@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        agordeev@linux.ibm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233053.96DE4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     s390-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-implement-the-new-page-table-range-api.patch

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
Subject: s390: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:24 +0100

Add set_ptes() and update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230710204339.3554919-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |   33 +++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~s390-implement-the-new-page-table-range-api
+++ a/arch/s390/include/asm/pgtable.h
@@ -47,6 +47,7 @@ static inline void update_page_count(int
  * tables contain all the necessary information.
  */
 #define update_mmu_cache(vma, address, ptep)     do { } while (0)
+#define update_mmu_cache_range(vmf, vma, addr, ptep, nr) do { } while (0)
 #define update_mmu_cache_pmd(vma, address, ptep) do { } while (0)
 
 /*
@@ -1316,20 +1317,34 @@ pgprot_t pgprot_writecombine(pgprot_t pr
 pgprot_t pgprot_writethrough(pgprot_t prot);
 
 /*
- * Certain architectures need to do special things when PTEs
- * within a page table are directly modified.  Thus, the following
- * hook is made available.
+ * Set multiple PTEs to consecutive pages with a single call.  All PTEs
+ * are within the same folio, PMD and VMA.
  */
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t entry)
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t entry, unsigned int nr)
 {
 	if (pte_present(entry))
 		entry = clear_pte_bit(entry, __pgprot(_PAGE_UNUSED));
-	if (mm_has_pgste(mm))
-		ptep_set_pte_at(mm, addr, ptep, entry);
-	else
-		set_pte(ptep, entry);
+	if (mm_has_pgste(mm)) {
+		for (;;) {
+			ptep_set_pte_at(mm, addr, ptep, entry);
+			if (--nr == 0)
+				break;
+			ptep++;
+			entry = __pte(pte_val(entry) + PAGE_SIZE);
+			addr += PAGE_SIZE;
+		}
+	} else {
+		for (;;) {
+			set_pte(ptep, entry);
+			if (--nr == 0)
+				break;
+			ptep++;
+			entry = __pte(pte_val(entry) + PAGE_SIZE);
+		}
+	}
 }
+#define set_ptes set_ptes
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
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

