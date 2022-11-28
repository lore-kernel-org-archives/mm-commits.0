Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29D0C43217
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 23:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiK1XK3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiK1XKW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 18:10:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE4231DC6
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 15:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A381614DB
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 23:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF17BC433D6;
        Mon, 28 Nov 2022 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669677020;
        bh=PNwOZGQWDbawTzr5w+EPrkBG93hFvnqnpAoR/CB6dTk=;
        h=Date:To:From:Subject:From;
        b=jcHOptbsdIjPCEzN8JDvClThFR2ty4dxvUe6Dn82lCboByNI7PEDmQg47JUO1wTCs
         LwTkjfbtS6tDInI0MZhjHIVz8CKDwVf6PJXyDNpDkAHiAQ85WjL3K0Fizwuw8InNNq
         SgFAYpHsS5Ld/gNlgbZoMTRx/FTmuPVTYmpyEZ94=
Date:   Mon, 28 Nov 2022 15:10:19 -0800
To:     mm-commits@vger.kernel.org, zhoumin@loongson.cn, will@kernel.org,
        tsbogend@alpha.franken.de, songmuchun@bytedance.com,
        philmd@linaro.org, peterz@infradead.org, luto@kernel.org,
        lixuefeng@loongson.cn, kernel@xen0n.name, jiaxun.yang@flygoat.com,
        guoren@kernel.org, dinguyen@kernel.org,
        dave.hansen@linux.intel.com, chenhuacai@loongson.cn,
        catalin.marinas@arm.com, arnd@arndb.de, chenfeiyang@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages.patch added to mm-unstable branch
Message-Id: <20221128231020.AF17BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap: generalise vmemmap_populate_hugepages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages.patch

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
From: Feiyang Chen <chenfeiyang@loongson.cn>
Subject: mm/sparse-vmemmap: generalise vmemmap_populate_hugepages()
Date: Thu, 27 Oct 2022 20:52:52 +0800

Generalise vmemmap_populate_hugepages() so ARM64 & X86 & LoongArch can
share its implementation.

Link: https://lkml.kernel.org/r/20221027125253.3458989-4-chenhuacai@loongson.cn
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Min Zhou <zhoumin@loongson.cn>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Cc: Xuerui Wang <kernel@xen0n.name>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c      |   55 +++++---------------
 arch/loongarch/mm/init.c |   61 ++++++----------------
 arch/x86/mm/init_64.c    |  100 +++++++++++++------------------------
 include/linux/mm.h       |    6 ++
 mm/sparse-vmemmap.c      |   63 +++++++++++++++++++++++
 5 files changed, 137 insertions(+), 148 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages
+++ a/arch/arm64/mm/mmu.c
@@ -1137,53 +1137,28 @@ static void free_empty_tables(unsigned l
 }
 #endif
 
+void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
+			       unsigned long addr, unsigned long next)
+{
+	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
+}
+
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	vmemmap_verify((pte_t *)pmdp, node, addr, next);
+	return 1;
+}
+
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-	unsigned long addr = start;
-	unsigned long next;
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 
 	if (!ARM64_KERNEL_USES_PMD_MAPS)
 		return vmemmap_populate_basepages(start, end, node, altmap);
-
-	do {
-		next = pmd_addr_end(addr, end);
-
-		pgdp = vmemmap_pgd_populate(addr, node);
-		if (!pgdp)
-			return -ENOMEM;
-
-		p4dp = vmemmap_p4d_populate(pgdp, addr, node);
-		if (!p4dp)
-			return -ENOMEM;
-
-		pudp = vmemmap_pud_populate(p4dp, addr, node);
-		if (!pudp)
-			return -ENOMEM;
-
-		pmdp = pmd_offset(pudp, addr);
-		if (pmd_none(READ_ONCE(*pmdp))) {
-			void *p = NULL;
-
-			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
-			if (!p) {
-				if (vmemmap_populate_basepages(addr, next, node, altmap))
-					return -ENOMEM;
-				continue;
-			}
-
-			pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
-		} else
-			vmemmap_verify((pte_t *)pmdp, node, addr, next);
-	} while (addr = next, addr != end);
-
-	return 0;
+	else
+		return vmemmap_populate_hugepages(start, end, node, altmap);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
--- a/arch/loongarch/mm/init.c~mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages
+++ a/arch/loongarch/mm/init.c
@@ -153,52 +153,25 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-						int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
-	unsigned long addr = start;
-	unsigned long next;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	for (addr = start; addr < end; addr = next) {
-		next = pmd_addr_end(addr, end);
-
-		pgd = vmemmap_pgd_populate(addr, node);
-		if (!pgd)
-			return -ENOMEM;
-		p4d = vmemmap_p4d_populate(pgd, addr, node);
-		if (!p4d)
-			return -ENOMEM;
-		pud = vmemmap_pud_populate(p4d, addr, node);
-		if (!pud)
-			return -ENOMEM;
-
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			void *p = NULL;
-
-			p = vmemmap_alloc_block_buf(PMD_SIZE, node, NULL);
-			if (p) {
-				pmd_t entry;
-
-				entry = pfn_pmd(virt_to_pfn(p), PAGE_KERNEL);
-				pmd_val(entry) |= _PAGE_HUGE | _PAGE_HGLOBAL;
-				set_pmd_at(&init_mm, addr, pmd, entry);
-
-				continue;
-			}
-		} else if (pmd_val(*pmd) & _PAGE_HUGE) {
-			vmemmap_verify((pte_t *)pmd, node, addr, next);
-			continue;
-		}
-		if (vmemmap_populate_basepages(addr, next, node, NULL))
-			return -ENOMEM;
-	}
+	pmd_t entry;
 
-	return 0;
+	entry = pfn_pmd(virt_to_pfn(p), PAGE_KERNEL);
+	pmd_val(entry) |= _PAGE_HUGE | _PAGE_HGLOBAL;
+	set_pmd_at(&init_mm, addr, pmd, entry);
+}
+
+int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
+				unsigned long addr, unsigned long next)
+{
+	int huge = pmd_val(*pmd) & _PAGE_HUGE;
+
+	if (huge)
+		vmemmap_verify((pte_t *)pmd, node, addr, next);
+
+	return huge;
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
--- a/arch/x86/mm/init_64.c~mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages
+++ a/arch/x86/mm/init_64.c
@@ -1492,72 +1492,44 @@ static long __meminitdata addr_start, ad
 static void __meminitdata *p_start, *p_end;
 static int __meminitdata node_start;
 
-static int __meminit vmemmap_populate_hugepages(unsigned long start,
-		unsigned long end, int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
-	unsigned long addr;
-	unsigned long next;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	for (addr = start; addr < end; addr = next) {
-		next = pmd_addr_end(addr, end);
-
-		pgd = vmemmap_pgd_populate(addr, node);
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, addr, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, addr, node);
-		if (!pud)
-			return -ENOMEM;
-
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			void *p;
-
-			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
-			if (p) {
-				pte_t entry;
-
-				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-						PAGE_KERNEL_LARGE);
-				set_pmd(pmd, __pmd(pte_val(entry)));
-
-				/* check to see if we have contiguous blocks */
-				if (p_end != p || node_start != node) {
-					if (p_start)
-						pr_debug(" [%lx-%lx] PMD -> [%p-%p] on node %d\n",
-						       addr_start, addr_end-1, p_start, p_end-1, node_start);
-					addr_start = addr;
-					node_start = node;
-					p_start = p;
-				}
-
-				addr_end = addr + PMD_SIZE;
-				p_end = p + PMD_SIZE;
-
-				if (!IS_ALIGNED(addr, PMD_SIZE) ||
-				    !IS_ALIGNED(next, PMD_SIZE))
-					vmemmap_use_new_sub_pmd(addr, next);
-
-				continue;
-			} else if (altmap)
-				return -ENOMEM; /* no fallback */
-		} else if (pmd_large(*pmd)) {
-			vmemmap_verify((pte_t *)pmd, node, addr, next);
-			vmemmap_use_sub_pmd(addr, next);
-			continue;
-		}
-		if (vmemmap_populate_basepages(addr, next, node, NULL))
-			return -ENOMEM;
+	pte_t entry;
+
+	entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+			PAGE_KERNEL_LARGE);
+	set_pmd(pmd, __pmd(pte_val(entry)));
+
+	/* check to see if we have contiguous blocks */
+	if (p_end != p || node_start != node) {
+		if (p_start)
+			pr_debug(" [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+				addr_start, addr_end-1, p_start, p_end-1, node_start);
+		addr_start = addr;
+		node_start = node;
+		p_start = p;
 	}
-	return 0;
+
+	addr_end = addr + PMD_SIZE;
+	p_end = p + PMD_SIZE;
+
+	if (!IS_ALIGNED(addr, PMD_SIZE) ||
+		!IS_ALIGNED(next, PMD_SIZE))
+		vmemmap_use_new_sub_pmd(addr, next);
+}
+
+int __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
+				unsigned long addr, unsigned long next)
+{
+	int large = pmd_large(*pmd);
+
+	if (pmd_large(*pmd)) {
+		vmemmap_verify((pte_t *)pmd, node, addr, next);
+		vmemmap_use_sub_pmd(addr, next);
+	}
+
+	return large;
 }
 
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
--- a/include/linux/mm.h~mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages
+++ a/include/linux/mm.h
@@ -3343,8 +3343,14 @@ struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
 			      struct vmem_altmap *altmap);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
+void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+		     unsigned long addr, unsigned long next);
+int vmemmap_check_pmd(pmd_t *pmd, int node,
+		      unsigned long addr, unsigned long next);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
+int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
+			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
 void vmemmap_populate_print_last(void);
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages
+++ a/mm/sparse-vmemmap.c
@@ -295,6 +295,69 @@ int __meminit vmemmap_populate_basepages
 	return vmemmap_populate_range(start, end, node, altmap, NULL);
 }
 
+void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+				      unsigned long addr, unsigned long next)
+{
+}
+
+int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
+				       unsigned long addr, unsigned long next)
+{
+	return 0;
+}
+
+int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
+{
+	unsigned long addr;
+	unsigned long next;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	for (addr = start; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+
+		p4d = vmemmap_p4d_populate(pgd, addr, node);
+		if (!p4d)
+			return -ENOMEM;
+
+		pud = vmemmap_pud_populate(p4d, addr, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(READ_ONCE(*pmd))) {
+			void *p;
+
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
+			if (p) {
+				vmemmap_set_pmd(pmd, p, node, addr, next);
+				continue;
+			} else if (altmap) {
+				/*
+				 * No fallback: In any case we care about, the
+				 * altmap should be reasonably sized and aligned
+				 * such that vmemmap_alloc_block_buf() will always
+				 * succeed. For consistency with the PTE case,
+				 * return an error here as failure could indicate
+				 * a configuration issue with the size of the altmap.
+				 */
+				return -ENOMEM;
+			}
+		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+			continue;
+		if (vmemmap_populate_basepages(addr, next, node, altmap))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 /*
  * For compound pages bigger than section size (e.g. x86 1G compound
  * pages with 2M subsection size) fill the rest of sections as tail
_

Patches currently in -mm which might be from chenfeiyang@loongson.cn are

mipsloongarchnios2-adjust-prototypes-of-pd_init.patch
loongarch-add-sparse-memory-vmemmap-support.patch
mm-sparse-vmemmap-generalise-vmemmap_populate_hugepages.patch
loongarch-enable-arch_want_hugetlb_page_optimize_vmemmap.patch

