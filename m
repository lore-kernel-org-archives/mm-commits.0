Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421D8C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05E8664F4D
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhBDA1k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:27:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233395AbhBDA1k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:27:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E692A64F4D;
        Thu,  4 Feb 2021 00:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612398419;
        bh=WhwTyxPrJXDoAPOMB1fu1GPsoSf+HC8L23ebGDU3xOo=;
        h=Date:From:To:Subject:From;
        b=qE2ii5p++o2q7l7PEzEvuDWUCBCDc0ekpjjJYCTaMxT/ZEWujDhdbq2wDB1fcsdzu
         cxBK4Z6GS1Ltg2Rt70jJVm9BqtFMhTyGSfC1jlrLDghj2WZYICFIBKFgIDo3zAsuzW
         eEhVspNEXp0NozftRJVgiXiF+q9oOWfjujZmleM8=
Date:   Wed, 03 Feb 2021 16:26:58 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, justin.he@arm.com,
        maobibo@loongson.cn, mm-commits@vger.kernel.org,
        tsbogend@alpha.franken.de
Subject:  + mm-memoryc-remove-pte_sw_mkyoung.patch added to -mm
 tree
Message-ID: <20210204002658.zT72EcVWe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: remove pte_sw_mkyoung()
has been added to the -mm tree.  Its filename is
     mm-memoryc-remove-pte_sw_mkyoung.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-remove-pte_sw_mkyoung.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-remove-pte_sw_mkyoung.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/memory.c: remove pte_sw_mkyoung()

Commit 83d116c53058 ("mm: fix double page fault on arm64 if PTE_AF is
cleared") introduced arch_faults_on_old_pte() helper to identify platforms
that don't set page access bit in HW and require a page fault to set it.

Commit 44bf431b47b4 ("mm/memory.c: Add memory read privilege on page fault
handling") added pte_sw_mkyoung() which is yet another way to manage
platforms that don't set page access bit in HW and require a page fault to
set it.

Remove that pte_sw_mkyoung() helper and use the already existing
arch_faults_on_old_pte() helper together with pte_mkyoung() instead.

Link: https://lkml.kernel.org/r/f302ef92c48d1f08a0459aaee1c568ca11213814.1612345700.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Jia He <justin.he@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h |    2 --
 include/linux/pgtable.h         |   16 ----------------
 mm/memory.c                     |    9 ++++++---
 3 files changed, 6 insertions(+), 21 deletions(-)

--- a/arch/mips/include/asm/pgtable.h~mm-memoryc-remove-pte_sw_mkyoung
+++ a/arch/mips/include/asm/pgtable.h
@@ -406,8 +406,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return pte;
 }
 
-#define pte_sw_mkyoung	pte_mkyoung
-
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 static inline int pte_huge(pte_t pte)	{ return pte_val(pte) & _PAGE_HUGE; }
 
--- a/include/linux/pgtable.h~mm-memoryc-remove-pte_sw_mkyoung
+++ a/include/linux/pgtable.h
@@ -424,22 +424,6 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
-/*
- * On some architectures hardware does not set page access bit when accessing
- * memory page, it is responsibilty of software setting this bit. It brings
- * out extra page fault penalty to track page access bit. For optimization page
- * access bit can be set during all page fault flow on these arches.
- * To be differentiate with macro pte_mkyoung, this macro is used on platforms
- * where software maintains page access bit.
- */
-#ifndef pte_sw_mkyoung
-static inline pte_t pte_sw_mkyoung(pte_t pte)
-{
-	return pte;
-}
-#define pte_sw_mkyoung	pte_sw_mkyoung
-#endif
-
 #ifndef pte_savedwrite
 #define pte_savedwrite pte_write
 #endif
--- a/mm/memory.c~mm-memoryc-remove-pte_sw_mkyoung
+++ a/mm/memory.c
@@ -2890,7 +2890,8 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
-		entry = pte_sw_mkyoung(entry);
+		if (arch_faults_on_old_pte())
+			entry = pte_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 		/*
@@ -3548,7 +3549,8 @@ static vm_fault_t do_anonymous_page(stru
 	__SetPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
+	if (arch_faults_on_old_pte())
+		entry = pte_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
@@ -3824,7 +3826,8 @@ vm_fault_t alloc_set_pte(struct vm_fault
 
 	flush_icache_page(vma, page);
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
+	if (arch_faults_on_old_pte())
+		entry = pte_mkyoung(entry);
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	/* copy-on-write page */
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-memoryc-remove-pte_sw_mkyoung.patch
mm-remove-arch_remap-and-mm-arch-hooksh.patch

