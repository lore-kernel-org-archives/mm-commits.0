Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334E6C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08EF220739
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595023165;
	bh=AdEjSysbBUtDuM4mq+NSo8PX79U4dEwbhppRiLyr9sc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BpIdJLpYDvfbvlVfYaIH8x8hGmxGWF6VDEjdsymU3wZWozTPVbGATjymc1G5/mPfs
	 G6GGrGmbzZJhajJMlNhSqg1pulxGKUfQRaB8VFLHdyyGckOsVTbLVSFId3x3EM+is2
	 MfVIDrtt2IMjQj9yxP1tzXbwNE/iZY7BbROQtBgk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGQV7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgGQV7Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:59:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5670D2070A;
        Fri, 17 Jul 2020 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595023163;
        bh=AdEjSysbBUtDuM4mq+NSo8PX79U4dEwbhppRiLyr9sc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VdkuxyhExLOORlhnncg7JutGdd+yfqbmo0TqN0GQF3jzzaxY2Necynnbk8tBtaWva
         uvD+3f1xSFQcOVEYvBOzMvRlcou3fxVPthZtpnsjKHf0zbIvdIsiFa5FOeep3vY2U7
         MzBGOoehUwdIro7vIw6oEoF6nKBHysMGJsWf8MK0=
Date:   Fri, 17 Jul 2020 14:59:21 -0700
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
 mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch
 added to -mm tree
Message-ID: <20200717215921.4ZhT-MPhM%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: enable vmem_altmap support in vmemmap_populate_basepages()
has been added to the -mm tree.  Its filename is
     mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch

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
Subject: mm/sparsemem: enable vmem_altmap support in vmemmap_populate_basepages()

Patch series "arm64: Enable vmemmap mapping from device memory", v4.

This series enables vmemmap backing memory allocation from device memory
ranges on arm64.  But before that, it enables vmemmap_populate_basepages()
and vmemmap_alloc_block_buf() to accommodate struct vmem_altmap based
alocation requests.


This patch (of 3):

vmemmap_populate_basepages() is used across platforms to allocate backing
memory for vmemmap mapping.  This is used as a standard default choice or
as a fallback when intended huge pages allocation fails.  This just
creates entire vmemmap mapping with base pages (PAGE_SIZE).

On arm64 platforms, vmemmap_populate_basepages() is called instead of the
platform specific vmemmap_populate() when ARM64_SWAPPER_USES_SECTION_MAPS
is not enabled as in case for ARM64_16K_PAGES and ARM64_64K_PAGES configs.

At present vmemmap_populate_basepages() does not support allocating from
driver defined struct vmem_altmap while trying to create vmemmap mapping
for a device memory range.  It prevents ARM64_16K_PAGES and
ARM64_64K_PAGES configs on arm64 from supporting device memory with
vmemap_altmap request.

This enables vmem_altmap support in vmemmap_populate_basepages() unlocking
device memory allocation for vmemap mapping on arm64 platforms with 16K or
64K base page configs.

Each architecture should evaluate and decide on subscribing device memory
based base page allocation through vmemmap_populate_basepages().  Hence
lets keep it disabled on all archs in order to preserve the existing
semantics.  A subsequent patch enables it on arm64.

Link: http://lkml.kernel.org/r/1594004178-8861-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1594004178-8861-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Jia He <justin.he@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c      |    2 +-
 arch/ia64/mm/discontig.c |    2 +-
 arch/riscv/mm/init.c     |    2 +-
 arch/x86/mm/init_64.c    |    6 +++---
 include/linux/mm.h       |    5 +++--
 mm/sparse-vmemmap.c      |   16 +++++++++++-----
 6 files changed, 20 insertions(+), 13 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/arch/arm64/mm/mmu.c
@@ -1070,7 +1070,7 @@ static void free_empty_tables(unsigned l
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_basepages(start, end, node);
+	return vmemmap_populate_basepages(start, end, node, NULL);
 }
 #else	/* !ARM64_SWAPPER_USES_SECTION_MAPS */
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
--- a/arch/ia64/mm/discontig.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/arch/ia64/mm/discontig.c
@@ -655,7 +655,7 @@ void arch_refresh_nodedata(int update_no
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_basepages(start, end, node);
+	return vmemmap_populate_basepages(start, end, node, NULL);
 }
 
 void vmemmap_free(unsigned long start, unsigned long end,
--- a/arch/riscv/mm/init.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/arch/riscv/mm/init.c
@@ -530,6 +530,6 @@ void __init paging_init(void)
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 			       struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_basepages(start, end, node);
+	return vmemmap_populate_basepages(start, end, node, NULL);
 }
 #endif
--- a/arch/x86/mm/init_64.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/arch/x86/mm/init_64.c
@@ -1493,7 +1493,7 @@ static int __meminit vmemmap_populate_hu
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
 			continue;
 		}
-		if (vmemmap_populate_basepages(addr, next, node))
+		if (vmemmap_populate_basepages(addr, next, node, NULL))
 			return -ENOMEM;
 	}
 	return 0;
@@ -1505,7 +1505,7 @@ int __meminit vmemmap_populate(unsigned
 	int err;
 
 	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
-		err = vmemmap_populate_basepages(start, end, node);
+		err = vmemmap_populate_basepages(start, end, node, NULL);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
 		err = vmemmap_populate_hugepages(start, end, node, altmap);
 	else if (altmap) {
@@ -1513,7 +1513,7 @@ int __meminit vmemmap_populate(unsigned
 				__func__);
 		err = -ENOMEM;
 	} else
-		err = vmemmap_populate_basepages(start, end, node);
+		err = vmemmap_populate_basepages(start, end, node, NULL);
 	if (!err)
 		sync_global_pgds(start, end - 1);
 	return err;
--- a/include/linux/mm.h~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/include/linux/mm.h
@@ -2968,14 +2968,15 @@ pgd_t *vmemmap_pgd_populate(unsigned lon
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
-pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node);
+pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+			    struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node);
 void *altmap_alloc_block_buf(unsigned long size, struct vmem_altmap *altmap);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
-			       int node);
+			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
 void vmemmap_populate_print_last(void);
--- a/mm/sparse-vmemmap.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages
+++ a/mm/sparse-vmemmap.c
@@ -139,12 +139,18 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
-pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
+pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+				       struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
-		void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
+		void *p;
+
+		if (altmap)
+			p = altmap_alloc_block_buf(PAGE_SIZE, altmap);
+		else
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
@@ -212,8 +218,8 @@ pgd_t * __meminit vmemmap_pgd_populate(u
 	return pgd;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start,
-					 unsigned long end, int node)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	unsigned long addr = start;
 	pgd_t *pgd;
@@ -235,7 +241,7 @@ int __meminit vmemmap_populate_basepages
 		pmd = vmemmap_pmd_populate(pud, addr, node);
 		if (!pmd)
 			return -ENOMEM;
-		pte = vmemmap_pte_populate(pmd, addr, node);
+		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
 		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
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

