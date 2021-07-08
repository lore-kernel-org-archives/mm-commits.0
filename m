Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A46BC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D96C61CCF
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGHBKm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhGHBKm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A17461CCA;
        Thu,  8 Jul 2021 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706480;
        bh=4SS/PDIMCiminyeew7UWUCVkbcqVy04VIfF17MK12vw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M2mQuhfiTMb2r69S1S6jwrdAfLJlFCuHn14IWWiAlbwau6d/5S35msgKa30RuDxzI
         8qNkN1BOSbw5BPsy5ycijiyIbWkgbJUSmFztcVizdcIyTnjLV8Wa9LTnRSxfkLrlXr
         HVubVZrKg4DqJsaRnQtlF249/wSf1WIw1gMbjkV0=
Date:   Wed, 07 Jul 2021 18:07:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        jejb@linux.ibm.com, kirill@shutemov.name, linux-mm@kvack.org,
        lkp@intel.com, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, tycho@tycho.ws,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  [patch 10/54] set_memory: allow querying whether
 set_direct_map_*() is actually enabled
Message-ID: <20210708010759.RkYzreOc1%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: set_memory: allow querying whether set_direct_map_*() is actually enabled

On arm64, set_direct_map_*() functions may return 0 without actually
changing the linear map.  This behaviour can be controlled using kernel
parameters, so we need a way to determine at runtime whether calls to
set_direct_map_invalid_noflush() and set_direct_map_default_noflush() have
any effect.

Extend set_memory API with can_set_direct_map() function that allows
checking if calling set_direct_map_*() will actually change the page
table, replace several occurrences of open coded checks in arm64 with the
new function and provide a generic stub for architectures that always
modify page tables upon calls to set_direct_map APIs.

[arnd@arndb.de: arm64: kfence: fix header inclusion ]
Link: https://lkml.kernel.org/r/20210518072034.31572-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/Kbuild       |    1 -
 arch/arm64/include/asm/cacheflush.h |    6 ------
 arch/arm64/include/asm/kfence.h     |    2 +-
 arch/arm64/include/asm/set_memory.h |   17 +++++++++++++++++
 arch/arm64/kernel/machine_kexec.c   |    1 +
 arch/arm64/mm/mmu.c                 |    7 +++----
 arch/arm64/mm/pageattr.c            |   13 +++++++++----
 include/linux/set_memory.h          |   12 ++++++++++++
 8 files changed, 43 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -144,12 +144,6 @@ static __always_inline void icache_inval
 	dsb(ish);
 }
 
-int set_memory_valid(unsigned long addr, int numpages, int enable);
-
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
-bool kernel_page_present(struct page *page);
-
 #include <asm-generic/cacheflush.h>
 
 #endif /* __ASM_CACHEFLUSH_H */
--- a/arch/arm64/include/asm/Kbuild~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/include/asm/Kbuild
@@ -3,7 +3,6 @@ generic-y += early_ioremap.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
-generic-y += set_memory.h
 generic-y += user.h
 
 generated-y += cpucaps.h
--- a/arch/arm64/include/asm/kfence.h~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/include/asm/kfence.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_KFENCE_H
 #define __ASM_KFENCE_H
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 static inline bool arch_kfence_init_pool(void) { return true; }
 
--- /dev/null
+++ a/arch/arm64/include/asm/set_memory.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_ARM64_SET_MEMORY_H
+#define _ASM_ARM64_SET_MEMORY_H
+
+#include <asm-generic/set_memory.h>
+
+bool can_set_direct_map(void);
+#define can_set_direct_map can_set_direct_map
+
+int set_memory_valid(unsigned long addr, int numpages, int enable);
+
+int set_direct_map_invalid_noflush(struct page *page);
+int set_direct_map_default_noflush(struct page *page);
+bool kernel_page_present(struct page *page);
+
+#endif /* _ASM_ARM64_SET_MEMORY_H */
--- a/arch/arm64/kernel/machine_kexec.c~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/kernel/machine_kexec.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/page-flags.h>
+#include <linux/set_memory.h>
 #include <linux/smp.h>
 
 #include <asm/cacheflush.h>
--- a/arch/arm64/mm/mmu.c~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/mm/mmu.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/set_memory.h>
 
 #include <asm/barrier.h>
 #include <asm/cputype.h>
@@ -515,8 +516,7 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled() ||
-	    IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map() || crash_mem_map || IS_ENABLED(CONFIG_KFENCE))
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -1489,8 +1489,7 @@ int arch_add_memory(int nid, u64 start,
 	 * KFENCE requires linear map to be mapped at page granularity, so that
 	 * it is possible to protect/unprotect single pages in the KFENCE pool.
 	 */
-	if (rodata_full || debug_pagealloc_enabled() ||
-	    IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
--- a/arch/arm64/mm/pageattr.c~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/arch/arm64/mm/pageattr.c
@@ -19,6 +19,11 @@ struct page_change_data {
 
 bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED);
 
+bool can_set_direct_map(void)
+{
+	return rodata_full || debug_pagealloc_enabled();
+}
+
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
 {
 	struct page_change_data *cdata = data;
@@ -155,7 +160,7 @@ int set_direct_map_invalid_noflush(struc
 		.clear_mask = __pgprot(PTE_VALID),
 	};
 
-	if (!debug_pagealloc_enabled() && !rodata_full)
+	if (!can_set_direct_map())
 		return 0;
 
 	return apply_to_page_range(&init_mm,
@@ -170,7 +175,7 @@ int set_direct_map_default_noflush(struc
 		.clear_mask = __pgprot(PTE_RDONLY),
 	};
 
-	if (!debug_pagealloc_enabled() && !rodata_full)
+	if (!can_set_direct_map())
 		return 0;
 
 	return apply_to_page_range(&init_mm,
@@ -181,7 +186,7 @@ int set_direct_map_default_noflush(struc
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled() && !rodata_full)
+	if (!can_set_direct_map())
 		return;
 
 	set_memory_valid((unsigned long)page_address(page), numpages, enable);
@@ -206,7 +211,7 @@ bool kernel_page_present(struct page *pa
 	pte_t *ptep;
 	unsigned long addr = (unsigned long)page_address(page);
 
-	if (!debug_pagealloc_enabled() && !rodata_full)
+	if (!can_set_direct_map())
 		return true;
 
 	pgdp = pgd_offset_k(addr);
--- a/include/linux/set_memory.h~set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled
+++ a/include/linux/set_memory.h
@@ -28,7 +28,19 @@ static inline bool kernel_page_present(s
 {
 	return true;
 }
+#else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
+/*
+ * Some architectures, e.g. ARM64 can disable direct map modifications at
+ * boot time. Let them overrive this query.
+ */
+#ifndef can_set_direct_map
+static inline bool can_set_direct_map(void)
+{
+	return true;
+}
+#define can_set_direct_map can_set_direct_map
 #endif
+#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifndef set_mce_nospec
 static inline int set_mce_nospec(unsigned long pfn, bool unmap)
_
