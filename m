Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2042EF65A
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372358; cv=none; b=qqPfkoYEWdn2AMEu+dptKEXQ9glFAvck0DoI8UuuXt7zrQMfAvgBZxWKPu85s14fsm3V6IIBmYOz7o6/BFQUugXetZgvM/mPmI08Hoh3U0hHVks6h8JOz39+qla6lvcMPC/5l0gFgaE5Vavl8hf466J6Z82PlGSYICcADCRLUi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372358; c=relaxed/simple;
	bh=c1lZLRA/cmVZkT3MkIRxz7WnaOzzNRlxre3MX5JaSJ4=;
	h=Date:To:From:Subject:Message-Id; b=rFgeLtMP8DUfXluROMQWSN6oCMfmW8R2ymn5LKZI6MGiAUwOLKnuvqTKhEaO8tX2b16OMzyqEm40m0vVfBHHtpu/lRTdR6syjFDKs5piOcsjeyJbXJfsz4bephUVyWVwjJIv/gyfB5ypKWQDUdkpfqSVVPtD+J/qZQNna60DM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSQz0qMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSQz0qMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A522C4CEF7;
	Mon,  8 Sep 2025 22:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372356;
	bh=c1lZLRA/cmVZkT3MkIRxz7WnaOzzNRlxre3MX5JaSJ4=;
	h=Date:To:From:Subject:From;
	b=jSQz0qMJtOMS2dTaPuN0/CRZzecFdmJUn15J4YaeVFkrRcxi3yT8WhUsXFQzjoOBr
	 UOyJym3sYRCujtrynQzWmZ+gFkWE/a8+IbuSr+fhVAA1+teqhWa610MVfRC8Ykf+Ze
	 urdgmvqdTGr6ABpUQkNYvqzMLIY39x2wA1cE1cgo=
Date: Mon, 08 Sep 2025 15:59:15 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptdesc-remove-ptdesc_to_virt.patch added to mm-new branch
Message-Id: <20250908225916.6A522C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ptdesc: remove ptdesc_to_virt()
has been added to the -mm mm-new branch.  Its filename is
     ptdesc-remove-ptdesc_to_virt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptdesc-remove-ptdesc_to_virt.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ptdesc: remove ptdesc_to_virt()
Date: Mon, 8 Sep 2025 18:11:02 +0100

This has the same effect as ptdesc_address() so convert the callers to use
that and delete the function.  Add kernel-doc for ptdesc_address().

Link: https://lkml.kernel.org/r/20250908171104.2409217-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c      |    2 +-
 arch/s390/mm/pgalloc.c |    6 +++---
 include/linux/mm.h     |   11 ++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/arm/mm/mmu.c~ptdesc-remove-ptdesc_to_virt
+++ a/arch/arm/mm/mmu.c
@@ -737,7 +737,7 @@ static void *__init late_alloc(unsigned
 
 	if (!ptdesc || !pagetable_pte_ctor(NULL, ptdesc))
 		BUG();
-	return ptdesc_to_virt(ptdesc);
+	return ptdesc_address(ptdesc);
 }
 
 static pte_t * __init arm_pte_alloc(pmd_t *pmd, unsigned long addr,
--- a/arch/s390/mm/pgalloc.c~ptdesc-remove-ptdesc_to_virt
+++ a/arch/s390/mm/pgalloc.c
@@ -21,7 +21,7 @@ unsigned long *crst_table_alloc(struct m
 
 	if (!ptdesc)
 		return NULL;
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1UL << CRST_ALLOC_ORDER);
 	return table;
 }
@@ -119,7 +119,7 @@ struct ptdesc *page_table_alloc_pgste(st
 
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (ptdesc) {
-		table = (u64 *)ptdesc_to_virt(ptdesc);
+		table = (u64 *)ptdesc_address(ptdesc);
 		__arch_set_page_dat(table, 1);
 		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
@@ -146,7 +146,7 @@ unsigned long *page_table_alloc(struct m
 		pagetable_free(ptdesc);
 		return NULL;
 	}
-	table = ptdesc_to_virt(ptdesc);
+	table = ptdesc_address(ptdesc);
 	__arch_set_page_dat(table, 1);
 	memset64((u64 *)table, _PAGE_INVALID, PTRS_PER_PTE);
 	memset64((u64 *)table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
--- a/include/linux/mm.h~ptdesc-remove-ptdesc_to_virt
+++ a/include/linux/mm.h
@@ -2944,11 +2944,12 @@ static inline struct ptdesc *virt_to_ptd
 	return page_ptdesc(virt_to_page(x));
 }
 
-static inline void *ptdesc_to_virt(const struct ptdesc *pt)
-{
-	return page_to_virt(ptdesc_page(pt));
-}
-
+/**
+ * ptdesc_address - Virtual address of page table.
+ * @pt: Page table descriptor.
+ *
+ * Return: The first byte of the page table described by @pt.
+ */
 static inline void *ptdesc_address(const struct ptdesc *pt)
 {
 	return folio_address(ptdesc_folio(pt));
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch
mm-remove-mlock_count-from-struct-page.patch
ptdesc-convert-__page_flags-to-pt_flags.patch
ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch
ptdesc-remove-ptdesc_to_virt.patch

