Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA00EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiATCHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:07:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41084 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCHr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:07:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0F76157F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348BC004E1;
        Thu, 20 Jan 2022 02:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644467;
        bh=gX6Z9QuvX4dWD89rf8Dd3wyLMXnezKiGsgHzuY/vdIo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZZp8VCozxppc4RqhwpdWvaxjjkt7oPzUIpG/E58jX2CqccEZDa79F6E2gV0ITx4uJ
         g235xLgHjESZy97i5NTmUFR19yT52JLZ40lENpeB/XJq2j73ojtdzcWXlEbScaFRb1
         e7PgpwUxKtjEX6PicQRFxZWod0l/kIHx0GOcZ82Q=
Date:   Wed, 19 Jan 2022 18:07:45 -0800
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
Subject:  [patch 02/55] mm: percpu: add pcpu_fc_cpu_to_node_fn_t
 typedef
Message-ID: <20220120020745.FuVQeKWep%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: percpu: add pcpu_fc_cpu_to_node_fn_t typedef

Add pcpu_fc_cpu_to_node_fn_t and pass it into pcpu_fc_alloc_fn_t, pcpu
first chunk allocation will call it to alloc memblock on the corresponding
node by it, this is prepare for the next patch.

Link: https://lkml.kernel.org/r/20211216112359.103822-3-wangkefeng.wang@huawei.com
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
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/init.c            |   12 +++++++++---
 arch/powerpc/kernel/setup_64.c |   15 +++++++++++----
 arch/sparc/kernel/smp_64.c     |   13 ++++++++++---
 arch/x86/kernel/setup_percpu.c |   18 +++++++++++++-----
 drivers/base/arch_numa.c       |    8 +++++---
 include/linux/percpu.h         |    7 +++++--
 mm/percpu.c                    |   14 +++++++++-----
 7 files changed, 62 insertions(+), 25 deletions(-)

--- a/arch/mips/mm/init.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/arch/mips/mm/init.c
@@ -519,12 +519,17 @@ static int __init pcpu_cpu_distance(unsi
 	return node_distance(cpu_to_node(from), cpu_to_node(to));
 }
 
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size,
-				       size_t align)
+static int __init pcpu_cpu_to_node(int cpu)
+{
+	return cpu_to_node(cpu);
+}
+
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
+				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	return memblock_alloc_try_nid(size, align, __pa(MAX_DMA_ADDRESS),
 				      MEMBLOCK_ALLOC_ACCESSIBLE,
-				      cpu_to_node(cpu));
+				      cpu_to_nd_fn(cpu));
 }
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
@@ -545,6 +550,7 @@ void __init setup_per_cpu_areas(void)
 	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
 				    pcpu_cpu_distance,
+				    pcpu_cpu_to_node,
 				    pcpu_fc_alloc, pcpu_fc_free);
 	if (rc < 0)
 		panic("Failed to initialize percpu areas.");
--- a/arch/powerpc/kernel/setup_64.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/arch/powerpc/kernel/setup_64.c
@@ -784,12 +784,12 @@ void __init emergency_stack_init(void)
  * RETURNS:
  * Pointer to the allocated area on success, NULL on failure.
  */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size,
-					size_t align)
+static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size, size_t align,
+					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
 #ifdef CONFIG_NUMA
-	int node = early_cpu_to_node(cpu);
+	int node = cpu_to_nd_fun(cpu);
 	void *ptr;
 
 	if (!node_online(node) || !NODE_DATA(node)) {
@@ -823,6 +823,11 @@ static int pcpu_cpu_distance(unsigned in
 		return REMOTE_DISTANCE;
 }
 
+static __init int pcpu_cpu_to_node(int cpu)
+{
+	return early_cpu_to_node(cpu);
+}
+
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
@@ -891,6 +896,7 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
 		rc = pcpu_embed_first_chunk(0, dyn_size, atom_size, pcpu_cpu_distance,
+					    pcpu_cpu_to_node,
 					    pcpu_alloc_bootmem, pcpu_free_bootmem);
 		if (rc)
 			pr_warn("PERCPU: %s allocator failed (%d), "
@@ -899,7 +905,8 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	if (rc < 0)
-		rc = pcpu_page_first_chunk(0, pcpu_alloc_bootmem, pcpu_free_bootmem,
+		rc = pcpu_page_first_chunk(0, pcpu_cpu_to_node,
+					   pcpu_alloc_bootmem, pcpu_free_bootmem,
 					   pcpu_populate_pte);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
--- a/arch/sparc/kernel/smp_64.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/arch/sparc/kernel/smp_64.c
@@ -1539,12 +1539,12 @@ void smp_send_stop(void)
  * RETURNS:
  * Pointer to the allocated area on success, NULL on failure.
  */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size,
-					size_t align)
+static void * __init pcpu_alloc_bootmem(unsigned int cpu, size_t size, size_t align,
+					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
 #ifdef CONFIG_NUMA
-	int node = cpu_to_node(cpu);
+	int node = cpu_to_nd_fn(cpu);
 	void *ptr;
 
 	if (!node_online(node) || !NODE_DATA(node)) {
@@ -1578,6 +1578,11 @@ static int __init pcpu_cpu_distance(unsi
 		return REMOTE_DISTANCE;
 }
 
+static int __init pcpu_cpu_to_node(int cpu)
+{
+	return cpu_to_node(cpu);
+}
+
 static void __init pcpu_populate_pte(unsigned long addr)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
@@ -1641,6 +1646,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 					    PERCPU_DYNAMIC_RESERVE, 4 << 20,
 					    pcpu_cpu_distance,
+					    pcpu_cpu_to_node,
 					    pcpu_alloc_bootmem,
 					    pcpu_free_bootmem);
 		if (rc)
@@ -1650,6 +1656,7 @@ void __init setup_per_cpu_areas(void)
 	}
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
+					   pcpu_cpu_to_node,
 					   pcpu_alloc_bootmem,
 					   pcpu_free_bootmem,
 					   pcpu_populate_pte);
--- a/arch/x86/kernel/setup_percpu.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/arch/x86/kernel/setup_percpu.c
@@ -97,12 +97,12 @@ static bool __init pcpu_need_numa(void)
  * RETURNS:
  * Pointer to the allocated area on success, NULL on failure.
  */
-static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
-					unsigned long align)
+static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size, unsigned long align,
+					pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	const unsigned long goal = __pa(MAX_DMA_ADDRESS);
 #ifdef CONFIG_NUMA
-	int node = early_cpu_to_node(cpu);
+	int node = cpu_to_nd_fn(cpu);
 	void *ptr;
 
 	if (!node_online(node) || !NODE_DATA(node)) {
@@ -128,9 +128,10 @@ static void * __init pcpu_alloc_bootmem(
 /*
  * Helpers for first chunk memory allocation
  */
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
+				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
-	return pcpu_alloc_bootmem(cpu, size, align);
+	return pcpu_alloc_bootmem(cpu, size, align, cpu_to_nd_fn);
 }
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
@@ -150,6 +151,11 @@ static int __init pcpu_cpu_distance(unsi
 #endif
 }
 
+static int __init pcpu_cpu_to_node(int cpu)
+{
+	return early_cpu_to_node(cpu);
+}
+
 static void __init pcpup_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
@@ -205,6 +211,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					    dyn_size, atom_size,
 					    pcpu_cpu_distance,
+					    pcpu_cpu_to_node,
 					    pcpu_fc_alloc, pcpu_fc_free);
 		if (rc < 0)
 			pr_warn("%s allocator failed (%d), falling back to page size\n",
@@ -212,6 +219,7 @@ void __init setup_per_cpu_areas(void)
 	}
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
+					   pcpu_cpu_to_node,
 					   pcpu_fc_alloc, pcpu_fc_free,
 					   pcpup_populate_pte);
 	if (rc < 0)
--- a/drivers/base/arch_numa.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/drivers/base/arch_numa.c
@@ -155,10 +155,10 @@ static int __init pcpu_cpu_distance(unsi
 	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
 }
 
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size,
-				       size_t align)
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align,
+				   pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
-	int nid = early_cpu_to_node(cpu);
+	int nid = cpu_to_nd_fn(cpu);
 
 	return  memblock_alloc_try_nid(size, align,
 			__pa(MAX_DMA_ADDRESS), MEMBLOCK_ALLOC_ACCESSIBLE, nid);
@@ -229,6 +229,7 @@ void __init setup_per_cpu_areas(void)
 		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
 					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
 					    pcpu_cpu_distance,
+					    early_cpu_to_node,
 					    pcpu_fc_alloc, pcpu_fc_free);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		if (rc < 0)
@@ -240,6 +241,7 @@ void __init setup_per_cpu_areas(void)
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
+					   early_cpu_to_node,
 					   pcpu_fc_alloc,
 					   pcpu_fc_free,
 					   pcpu_populate_pte);
--- a/include/linux/percpu.h~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/include/linux/percpu.h
@@ -94,8 +94,9 @@ extern const char * const pcpu_fc_names[
 
 extern enum pcpu_fc pcpu_chosen_fc;
 
-typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size,
-				     size_t align);
+typedef int (pcpu_fc_cpu_to_node_fn_t)(int cpu);
+typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size, size_t align,
+				     pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
@@ -111,12 +112,14 @@ extern void __init pcpu_setup_first_chun
 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				size_t atom_size,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
+				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 extern int __init pcpu_page_first_chunk(size_t reserved_size,
+				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
--- a/mm/percpu.c~mm-percpu-add-pcpu_fc_cpu_to_node_fn_t-typedef
+++ a/mm/percpu.c
@@ -3001,6 +3001,7 @@ static struct pcpu_alloc_info * __init _
  * @dyn_size: minimum free size for dynamic allocation in bytes
  * @atom_size: allocation atom size
  * @cpu_distance_fn: callback to determine distance between cpus, optional
+ * @cpu_to_nd_fn: callback to convert cpu to it's node, optional
  * @alloc_fn: function to allocate percpu page
  * @free_fn: function to free percpu page
  *
@@ -3030,6 +3031,7 @@ static struct pcpu_alloc_info * __init _
 int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				  size_t atom_size,
 				  pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
+				  pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
 				  pcpu_fc_alloc_fn_t alloc_fn,
 				  pcpu_fc_free_fn_t free_fn)
 {
@@ -3066,7 +3068,7 @@ int __init pcpu_embed_first_chunk(size_t
 		BUG_ON(cpu == NR_CPUS);
 
 		/* allocate space for the whole group */
-		ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size, atom_size);
+		ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size, atom_size, cpu_to_nd_fn);
 		if (!ptr) {
 			rc = -ENOMEM;
 			goto out_free_areas;
@@ -3143,6 +3145,7 @@ out_free:
 /**
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @reserved_size: the size of reserved percpu area in bytes
+ * @cpu_to_nd_fn: callback to convert cpu to it's node, optional
  * @alloc_fn: function to allocate percpu page, always called with PAGE_SIZE
  * @free_fn: function to free percpu page, always called with PAGE_SIZE
  * @populate_pte_fn: function to populate pte
@@ -3157,6 +3160,7 @@ out_free:
  * 0 on success, -errno on failure.
  */
 int __init pcpu_page_first_chunk(size_t reserved_size,
+				 pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
 				 pcpu_fc_alloc_fn_t alloc_fn,
 				 pcpu_fc_free_fn_t free_fn,
 				 pcpu_fc_populate_pte_fn_t populate_pte_fn)
@@ -3201,7 +3205,7 @@ int __init pcpu_page_first_chunk(size_t
 		for (i = 0; i < unit_pages; i++) {
 			void *ptr;
 
-			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
+			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE, cpu_to_nd_fn);
 			if (!ptr) {
 				pr_warn("failed to allocate %s page for cpu%u\n",
 						psize_str, cpu);
@@ -3278,8 +3282,8 @@ out_free_ar:
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
-static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size,
-				       size_t align)
+static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size, size_t align,
+				       pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	return  memblock_alloc_from(size, align, __pa(MAX_DMA_ADDRESS));
 }
@@ -3300,7 +3304,7 @@ void __init setup_per_cpu_areas(void)
 	 * what the legacy allocator did.
 	 */
 	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE, NULL,
+				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE, NULL, NULL,
 				    pcpu_dfl_fc_alloc, pcpu_dfl_fc_free);
 	if (rc < 0)
 		panic("Failed to initialize percpu areas.");
_
