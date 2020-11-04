Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E393C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217B2223FD
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459465;
	bh=AV3ZnN40TfgaHPVHbfUt42HgSNK24ej2mmQ85KHAGm8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HP+GsrJhwzwMW8adcjPC9CaBfb40zkIxL94qIdFCK3LBUqBOc8mEb1lfqkt9PV+Es
	 +wVV1UBYAz/jICZ4o+Ib9z2r95MtSctqiU7XFXPJelH9Bq2s6UrKrQUfzQIJJXPhrT
	 4+6A/85dcO6TPzpf/sC7XVnRZOhmApvHH2iEx230=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbgKDDLE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:03 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37986223FB;
        Wed,  4 Nov 2020 03:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459462;
        bh=AV3ZnN40TfgaHPVHbfUt42HgSNK24ej2mmQ85KHAGm8=;
        h=Date:From:To:Subject:From;
        b=djYCp0xHffla20TVFmz6T1wz28UqVeMQ2TdbK1XKZMuKPuQ5mtujXA8/HJSolDluO
         rkoC/mA/TvqlNttXstcO7RlTTQV1vUJ3kAPwqCc9DBWQYWVRZeCjuuqWngF3HpSbm/
         VmAWk/MIGTCpV+xyE63Bnvvo8kfkMQWs7M6lEQcQ=
Date:   Tue, 03 Nov 2020 19:11:00 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  + ia64-remove-custom-__early_pfn_to_nid.patch added to -mm
 tree
Message-ID: <20201104031100.e-Sjp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove custom __early_pfn_to_nid()
has been added to the -mm tree.  Its filename is
     ia64-remove-custom-__early_pfn_to_nid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-remove-custom-__early_pfn_to_nid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-remove-custom-__early_pfn_to_nid.patch

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
@@ -2412,9 +2412,6 @@ static inline int early_pfn_to_nid(unsig
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
@@ -1557,14 +1557,23 @@ void __free_pages_core(struct page *page
 
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
@@ -1582,7 +1591,6 @@ int __meminit __early_pfn_to_nid(unsigne
 
 	return nid;
 }
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch

