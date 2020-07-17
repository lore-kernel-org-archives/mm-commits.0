Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C698C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96D120775
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595023170;
	bh=uyfG/ozMcNMiNaSSLczb5s4k9MbUrqBiTJrLOwjcDgA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qRCOyxpP9+lRNN+gwK9KXTwe0FgEmHZN+Hv6vPvGc6iSNVCddrr4YN1EwOnkop7Nl
	 j0ytf7HEIPiHejttL2BHa2vomZ/sNYMeUZTSTHKlYcXlmgKV2YoDyKVUnXUr31lFz3
	 mI2bMs+/dSpSHqI9lYjpQViEfcJfx6V0gdjiGdYM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGQV73 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgGQV73 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:59:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A52920739;
        Fri, 17 Jul 2020 21:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595023168;
        bh=uyfG/ozMcNMiNaSSLczb5s4k9MbUrqBiTJrLOwjcDgA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zwk/z74yr64GVyi5uYYI4ad3TVqertSTjiAKhceQ//pLzP8kYm+nenBmHtacagevV
         byOUUF1soDNwsWq7RaLcocPMGkVg+nXfEkRyc10zGLBOYn71lwlLuFvB1rF0X1Nb1J
         RLPBPxBwTnH2c8ZCIJxFtC4H0PyawjKkdj8gJnhA=
Date:   Fri, 17 Jul 2020 14:59:26 -0700
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
 mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch
 added to -mm tree
Message-ID: <20200717215926.bvv3Kx0q2%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: enable vmem_altmap support in vmemmap_alloc_block_buf()
has been added to the -mm tree.  Its filename is
     mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch

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
Subject: mm/sparsemem: enable vmem_altmap support in vmemmap_alloc_block_buf()

There are many instances where vmemap allocation is often switched between
regular memory and device memory just based on whether altmap is available
or not.  vmemmap_alloc_block_buf() is used in various platforms to
allocate vmemmap mappings.  Lets also enable it to handle altmap based
device memory allocation along with existing regular memory allocations. 
This will help in avoiding the altmap based allocation switch in many
places.  To summarize there are two different methods to call
vmemmap_alloc_block_buf().

vmemmap_alloc_block_buf(size, node, NULL)   /* Allocate from system RAM */
vmemmap_alloc_block_buf(size, node, altmap) /* Allocate from altmap */

This converts altmap_alloc_block_buf() into a static function, drops it's
entry from the header and updates Documentation/vm/memory-model.rst.

Link: http://lkml.kernel.org/r/1594004178-8861-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Jia He <justin.he@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Will Deacon <will@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/memory-model.rst |    2 +-
 arch/arm64/mm/mmu.c               |    2 +-
 arch/powerpc/mm/init_64.c         |    4 ++--
 arch/x86/mm/init_64.c             |    5 +----
 include/linux/mm.h                |    4 ++--
 mm/sparse-vmemmap.c               |   28 +++++++++++++---------------
 6 files changed, 20 insertions(+), 25 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/arch/arm64/mm/mmu.c
@@ -1102,7 +1102,7 @@ int __meminit vmemmap_populate(unsigned
 		if (pmd_none(READ_ONCE(*pmdp))) {
 			void *p = NULL;
 
-			p = vmemmap_alloc_block_buf(PMD_SIZE, node);
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node, NULL);
 			if (!p)
 				return -ENOMEM;
 
--- a/arch/powerpc/mm/init_64.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/arch/powerpc/mm/init_64.c
@@ -225,12 +225,12 @@ int __meminit vmemmap_populate(unsigned
 		 * fall back to system memory if the altmap allocation fail.
 		 */
 		if (altmap && !altmap_cross_boundary(altmap, start, page_size)) {
-			p = altmap_alloc_block_buf(page_size, altmap);
+			p = vmemmap_alloc_block_buf(page_size, node, altmap);
 			if (!p)
 				pr_debug("altmap block allocation failed, falling back to system memory");
 		}
 		if (!p)
-			p = vmemmap_alloc_block_buf(page_size, node);
+			p = vmemmap_alloc_block_buf(page_size, node, NULL);
 		if (!p)
 			return -ENOMEM;
 
--- a/arch/x86/mm/init_64.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/arch/x86/mm/init_64.c
@@ -1463,10 +1463,7 @@ static int __meminit vmemmap_populate_hu
 		if (pmd_none(*pmd)) {
 			void *p;
 
-			if (altmap)
-				p = altmap_alloc_block_buf(PMD_SIZE, altmap);
-			else
-				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
+			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
 			if (p) {
 				pte_t entry;
 
--- a/Documentation/vm/memory-model.rst~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/Documentation/vm/memory-model.rst
@@ -178,7 +178,7 @@ for persistent memory devices in pre-all
 devices. This storage is represented with :c:type:`struct vmem_altmap`
 that is eventually passed to vmemmap_populate() through a long chain
 of function calls. The vmemmap_populate() implementation may use the
-`vmem_altmap` along with :c:func:`altmap_alloc_block_buf` helper to
+`vmem_altmap` along with :c:func:`vmemmap_alloc_block_buf` helper to
 allocate memory map on the persistent memory device.
 
 ZONE_DEVICE
--- a/include/linux/mm.h~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/include/linux/mm.h
@@ -2972,8 +2972,8 @@ pte_t *vmemmap_pte_populate(pmd_t *pmd,
 			    struct vmem_altmap *altmap);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
-void *vmemmap_alloc_block_buf(unsigned long size, int node);
-void *altmap_alloc_block_buf(unsigned long size, struct vmem_altmap *altmap);
+void *vmemmap_alloc_block_buf(unsigned long size, int node,
+			      struct vmem_altmap *altmap);
 void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
--- a/mm/sparse-vmemmap.c~mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf
+++ a/mm/sparse-vmemmap.c
@@ -69,11 +69,19 @@ void * __meminit vmemmap_alloc_block(uns
 				__pa(MAX_DMA_ADDRESS));
 }
 
+static void * __meminit altmap_alloc_block_buf(unsigned long size,
+					       struct vmem_altmap *altmap);
+
 /* need to make sure size is all the same during early stage */
-void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node)
+void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node,
+					 struct vmem_altmap *altmap)
 {
-	void *ptr = sparse_buffer_alloc(size);
+	void *ptr;
+
+	if (altmap)
+		return altmap_alloc_block_buf(size, altmap);
 
+	ptr = sparse_buffer_alloc(size);
 	if (!ptr)
 		ptr = vmemmap_alloc_block(size, node);
 	return ptr;
@@ -94,15 +102,8 @@ static unsigned long __meminit vmem_altm
 	return 0;
 }
 
-/**
- * altmap_alloc_block_buf - allocate pages from the device page map
- * @altmap:	device page map
- * @size:	size (in bytes) of the allocation
- *
- * Allocations are aligned to the size of the request.
- */
-void * __meminit altmap_alloc_block_buf(unsigned long size,
-		struct vmem_altmap *altmap)
+static void * __meminit altmap_alloc_block_buf(unsigned long size,
+					       struct vmem_altmap *altmap)
 {
 	unsigned long pfn, nr_pfns, nr_align;
 
@@ -147,10 +148,7 @@ pte_t * __meminit vmemmap_pte_populate(p
 		pte_t entry;
 		void *p;
 
-		if (altmap)
-			p = altmap_alloc_block_buf(PAGE_SIZE, altmap);
-		else
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node);
+		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 		if (!p)
 			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
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

