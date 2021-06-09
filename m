Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D914AC48BD1
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A5A613C1
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhFIA1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234467AbhFIA1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D36613AC;
        Wed,  9 Jun 2021 00:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623198347;
        bh=D7bKmTzOpRt+dSu9gD9Y6sGFFY3DpPhQTOh+APBDO18=;
        h=Date:From:To:Subject:From;
        b=zriW83i73mEXL9Q7Mf2myE+VtRVCuWzHpEwMJGMAivM99XdxsMOI4uzu0VyI5zcjA
         jrNI6ajawnFYE2x8LbAoktXm6mlby/dgF4XQAPLWda+rlsfcztqD0Vw9/diVqg93hb
         GYY3RW3taamqgiysl9By3bYdloZoYNfxCGTKiypM=
Date:   Tue, 08 Jun 2021 17:25:46 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, geert@linux-m68k.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  + m68k-remove-support-for-discontigmem.patch added to -mm
 tree
Message-ID: <20210609002546.HH9wqNcSl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: remove support for DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     m68k-remove-support-for-discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-remove-support-for-discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-remove-support-for-discontigmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: m68k: remove support for DISCONTIGMEM

DISCONTIGMEM was replaced by FLATMEM with freeing of the unused memory map
in v5.11.

Remove the support for DISCONTIGMEM entirely.

Link: https://lkml.kernel.org/r/20210608091316.3622-5-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig.cpu           |   10 --------
 arch/m68k/include/asm/mmzone.h  |   10 --------
 arch/m68k/include/asm/page.h    |    2 -
 arch/m68k/include/asm/page_mm.h |   35 ------------------------------
 arch/m68k/mm/init.c             |   20 -----------------
 5 files changed, 1 insertion(+), 76 deletions(-)

--- a/arch/m68k/include/asm/mmzone.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_M68K_MMZONE_H_
-#define _ASM_M68K_MMZONE_H_
-
-extern pg_data_t pg_data_map[];
-
-#define NODE_DATA(nid)		(&pg_data_map[nid])
-#define NODE_MEM_MAP(nid)	(NODE_DATA(nid)->node_mem_map)
-
-#endif /* _ASM_M68K_MMZONE_H_ */
--- a/arch/m68k/include/asm/page.h~m68k-remove-support-for-discontigmem
+++ a/arch/m68k/include/asm/page.h
@@ -62,7 +62,7 @@ extern unsigned long _ramend;
 #include <asm/page_no.h>
 #endif
 
-#if !defined(CONFIG_MMU) || defined(CONFIG_DISCONTIGMEM)
+#ifndef CONFIG_MMU
 #define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
 #define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 #endif
--- a/arch/m68k/include/asm/page_mm.h~m68k-remove-support-for-discontigmem
+++ a/arch/m68k/include/asm/page_mm.h
@@ -126,26 +126,6 @@ static inline void *__va(unsigned long x
 
 extern int m68k_virt_to_node_shift;
 
-#ifndef CONFIG_DISCONTIGMEM
-#define __virt_to_node(addr)	(&pg_data_map[0])
-#else
-extern struct pglist_data *pg_data_table[];
-
-static inline __attribute_const__ int __virt_to_node_shift(void)
-{
-	int shift;
-
-	asm (
-		"1:	moveq	#0,%0\n"
-		m68k_fixup(%c1, 1b)
-		: "=d" (shift)
-		: "i" (m68k_fixup_vnode_shift));
-	return shift;
-}
-
-#define __virt_to_node(addr)	(pg_data_table[(unsigned long)(addr) >> __virt_to_node_shift()])
-#endif
-
 #define virt_to_page(addr) ({						\
 	pfn_to_page(virt_to_pfn(addr));					\
 })
@@ -153,23 +133,8 @@ static inline __attribute_const__ int __
 	pfn_to_virt(page_to_pfn(page));					\
 })
 
-#ifdef CONFIG_DISCONTIGMEM
-#define pfn_to_page(pfn) ({						\
-	unsigned long __pfn = (pfn);					\
-	struct pglist_data *pgdat;					\
-	pgdat = __virt_to_node((unsigned long)pfn_to_virt(__pfn));	\
-	pgdat->node_mem_map + (__pfn - pgdat->node_start_pfn);		\
-})
-#define page_to_pfn(_page) ({						\
-	const struct page *__p = (_page);				\
-	struct pglist_data *pgdat;					\
-	pgdat = &pg_data_map[page_to_nid(__p)];				\
-	((__p) - pgdat->node_mem_map) + pgdat->node_start_pfn;		\
-})
-#else
 #define ARCH_PFN_OFFSET (m68k_memory[0].addr >> PAGE_SHIFT)
 #include <asm-generic/memory_model.h>
-#endif
 
 #define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && (unsigned long)(kaddr) < (unsigned long)high_memory)
 #define pfn_valid(pfn)		virt_addr_valid(pfn_to_virt(pfn))
--- a/arch/m68k/Kconfig.cpu~m68k-remove-support-for-discontigmem
+++ a/arch/m68k/Kconfig.cpu
@@ -408,10 +408,6 @@ config SINGLE_MEMORY_CHUNK
 	  order" to save memory that could be wasted for unused memory map.
 	  Say N if not sure.
 
-config ARCH_DISCONTIGMEM_ENABLE
-	depends on BROKEN
-	def_bool MMU && !SINGLE_MEMORY_CHUNK
-
 config FORCE_MAX_ZONEORDER
 	int "Maximum zone order" if ADVANCED
 	depends on !SINGLE_MEMORY_CHUNK
@@ -451,11 +447,6 @@ config M68K_L2_CACHE
 	depends on MAC
 	default y
 
-config NODES_SHIFT
-	int
-	default "3"
-	depends on DISCONTIGMEM
-
 config CPU_HAS_NO_BITFIELDS
 	bool
 
@@ -553,4 +544,3 @@ config CACHE_COPYBACK
 	  The ColdFire CPU cache is set into Copy-back mode.
 endchoice
 endif
-
--- a/arch/m68k/mm/init.c~m68k-remove-support-for-discontigmem
+++ a/arch/m68k/mm/init.c
@@ -44,28 +44,8 @@ EXPORT_SYMBOL(empty_zero_page);
 
 int m68k_virt_to_node_shift;
 
-#ifdef CONFIG_DISCONTIGMEM
-pg_data_t pg_data_map[MAX_NUMNODES];
-EXPORT_SYMBOL(pg_data_map);
-
-pg_data_t *pg_data_table[65];
-EXPORT_SYMBOL(pg_data_table);
-#endif
-
 void __init m68k_setup_node(int node)
 {
-#ifdef CONFIG_DISCONTIGMEM
-	struct m68k_mem_info *info = m68k_memory + node;
-	int i, end;
-
-	i = (unsigned long)phys_to_virt(info->addr) >> __virt_to_node_shift();
-	end = (unsigned long)phys_to_virt(info->addr + info->size - 1) >> __virt_to_node_shift();
-	for (; i <= end; i++) {
-		if (pg_data_table[i])
-			pr_warn("overlap at %u for chunk %u\n", i, node);
-		pg_data_table[i] = pg_data_map + node;
-	}
-#endif
 	node_set_online(node);
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
alpha-remove-discontigmem-and-numa.patch
arc-update-comment-about-highmem-implementation.patch
arc-remove-support-for-discontigmem.patch
m68k-remove-support-for-discontigmem.patch
mm-remove-config_discontigmem.patch
arch-mm-remove-stale-mentions-of-disconigmem.patch
docs-remove-description-of-discontigmem.patch
mm-replace-config_need_multiple_nodes-with-config_numa.patch
mm-replace-config_flat_node_mem_map-with-config_flatmem.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

