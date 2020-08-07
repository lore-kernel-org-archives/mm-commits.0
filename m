Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01EBC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79FF022CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781408;
	bh=TQ5Ff4Ar0kztfOqZ4wnyCQsV6UFDRMfaNs+xp0sXu6k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=e1TDaBGohdF4UlomoE0WBzmgs+/nuM4QVXyPsBJ0MHMJ1nSbQxieOBOb4kH6wVb8f
	 iBMFIkmMbRE2M+vht6OkX0dkn70jrtzrqZPxhS105uWusddO30v7VSpfCdQ277y/e9
	 7f5wJhE8Tt8EDkNOydU2OnvJXFCFvJLSXO+w1jPE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgHGGX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1576E22CAF;
        Fri,  7 Aug 2020 06:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781406;
        bh=TQ5Ff4Ar0kztfOqZ4wnyCQsV6UFDRMfaNs+xp0sXu6k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KNSrLPmWoSPraKgP7hcEkgVacQM3XgZENAQeADvg8usCLyuKFDZ8ae1OO1y7+o9OM
         uSn5g3+qttrrgNudgfPmI4gHLWs4azlrOQztbE10s20BJMkFkJ+TYj0IyLvBtdRfvw
         m+ZfLSGZgGFBPtTg8ja6PjvMpnjbEKOaFzGRwo+4=
Date:   Thu, 06 Aug 2020 23:23:24 -0700
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
Subject:  [patch 110/163] mm/sparsemem: enable vmem_altmap support
 in vmemmap_alloc_block_buf()
Message-ID: <20200807062324.zHDQnOlwz%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1515,10 +1515,7 @@ static int __meminit vmemmap_populate_hu
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
@@ -2982,8 +2982,8 @@ pte_t *vmemmap_pte_populate(pmd_t *pmd,
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
