Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F2BC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC0A064F13
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBZBXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhBZBX3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B86764F35;
        Fri, 26 Feb 2021 01:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302571;
        bh=37Lt08SL1AOCqMoBpCWDdiIPkYUAoQaOE4qJNAJF5Ug=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QeiyweP1BwcbVhpJRrFMdk6LKEfzRCT6nit4T1yGrbjYhFK9F8+l4fLn1RfrMZeSy
         HmudV6Ga6+izCFC6srANmE9wsIiJJJk+m1m/naAjYyjvJS+CGxRVnSvpR2//x3njpu
         XPUQBCm5gf0veZpi8EMqEHWmV4/JDhQtRvRmeFwk=
Date:   Thu, 25 Feb 2021 17:22:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ambrosehua@gmail.com, chenhc@lemote.com,
        christophe.leroy@csgroup.eu, gaojuxin@loongson.cn,
        huangpei@loongson.cn, jiaxun.yang@flygoat.com, linux-mm@kvack.org,
        lixuefeng@loongson.cn, maobibo@loongson.cn,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        paulburton@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, yangtiezhu@loongson.cn,
        zhangfx@lemote.com
Subject:  [patch 118/118] MIPS: make userspace mapping young by
 default
Message-ID: <20210226012249.-qWuoqPYr%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
