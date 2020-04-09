From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch added to
 -mm tree
Date: Wed, 08 Apr 2020 18:00:08 -0700
Message-ID: <20200409010008.7Jn95V08o%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgDIBAL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 21:00:11 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: optionally allocate gigantic hugepages using cma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: hugetlb: optionally allocate gigantic hugepages using cma

Commit 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at
runtime") has added the run-time allocation of gigantic pages.  However it
actually works only at early stages of the system loading, when the
majority of memory is free.  After some time the memory gets fragmented by
non-movable pages, so the chances to find a contiguous 1 GB block are
getting close to zero.  Even dropping caches manually doesn't help a lot.

At large scale rebooting servers in order to allocate gigantic hugepages
is quite expensive and complex.  At the same time keeping some constant
percentage of memory in reserved hugepages even if the workload isn't
using it is a big waste: not all workloads can benefit from using 1 GB
pages.

The following solution can solve the problem:
1) On boot time a dedicated cma area* is reserved. The size is passed
   as a kernel argument.
2) Run-time allocations of gigantic hugepages are performed using the
   cma allocator and the dedicated cma area

In this case gigantic hugepages can be allocated successfully with a high
probability, however the memory isn't completely wasted if nobody is using
1GB hugepages: it can be used for pagecache, anon memory, THPs, etc.

* On a multi-node machine a per-node cma area is allocated on each node.
  Following gigantic hugetlb allocation are using the first available
  numa node if the mask isn't specified by a user.

Usage:
1) configure the kernel to allocate a cma area for hugetlb allocations:
   pass hugetlb_cma=10G as a kernel argument

2) allocate hugetlb pages as usual, e.g.
   echo 10 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

If the option isn't enabled or the allocation of the cma area failed,
the current behavior of the system is preserved.

x86 and arm-64 are covered by this patch, other architectures can be
trivially added later.

The patch contains clean-ups and fixes proposed and implemented by Aslan
Bakirov and Randy Dunlap.  It also contains ideas and suggestions proposed
by Rik van Riel, Michal Hocko and Mike Kravetz.  Thanks!

Link: http://lkml.kernel.org/r/20200407163840.92263-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Tested-by: Andreas Schaufler <andreas.schaufler@gmx.de>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@kernel.org>
Cc: Aslan Bakirov <aslan@fb.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 +
 arch/arm64/mm/init.c                            |    6 
 arch/x86/kernel/setup.c                         |    4 
 include/linux/hugetlb.h                         |   12 +
 mm/hugetlb.c                                    |  109 ++++++++++++++
 5 files changed, 139 insertions(+)

--- a/arch/arm64/mm/init.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma
+++ a/arch/arm64/mm/init.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
+#include <linux/hugetlb.h>
 
 #include <asm/boot.h>
 #include <asm/fixmap.h>
@@ -457,6 +458,11 @@ void __init arm64_memblock_init(void)
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 
 	dma_contiguous_reserve(arm64_dma32_phys_limit);
+
+#ifdef CONFIG_ARM64_4K_PAGES
+	hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+#endif
+
 }
 
 void __init bootmem_init(void)
--- a/arch/x86/kernel/setup.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma
+++ a/arch/x86/kernel/setup.c
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/root_dev.h>
 #include <linux/sfi.h>
+#include <linux/hugetlb.h>
 #include <linux/tboot.h>
 #include <linux/usb/xhci-dbgp.h>
 
@@ -1157,6 +1158,9 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
+	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
 	 * won't consume hotpluggable memory.
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1475,6 +1475,14 @@
 	hpet_mmap=	[X86, HPET_MMAP] Allow userspace to mmap HPET
 			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
 
+	hugetlb_cma=	[HW] The size of a cma area used for allocation
+			of gigantic hugepages.
+			Format: nn[KMGTPE]
+
+			Reserve a cma area of given size and allocate gigantic
+			hugepages using the cma allocator. If enabled, the
+			boot-time allocation of gigantic hugepages is skipped.
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
--- a/include/linux/hugetlb.h~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma
+++ a/include/linux/hugetlb.h
@@ -895,4 +895,16 @@ static inline spinlock_t *huge_pte_lock(
 	return ptl;
 }
 
+#if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
+extern void __init hugetlb_cma_reserve(int order);
+extern void __init hugetlb_cma_check(void);
+#else
+static inline __init void hugetlb_cma_reserve(int order)
+{
+}
+static inline __init void hugetlb_cma_check(void)
+{
+}
+#endif
+
 #endif /* _LINUX_HUGETLB_H */
--- a/mm/hugetlb.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma
+++ a/mm/hugetlb.c
@@ -28,6 +28,7 @@
 #include <linux/jhash.h>
 #include <linux/numa.h>
 #include <linux/llist.h>
+#include <linux/cma.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -44,6 +45,9 @@
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
+
+static struct cma *hugetlb_cma[MAX_NUMNODES];
+
 /*
  * Minimum page order among possible hugepage sizes, set to a proper value
  * at boot time.
@@ -1228,6 +1232,14 @@ static void destroy_compound_gigantic_pa
 
 static void free_gigantic_page(struct page *page, unsigned int order)
 {
+	/*
+	 * If the page isn't allocated using the cma allocator,
+	 * cma_release() returns false.
+	 */
+	if (IS_ENABLED(CONFIG_CMA) &&
+	    cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
+		return;
+
 	free_contig_range(page_to_pfn(page), 1 << order);
 }
 
@@ -1237,6 +1249,21 @@ static struct page *alloc_gigantic_page(
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
 
+	if (IS_ENABLED(CONFIG_CMA)) {
+		struct page *page;
+		int node;
+
+		for_each_node_mask(node, *nodemask) {
+			if (!hugetlb_cma[node])
+				continue;
+
+			page = cma_alloc(hugetlb_cma[node], nr_pages,
+					 huge_page_order(h), true);
+			if (page)
+				return page;
+		}
+	}
+
 	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
 }
 
@@ -1281,8 +1308,14 @@ static void update_and_free_page(struct
 	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
+		/*
+		 * Temporarily drop the hugetlb_lock, because
+		 * we might block in free_gigantic_page().
+		 */
+		spin_unlock(&hugetlb_lock);
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
+		spin_lock(&hugetlb_lock);
 	} else {
 		__free_pages(page, huge_page_order(h));
 	}
@@ -2539,6 +2572,10 @@ static void __init hugetlb_hstate_alloc_
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (hstate_is_gigantic(h)) {
+			if (IS_ENABLED(CONFIG_CMA) && hugetlb_cma[0]) {
+				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
+				break;
+			}
 			if (!alloc_bootmem_huge_page(h))
 				break;
 		} else if (!alloc_pool_huge_page(h,
@@ -3194,6 +3231,7 @@ static int __init hugetlb_init(void)
 			default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 	}
 
+	hugetlb_cma_check();
 	hugetlb_init_hstates();
 	gather_bootmem_prealloc();
 	report_hugepages();
@@ -5506,3 +5544,74 @@ void move_hugetlb_state(struct page *old
 		spin_unlock(&hugetlb_lock);
 	}
 }
+
+#ifdef CONFIG_CMA
+static unsigned long hugetlb_cma_size __initdata;
+static bool cma_reserve_called __initdata;
+
+static int __init cmdline_parse_hugetlb_cma(char *p)
+{
+	hugetlb_cma_size = memparse(p, &p);
+	return 0;
+}
+
+early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
+
+void __init hugetlb_cma_reserve(int order)
+{
+	unsigned long size, reserved, per_node;
+	int nid;
+
+	cma_reserve_called = true;
+
+	if (!hugetlb_cma_size)
+		return;
+
+	if (hugetlb_cma_size < (PAGE_SIZE << order)) {
+		pr_warn("hugetlb_cma: cma area should be at least %lu MiB\n",
+			(PAGE_SIZE << order) / SZ_1M);
+		return;
+	}
+
+	/*
+	 * If 3 GB area is requested on a machine with 4 numa nodes,
+	 * let's allocate 1 GB on first three nodes and ignore the last one.
+	 */
+	per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+	pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
+		hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+
+	reserved = 0;
+	for_each_node_state(nid, N_ONLINE) {
+		int res;
+
+		size = min(per_node, hugetlb_cma_size - reserved);
+		size = round_up(size, PAGE_SIZE << order);
+
+		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
+						 0, false, "hugetlb",
+						 &hugetlb_cma[nid], nid);
+		if (res) {
+			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+				res, nid);
+			continue;
+		}
+
+		reserved += size;
+		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
+			size / SZ_1M, nid);
+
+		if (reserved >= hugetlb_cma_size)
+			break;
+	}
+}
+
+void __init hugetlb_cma_check(void)
+{
+	if (!hugetlb_cma_size || cma_reserve_called)
+		return;
+
+	pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
+}
+
+#endif /* CONFIG_CMA */
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
