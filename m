Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5816EC49EC8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3122122CAE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgLOX7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgLOXWy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:54 -0500
Date:   Tue, 15 Dec 2020 15:20:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074439;
        bh=fsaFFDkciD8U4C0ereX4YR+81oq1xBBKMv9D+syk2rM=;
        h=From:To:Subject:From;
        b=psvG6jnKqipaB1U7CbLSGaNB3apS8OACfaYx89ER4dU1Rq0O8Xe9+Whqawh8KtYn7
         lLzSgFZyHYZt8oW0fTqb9/JYgrOrC+rh/Typo7lV/gpGHjhEBTk4wq1rW6c9KRmWcm
         RGkCbflBXOyWr0wDhc5QXKOUYkEU100ZXfvK91qY=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged] ia64-remove-custom-__early_pfn_to_nid.patch
 removed from -mm tree
Message-ID: <20201215232038.1nOK1zZPX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove custom __early_pfn_to_nid()
has been removed from the -mm tree.  Its filename was
     ia64-remove-custom-__early_pfn_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ia64: remove custom __early_pfn_to_nid()

The ia64 implementation of __early_pfn_to_nid() essentially relies on the
same data as the generic implementation.

The correspondence between memory ranges and nodes is set in memblock
during early memory initialization in register_active_ranges() function.

The initialization of sparsemem that requires early_pfn_to_nid() happens
later and it can use the memblock information like the other architectures.

Link: https://lkml.kernel.org/r/20201101170454.9567-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig      |    3 ---
 arch/ia64/mm/numa.c    |   30 ------------------------------
 include/linux/mm.h     |    3 ---
 include/linux/mmzone.h |   11 -----------
 mm/page_alloc.c        |   16 ++++++++++++----
 5 files changed, 12 insertions(+), 51 deletions(-)

--- a/arch/ia64/Kconfig~ia64-remove-custom-__early_pfn_to_nid
+++ a/arch/ia64/Kconfig
@@ -342,9 +342,6 @@ config HOLES_IN_ZONE
 	bool
 	default y if VIRTUAL_MEM_MAP
 
-config HAVE_ARCH_EARLY_PFN_TO_NID
-	def_bool NUMA && SPARSEMEM
-
 config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
--- a/arch/ia64/mm/numa.c~ia64-remove-custom-__early_pfn_to_nid
+++ a/arch/ia64/mm/numa.c
@@ -58,36 +58,6 @@ paddr_to_nid(unsigned long paddr)
 EXPORT_SYMBOL(paddr_to_nid);
 
 #if defined(CONFIG_SPARSEMEM) && defined(CONFIG_NUMA)
-/*
- * Because of holes evaluate on section limits.
- * If the section of memory exists, then return the node where the section
- * resides.  Otherwise return node 0 as the default.  This is used by
- * SPARSEMEM to allocate the SPARSEMEM sectionmap on the NUMA node where
- * the section resides.
- */
-int __meminit __early_pfn_to_nid(unsigned long pfn,
-					struct mminit_pfnnid_cache *state)
-{
-	int i, section = pfn >> PFN_SECTION_SHIFT, ssec, esec;
-
-	if (section >= state->last_start && section < state->last_end)
-		return state->last_nid;
-
-	for (i = 0; i < num_node_memblks; i++) {
-		ssec = node_memblk[i].start_paddr >> PA_SECTION_SHIFT;
-		esec = (node_memblk[i].start_paddr + node_memblk[i].size +
-			((1L << PA_SECTION_SHIFT) - 1)) >> PA_SECTION_SHIFT;
-		if (section >= ssec && section < esec) {
-			state->last_start = ssec;
-			state->last_end = esec;
-			state->last_nid = node_memblk[i].nid;
-			return node_memblk[i].nid;
-		}
-	}
-
-	return -1;
-}
-
 void numa_clear_node(int cpu)
 {
 	unmap_cpu_from_node(cpu, NUMA_NO_NODE);
--- a/include/linux/mm.h~ia64-remove-custom-__early_pfn_to_nid
+++ a/include/linux/mm.h
@@ -2434,9 +2434,6 @@ static inline int early_pfn_to_nid(unsig
 #else
 /* please see mm/page_alloc.c */
 extern int __meminit early_pfn_to_nid(unsigned long pfn);
-/* there is a per-arch backend function. */
-extern int __meminit __early_pfn_to_nid(unsigned long pfn,
-					struct mminit_pfnnid_cache *state);
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
--- a/include/linux/mmzone.h~ia64-remove-custom-__early_pfn_to_nid
+++ a/include/linux/mmzone.h
@@ -1429,17 +1429,6 @@ void sparse_init(void);
 #endif /* CONFIG_SPARSEMEM */
 
 /*
- * During memory init memblocks map pfns to nids. The search is expensive and
- * this caches recent lookups. The implementation of __early_pfn_to_nid
- * may treat start/end as pfns or sections.
- */
-struct mminit_pfnnid_cache {
-	unsigned long last_start;
-	unsigned long last_end;
-	int last_nid;
-};
-
-/*
  * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
  * need to check pfn validity within that MAX_ORDER_NR_PAGES block.
  * pfn_valid_within() should be used in this case; we optimise this away
--- a/mm/page_alloc.c~ia64-remove-custom-__early_pfn_to_nid
+++ a/mm/page_alloc.c
@@ -1559,14 +1559,23 @@ void __free_pages_core(struct page *page
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 
-static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
+/*
+ * During memory init memblocks map pfns to nids. The search is expensive and
+ * this caches recent lookups. The implementation of __early_pfn_to_nid
+ * treats start/end as pfns.
+ */
+struct mminit_pfnnid_cache {
+	unsigned long last_start;
+	unsigned long last_end;
+	int last_nid;
+};
 
-#ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
+static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
 
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
  */
-int __meminit __early_pfn_to_nid(unsigned long pfn,
+static int __meminit __early_pfn_to_nid(unsigned long pfn,
 					struct mminit_pfnnid_cache *state)
 {
 	unsigned long start_pfn, end_pfn;
@@ -1584,7 +1593,6 @@ int __meminit __early_pfn_to_nid(unsigne
 
 	return nid;
 }
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

