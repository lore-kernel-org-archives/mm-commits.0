Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4167C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiEJERq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiEJEQa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2223E28D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8540B81AFB
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A069C385C2;
        Tue, 10 May 2022 04:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155927;
        bh=K2PTTnBjlPGLlIrn5Y8lYTVj/QNTVBCsNsyeUt/J2N8=;
        h=Date:To:From:Subject:From;
        b=Fw0SFYc43Dl6vtMu88NvTDm1awhVT8bpC0KXDAs26SnVDDhdq6OrQr6+ClKqJ5IRR
         cXPMlr6yZ2sGFpd6PJQj6IWT3Epp1GBnc5nY14GvQL4/ycQHK/p/+ykDOu/6yeyaF1
         Rj21GHx/YPnyuMC4tXN8KKlc3xNw2g8MnHCP2+Q0=
Date:   Mon, 09 May 2022 21:12:07 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch removed from -mm tree
Message-Id: <20220510041207.9A069C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: cleanup CONFIG_HUGETLB_PAGE_FREE_VMEMMAP*
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: cleanup CONFIG_HUGETLB_PAGE_FREE_VMEMMAP*

The word of "free" is not expressive enough to express the feature of
optimizing vmemmap pages associated with each HugeTLB, rename this keywork
to "optimize".  In this patch , cheanup configs to make code more
expressive.

Link: https://lkml.kernel.org/r/20220404074652.68024-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 +--
 Documentation/admin-guide/mm/hugetlbpage.rst    |    2 -
 arch/arm64/Kconfig                              |    2 -
 arch/arm64/mm/flush.c                           |    2 -
 arch/x86/Kconfig                                |    2 -
 arch/x86/mm/init_64.c                           |    2 -
 fs/Kconfig                                      |   16 +++++++-------
 include/linux/hugetlb.h                         |    2 -
 include/linux/mm.h                              |    2 -
 include/linux/page-flags.h                      |    6 ++---
 mm/Makefile                                     |    2 -
 mm/hugetlb_vmemmap.c                            |    4 +--
 mm/hugetlb_vmemmap.h                            |    4 +--
 mm/sparse-vmemmap.c                             |    4 +--
 14 files changed, 27 insertions(+), 27 deletions(-)

--- a/arch/arm64/Kconfig~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/arch/arm64/Kconfig
@@ -97,7 +97,7 @@ config ARM64
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
-	select ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
+	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
--- a/arch/arm64/mm/flush.c~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/arch/arm64/mm/flush.c
@@ -78,7 +78,7 @@ void flush_dcache_page(struct page *page
 	/*
 	 * Only the head page's flags of HugeTLB can be cleared since the tail
 	 * vmemmap pages associated with each HugeTLB page are mapped with
-	 * read-only when CONFIG_HUGETLB_PAGE_FREE_VMEMMAP is enabled (more
+	 * read-only when CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is enabled (more
 	 * details can refer to vmemmap_remap_pte()).  Although
 	 * __sync_icache_dcache() only set PG_dcache_clean flag on the head
 	 * page struct, there is more than one page struct with PG_dcache_clean
--- a/arch/x86/Kconfig~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/arch/x86/Kconfig
@@ -121,7 +121,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
-	select ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP	if X86_64
+	select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP	if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
--- a/arch/x86/mm/init_64.c~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -1269,7 +1269,7 @@ static struct kcore_list kcore_vsyscall;
 
 static void __init register_page_bootmem_info(void)
 {
-#if defined(CONFIG_NUMA) || defined(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP)
+#if defined(CONFIG_NUMA) || defined(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)
 	int i;
 
 	for_each_online_node(i)
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1660,7 +1660,7 @@
 			Format: size[KMG]
 
 	hugetlb_free_vmemmap=
-			[KNL] Reguires CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+			[KNL] Reguires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (7 * PAGE_SIZE for each 2MB hugetlb page).
@@ -1669,7 +1669,7 @@
 			on:  enable the feature
 			off: disable the feature
 
-			Built with CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON=y,
+			Built with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y,
 			the default is on.
 
 			This is not compatible with memory_hotplug.memmap_on_memory.
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -164,7 +164,7 @@ default_hugepagesz
 	will all result in 256 2M huge pages being allocated.  Valid default
 	huge page size is architecture dependent.
 hugetlb_free_vmemmap
-	When CONFIG_HUGETLB_PAGE_FREE_VMEMMAP is set, this enables freeing
+	When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is set, this enables optimizing
 	unused vmemmap pages associated with each HugeTLB page.
 
 When multiple huge page sizes are supported, ``/proc/sys/vm/nr_hugepages``
--- a/fs/Kconfig~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/fs/Kconfig
@@ -250,22 +250,22 @@ config HUGETLB_PAGE
 # to enable the feature of minimizing overhead of struct page associated with
 # each HugeTLB page.
 #
-config ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
+config ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	bool
 
-config HUGETLB_PAGE_FREE_VMEMMAP
+config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
+	depends on ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
-config HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
-	bool "Default freeing vmemmap pages of HugeTLB to on"
+config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
+	bool "Default optimizing vmemmap pages of HugeTLB to on"
 	default n
-	depends on HUGETLB_PAGE_FREE_VMEMMAP
+	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  When using HUGETLB_PAGE_FREE_VMEMMAP, the freeing unused vmemmap
+	  When using HUGETLB_PAGE_OPTIMIZE_VMEMMAP, the optimizing unused vmemmap
 	  pages associated with each HugeTLB page is default off. Say Y here
-	  to enable freeing vmemmap pages of HugeTLB by default. It can then
+	  to enable optimizing vmemmap pages of HugeTLB by default. It can then
 	  be disabled on the command line via hugetlb_free_vmemmap=off.
 
 config MEMFD_CREATE
--- a/include/linux/hugetlb.h~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/include/linux/hugetlb.h
@@ -623,7 +623,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	unsigned int optimize_vmemmap_pages;
 #endif
 #ifdef CONFIG_CGROUP_HUGETLB
--- a/include/linux/mm.h~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/include/linux/mm.h
@@ -3145,7 +3145,7 @@ static inline void print_vma_addr(char *
 }
 #endif
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int vmemmap_remap_free(unsigned long start, unsigned long end,
 		       unsigned long reuse);
 int vmemmap_remap_alloc(unsigned long start, unsigned long end,
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/include/linux/page-flags.h
@@ -190,13 +190,13 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
-DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
 			 hugetlb_optimize_vmemmap_key);
 
 static __always_inline bool hugetlb_optimize_vmemmap_enabled(void)
 {
-	return static_branch_maybe(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+	return static_branch_maybe(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
 				   &hugetlb_optimize_vmemmap_key);
 }
 
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -188,7 +188,7 @@
 #define RESERVE_VMEMMAP_NR		1U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
-DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON,
+DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
 			hugetlb_optimize_vmemmap_key);
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
@@ -276,7 +276,7 @@ void __init hugetlb_vmemmap_init(struct
 
 	/*
 	 * There are only (RESERVE_VMEMMAP_SIZE / sizeof(struct page)) struct
-	 * page structs that can be used when CONFIG_HUGETLB_PAGE_FREE_VMEMMAP,
+	 * page structs that can be used when CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP,
 	 * so add a BUILD_BUG_ON to catch invalid usage of the tail struct page.
 	 */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/mm/hugetlb_vmemmap.h
@@ -10,7 +10,7 @@
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head);
 void hugetlb_vmemmap_free(struct hstate *h, struct page *head);
 void hugetlb_vmemmap_init(struct hstate *h);
@@ -41,5 +41,5 @@ static inline unsigned int hugetlb_optim
 {
 	return 0;
 }
-#endif /* CONFIG_HUGETLB_PAGE_FREE_VMEMMAP */
+#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
--- a/mm/Makefile~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/mm/Makefile
@@ -77,7 +77,7 @@ obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
-obj-$(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP)	+= hugetlb_vmemmap.o
+obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
--- a/mm/sparse-vmemmap.c~mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap
+++ a/mm/sparse-vmemmap.c
@@ -34,7 +34,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
-#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
  *
@@ -420,7 +420,7 @@ int vmemmap_remap_alloc(unsigned long st
 
 	return 0;
 }
-#endif /* CONFIG_HUGETLB_PAGE_FREE_VMEMMAP */
+#endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

