Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3299C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89AC0207EA
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595023175;
	bh=FL/NS1BJ1W0vSbu3yOPHzVCX9U89P03d1hUt0W/VEl4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aZufxL7LCo3hQPGkf+0QgQvwzF1/Z6QoyG6CyqojOCL2RzqeYt1EuaBb0nP7a4ax/
	 +cSOkOU25tDfpIjNTzypGtYWb4JLaBJ6X2vx4T7+HWqQnhkJfpRMEMbHfGYNLI7AIS
	 zOfWSutwz7VMzHTcau4nKTtUiMEY7rZpU/WZmDEs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGQV7f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgGQV7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:59:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 437F720775;
        Fri, 17 Jul 2020 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595023173;
        bh=FL/NS1BJ1W0vSbu3yOPHzVCX9U89P03d1hUt0W/VEl4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wGdluo0c4OBd8vVO199e+yECDo2+D5DqWQ3Arcv0RDRlzDatlK8uLfXjd3nhFo8gJ
         YkNUJNuId1WlOkvdamlRuOB0Iry709o2YUcyMsdK64LKD2FjL7xtJhRUQQrAVOYDfS
         rMYrVMnV9Bhd+9cHkZJuf+1gdq40fqUbC7bliTTI=
Date:   Fri, 17 Jul 2020 14:59:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org, bp@alien8.de,
        catalin.marinas@arm.com, corbet@lwn.net, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        fenghua.yu@intel.com, hpa@zytor.com, hsinyi@chromium.org,
        justin.he@arm.com, kirill.shutemov@linux.intel.com,
        luto@kernel.org, mark.rutland@arm.com, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        palmer@dabbelt.com, pasha.tatashin@soleen.com,
        paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org,
        robin.murphy@arm.com, rppt@linux.ibm.com, steve.capper@arm.com,
        tglx@linutronix.de, tony.luck@intel.com, will@kernel.org,
        willy@infradead.org, yuzhao@google.com
Subject:  +
 arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch added to -mm
 tree
Message-ID: <20200717215931.u6QTZaCVs%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: enable vmem_altmap support for vmemmap mappings
has been added to the -mm tree.  Its filename is
     arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: enable vmem_altmap support for vmemmap mappings

Device memory ranges when getting hot added into ZONE_DEVICE, might
require their vmemmap mapping's backing memory to be allocated from their
own range instead of consuming system memory.  This prevents large system
memory usage for potentially large device memory ranges.  Device driver
communicates this request via vmem_altmap structure.  Architecture needs
to take this request into account while creating and tearing down vemmmap
mappings.

This enables vmem_altmap support in vmemmap_populate() and vmemmap_free()
which includes vmemmap_populate_basepages() used for ARM64_16K_PAGES and
ARM64_64K_PAGES configs.

Link: http://lkml.kernel.org/r/1594004178-8861-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Jia He <justin.he@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   58 +++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 20 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings
+++ a/arch/arm64/mm/mmu.c
@@ -761,15 +761,20 @@ int kern_addr_valid(unsigned long addr)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static void free_hotplug_page_range(struct page *page, size_t size)
+static void free_hotplug_page_range(struct page *page, size_t size,
+				    struct vmem_altmap *altmap)
 {
-	WARN_ON(PageReserved(page));
-	free_pages((unsigned long)page_address(page), get_order(size));
+	if (altmap) {
+		vmem_altmap_free(altmap, size >> PAGE_SHIFT);
+	} else {
+		WARN_ON(PageReserved(page));
+		free_pages((unsigned long)page_address(page), get_order(size));
+	}
 }
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	free_hotplug_page_range(page, PAGE_SIZE);
+	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
@@ -792,7 +797,8 @@ static bool pgtable_range_aligned(unsign
 }
 
 static void unmap_hotplug_pte_range(pmd_t *pmdp, unsigned long addr,
-				    unsigned long end, bool free_mapped)
+				    unsigned long end, bool free_mapped,
+				    struct vmem_altmap *altmap)
 {
 	pte_t *ptep, pte;
 
@@ -806,12 +812,14 @@ static void unmap_hotplug_pte_range(pmd_
 		pte_clear(&init_mm, addr, ptep);
 		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 		if (free_mapped)
-			free_hotplug_page_range(pte_page(pte), PAGE_SIZE);
+			free_hotplug_page_range(pte_page(pte),
+						PAGE_SIZE, altmap);
 	} while (addr += PAGE_SIZE, addr < end);
 }
 
 static void unmap_hotplug_pmd_range(pud_t *pudp, unsigned long addr,
-				    unsigned long end, bool free_mapped)
+				    unsigned long end, bool free_mapped,
+				    struct vmem_altmap *altmap)
 {
 	unsigned long next;
 	pmd_t *pmdp, pmd;
@@ -834,16 +842,17 @@ static void unmap_hotplug_pmd_range(pud_
 			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 			if (free_mapped)
 				free_hotplug_page_range(pmd_page(pmd),
-							PMD_SIZE);
+							PMD_SIZE, altmap);
 			continue;
 		}
 		WARN_ON(!pmd_table(pmd));
-		unmap_hotplug_pte_range(pmdp, addr, next, free_mapped);
+		unmap_hotplug_pte_range(pmdp, addr, next, free_mapped, altmap);
 	} while (addr = next, addr < end);
 }
 
 static void unmap_hotplug_pud_range(p4d_t *p4dp, unsigned long addr,
-				    unsigned long end, bool free_mapped)
+				    unsigned long end, bool free_mapped,
+				    struct vmem_altmap *altmap)
 {
 	unsigned long next;
 	pud_t *pudp, pud;
@@ -866,16 +875,17 @@ static void unmap_hotplug_pud_range(p4d_
 			flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 			if (free_mapped)
 				free_hotplug_page_range(pud_page(pud),
-							PUD_SIZE);
+							PUD_SIZE, altmap);
 			continue;
 		}
 		WARN_ON(!pud_table(pud));
-		unmap_hotplug_pmd_range(pudp, addr, next, free_mapped);
+		unmap_hotplug_pmd_range(pudp, addr, next, free_mapped, altmap);
 	} while (addr = next, addr < end);
 }
 
 static void unmap_hotplug_p4d_range(pgd_t *pgdp, unsigned long addr,
-				    unsigned long end, bool free_mapped)
+				    unsigned long end, bool free_mapped,
+				    struct vmem_altmap *altmap)
 {
 	unsigned long next;
 	p4d_t *p4dp, p4d;
@@ -888,16 +898,24 @@ static void unmap_hotplug_p4d_range(pgd_
 			continue;
 
 		WARN_ON(!p4d_present(p4d));
-		unmap_hotplug_pud_range(p4dp, addr, next, free_mapped);
+		unmap_hotplug_pud_range(p4dp, addr, next, free_mapped, altmap);
 	} while (addr = next, addr < end);
 }
 
 static void unmap_hotplug_range(unsigned long addr, unsigned long end,
-				bool free_mapped)
+				bool free_mapped, struct vmem_altmap *altmap)
 {
 	unsigned long next;
 	pgd_t *pgdp, pgd;
 
+	/*
+	 * altmap can only be used as vmemmap mapping backing memory.
+	 * In case the backing memory itself is not being freed, then
+	 * altmap is irrelevant. Warn about this inconsistency when
+	 * encountered.
+	 */
+	WARN_ON(!free_mapped && altmap);
+
 	do {
 		next = pgd_addr_end(addr, end);
 		pgdp = pgd_offset_k(addr);
@@ -906,7 +924,7 @@ static void unmap_hotplug_range(unsigned
 			continue;
 
 		WARN_ON(!pgd_present(pgd));
-		unmap_hotplug_p4d_range(pgdp, addr, next, free_mapped);
+		unmap_hotplug_p4d_range(pgdp, addr, next, free_mapped, altmap);
 	} while (addr = next, addr < end);
 }
 
@@ -1070,7 +1088,7 @@ static void free_empty_tables(unsigned l
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_basepages(start, end, node, NULL);
+	return vmemmap_populate_basepages(start, end, node, altmap);
 }
 #else	/* !ARM64_SWAPPER_USES_SECTION_MAPS */
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
@@ -1102,7 +1120,7 @@ int __meminit vmemmap_populate(unsigned
 		if (pmd_none(READ_ONCE(*pmdp))) {
 			void *p = NULL;
 
-			p = vmemmap_alloc_block_buf(PMD_SIZE, node, NULL);
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
 			if (!p)
 				return -ENOMEM;
 
@@ -1120,7 +1138,7 @@ void vmemmap_free(unsigned long start, u
 #ifdef CONFIG_MEMORY_HOTPLUG
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
 
-	unmap_hotplug_range(start, end, true);
+	unmap_hotplug_range(start, end, true, altmap);
 	free_empty_tables(start, end, VMEMMAP_START, VMEMMAP_END);
 #endif
 }
@@ -1411,7 +1429,7 @@ static void __remove_pgd_mapping(pgd_t *
 	WARN_ON(pgdir != init_mm.pgd);
 	WARN_ON((start < PAGE_OFFSET) || (end > PAGE_END));
 
-	unmap_hotplug_range(start, end, false);
+	unmap_hotplug_range(start, end, false, NULL);
 	free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
 }
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers-v5.patch
mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch
mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch
arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch
mm-vmstat-add-events-for-thp-migration-without-split.patch

