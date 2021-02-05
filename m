Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AB4C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2083264E3D
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhBFC6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 21:58:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhBFCq4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 21:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A796501D;
        Fri,  5 Feb 2021 23:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612568471;
        bh=sL42fBkIHoXO3lC96z3bzs3rFImpSlDATMffD73Tv18=;
        h=Date:From:To:Subject:From;
        b=lyLtkFRHTl7EZF5AcMw1Lb9UNpqEwCQTeGxZhlV/pvHnqpeYHTcWOfWL4qatCVBqM
         ukpB4cs1MdIKw6w3PCSBI/rU9q1ga8fA5PtwhpgaLzdg0Uv0l+cAQDmOW+CogoWjpX
         WnqB5Yh5MC6eC8KzynQqoEa74GHx0tVb/pwAx9n8=
Date:   Fri, 05 Feb 2021 15:41:10 -0800
From:   akpm@linux-foundation.org
To:     ambrosehua@gmail.com, chenhc@lemote.com,
        christophe.leroy@csgroup.eu, gaojuxin@loongson.cn,
        huangpei@loongson.cn, jiaxun.yang@flygoat.com,
        lixuefeng@loongson.cn, maobibo@loongson.cn,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        paulburton@kernel.org, tsbogend@alpha.franken.de,
        yangtiezhu@loongson.cn, zhangfx@lemote.com
Subject:  + mips-make-userspace-mapping-young-by-default.patch
 added to -mm tree
Message-ID: <20210205234110.Qg4sj6BMr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: make userspace mapping young by default
has been added to the -mm tree.  Its filename is
     mips-make-userspace-mapping-young-by-default.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mips-make-userspace-mapping-young-by-default.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mips-make-userspace-mapping-young-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Pei <huangpei@loongson.cn>
Subject: MIPS: make userspace mapping young by default

MIPS page fault path(except huge page) takes 3 exceptions (1 TLB Miss + 2
TLB Invalid), butthe second TLB Invalid exception is just triggered by
__update_tlb from do_page_fault writing tlb without _PAGE_VALID set.  With
this patch, user space mapping prot is made young by default (with both
_PAGE_VALID and _PAGE_YOUNG set), and it only take 1 TLB Miss + 1 TLB
Invalid exception

Remove pte_sw_mkyoung without polluting MM code and make page fault delay
of MIPS on par with other architecture

Link: https://lkml.kernel.org/r/20210204013942.8398-1-huangpei@loongson.cn
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: <huangpei@loongson.cn>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <ambrosehua@gmail.com>
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Li Xuefeng <lixuefeng@loongson.cn>
Cc: Yang Tiezhu <yangtiezhu@loongson.cn>
Cc: Gao Juxin <gaojuxin@loongson.cn>
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c    |   30 ++++++++++++++++--------------
 include/linux/pgtable.h |    8 --------
 mm/memory.c             |    4 ----
 3 files changed, 16 insertions(+), 26 deletions(-)

--- a/arch/mips/mm/cache.c~mips-make-userspace-mapping-young-by-default
+++ a/arch/mips/mm/cache.c
@@ -157,29 +157,31 @@ unsigned long _page_cachable_default;
 EXPORT_SYMBOL(_page_cachable_default);
 
 #define PM(p)	__pgprot(_page_cachable_default | (p))
+#define PVA(p)	PM(_PAGE_VALID | _PAGE_ACCESSED | (p))
 
 static inline void setup_protection_map(void)
 {
 	protection_map[0]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[1]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[2]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[3]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[4]  = PM(_PAGE_PRESENT);
-	protection_map[5]  = PM(_PAGE_PRESENT);
-	protection_map[6]  = PM(_PAGE_PRESENT);
-	protection_map[7]  = PM(_PAGE_PRESENT);
+	protection_map[1]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[2]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[3]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[4]  = PVA(_PAGE_PRESENT);
+	protection_map[5]  = PVA(_PAGE_PRESENT);
+	protection_map[6]  = PVA(_PAGE_PRESENT);
+	protection_map[7]  = PVA(_PAGE_PRESENT);
 
 	protection_map[8]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-	protection_map[9]  = PM(_PAGE_PRESENT | _PAGE_NO_EXEC);
-	protection_map[10] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
+	protection_map[9]  = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[10] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE |
 				_PAGE_NO_READ);
-	protection_map[11] = PM(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
-	protection_map[12] = PM(_PAGE_PRESENT);
-	protection_map[13] = PM(_PAGE_PRESENT);
-	protection_map[14] = PM(_PAGE_PRESENT | _PAGE_WRITE);
-	protection_map[15] = PM(_PAGE_PRESENT | _PAGE_WRITE);
+	protection_map[11] = PVA(_PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
+	protection_map[12] = PVA(_PAGE_PRESENT);
+	protection_map[13] = PVA(_PAGE_PRESENT);
+	protection_map[14] = PVA(_PAGE_PRESENT);
+	protection_map[15] = PVA(_PAGE_PRESENT);
 }
 
+#undef _PVA
 #undef PM
 
 void cpu_cache_init(void)
--- a/include/linux/pgtable.h~mips-make-userspace-mapping-young-by-default
+++ a/include/linux/pgtable.h
@@ -432,14 +432,6 @@ static inline void ptep_set_wrprotect(st
  * To be differentiate with macro pte_mkyoung, this macro is used on platforms
  * where software maintains page access bit.
  */
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
--- a/mm/memory.c~mips-make-userspace-mapping-young-by-default
+++ a/mm/memory.c
@@ -2902,7 +2902,6 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
-		entry = pte_sw_mkyoung(entry);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 		/*
@@ -3560,7 +3559,6 @@ static vm_fault_t do_anonymous_page(stru
 	__SetPageUptodate(page);
 
 	entry = mk_pte(page, vma->vm_page_prot);
-	entry = pte_sw_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
@@ -3745,8 +3743,6 @@ void do_set_pte(struct vm_fault *vmf, st
 
 	if (prefault && arch_wants_old_prefaulted_pte())
 		entry = pte_mkold(entry);
-	else
-		entry = pte_sw_mkyoung(entry);
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
_

Patches currently in -mm which might be from huangpei@loongson.cn are

mips-make-userspace-mapping-young-by-default.patch
mips-make-userspace-mapping-young-by-default.patch

