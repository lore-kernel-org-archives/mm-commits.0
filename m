Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254AAC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377908AbiATV31 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377907AbiATV31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11433C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A669CB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE3FC340E0;
        Thu, 20 Jan 2022 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714164;
        bh=llYFbgwKl9McTFJ1EH0laU5rI7hoDFHdOXvPUAl6g2U=;
        h=Date:From:To:Subject:From;
        b=ISPimQLpTenY93Awd6R9sUyuhspsAuipz2FE+8qESyqSFFmyaObtyjHE5KtUFE5fD
         W0Z6E8dzUnx1R6wexmiGJ3bcXp/TcTBvZvTxkVKo4hTu1HYJMet0ZEbGeNpBr8yRpw
         jQpmN+GilXlr7ZSLP7FBdmWVC/uVntvDo/3CLdeQ=
Date:   Thu, 20 Jan 2022 13:29:23 -0800
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, dennis@kernel.org, gregkh@linuxfoundation.org,
        hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, rafael@kernel.org, tglx@linutronix.de,
        tj@kernel.org, tsbogend@alpha.franken.de,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged]
 mm-percpu-add-generic-pcpu_populate_pte-function.patch removed from -mm
 tree
Message-ID: <20220120212923.OEsz3_KDU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: percpu: add generic pcpu_populate_pte() function
has been removed from the -mm tree.  Its filename was
     mm-percpu-add-generic-pcpu_populate_pte-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: percpu: add generic pcpu_populate_pte() function

With NEED_PER_CPU_PAGE_FIRST_CHUNK enabled, we need a function to populate
pte, this patch adds a generic pcpu populate pte function,
pcpu_populate_pte(), which is marked __weak and used on most
architectures, but it is overridden on x86, which has its own
implementation.

Link: https://lkml.kernel.org/r/20211216112359.103822-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup_64.c |   47 -------------------
 arch/sparc/kernel/smp_64.c     |   56 ----------------------
 arch/x86/kernel/setup_percpu.c |    5 --
 drivers/base/arch_numa.c       |   51 --------------------
 include/linux/percpu.h         |    5 --
 mm/percpu.c                    |   76 ++++++++++++++++++++++++++++---
 6 files changed, 78 insertions(+), 162 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/arch/powerpc/kernel/setup_64.c
@@ -787,51 +787,6 @@ static __init int pcpu_cpu_to_node(int c
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
-static void __init pcpu_populate_pte(unsigned long addr)
-{
-	pgd_t *pgd = pgd_offset_k(addr);
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d)) {
-		pud_t *new;
-
-		new = memblock_alloc(PUD_TABLE_SIZE, PUD_TABLE_SIZE);
-		if (!new)
-			goto err_alloc;
-		p4d_populate(&init_mm, p4d, new);
-	}
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud)) {
-		pmd_t *new;
-
-		new = memblock_alloc(PMD_TABLE_SIZE, PMD_TABLE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pud_populate(&init_mm, pud, new);
-	}
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd)) {
-		pte_t *new;
-
-		new = memblock_alloc(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pmd_populate_kernel(&init_mm, pmd, new);
-	}
-
-	return;
-
-err_alloc:
-	panic("%s: Failed to allocate %lu bytes align=%lx from=%lx\n",
-	      __func__, PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-}
-
-
 void __init setup_per_cpu_areas(void)
 {
 	const size_t dyn_size = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
@@ -860,7 +815,7 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	if (rc < 0)
-		rc = pcpu_page_first_chunk(0, pcpu_cpu_to_node, pcpu_populate_pte);
+		rc = pcpu_page_first_chunk(0, pcpu_cpu_to_node);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
--- a/arch/sparc/kernel/smp_64.c~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/arch/sparc/kernel/smp_64.c
@@ -1539,59 +1539,6 @@ static int __init pcpu_cpu_to_node(int c
 	return cpu_to_node(cpu);
 }
 
-static void __init pcpu_populate_pte(unsigned long addr)
-{
-	pgd_t *pgd = pgd_offset_k(addr);
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	if (pgd_none(*pgd)) {
-		pud_t *new;
-
-		new = memblock_alloc_from(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pgd_populate(&init_mm, pgd, new);
-	}
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d)) {
-		pud_t *new;
-
-		new = memblock_alloc_from(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		p4d_populate(&init_mm, p4d, new);
-	}
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud)) {
-		pmd_t *new;
-
-		new = memblock_alloc_from(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pud_populate(&init_mm, pud, new);
-	}
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd)) {
-		pte_t *new;
-
-		new = memblock_alloc_from(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pmd_populate_kernel(&init_mm, pmd, new);
-	}
-
-	return;
-
-err_alloc:
-	panic("%s: Failed to allocate %lu bytes align=%lx from=%lx\n",
-	      __func__, PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-}
-
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
@@ -1610,8 +1557,7 @@ void __init setup_per_cpu_areas(void)
 	}
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
-					   pcpu_cpu_to_node,
-					   pcpu_populate_pte);
+					   pcpu_cpu_to_node);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
--- a/arch/x86/kernel/setup_percpu.c~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/arch/x86/kernel/setup_percpu.c
@@ -101,7 +101,7 @@ static int __init pcpu_cpu_to_node(int c
 	return early_cpu_to_node(cpu);
 }
 
-static void __init pcpup_populate_pte(unsigned long addr)
+void __init pcpu_populate_pte(unsigned long addr)
 {
 	populate_extra_pte(addr);
 }
@@ -163,8 +163,7 @@ void __init setup_per_cpu_areas(void)
 	}
 	if (rc < 0)
 		rc = pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
-					   pcpu_cpu_to_node,
-					   pcpup_populate_pte);
+					   pcpu_cpu_to_node);
 	if (rc < 0)
 		panic("cannot initialize percpu area (err=%d)", rc);
 
--- a/drivers/base/arch_numa.c~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/drivers/base/arch_numa.c
@@ -14,7 +14,6 @@
 #include <linux/of.h>
 
 #include <asm/sections.h>
-#include <asm/pgalloc.h>
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
@@ -155,52 +154,6 @@ static int __init pcpu_cpu_distance(unsi
 	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
 }
 
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-static void __init pcpu_populate_pte(unsigned long addr)
-{
-	pgd_t *pgd = pgd_offset_k(addr);
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d)) {
-		pud_t *new;
-
-		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		p4d_populate(&init_mm, p4d, new);
-	}
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud)) {
-		pmd_t *new;
-
-		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pud_populate(&init_mm, pud, new);
-	}
-
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd)) {
-		pte_t *new;
-
-		new = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
-		if (!new)
-			goto err_alloc;
-		pmd_populate_kernel(&init_mm, pmd, new);
-	}
-
-	return;
-
-err_alloc:
-	panic("%s: Failed to allocate %lu bytes align=%lx from=%lx\n",
-	      __func__, PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
-}
-#endif
-
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
@@ -225,9 +178,7 @@ void __init setup_per_cpu_areas(void)
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 	if (rc < 0)
-		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
-					   early_cpu_to_node,
-					   pcpu_populate_pte);
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
 #endif
 	if (rc < 0)
 		panic("Failed to initialize percpu areas (err=%d).", rc);
--- a/include/linux/percpu.h~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/include/linux/percpu.h
@@ -95,7 +95,6 @@ extern const char * const pcpu_fc_names[
 extern enum pcpu_fc pcpu_chosen_fc;
 
 typedef int (pcpu_fc_cpu_to_node_fn_t)(int cpu);
-typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
 
 extern struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
@@ -113,9 +112,9 @@ extern int __init pcpu_embed_first_chunk
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+void __init pcpu_populate_pte(unsigned long addr);
 extern int __init pcpu_page_first_chunk(size_t reserved_size,
-				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				pcpu_fc_populate_pte_fn_t populate_pte_fn);
+				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);
 #endif
 
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align) __alloc_size(1);
--- a/mm/percpu.c~mm-percpu-add-generic-pcpu_populate_pte-function
+++ a/mm/percpu.c
@@ -3174,11 +3174,79 @@ out_free:
 #endif /* BUILD_EMBED_FIRST_CHUNK */
 
 #ifdef BUILD_PAGE_FIRST_CHUNK
+#include <asm/pgalloc.h>
+
+#ifndef P4D_TABLE_SIZE
+#define P4D_TABLE_SIZE PAGE_SIZE
+#endif
+
+#ifndef PUD_TABLE_SIZE
+#define PUD_TABLE_SIZE PAGE_SIZE
+#endif
+
+#ifndef PMD_TABLE_SIZE
+#define PMD_TABLE_SIZE PAGE_SIZE
+#endif
+
+#ifndef PTE_TABLE_SIZE
+#define PTE_TABLE_SIZE PAGE_SIZE
+#endif
+void __init __weak pcpu_populate_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	if (pgd_none(*pgd)) {
+		p4d_t *new;
+
+		new = memblock_alloc(P4D_TABLE_SIZE, P4D_TABLE_SIZE);
+		if (!new)
+			goto err_alloc;
+		pgd_populate(&init_mm, pgd, new);
+	}
+
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d)) {
+		pud_t *new;
+
+		new = memblock_alloc(PUD_TABLE_SIZE, PUD_TABLE_SIZE);
+		if (!new)
+			goto err_alloc;
+		p4d_populate(&init_mm, p4d, new);
+	}
+
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud)) {
+		pmd_t *new;
+
+		new = memblock_alloc(PMD_TABLE_SIZE, PMD_TABLE_SIZE);
+		if (!new)
+			goto err_alloc;
+		pud_populate(&init_mm, pud, new);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd)) {
+		pte_t *new;
+
+		new = memblock_alloc(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
+		if (!new)
+			goto err_alloc;
+		pmd_populate_kernel(&init_mm, pmd, new);
+	}
+
+	return;
+
+err_alloc:
+	panic("%s: Failed to allocate memory\n", __func__);
+}
+
 /**
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @reserved_size: the size of reserved percpu area in bytes
  * @cpu_to_nd_fn: callback to convert cpu to it's node, optional
- * @populate_pte_fn: function to populate pte
  *
  * This is a helper to ease setting up page-remapped first percpu
  * chunk and can be called where pcpu_setup_first_chunk() is expected.
@@ -3189,9 +3257,7 @@ out_free:
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int __init pcpu_page_first_chunk(size_t reserved_size,
-				 pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn,
-				 pcpu_fc_populate_pte_fn_t populate_pte_fn)
+int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	static struct vm_struct vm;
 	struct pcpu_alloc_info *ai;
@@ -3255,7 +3321,7 @@ int __init pcpu_page_first_chunk(size_t
 			(unsigned long)vm.addr + unit * ai->unit_size;
 
 		for (i = 0; i < unit_pages; i++)
-			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
+			pcpu_populate_pte(unit_addr + (i << PAGE_SHIFT));
 
 		/* pte already populated, the following shouldn't fail */
 		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


