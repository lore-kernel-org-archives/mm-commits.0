Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DF8C433DB
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77A064DF2
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhBFDPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhBFDME (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:12:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64FB664FF1;
        Fri,  5 Feb 2021 23:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612568098;
        bh=BYPVdRKZh9d4qKVQ46WXMIcsDZ/OWQK6XgeYjEmkm+M=;
        h=Date:From:To:Subject:From;
        b=CPQByhW7Yyu2Kb0GaWuMk0KMzq/Ggknup/+BMLYBNXNotdn52kPmdSEBSxIjuw25w
         rzbUMJhF6hoEn1DnmMGXBWEH3YZkhqbrYbEnP48samn0PlBVsicyzTdodgFAgTNAJh
         OXOSmd0Wz4ANHy58u5FU7eM/zr2g7g0KFCwqiZbg=
Date:   Fri, 05 Feb 2021 15:34:57 -0800
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, justin.he@arm.com,
        maobibo@loongson.cn, mm-commits@vger.kernel.org,
        tsbogend@alpha.franken.de
Subject:  [to-be-updated] mm-memoryc-remove-pte_sw_mkyoung.patch
 removed from -mm tree
Message-ID: <20210205233457.OEwk5RotP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: remove pte_sw_mkyoung()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-remove-pte_sw_mkyoung.patch

This patch was dropped because an updated version will be merged

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
 mm/memory.c                     |   10 ++++++----
 3 files changed, 6 insertions(+), 22 deletions(-)

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
@@ -2902,7 +2902,8 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
-		entry = pte_sw_mkyoung(entry);
+		if (arch_faults_on_old_pte())
+			entry = pte_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 		/*
@@ -3560,7 +3561,8 @@ static vm_fault_t do_anonymous_page(stru
 	__SetPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
+	if (arch_faults_on_old_pte())
+		entry = pte_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
@@ -3745,8 +3747,8 @@ void do_set_pte(struct vm_fault *vmf, st
 
 	if (prefault && arch_wants_old_prefaulted_pte())
 		entry = pte_mkold(entry);
-	else
-		entry = pte_sw_mkyoung(entry);
+	else if (arch_faults_on_old_pte())
+		entry = pte_mkyoung(entry);
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-remove-arch_remap-and-mm-arch-hooksh.patch

