Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AEFC433E4
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A71322C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781418;
	bh=BYgXQkk0YpzEpZs+H3DKrPqJ+d4D9s9TZ2WNsBZkKLc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Hug34+mOSEoGbZyn381HFKN+aiTjQt/jaIB+koRKsOwoV1moIMWxUPBRz2TBNd6ou
	 e10DB+jAW8Cla7tvfd+zMAl0YYWoTpZPz5AtRp3cTSfA9pKpVF52cACNGjY+uU/aC3
	 JIZuSdW70xX2nJk+7azsWGr/a3u3KdsrZF1rbV3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGXh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgHGGXc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D19B22D08;
        Fri,  7 Aug 2020 06:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781411;
        bh=BYgXQkk0YpzEpZs+H3DKrPqJ+d4D9s9TZ2WNsBZkKLc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W4GaR8ddiWZDruadX5ttkBapGc0cNgg/r1aSsJi5AA+MbQWj69HHWqBi0/CY42/X7
         Kgrgdx/JhCSGCH8WO4sbFh4yn/A4paKw7UMa85aSIxyh25uyGVskCP0BYzS/owGkV9
         UcQKNUNLlP8GoK+m5ixI9CK6p5TAKuCovDr613pg=
Date:   Thu, 06 Aug 2020 23:23:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
        corbet@lwn.net, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        fenghua.yu@intel.com, hpa@zytor.com, hsinyi@chromium.org,
        justin.he@arm.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com,
        mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, pasha.tatashin@soleen.com,
        paul.walmsley@sifive.com, paulus@samba.org, peterz@infradead.org,
        robin.murphy@arm.com, rppt@linux.ibm.com, steve.capper@arm.com,
        tglx@linutronix.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, will@kernel.org,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 111/163] arm64/mm: enable vmem_altmap support for
 vmemmap mappings
Message-ID: <20200807062329.wUIkG4Im_%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
