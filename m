Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32288C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiATCHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:07:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:07:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B8CB81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DFDC004E1;
        Thu, 20 Jan 2022 02:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644470;
        bh=Kf3dMusxS58VnyWPOos4PECCFaiOBn4hWTWXR8MFOUQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KVnLD+WEws9ro2+li4lIB/hNAFV56/26XUQ6GAKe2t7TdkgCocqeaKjAjIg+lOP6M
         cpf6Gujq5e6ALKcjWJ8AUKxdbUF3x8j10lS9J5xO7F57nLgrAzy+ttue2oFuoQE8Oo
         AAvEiWNlo60jADJgjw2oc8Mpl6TS6CJD8l3MkBck=
Date:   Wed, 19 Jan 2022 18:07:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, dave.hansen@linux.intel.com, davem@davemloft.net,
        dennis@kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, rafael@kernel.org, tglx@linutronix.de,
        tj@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, wangkefeng.wang@huawei.com,
        will@kernel.org
Subject:  [patch 03/55] mm: percpu: add generic pcpu_fc_alloc/free
 funciton
Message-ID: <20220120020749.03IA4YUdL%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: percpu: add generic pcpu_fc_alloc/free funciton

With previous patch, we could add a generic pcpu first chunk allocate and
free function to cleanup the duplicated definations.  on each
architecture.

Link: https://lkml.kernel.org/r/20211216112359.103822-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c            |   16 ------
 arch/powerpc/kernel/setup_64.c |   51 --------------------
 arch/sparc/kernel/smp_64.c     |   50 -------------------
 arch/x86/kernel/setup_percpu.c |   59 -----------------------
 drivers/base/arch_numa.c       |   19 -------
 include/linux/percpu.h         |    9 ---
 mm/percpu.c                    |   78 ++++++++++++++++++-------------
 7 files changed, 54 insertions(+), 228 deletions(-)

--- a/arch/mips/mm/init.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/arch/mips/mm/init.c
@@ -524,19 +524,6 @@ static int __init pcpu_cpu_to_node(int c
 	return cpu_to_node(cpu);
 }
 
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
-				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	return memblock_alloc_try_nid(size, align, __pa(MAX_DMA_ADDRESS),
-				      MEMBLOCK_ALLOC_ACCESSIBLE,
-				      cpu_to_nd_fn(cpu));
-}
-
-static void __init pcpu_fc_free(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
@@ -550,8 +537,7 @@ void __init setup_per_cpu_areas(void)
 	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
 				    pcpu_cpu_distance,
-				    pcpu_cpu_to_node,
-				    pcpu_fc_alloc, pcpu_fc_free);
+				    pcpu_cpu_to_node);
 	if (rc < 0)
 		panic("Failed to initialize percpu areas.");
 
--- a/arch/powerpc/kernel/setup_64.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/arch/powerpc/kernel/setup_64.c
@@ -771,50 +771,6 @@ void __init emergency_stack_init(void)
 }
 
 #ifdef CONFIG_SMP
-/**
- * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
- * @cpu: cpu to allocate for
- * @size: size allocation in bytes
- * @align: alignment
- *
- * Allocate @size bytes aligned at @align for cpu @cpu.  This wrapper
- * does the right thing for NUMA regardless of the current
- * configuration.
- *
- * RETURNS:
- * Pointer to the allocated area on success, NULL on failure.
- */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size, size_t align,
-					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NUMA
-	int node = cpu_to_nd_fun(cpu);
-	void *ptr;
-
-	if (!node_online(node) || !NODE_DATA(node)) {
-		ptr = memblock_alloc_from(size, align, goal);
-		pr_info("cpu %d has no node %d or node-local memory\n",
-			cpu, node);
-		pr_debug("per cpu data for cpu%d %lu bytes at %016lx\n",
-			 cpu, size, __pa(ptr));
-	} else {
-		ptr = memblock_alloc_try_nid(size, align, goal,
-					     MEMBLOCK_ALLOC_ACCESSIBLE, node);
-		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
-			 "%016lx\n", cpu, size, node, __pa(ptr));
-	}
-	return ptr;
-#else
-	return memblock_alloc_from(size, align, goal);
-#endif
-}
-
-static void __init pcpu_free_bootmem(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 static int pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
 	if (early_cpu_to_node(from) == early_cpu_to_node(to))
@@ -896,8 +852,7 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
 		rc = pcpu_embed_first_chunk(0, dyn_size, atom_size, pcpu_cpu_distance,
-					    pcpu_cpu_to_node,
-					    pcpu_alloc_bootmem, pcpu_free_bootmem);
+					    pcpu_cpu_to_node);
 		if (rc)
 			pr_warn("PERCPU: %s allocator failed (%d), "
 				"falling back to page size\n",
@@ -905,9 +860,7 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	if (rc < 0)
-		rc = pcpu_page_first_chunk(0, pcpu_cpu_to_node,
-					   pcpu_alloc_bootmem, pcpu_free_bootmem,
-					   pcpu_populate_pte);
+		rc = pcpu_page_first_chunk(0, pcpu_cpu_to_node, pcpu_populate_pte);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
--- a/arch/sparc/kernel/smp_64.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/arch/sparc/kernel/smp_64.c
@@ -1526,50 +1526,6 @@ void smp_send_stop(void)
 		smp_call_function(stop_this_cpu, NULL, 0);
 }
 
-/**
- * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
- * @cpu: cpu to allocate for
- * @size: size allocation in bytes
- * @align: alignment
- *
- * Allocate @size bytes aligned at @align for cpu @cpu.  This wrapper
- * does the right thing for NUMA regardless of the current
- * configuration.
- *
- * RETURNS:
- * Pointer to the allocated area on success, NULL on failure.
- */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size, size_t align,
-					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NUMA
-	int node = cpu_to_nd_fn(cpu);
-	void *ptr;
-
-	if (!node_online(node) || !NODE_DATA(node)) {
-		ptr = memblock_alloc_from(size, align, goal);
-		pr_info("cpu %d has no node %d or node-local memory\n",
-			cpu, node);
-		pr_debug("per cpu data for cpu%d %lu bytes at %016lx\n",
-			 cpu, size, __pa(ptr));
-	} else {
-		ptr = memblock_alloc_try_nid(size, align, goal,
-					     MEMBLOCK_ALLOC_ACCESSIBLE, node);
-		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
-			 "%016lx\n", cpu, size, node, __pa(ptr));
-	}
-	return ptr;
-#else
-	return memblock_alloc_from(size, align, goal);
-#endif
-}
-
-static void __init pcpu_free_bootmem(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
 	if (cpu_to_node(from) == cpu_to_node(to))
@@ -1646,9 +1602,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 					    PERCPU_DYNAMIC_RESERVE, 4 << 20,
 					    pcpu_cpu_distance,
-					    pcpu_cpu_to_node,
-					    pcpu_alloc_bootmem,
-					    pcpu_free_bootmem);
+					    pcpu_cpu_to_node);
 		if (rc)
 			pr_warn("PERCPU: %s allocator failed (%d), "
 				"falling back to page size\n",
@@ -1657,8 +1611,6 @@ void __init setup_per_cpu_areas(void)
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
 					   pcpu_cpu_to_node,
-					   pcpu_alloc_bootmem,
-					   pcpu_free_bootmem,
 					   pcpu_populate_pte);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
--- a/arch/x86/kernel/setup_percpu.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/arch/x86/kernel/setup_percpu.c
@@ -84,61 +84,6 @@ static bool __init pcpu_need_numa(void)
 }
 #endif
 
-/**
- * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
- * @cpu: cpu to allocate for
- * @size: size allocation in bytes
- * @align: alignment
- *
- * Allocate @size bytes aligned at @align for cpu @cpu.  This wrapper
- * does the right thing for NUMA regardless of the current
- * configuration.
- *
- * RETURNS:
- * Pointer to the allocated area on success, NULL on failure.
- */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size, unsigned long align,
-					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
-#ifdef CONFIG_NUMA
-	int node = cpu_to_nd_fn(cpu);
-	void *ptr;
-
-	if (!node_online(node) || !NODE_DATA(node)) {
-		ptr = memblock_alloc_from(size, align, goal);
-		pr_info("cpu %d has no node %d or node-local memory\n",
-			cpu, node);
-		pr_debug("per cpu data for cpu%d %lu bytes at %016lx\n",
-			 cpu, size, __pa(ptr));
-	} else {
-		ptr = memblock_alloc_try_nid(size, align, goal,
-					     MEMBLOCK_ALLOC_ACCESSIBLE,
-					     node);
-
-		pr_debug("per cpu data for cpu%d %lu bytes on node%d at %016lx\n",
-			 cpu, size, node, __pa(ptr));
-	}
-	return ptr;
-#else
-	return memblock_alloc_from(size, align, goal);
-#endif
-}
-
-/*
- * Helpers for first chunk memory allocation
- */
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
-				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	return pcpu_alloc_bootmem(cpu, size, align, cpu_to_nd_fn);
-}
-
-static void __init pcpu_fc_free(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
 #ifdef CONFIG_NUMA
@@ -211,8 +156,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					    dyn_size, atom_size,
 					    pcpu_cpu_distance,
-					    pcpu_cpu_to_node,
-					    pcpu_fc_alloc, pcpu_fc_free);
+					    pcpu_cpu_to_node);
 		if (rc < 0)
 			pr_warn("%s allocator failed (%d), falling back to page size\n",
 				pcpu_fc_names[pcpu_chosen_fc], rc);
@@ -220,7 +164,6 @@ void __init setup_per_cpu_areas(void)
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					   pcpu_cpu_to_node,
-					   pcpu_fc_alloc, pcpu_fc_free,
 					   pcpup_populate_pte);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
--- a/drivers/base/arch_numa.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/drivers/base/arch_numa.c
@@ -155,20 +155,6 @@ static int __init pcpu_cpu_distance(unsi
 	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
 }
 
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
-				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	int nid = cpu_to_nd_fn(cpu);
-
-	return  memblock_alloc_try_nid(size, align,
-			__pa(MAX_DMA_ADDRESS), MEMBLOCK_ALLOC_ACCESSIBLE, nid);
-}
-
-static void __init pcpu_fc_free(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 static void __init pcpu_populate_pte(unsigned long addr)
 {
@@ -229,8 +215,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
 					    pcpu_cpu_distance,
-					    early_cpu_to_node,
-					    pcpu_fc_alloc, pcpu_fc_free);
+					    early_cpu_to_node);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		if (rc < 0)
 			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
@@ -242,8 +227,6 @@ void __init setup_per_cpu_areas(void)
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
 					   early_cpu_to_node,
-					   pcpu_fc_alloc,
-					   pcpu_fc_free,
 					   pcpu_populate_pte);
 #endif
 	if (rc < 0)
--- a/include/linux/percpu.h~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/include/linux/percpu.h
@@ -95,9 +95,6 @@ extern const char * const pcpu_fc_names[
 extern enum pcpu_fc pcpu_chosen_fc;
 
 typedef int (pcpu_fc_cpu_to_node_fn_t)(int cpu);
-typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size, size_t align,
-				     pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);
-typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
 
@@ -112,16 +109,12 @@ extern void __init pcpu_setup_first_chun
 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				size_t atom_size,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
-				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				pcpu_fc_alloc_fn_t alloc_fn,
-				pcpu_fc_free_fn_t free_fn);
+				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 extern int __init pcpu_page_first_chunk(size_t reserved_size,
 				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				pcpu_fc_alloc_fn_t alloc_fn,
-				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
--- a/mm/percpu.c~mm-percpu-add-generic-pcpu_fc_alloc-free-funciton
+++ a/mm/percpu.c
@@ -2992,6 +2992,42 @@ static struct pcpu_alloc_info * __init _
 
 	return ai;
 }
+
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
+				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
+{
+	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
+#ifdef CONFIG_NUMA
+	int node = NUMA_NO_NODE;
+	void *ptr;
+
+	if (cpu_to_nd_fn)
+		node = cpu_to_nd_fn(cpu);
+
+	if (node == NUMA_NO_NODE || !node_online(node) || !NODE_DATA(node)) {
+		ptr = memblock_alloc_from(size, align, goal);
+		pr_info("cpu %d has no node %d or node-local memory\n",
+			cpu, node);
+		pr_debug("per cpu data for cpu%d %zu bytes at 0x%llx\n",
+			 cpu, size, (u64)__pa(ptr));
+	} else {
+		ptr = memblock_alloc_try_nid(size, align, goal,
+					     MEMBLOCK_ALLOC_ACCESSIBLE,
+					     node);
+
+		pr_debug("per cpu data for cpu%d %zu bytes on node%d at 0x%llx\n",
+			 cpu, size, node, (u64)__pa(ptr));
+	}
+	return ptr;
+#else
+	return memblock_alloc_from(size, align, goal);
+#endif
+}
+
+static void __init pcpu_fc_free(void *ptr, size_t size)
+{
+	memblock_free(ptr, size);
+}
 #endif /* BUILD_EMBED_FIRST_CHUNK || BUILD_PAGE_FIRST_CHUNK */
 
 #if defined(BUILD_EMBED_FIRST_CHUNK)
@@ -3002,14 +3038,12 @@ static struct pcpu_alloc_info * __init _
  * @atom_size: allocation atom size
  * @cpu_distance_fn: callback to determine distance between cpus, optional
  * @cpu_to_nd_fn: callback to convert cpu to it's node, optional
- * @alloc_fn: function to allocate percpu page
- * @free_fn: function to free percpu page
  *
  * This is a helper to ease setting up embedded first percpu chunk and
  * can be called where pcpu_setup_first_chunk() is expected.
  *
  * If this function is used to setup the first chunk, it is allocated
- * by calling @alloc_fn and used as-is without being mapped into
+ * by calling pcpu_fc_alloc and used as-is without being mapped into
  * vmalloc area.  Allocations are always whole multiples of @atom_size
  * aligned to @atom_size.
  *
@@ -3023,7 +3057,7 @@ static struct pcpu_alloc_info * __init _
  * @dyn_size specifies the minimum dynamic area size.
  *
  * If the needed size is smaller than the minimum or specified unit
- * size, the leftover is returned using @free_fn.
+ * size, the leftover is returned using pcpu_fc_free.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
@@ -3031,9 +3065,7 @@ static struct pcpu_alloc_info * __init _
 int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				  size_t atom_size,
 				  pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
-				  pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				  pcpu_fc_alloc_fn_t alloc_fn,
-				  pcpu_fc_free_fn_t free_fn)
+				  pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	void *base = (void *)ULONG_MAX;
 	void **areas = NULL;
@@ -3068,7 +3100,7 @@ int __init pcpu_embed_first_chunk(size_t
 		BUG_ON(cpu == NR_CPUS);
 
 		/* allocate space for the whole group */
-		ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size, atom_size, cpu_to_nd_fn);
+		ptr = pcpu_fc_alloc(cpu, gi->nr_units * ai->unit_size, atom_size, cpu_to_nd_fn);
 		if (!ptr) {
 			rc = -ENOMEM;
 			goto out_free_areas;
@@ -3107,12 +3139,12 @@ int __init pcpu_embed_first_chunk(size_t
 		for (i = 0; i < gi->nr_units; i++, ptr += ai->unit_size) {
 			if (gi->cpu_map[i] == NR_CPUS) {
 				/* unused unit, free whole */
-				free_fn(ptr, ai->unit_size);
+				pcpu_fc_free(ptr, ai->unit_size);
 				continue;
 			}
 			/* copy and return the unused part */
 			memcpy(ptr, __per_cpu_load, ai->static_size);
-			free_fn(ptr + size_sum, ai->unit_size - size_sum);
+			pcpu_fc_free(ptr + size_sum, ai->unit_size - size_sum);
 		}
 	}
 
@@ -3131,7 +3163,7 @@ int __init pcpu_embed_first_chunk(size_t
 out_free_areas:
 	for (group = 0; group < ai->nr_groups; group++)
 		if (areas[group])
-			free_fn(areas[group],
+			pcpu_fc_free(areas[group],
 				ai->groups[group].nr_units * ai->unit_size);
 out_free:
 	pcpu_free_alloc_info(ai);
@@ -3146,8 +3178,6 @@ out_free:
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @reserved_size: the size of reserved percpu area in bytes
  * @cpu_to_nd_fn: callback to convert cpu to it's node, optional
- * @alloc_fn: function to allocate percpu page, always called with PAGE_SIZE
- * @free_fn: function to free percpu page, always called with PAGE_SIZE
  * @populate_pte_fn: function to populate pte
  *
  * This is a helper to ease setting up page-remapped first percpu
@@ -3161,8 +3191,6 @@ out_free:
  */
 int __init pcpu_page_first_chunk(size_t reserved_size,
 				 pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				 pcpu_fc_alloc_fn_t alloc_fn,
-				 pcpu_fc_free_fn_t free_fn,
 				 pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
@@ -3205,7 +3233,7 @@ int __init pcpu_page_first_chunk(size_t
 		for (i = 0; i < unit_pages; i++) {
 			void *ptr;
 
-			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE, cpu_to_nd_fn);
+			ptr = pcpu_fc_alloc(cpu, PAGE_SIZE, PAGE_SIZE, cpu_to_nd_fn);
 			if (!ptr) {
 				pr_warn("failed to allocate %s page for cpu%u\n",
 						psize_str, cpu);
@@ -3257,7 +3285,7 @@ int __init pcpu_page_first_chunk(size_t
 
 enomem:
 	while (--j >= 0)
-		free_fn(page_address(pages[j]), PAGE_SIZE);
+		pcpu_fc_free(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
 	memblock_free(pages, pages_size);
@@ -3282,17 +3310,6 @@ out_free_ar:
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
-static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size, size_t align,
-				       pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
-{
-	return  memblock_alloc_from(size, align, __pa(MAX_DMA_ADDRESS));
-}
-
-static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
-{
-	memblock_free(ptr, size);
-}
-
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
@@ -3303,9 +3320,8 @@ void __init setup_per_cpu_areas(void)
 	 * Always reserve area for module percpu variables.  That's
 	 * what the legacy allocator did.
 	 */
-	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE, NULL, NULL,
-				    pcpu_dfl_fc_alloc, pcpu_dfl_fc_free);
+	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE, PERCPU_DYNAMIC_RESERVE,
+				    PAGE_SIZE, NULL, NULL);
 	if (rc < 0)
 		panic("Failed to initialize percpu areas.");
 
_
