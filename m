Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C99C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjEPWXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjEPWXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A7C59E0
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A104C63FF3
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C86C433D2;
        Tue, 16 May 2023 22:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275778;
        bh=2z+FguzrcNFeZVglRXRdXp7qm9a7Tx6EcaviZ3Yij1M=;
        h=Date:To:From:Subject:From;
        b=sDceE5E++D4wb+uGPF62qjVD6Mi90shFT2Igh9qSyNi9XEZ0/d5oDnZVX3OHcV82K
         NFqlBCeUIynz8nfdHzeBdWP4c2OfeBorBde2eurAm+/Ip9lVYSC3M2hFDHc4ROsOTG
         +sWeqwgoMxdhGU+2vW62EsuxfzhE5uVN+QjIZUlU=
Date:   Tue, 16 May 2023 15:22:57 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-sysctls-into-it-own-fils.patch added to mm-unstable branch
Message-Id: <20230516222258.04C86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move sysctls into it own fils
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-sysctls-into-it-own-fils.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-sysctls-into-it-own-fils.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move sysctls into it own fils
Date: Tue, 16 May 2023 14:38:20 +0800

This moves all page alloc related sysctls to its own file, as part of the
kernel/sysctl.c spring cleaning, also move some functions declarations
from mm.h into internal.h.

Link: https://lkml.kernel.org/r/20230516063821.121844-13-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |   11 ----
 include/linux/mmzone.h |   21 -------
 kernel/sysctl.c        |   67 -------------------------
 mm/internal.h          |   11 ++++
 mm/mm_init.c           |    2 
 mm/page_alloc.c        |  103 +++++++++++++++++++++++++++++++++------
 6 files changed, 102 insertions(+), 113 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/include/linux/mm.h
@@ -3034,12 +3034,6 @@ extern int __meminit early_pfn_to_nid(un
 #endif
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
-extern void memmap_init_range(unsigned long, int, unsigned long,
-		unsigned long, unsigned long, enum meminit_context,
-		struct vmem_altmap *, int migratetype);
-extern void setup_per_zone_wmarks(void);
-extern void calculate_min_free_kbytes(void);
-extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
@@ -3060,11 +3054,6 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 
 extern void setup_per_cpu_pageset(void);
 
-/* page_alloc.c */
-extern int min_free_kbytes;
-extern int watermark_boost_factor;
-extern int watermark_scale_factor;
-
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
--- a/include/linux/mmzone.h~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/include/linux/mmzone.h
@@ -1512,27 +1512,6 @@ static inline bool has_managed_dma(void)
 }
 #endif
 
-/* These two functions are used to setup the per zone pages min values */
-struct ctl_table;
-
-int min_free_kbytes_sysctl_handler(struct ctl_table *, int, void *, size_t *,
-		loff_t *);
-int watermark_scale_factor_sysctl_handler(struct ctl_table *, int, void *,
-		size_t *, loff_t *);
-extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
-int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int, void *,
-		size_t *, loff_t *);
-int percpu_pagelist_high_fraction_sysctl_handler(struct ctl_table *, int,
-		void *, size_t *, loff_t *);
-int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
-		void *, size_t *, loff_t *);
-int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *, int,
-		void *, size_t *, loff_t *);
-int numa_zonelist_order_handler(struct ctl_table *, int,
-		void *, size_t *, loff_t *);
-extern int percpu_pagelist_high_fraction;
-extern char numa_zonelist_order[];
-#define NUMA_ZONELIST_ORDER_LEN	16
 
 #ifndef CONFIG_NUMA
 
--- a/kernel/sysctl.c~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/kernel/sysctl.c
@@ -2120,13 +2120,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 	{
-		.procname	= "lowmem_reserve_ratio",
-		.data		= &sysctl_lowmem_reserve_ratio,
-		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
-		.mode		= 0644,
-		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
-	},
-	{
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
@@ -2136,39 +2129,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= SYSCTL_FOUR,
 	},
 	{
-		.procname	= "min_free_kbytes",
-		.data		= &min_free_kbytes,
-		.maxlen		= sizeof(min_free_kbytes),
-		.mode		= 0644,
-		.proc_handler	= min_free_kbytes_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "watermark_boost_factor",
-		.data		= &watermark_boost_factor,
-		.maxlen		= sizeof(watermark_boost_factor),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
-		.procname	= "watermark_scale_factor",
-		.data		= &watermark_scale_factor,
-		.maxlen		= sizeof(watermark_scale_factor),
-		.mode		= 0644,
-		.proc_handler	= watermark_scale_factor_sysctl_handler,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_THREE_THOUSAND,
-	},
-	{
-		.procname	= "percpu_pagelist_high_fraction",
-		.data		= &percpu_pagelist_high_fraction,
-		.maxlen		= sizeof(percpu_pagelist_high_fraction),
-		.mode		= 0644,
-		.proc_handler	= percpu_pagelist_high_fraction_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
 		.procname	= "page_lock_unfairness",
 		.data		= &sysctl_page_lock_unfairness,
 		.maxlen		= sizeof(sysctl_page_lock_unfairness),
@@ -2223,24 +2183,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
-	{
-		.procname	= "min_unmapped_ratio",
-		.data		= &sysctl_min_unmapped_ratio,
-		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
-	{
-		.procname	= "min_slab_ratio",
-		.data		= &sysctl_min_slab_ratio,
-		.maxlen		= sizeof(sysctl_min_slab_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
 #endif
 #ifdef CONFIG_SMP
 	{
@@ -2267,15 +2209,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= mmap_min_addr_handler,
 	},
 #endif
-#ifdef CONFIG_NUMA
-	{
-		.procname	= "numa_zonelist_order",
-		.data		= &numa_zonelist_order,
-		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
-		.mode		= 0644,
-		.proc_handler	= numa_zonelist_order_handler,
-	},
-#endif
 #if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
--- a/mm/internal.h~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/mm/internal.h
@@ -213,6 +213,13 @@ static inline bool is_check_pages_enable
 	return static_branch_unlikely(&check_pages_enabled);
 }
 
+extern int min_free_kbytes;
+
+void setup_per_zone_wmarks(void);
+void calculate_min_free_kbytes(void);
+int __meminit init_per_zone_wmark_min(void);
+void page_alloc_sysctl_init(void);
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
@@ -423,6 +430,10 @@ extern void *memmap_alloc(phys_addr_t si
 			  phys_addr_t min_addr,
 			  int nid, bool exact_nid);
 
+void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
+		unsigned long, enum meminit_context, struct vmem_altmap *, int);
+
+
 int split_free_page(struct page *free_page,
 			unsigned int order, unsigned long split_pfn_offset);
 
--- a/mm/mm_init.c~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/mm/mm_init.c
@@ -2392,6 +2392,8 @@ void __init page_alloc_init_late(void)
 	/* Initialize page ext after all struct pages are initialized. */
 	if (deferred_struct_pages)
 		page_ext_init();
+
+	page_alloc_sysctl_init();
 }
 
 #ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
--- a/mm/page_alloc.c~mm-page_alloc-move-sysctls-into-it-own-fils
+++ a/mm/page_alloc.c
@@ -206,7 +206,6 @@ nodemask_t node_states[NR_NODE_STATES] _
 };
 EXPORT_SYMBOL(node_states);
 
-int percpu_pagelist_high_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 /*
@@ -302,8 +301,8 @@ compound_page_dtor * const compound_page
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
-int watermark_boost_factor __read_mostly = 15000;
-int watermark_scale_factor = 10;
+static int watermark_boost_factor __read_mostly = 15000;
+static int watermark_scale_factor = 10;
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4917,12 +4916,12 @@ static int __parse_numa_zonelist_order(c
 	return 0;
 }
 
-char numa_zonelist_order[] = "Node";
-
+static char numa_zonelist_order[] = "Node";
+#define NUMA_ZONELIST_ORDER_LEN	16
 /*
  * sysctl handler for numa_zonelist_order
  */
-int numa_zonelist_order_handler(struct ctl_table *table, int write,
+static int numa_zonelist_order_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	if (write)
@@ -4930,7 +4929,6 @@ int numa_zonelist_order_handler(struct c
 	return proc_dostring(table, write, buffer, length, ppos);
 }
 
-
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -5333,6 +5331,7 @@ static int zone_batchsize(struct zone *z
 #endif
 }
 
+static int percpu_pagelist_high_fraction;
 static int zone_highsize(struct zone *zone, int batch, int cpu_online)
 {
 #ifdef CONFIG_MMU
@@ -5862,7 +5861,7 @@ postcore_initcall(init_per_zone_wmark_mi
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
+static int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5878,7 +5877,7 @@ int min_free_kbytes_sysctl_handler(struc
 	return 0;
 }
 
-int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
+static int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5908,7 +5907,7 @@ static void setup_min_unmapped_ratio(voi
 }
 
 
-int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
+static int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5935,7 +5934,7 @@ static void setup_min_slab_ratio(void)
 						     sysctl_min_slab_ratio) / 100;
 }
 
-int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
+static int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	int rc;
@@ -5959,8 +5958,8 @@ int sysctl_min_slab_ratio_sysctl_handler
  * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
-int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
+static int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *table,
+		int write, void *buffer, size_t *length, loff_t *ppos)
 {
 	int i;
 
@@ -5980,7 +5979,7 @@ int lowmem_reserve_ratio_sysctl_handler(
  * cpu. It is the fraction of total pages in each zone that a hot per cpu
  * pagelist can have before it gets flushed back to buddy allocator.
  */
-int percpu_pagelist_high_fraction_sysctl_handler(struct ctl_table *table,
+static int percpu_pagelist_high_fraction_sysctl_handler(struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
 	struct zone *zone;
@@ -6013,6 +6012,82 @@ out:
 	return ret;
 }
 
+static struct ctl_table page_alloc_sysctl_table[] = {
+	{
+		.procname	= "min_free_kbytes",
+		.data		= &min_free_kbytes,
+		.maxlen		= sizeof(min_free_kbytes),
+		.mode		= 0644,
+		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "watermark_boost_factor",
+		.data		= &watermark_boost_factor,
+		.maxlen		= sizeof(watermark_boost_factor),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "watermark_scale_factor",
+		.data		= &watermark_scale_factor,
+		.maxlen		= sizeof(watermark_scale_factor),
+		.mode		= 0644,
+		.proc_handler	= watermark_scale_factor_sysctl_handler,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_THREE_THOUSAND,
+	},
+	{
+		.procname	= "percpu_pagelist_high_fraction",
+		.data		= &percpu_pagelist_high_fraction,
+		.maxlen		= sizeof(percpu_pagelist_high_fraction),
+		.mode		= 0644,
+		.proc_handler	= percpu_pagelist_high_fraction_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "lowmem_reserve_ratio",
+		.data		= &sysctl_lowmem_reserve_ratio,
+		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
+		.mode		= 0644,
+		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+	},
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "numa_zonelist_order",
+		.data		= &numa_zonelist_order,
+		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
+		.mode		= 0644,
+		.proc_handler	= numa_zonelist_order_handler,
+	},
+	{
+		.procname	= "min_unmapped_ratio",
+		.data		= &sysctl_min_unmapped_ratio,
+		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
+		.mode		= 0644,
+		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname	= "min_slab_ratio",
+		.data		= &sysctl_min_slab_ratio,
+		.maxlen		= sizeof(sysctl_min_slab_ratio),
+		.mode		= 0644,
+		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+#endif
+	{}
+};
+
+void __init page_alloc_sysctl_init(void)
+{
+	register_sysctl_init("vm", page_alloc_sysctl_table);
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

