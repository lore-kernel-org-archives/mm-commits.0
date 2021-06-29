Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6A9C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E2461D15
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhF2CpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2CpT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C768461D11;
        Tue, 29 Jun 2021 02:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934573;
        bh=zTpKVSsnw7Fm2IiVR6Pi9Iu41mA+ejynq/0TUBymlQo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kZSEcrJKXLa8Z8UfPKajLOH/QAd2Mqb+RFiyXWk1uy2i/8FZDpFE/f9Mx/Eo7/fJF
         qUCUctmoXGLcNT2s8jKh3k/eEtLs467yAfh4ZgoBUgvLl3AtF9Bmz/ACzEJ/DSGPUt
         R3cFaLRS7Toef2+AGB/21Pzvi/4n+HoanlfIQ96s=
Date:   Mon, 28 Jun 2021 19:42:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 184/192] mm: remove CONFIG_DISCONTIGMEM
Message-ID: <20210629024252.yt_lGoU4L%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: remove CONFIG_DISCONTIGMEM

There are no architectures that support DISCONTIGMEM left.

Remove the configuration option and the dead code it was guarding in the
generic memory management code.

Link: https://lkml.kernel.org/r/20210608091316.3622-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |   37 ++-------------------------
 include/linux/mmzone.h             |    8 +++--
 mm/Kconfig                         |   25 ++----------------
 mm/page_alloc.c                    |   13 ---------
 4 files changed, 12 insertions(+), 71 deletions(-)

--- a/include/asm-generic/memory_model.h~mm-remove-config_discontigmem
+++ a/include/asm-generic/memory_model.h
@@ -6,47 +6,18 @@
 
 #ifndef __ASSEMBLY__
 
+/*
+ * supports 3 memory models.
+ */
 #if defined(CONFIG_FLATMEM)
 
 #ifndef ARCH_PFN_OFFSET
 #define ARCH_PFN_OFFSET		(0UL)
 #endif
 
-#elif defined(CONFIG_DISCONTIGMEM)
-
-#ifndef arch_pfn_to_nid
-#define arch_pfn_to_nid(pfn)	pfn_to_nid(pfn)
-#endif
-
-#ifndef arch_local_page_offset
-#define arch_local_page_offset(pfn, nid)	\
-	((pfn) - NODE_DATA(nid)->node_start_pfn)
-#endif
-
-#endif /* CONFIG_DISCONTIGMEM */
-
-/*
- * supports 3 memory models.
- */
-#if defined(CONFIG_FLATMEM)
-
 #define __pfn_to_page(pfn)	(mem_map + ((pfn) - ARCH_PFN_OFFSET))
 #define __page_to_pfn(page)	((unsigned long)((page) - mem_map) + \
 				 ARCH_PFN_OFFSET)
-#elif defined(CONFIG_DISCONTIGMEM)
-
-#define __pfn_to_page(pfn)			\
-({	unsigned long __pfn = (pfn);		\
-	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
-	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
-})
-
-#define __page_to_pfn(pg)						\
-({	const struct page *__pg = (pg);					\
-	struct pglist_data *__pgdat = NODE_DATA(page_to_nid(__pg));	\
-	(unsigned long)(__pg - __pgdat->node_mem_map) +			\
-	 __pgdat->node_start_pfn;					\
-})
 
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
@@ -70,7 +41,7 @@
 	struct mem_section *__sec = __pfn_to_section(__pfn);	\
 	__section_mem_map_addr(__sec) + __pfn;		\
 })
-#endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
+#endif /* CONFIG_FLATMEM/SPARSEMEM */
 
 /*
  * Convert a physical address to a Page Frame Number and back
--- a/include/linux/mmzone.h~mm-remove-config_discontigmem
+++ a/include/linux/mmzone.h
@@ -749,10 +749,12 @@ struct zonelist {
 	struct zoneref _zonerefs[MAX_ZONES_PER_ZONELIST + 1];
 };
 
-#ifndef CONFIG_DISCONTIGMEM
-/* The array of struct pages - for discontigmem use pgdat->lmem_map */
+/*
+ * The array of struct pages for flatmem.
+ * It must be declared for SPARSEMEM as well because there are configurations
+ * that rely on that.
+ */
 extern struct page *mem_map;
-#endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 struct deferred_split {
--- a/mm/Kconfig~mm-remove-config_discontigmem
+++ a/mm/Kconfig
@@ -19,7 +19,7 @@ choice
 
 config FLATMEM_MANUAL
 	bool "Flat Memory"
-	depends on !(ARCH_DISCONTIGMEM_ENABLE || ARCH_SPARSEMEM_ENABLE) || ARCH_FLATMEM_ENABLE
+	depends on !ARCH_SPARSEMEM_ENABLE || ARCH_FLATMEM_ENABLE
 	help
 	  This option is best suited for non-NUMA systems with
 	  flat address space. The FLATMEM is the most efficient
@@ -32,21 +32,6 @@ config FLATMEM_MANUAL
 
 	  If unsure, choose this option (Flat Memory) over any other.
 
-config DISCONTIGMEM_MANUAL
-	bool "Discontiguous Memory"
-	depends on ARCH_DISCONTIGMEM_ENABLE
-	help
-	  This option provides enhanced support for discontiguous
-	  memory systems, over FLATMEM.  These systems have holes
-	  in their physical address spaces, and this option provides
-	  more efficient handling of these holes.
-
-	  Although "Discontiguous Memory" is still used by several
-	  architectures, it is considered deprecated in favor of
-	  "Sparse Memory".
-
-	  If unsure, choose "Sparse Memory" over this option.
-
 config SPARSEMEM_MANUAL
 	bool "Sparse Memory"
 	depends on ARCH_SPARSEMEM_ENABLE
@@ -62,17 +47,13 @@ config SPARSEMEM_MANUAL
 
 endchoice
 
-config DISCONTIGMEM
-	def_bool y
-	depends on (!SELECT_MEMORY_MODEL && ARCH_DISCONTIGMEM_ENABLE) || DISCONTIGMEM_MANUAL
-
 config SPARSEMEM
 	def_bool y
 	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
 
 config FLATMEM
 	def_bool y
-	depends on (!DISCONTIGMEM && !SPARSEMEM) || FLATMEM_MANUAL
+	depends on !SPARSEMEM || FLATMEM_MANUAL
 
 config FLAT_NODE_MEM_MAP
 	def_bool y
@@ -85,7 +66,7 @@ config FLAT_NODE_MEM_MAP
 #
 config NEED_MULTIPLE_NODES
 	def_bool y
-	depends on DISCONTIGMEM || NUMA
+	depends on NUMA
 
 #
 # SPARSEMEM_EXTREME (which is the default) does some bootmem
--- a/mm/page_alloc.c~mm-remove-config_discontigmem
+++ a/mm/page_alloc.c
@@ -349,20 +349,7 @@ compound_page_dtor * const compound_page
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
-#ifdef CONFIG_DISCONTIGMEM
-/*
- * DiscontigMem defines memory ranges as separate pg_data_t even if the ranges
- * are not on separate NUMA nodes. Functionally this works but with
- * watermark_boost_factor, it can reclaim prematurely as the ranges can be
- * quite small. By default, do not boost watermarks on discontigmem as in
- * many cases very high-order allocations like THP are likely to be
- * unsupported and the premature reclaim offsets the advantage of long-term
- * fragmentation avoidance.
- */
-int watermark_boost_factor __read_mostly;
-#else
 int watermark_boost_factor __read_mostly = 15000;
-#endif
 int watermark_scale_factor = 10;
 
 static unsigned long nr_kernel_pages __initdata;
_
