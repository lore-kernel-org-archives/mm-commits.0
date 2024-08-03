Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E49134AB
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722710600; cv=none; b=R/WiW7XSQ5SseBI1axMRRlbB3dPESENFG972asC1EmvH5LHC60v2S92jsjLa2m9EsfWxLXY0g0Zp8ZaakX76WGs5QRxVeM8lp5wISDHuPDAUeSkSArbqtcTQ+2g6c+lwWFykOaU0xm3V8EaVZxlIyGLlWJ1rMPBrCsaii5N++Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722710600; c=relaxed/simple;
	bh=5szuaU3PX4H/8xNKBiDvmeQ5fuizTajyhhzkhFjTfpg=;
	h=Date:To:From:Subject:Message-Id; b=dM9zRf6Kj6Kv2OiMa/hKu88pPLSX/WLUiFQvkNojDb6EK4U1hcS/WzRT9/4BWiD+USVabZLEfleQvJ7qPA58A8EEE9jR3ppKMKC5ewJza2WoVxWnUujKrb/SiJ/1VIEPk2auqmHdXq+/9VWBcypN3SLq43QAo+cId/7Jec/mWlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dltCOYib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dltCOYib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95043C116B1;
	Sat,  3 Aug 2024 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722710600;
	bh=5szuaU3PX4H/8xNKBiDvmeQ5fuizTajyhhzkhFjTfpg=;
	h=Date:To:From:Subject:From;
	b=dltCOYibcItYEsY3rIE+OdSem+X1p9Q9D79EVyIe7+tcn345Ui5zftCc9b+E6VUQ+
	 bSop4RmThedvHOsQmoTthAcJ3Uhvehp3Ku6Gyh3fc5/GrIXQLrUHiufOkn1v8uUiKz
	 Gu8TINhUrNFNSEwFTDBzPo/E4m6Blmk6z2RL71eA=
Date: Sat, 03 Aug 2024 11:43:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch_numa-switch-over-to-numa_memblks.patch added to mm-unstable branch
Message-Id: <20240803184320.95043C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch_numa: switch over to numa_memblks
has been added to the -mm mm-unstable branch.  Its filename is
     arch_numa-switch-over-to-numa_memblks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch_numa-switch-over-to-numa_memblks.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: arch_numa: switch over to numa_memblks
Date: Thu, 1 Aug 2024 09:08:24 +0300

Until now arch_numa was directly translating firmware NUMA information to
memblock.

Using numa_memblks as an intermediate step has a few advantages:
* alignment with more battle tested x86 implementation
* availability of NUMA emulation
* maintaining node information for not yet populated memory

Replace current functionality related to numa_add_memblk() and
__node_distance() with the implementation based on numa_memblks and add
functions required by numa_emulation.

Link: https://lkml.kernel.org/r/20240801060826.559858-25-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Zi Yan <ziy@nvidia.com>	[x86_64 and arm64]
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
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

 drivers/base/Kconfig       |    1 
 drivers/base/arch_numa.c   |  201 ++++++++++-------------------------
 include/asm-generic/numa.h |    6 -
 3 files changed, 65 insertions(+), 143 deletions(-)

--- a/drivers/base/arch_numa.c~arch_numa-switch-over-to-numa_memblks
+++ a/drivers/base/arch_numa.c
@@ -12,14 +12,12 @@
 #include <linux/memblock.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/numa_memblks.h>
 
 #include <asm/sections.h>
 
-nodemask_t numa_nodes_parsed __initdata;
 static int cpu_to_node_map[NR_CPUS] = { [0 ... NR_CPUS-1] = NUMA_NO_NODE };
 
-static int numa_distance_cnt;
-static u8 *numa_distance;
 bool numa_off;
 
 static __init int numa_parse_early_param(char *opt)
@@ -28,6 +26,8 @@ static __init int numa_parse_early_param
 		return -EINVAL;
 	if (str_has_prefix(opt, "off"))
 		numa_off = true;
+	if (!strncmp(opt, "fake=", 5))
+		return numa_emu_cmdline(opt + 5);
 
 	return 0;
 }
@@ -59,6 +59,7 @@ EXPORT_SYMBOL(cpumask_of_node);
 
 #endif
 
+#ifndef CONFIG_NUMA_EMU
 static void numa_update_cpu(unsigned int cpu, bool remove)
 {
 	int nid = cpu_to_node(cpu);
@@ -81,6 +82,7 @@ void numa_remove_cpu(unsigned int cpu)
 {
 	numa_update_cpu(cpu, true);
 }
+#endif
 
 void numa_clear_node(unsigned int cpu)
 {
@@ -142,7 +144,7 @@ void __init early_map_cpu_to_node(unsign
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
-int __init early_cpu_to_node(int cpu)
+int early_cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
@@ -187,30 +189,6 @@ void __init setup_per_cpu_areas(void)
 }
 #endif
 
-/**
- * numa_add_memblk() - Set node id to memblk
- * @nid: NUMA node ID of the new memblk
- * @start: Start address of the new memblk
- * @end:  End address of the new memblk
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init numa_add_memblk(int nid, u64 start, u64 end)
-{
-	int ret;
-
-	ret = memblock_set_node(start, (end - start), &memblock.memory, nid);
-	if (ret < 0) {
-		pr_err("memblock [0x%llx - 0x%llx] failed to add on node %d\n",
-			start, (end - 1), nid);
-		return ret;
-	}
-
-	node_set(nid, numa_nodes_parsed);
-	return ret;
-}
-
 /*
  * Initialize NODE_DATA for a node on the local memory
  */
@@ -226,116 +204,9 @@ static void __init setup_node_data(int n
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 }
 
-/*
- * numa_free_distance
- *
- * The current table is freed.
- */
-void __init numa_free_distance(void)
-{
-	size_t size;
-
-	if (!numa_distance)
-		return;
-
-	size = numa_distance_cnt * numa_distance_cnt *
-		sizeof(numa_distance[0]);
-
-	memblock_free(numa_distance, size);
-	numa_distance_cnt = 0;
-	numa_distance = NULL;
-}
-
-/*
- * Create a new NUMA distance table.
- */
-static int __init numa_alloc_distance(void)
-{
-	size_t size;
-	int i, j;
-
-	size = nr_node_ids * nr_node_ids * sizeof(numa_distance[0]);
-	numa_distance = memblock_alloc(size, PAGE_SIZE);
-	if (WARN_ON(!numa_distance))
-		return -ENOMEM;
-
-	numa_distance_cnt = nr_node_ids;
-
-	/* fill with the default distances */
-	for (i = 0; i < numa_distance_cnt; i++)
-		for (j = 0; j < numa_distance_cnt; j++)
-			numa_distance[i * numa_distance_cnt + j] = i == j ?
-				LOCAL_DISTANCE : REMOTE_DISTANCE;
-
-	pr_debug("Initialized distance table, cnt=%d\n", numa_distance_cnt);
-
-	return 0;
-}
-
-/**
- * numa_set_distance() - Set inter node NUMA distance from node to node.
- * @from: the 'from' node to set distance
- * @to: the 'to'  node to set distance
- * @distance: NUMA distance
- *
- * Set the distance from node @from to @to to @distance.
- * If distance table doesn't exist, a warning is printed.
- *
- * If @from or @to is higher than the highest known node or lower than zero
- * or @distance doesn't make sense, the call is ignored.
- */
-void __init numa_set_distance(int from, int to, int distance)
-{
-	if (!numa_distance) {
-		pr_warn_once("Warning: distance table not allocated yet\n");
-		return;
-	}
-
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
-			from < 0 || to < 0) {
-		pr_warn_once("Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
-			    from, to, distance);
-		return;
-	}
-
-	if ((u8)distance != distance ||
-	    (from == to && distance != LOCAL_DISTANCE)) {
-		pr_warn_once("Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
-			     from, to, distance);
-		return;
-	}
-
-	numa_distance[from * numa_distance_cnt + to] = distance;
-}
-
-/*
- * Return NUMA distance @from to @to
- */
-int __node_distance(int from, int to)
-{
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
-		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
-	return numa_distance[from * numa_distance_cnt + to];
-}
-EXPORT_SYMBOL(__node_distance);
-
 static int __init numa_register_nodes(void)
 {
 	int nid;
-	struct memblock_region *mblk;
-
-	/* Check that valid nid is set to memblks */
-	for_each_mem_region(mblk) {
-		int mblk_nid = memblock_get_region_node(mblk);
-		phys_addr_t start = mblk->base;
-		phys_addr_t end = mblk->base + mblk->size - 1;
-
-		if (mblk_nid == NUMA_NO_NODE || mblk_nid >= MAX_NUMNODES) {
-			pr_warn("Warning: invalid memblk node %d [mem %pap-%pap]\n",
-				mblk_nid, &start, &end);
-			return -EINVAL;
-		}
-	}
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, numa_nodes_parsed) {
@@ -360,11 +231,7 @@ static int __init numa_init(int (*init_f
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 
-	ret = numa_alloc_distance();
-	if (ret < 0)
-		return ret;
-
-	ret = init_func();
+	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
 	if (ret < 0)
 		goto out_free_distance;
 
@@ -382,7 +249,7 @@ static int __init numa_init(int (*init_f
 
 	return 0;
 out_free_distance:
-	numa_free_distance();
+	numa_reset_distance();
 	return ret;
 }
 
@@ -412,6 +279,7 @@ static int __init dummy_numa_init(void)
 		pr_err("NUMA init failed\n");
 		return ret;
 	}
+	node_set(0, numa_nodes_parsed);
 
 	numa_off = true;
 	return 0;
@@ -454,3 +322,54 @@ void __init arch_numa_init(void)
 
 	numa_init(dummy_numa_init);
 }
+
+#ifdef CONFIG_NUMA_EMU
+void __init numa_emu_update_cpu_to_node(int *emu_nid_to_phys,
+					unsigned int nr_emu_nids)
+{
+	int i, j;
+
+	/*
+	 * Transform cpu_to_node_map table to use emulated nids by
+	 * reverse-mapping phys_nid.  The maps should always exist but fall
+	 * back to zero just in case.
+	 */
+	for (i = 0; i < ARRAY_SIZE(cpu_to_node_map); i++) {
+		if (cpu_to_node_map[i] == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < nr_emu_nids; j++)
+			if (cpu_to_node_map[i] == emu_nid_to_phys[j])
+				break;
+		cpu_to_node_map[i] = j < nr_emu_nids ? j : 0;
+	}
+}
+
+u64 __init numa_emu_dma_end(void)
+{
+	return PFN_PHYS(memblock_start_of_DRAM() + SZ_4G);
+}
+
+void debug_cpumask_set_cpu(unsigned int cpu, int node, bool enable)
+{
+	struct cpumask *mask;
+
+	if (node == NUMA_NO_NODE)
+		return;
+
+	mask = node_to_cpumask_map[node];
+	if (!cpumask_available(mask)) {
+		pr_err("node_to_cpumask_map[%i] NULL\n", node);
+		dump_stack();
+		return;
+	}
+
+	if (enable)
+		cpumask_set_cpu(cpu, mask);
+	else
+		cpumask_clear_cpu(cpu, mask);
+
+	pr_debug("%s cpu %d node %d: mask now %*pbl\n",
+		 enable ? "numa_add_cpu" : "numa_remove_cpu",
+		 cpu, node, cpumask_pr_args(mask));
+}
+#endif /* CONFIG_NUMA_EMU */
--- a/drivers/base/Kconfig~arch_numa-switch-over-to-numa_memblks
+++ a/drivers/base/Kconfig
@@ -226,6 +226,7 @@ config GENERIC_ARCH_TOPOLOGY
 
 config GENERIC_ARCH_NUMA
 	bool
+	select NUMA_MEMBLKS
 	help
 	  Enable support for generic NUMA implementation. Currently, RISC-V
 	  and ARM64 use it.
--- a/include/asm-generic/numa.h~arch_numa-switch-over-to-numa_memblks
+++ a/include/asm-generic/numa.h
@@ -32,8 +32,6 @@ static inline const struct cpumask *cpum
 
 void __init arch_numa_init(void);
 int __init numa_add_memblk(int nodeid, u64 start, u64 end);
-void __init numa_set_distance(int from, int to, int distance);
-void __init numa_free_distance(void);
 void __init early_map_cpu_to_node(unsigned int cpu, int nid);
 int __init early_cpu_to_node(int cpu);
 void numa_store_cpu_info(unsigned int cpu);
@@ -51,4 +49,8 @@ static inline int early_cpu_to_node(int
 
 #endif	/* CONFIG_NUMA */
 
+#ifdef CONFIG_NUMA_EMU
+void debug_cpumask_set_cpu(unsigned int cpu, int node, bool enable);
+#endif
+
 #endif	/* __ASM_GENERIC_NUMA_H */
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch
x86-numa-simplify-numa_distance-allocation.patch
x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch
x86-numa-move-fake_node_-defines-to-numa_emu.patch
x86-numa_emu-simplify-allocation-of-phys_dist.patch
x86-numa_emu-split-__apicid_to_node-update-to-a-helper-function.patch
x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch
x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch
mm-introduce-numa_memblks.patch
mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch
mm-introduce-numa_emulation.patch
mm-numa_memblks-introduce-numa_memblks_init.patch
mm-numa_memblks-make-several-functions-and-variables-static.patch
mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch
of-numa-return-einval-when-no-numa-node-id-is-found.patch
arch_numa-switch-over-to-numa_memblks.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

