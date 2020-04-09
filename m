From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-v5.patch
 removed from -mm tree
Date: Wed, 08 Apr 2020 17:57:37 -0700
Message-ID: <20200409005737.7PuVA0imE%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgDIA5i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:57:38 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, riel@surriel.com


The patch titled
     Subject: mm: hugetlb: optionally allocate gigantic hugepages using cma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-v5.patch

This patch was dropped because it was folded into mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch

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

The patch contains clean-ups and fixes proposed and implemented by
Aslan Bakirov and Randy Dunlap. It also contains ideas and suggestions
proposed by Rik van Riel, Michal Hocko and Mike Kravetz. Thanks!

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

 Documentation/admin-guide/kernel-parameters.txt |    7 +
 include/linux/hugetlb.h                         |    4 +
 mm/hugetlb.c                                    |   54 ++++++--------
 3 files changed, 34 insertions(+), 31 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-v5
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1475,12 +1475,13 @@
 	hpet_mmap=	[X86, HPET_MMAP] Allow userspace to mmap HPET
 			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
 
-	hugetlb_cma=	[x86-64] The size of a cma area used for allocation
+	hugetlb_cma=	[HW] The size of a cma area used for allocation
 			of gigantic hugepages.
 			Format: nn[KMGTPE]
 
-			If enabled, boot-time allocation of gigantic hugepages
-			is skipped.
+			Reserve a cma area of given size and allocate gigantic
+			hugepages using the cma allocator. If enabled, the
+			boot-time allocation of gigantic hugepages is skipped.
 
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
--- a/include/linux/hugetlb.h~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-v5
+++ a/include/linux/hugetlb.h
@@ -897,10 +897,14 @@ static inline spinlock_t *huge_pte_lock(
 
 #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
 extern void __init hugetlb_cma_reserve(int order);
+extern void __init hugetlb_cma_check(void);
 #else
 static inline __init void hugetlb_cma_reserve(int order)
 {
 }
+static inline __init void hugetlb_cma_check(void)
+{
+}
 #endif
 
 #endif /* _LINUX_HUGETLB_H */
--- a/mm/hugetlb.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-v5
+++ a/mm/hugetlb.c
@@ -1255,7 +1255,7 @@ static struct page *alloc_gigantic_page(
 
 		for_each_node_mask(node, *nodemask) {
 			if (!hugetlb_cma[node])
-				break;
+				continue;
 
 			page = cma_alloc(hugetlb_cma[node], nr_pages,
 					 huge_page_order(h), true);
@@ -1308,8 +1308,14 @@ static void update_and_free_page(struct
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
@@ -3225,6 +3231,7 @@ static int __init hugetlb_init(void)
 			default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 	}
 
+	hugetlb_cma_check();
 	hugetlb_init_hstates();
 	gather_bootmem_prealloc();
 	report_hugepages();
@@ -5540,6 +5547,7 @@ void move_hugetlb_state(struct page *old
 
 #ifdef CONFIG_CMA
 static unsigned long hugetlb_cma_size __initdata;
+static bool cma_reserve_called __initdata;
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
 {
@@ -5554,6 +5562,8 @@ void __init hugetlb_cma_reserve(int orde
 	unsigned long size, reserved, per_node;
 	int nid;
 
+	cma_reserve_called = true;
+
 	if (!hugetlb_cma_size)
 		return;
 
@@ -5573,38 +5583,18 @@ void __init hugetlb_cma_reserve(int orde
 
 	reserved = 0;
 	for_each_node_state(nid, N_ONLINE) {
-		unsigned long start_pfn, end_pfn;
-		unsigned long min_pfn = 0, max_pfn = 0;
-		int res, i;
-
-		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
-			if (!min_pfn)
-				min_pfn = start_pfn;
-			max_pfn = end_pfn;
-		}
+		int res;
 
 		size = min(per_node, hugetlb_cma_size - reserved);
 		size = round_up(size, PAGE_SIZE << order);
 
-		if (size > ((max_pfn - min_pfn) << PAGE_SHIFT) / 2) {
-			pr_warn("hugetlb_cma: cma_area is too big, please try less than %lu MiB\n",
-				round_down(((max_pfn - min_pfn) << PAGE_SHIFT) *
-					   nr_online_nodes / 2 / SZ_1M,
-					   PAGE_SIZE << order));
-			break;
-		}
-
-		res = cma_declare_contiguous(PFN_PHYS(min_pfn), size,
-					     PFN_PHYS(max_pfn),
-					     PAGE_SIZE << order,
-					     0, false,
-					     "hugetlb", &hugetlb_cma[nid]);
+		res = cma_declare_contiguous_nid(0, size, 0, PAGE_SIZE << order,
+						 0, false, "hugetlb",
+						 &hugetlb_cma[nid], nid);
 		if (res) {
-			phys_addr_t begpa = PFN_PHYS(min_pfn);
-			phys_addr_t endpa = PFN_PHYS(max_pfn);
-			pr_warn("%s: reservation failed: err %d, node %d, [%pap, %pap)\n",
-				__func__, res, nid, &begpa, &endpa);
-			break;
+			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+				res, nid);
+			continue;
 		}
 
 		reserved += size;
@@ -5616,4 +5606,12 @@ void __init hugetlb_cma_reserve(int orde
 	}
 }
 
+void __init hugetlb_cma_check(void)
+{
+	if (!hugetlb_cma_size || cma_reserve_called)
+		return;
+
+	pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
+}
+
 #endif /* CONFIG_CMA */
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
