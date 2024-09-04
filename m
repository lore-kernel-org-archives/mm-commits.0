Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5A6EB7D
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423426; cv=none; b=Y0QOcMRvMJxT5cX8ydd9JUmQwkkiDrCHjG5AYadm7E1tKVBYKutLqsBuE5IzKWQ2OXmHuue0cbOT38LxJ/7ilacdk3+VJd7ZfQoOP8MtenLFP+yO44gEOQRTofkbswlgm+fMlMjkdBu8RLWooNLcH0OFgl8OFXI+L1FhcP6dBI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423426; c=relaxed/simple;
	bh=sCx3MEsiHBBhQBQfZCvTUtk5ry2yj8TYEihvoN61Svs=;
	h=Date:To:From:Subject:Message-Id; b=rWpwGYWYeWdwtHlkFBjhUniscjLQd3Mhy6Son22lHVKirk4AINX9OCHnl9VHPX34Kujp5EQgIVyM7flsMEDGZwkh8LhDUPl5ATZd7C5ZJDpkq4GFQN40X6PjCa4QJTAtKqyOOzwave6xEu7lnUDj/KDCogLYC1dY9WwW8xQ8N/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwW6yC3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwW6yC3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812EDC4CEC2;
	Wed,  4 Sep 2024 04:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423426;
	bh=sCx3MEsiHBBhQBQfZCvTUtk5ry2yj8TYEihvoN61Svs=;
	h=Date:To:From:Subject:From;
	b=YwW6yC3DvbovxrIZ1NPq7uVb2UrJ5DDO/a+1WFbnxf8MHAqhvztEq/8b7thl9NJhO
	 5V/OLBlhUHMKVLmaa6Rc2OgbBSSEjVDJnlB1EwOJMTZb8d2VmpI7nOSIjyHa4BTaD3
	 9PrjXgxQT8vIKV0Pyk70RPoA3Wp/3lkYnbp9uO3o=
Date: Tue, 03 Sep 2024 21:17:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch removed from -mm tree
Message-Id: <20240904041706.812EDC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch, mm: pull out allocation of NODE_DATA to generic code
has been removed from the -mm tree.  Its filename was
     arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch, mm: pull out allocation of NODE_DATA to generic code
Date: Wed, 7 Aug 2024 09:40:53 +0300

Architectures that support NUMA duplicate the code that allocates
NODE_DATA on the node-local memory with slight variations in reporting of
the addresses where the memory was allocated.

Use x86 version as the basis for the generic alloc_node_data() function
and call this function in architecture specific numa initialization.

Round up node data size to SMP_CACHE_BYTES rather than to PAGE_SIZE like
x86 used to do since the bootmem era when allocation granularity was
PAGE_SIZE anyway.

Link: https://lkml.kernel.org/r/20240807064110.1003856-10-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/numa.c |   18 -----------------
 arch/mips/loongson64/numa.c  |   16 +--------------
 arch/powerpc/mm/numa.c       |   20 -------------------
 arch/sh/mm/init.c            |    7 ------
 arch/sparc/mm/init_64.c      |    9 +-------
 arch/x86/mm/numa.c           |   34 ---------------------------------
 drivers/base/arch_numa.c     |   21 --------------------
 include/linux/numa.h         |    1 
 mm/numa.c                    |   27 ++++++++++++++++++++++++++
 9 files changed, 36 insertions(+), 117 deletions(-)

--- a/arch/loongarch/kernel/numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/loongarch/kernel/numa.c
@@ -187,24 +187,6 @@ int __init numa_add_memblk(int nid, u64
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-static void __init alloc_node_data(int nid)
-{
-	void *nd;
-	unsigned long nd_pa;
-	size_t nd_sz = roundup(sizeof(pg_data_t), PAGE_SIZE);
-
-	nd_pa = memblock_phys_alloc_try_nid(nd_sz, SMP_CACHE_BYTES, nid);
-	if (!nd_pa) {
-		pr_err("Cannot find %zu Byte for node_data (initial node: %d)\n", nd_sz, nid);
-		return;
-	}
-
-	nd = __va(nd_pa);
-
-	node_data[nid] = nd;
-	memset(nd, 0, sizeof(pg_data_t));
-}
-
 static void __init node_mem_init(unsigned int node)
 {
 	unsigned long start_pfn, end_pfn;
--- a/arch/mips/loongson64/numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/mips/loongson64/numa.c
@@ -81,12 +81,8 @@ static void __init init_topology_matrix(
 
 static void __init node_mem_init(unsigned int node)
 {
-	struct pglist_data *nd;
 	unsigned long node_addrspace_offset;
 	unsigned long start_pfn, end_pfn;
-	unsigned long nd_pa;
-	int tnid;
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
 
 	node_addrspace_offset = nid_to_addrbase(node);
 	pr_info("Node%d's addrspace_offset is 0x%lx\n",
@@ -96,16 +92,8 @@ static void __init node_mem_init(unsigne
 	pr_info("Node%d: start_pfn=0x%lx, end_pfn=0x%lx\n",
 		node, start_pfn, end_pfn);
 
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, node);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, node);
-	nd = __va(nd_pa);
-	memset(nd, 0, sizeof(struct pglist_data));
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != node)
-		pr_info("NODE_DATA(%d) on node %d\n", node, tnid);
-	node_data[node] = nd;
+	alloc_node_data(node);
+
 	NODE_DATA(node)->node_start_pfn = start_pfn;
 	NODE_DATA(node)->node_spanned_pages = end_pfn - start_pfn;
 
--- a/arch/powerpc/mm/numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/powerpc/mm/numa.c
@@ -1093,27 +1093,9 @@ void __init dump_numa_cpu_topology(void)
 static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 {
 	u64 spanned_pages = end_pfn - start_pfn;
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
 
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, nid);
+	alloc_node_data(nid);
 
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	pr_info("  NODE_DATA [mem %#010Lx-%#010Lx]\n",
-		nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
-
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 	NODE_DATA(nid)->node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = spanned_pages;
--- a/arch/sh/mm/init.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/sh/mm/init.c
@@ -212,12 +212,7 @@ void __init allocate_pgdat(unsigned int
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 
 #ifdef CONFIG_NUMA
-	NODE_DATA(nid) = memblock_alloc_try_nid(
-				sizeof(struct pglist_data),
-				SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
-				MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-	if (!NODE_DATA(nid))
-		panic("Can't allocate pgdat for node %d\n", nid);
+	alloc_node_data(nid);
 #endif
 
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
--- a/arch/sparc/mm/init_64.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/sparc/mm/init_64.c
@@ -1075,14 +1075,9 @@ static void __init allocate_node_data(in
 {
 	struct pglist_data *p;
 	unsigned long start_pfn, end_pfn;
-#ifdef CONFIG_NUMA
 
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid)) {
-		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
-		prom_halt();
-	}
+#ifdef CONFIG_NUMA
+	alloc_node_data(nid);
 
 	NODE_DATA(nid)->node_id = nid;
 #endif
--- a/arch/x86/mm/numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/arch/x86/mm/numa.c
@@ -191,39 +191,6 @@ int __init numa_add_memblk(int nid, u64
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-/* Allocate NODE_DATA for a node on the local memory */
-static void __init alloc_node_data(int nid)
-{
-	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
-
-	/*
-	 * Allocate node data.  Try node-local memory and then any node.
-	 * Never allocate in DMA zone.
-	 */
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in any node (initial node: %d)\n",
-		       nd_size, nid);
-		return;
-	}
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	printk(KERN_INFO "NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
-	       nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
-
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
-
-	node_set_online(nid);
-}
-
 /**
  * numa_cleanup_meminfo - Cleanup a numa_meminfo
  * @mi: numa_meminfo to clean up
@@ -571,6 +538,7 @@ static int __init numa_register_memblks(
 			continue;
 
 		alloc_node_data(nid);
+		node_set_online(nid);
 	}
 
 	/* Dump memblock with node info and return. */
--- a/drivers/base/arch_numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/drivers/base/arch_numa.c
@@ -216,30 +216,11 @@ int __init numa_add_memblk(int nid, u64
  */
 static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
 {
-	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
-	u64 nd_pa;
-	void *nd;
-	int tnid;
-
 	if (start_pfn >= end_pfn)
 		pr_info("Initmem setup node %d [<memory-less node>]\n", nid);
 
-	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
-	if (!nd_pa)
-		panic("Cannot allocate %zu bytes for node %d data\n",
-		      nd_size, nid);
-
-	nd = __va(nd_pa);
-
-	/* report and initialize */
-	pr_info("NODE_DATA [mem %#010Lx-%#010Lx]\n",
-		nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		pr_info("NODE_DATA(%d) on node %d\n", nid, tnid);
+	alloc_node_data(nid);
 
-	node_data[nid] = nd;
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 	NODE_DATA(nid)->node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
--- a/include/linux/numa.h~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/include/linux/numa.h
@@ -33,6 +33,7 @@ static inline bool numa_valid_node(int n
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)	(node_data[nid])
 
+void __init alloc_node_data(int nid);
 void __init alloc_offline_node_data(int nid);
 
 /* Generic implementation available */
--- a/mm/numa.c~arch-mm-pull-out-allocation-of-node_data-to-generic-code
+++ a/mm/numa.c
@@ -1,11 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include <linux/memblock.h>
 #include <linux/printk.h>
 #include <linux/numa.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
 
+/* Allocate NODE_DATA for a node on the local memory */
+void __init alloc_node_data(int nid)
+{
+	const size_t nd_size = roundup(sizeof(pg_data_t), SMP_CACHE_BYTES);
+	u64 nd_pa;
+	void *nd;
+	int tnid;
+
+	/* Allocate node data.  Try node-local memory and then any node. */
+	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
+	if (!nd_pa)
+		panic("Cannot allocate %zu bytes for node %d data\n",
+		      nd_size, nid);
+	nd = __va(nd_pa);
+
+	/* report and initialize */
+	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
+		nd_pa, nd_pa + nd_size - 1);
+	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
+	if (tnid != nid)
+		pr_info("    NODE_DATA(%d) on node %d\n", nid, tnid);
+
+	node_data[nid] = nd;
+	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+}
+
 void __init alloc_offline_node_data(int nid)
 {
 	pg_data_t *pgdat;
_

Patches currently in -mm which might be from rppt@kernel.org are


