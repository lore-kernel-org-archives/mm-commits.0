Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D8142E6F
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270764; cv=none; b=cSOrWZ0czzkKIFEM9AaJ6aO1zUZDO99B/B61klKSbzrlayM0EnzWxcB160iLvYxBNQdnDDQDZ6URA8ny3Bc/fFRwgUgZG4fH4RhxaKgmnNhTYNd+oIGpht5ka52g72uPIsAfhg/h1sOJZfYGzbIrza//tqmXaSgWVB+S69SHaUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270764; c=relaxed/simple;
	bh=qGpkVO1UbfxoayXKuKBeaPtjNh5JbdXfVcMucdBc8Nc=;
	h=Date:To:From:Subject:Message-Id; b=m6dS9wURvR9tQj9k3IsdDpq5JHJ5C8j0JzXNk31SMSprSk0y2c9quMxh0M2uvcJcBlYtoNOkfQPEMhW7NTLIHGpyb79wkFcfifk9MPqm4ISkc2C1ZDIOtUeq8M3ee8zo7pK+grcFXyyxS/OIOOlCp3/hcTn0SD1UHa9PqL3AHFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=an/3FEen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="an/3FEen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D14FC32781;
	Sat, 10 Aug 2024 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723270763;
	bh=qGpkVO1UbfxoayXKuKBeaPtjNh5JbdXfVcMucdBc8Nc=;
	h=Date:To:From:Subject:From;
	b=an/3FEenFvLNNV/W02l9prk3NeUUqRmZ0xVpKp4SgR/2t94t8Jjrki893YiHOK7fW
	 YQM+h+YYaz94E5kwz+dGGsZ73cZYxptOdbwGZzY6h216luPvFMzGTi92+fFYh0iKet
	 TCqVMWu3+I27O+BJlbYyQfob8B+ewuRr1zPm4Kg0=
Date: Fri, 09 Aug 2024 23:19:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rework-accept-memory-helpers.patch added to mm-unstable branch
Message-Id: <20240810061923.4D14FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rework accept memory helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rework-accept-memory-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rework-accept-memory-helpers.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rework accept memory helpers
Date: Fri, 9 Aug 2024 14:48:51 +0300

Make accept_memory() and range_contains_unaccepted_memory() take 'start'
and 'size' arguments instead of 'start' and 'end'.

Remove accept_page(), replacing it with direct calls to accept_memory(). 
The accept_page() name is going to be used for a different function.

Link: https://lkml.kernel.org/r/20240809114854.3745464-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/misc.c                  |    2 -
 arch/x86/boot/compressed/misc.h                  |    2 -
 drivers/firmware/efi/libstub/efistub.h           |    2 -
 drivers/firmware/efi/libstub/unaccepted_memory.c |    3 +-
 drivers/firmware/efi/unaccepted_memory.c         |   18 ++++++------
 include/linux/mm.h                               |   12 +++-----
 mm/memblock.c                                    |    2 -
 mm/mm_init.c                                     |    2 -
 mm/page_alloc.c                                  |   19 ++-----------
 tools/testing/memblock/internal.h                |    2 -
 10 files changed, 26 insertions(+), 38 deletions(-)

--- a/arch/x86/boot/compressed/misc.c~mm-rework-accept-memory-helpers
+++ a/arch/x86/boot/compressed/misc.c
@@ -511,7 +511,7 @@ asmlinkage __visible void *extract_kerne
 
 	if (init_unaccepted_memory()) {
 		debug_putstr("Accepting memory... ");
-		accept_memory(__pa(output), __pa(output) + needed_size);
+		accept_memory(__pa(output), needed_size);
 	}
 
 	entry_offset = decompress_kernel(output, virt_addr, error);
--- a/arch/x86/boot/compressed/misc.h~mm-rework-accept-memory-helpers
+++ a/arch/x86/boot/compressed/misc.h
@@ -256,6 +256,6 @@ static inline bool init_unaccepted_memor
 
 /* Defined in EFI stub */
 extern struct efi_unaccepted_memory *unaccepted_table;
-void accept_memory(phys_addr_t start, phys_addr_t end);
+void accept_memory(phys_addr_t start, unsigned long size);
 
 #endif /* BOOT_COMPRESSED_MISC_H */
--- a/drivers/firmware/efi/libstub/efistub.h~mm-rework-accept-memory-helpers
+++ a/drivers/firmware/efi/libstub/efistub.h
@@ -1229,7 +1229,7 @@ efi_zboot_entry(efi_handle_t handle, efi
 efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 					struct efi_boot_memmap *map);
 void process_unaccepted_memory(u64 start, u64 end);
-void accept_memory(phys_addr_t start, phys_addr_t end);
+void accept_memory(phys_addr_t start, unsigned long size);
 void arch_accept_memory(phys_addr_t start, phys_addr_t end);
 
 #endif
--- a/drivers/firmware/efi/libstub/unaccepted_memory.c~mm-rework-accept-memory-helpers
+++ a/drivers/firmware/efi/libstub/unaccepted_memory.c
@@ -177,9 +177,10 @@ void process_unaccepted_memory(u64 start
 		   start / unit_size, (end - start) / unit_size);
 }
 
-void accept_memory(phys_addr_t start, phys_addr_t end)
+void accept_memory(phys_addr_t start, unsigned long size)
 {
 	unsigned long range_start, range_end;
+	phys_addr_t end = start + size;
 	unsigned long bitmap_size;
 	u64 unit_size;
 
--- a/drivers/firmware/efi/unaccepted_memory.c~mm-rework-accept-memory-helpers
+++ a/drivers/firmware/efi/unaccepted_memory.c
@@ -30,11 +30,12 @@ static LIST_HEAD(accepting_list);
  *  - memory that is below phys_base;
  *  - memory that is above the memory that addressable by the bitmap;
  */
-void accept_memory(phys_addr_t start, phys_addr_t end)
+void accept_memory(phys_addr_t start, unsigned long size)
 {
 	struct efi_unaccepted_memory *unaccepted;
 	unsigned long range_start, range_end;
 	struct accept_range range, *entry;
+	phys_addr_t end = start + size;
 	unsigned long flags;
 	u64 unit_size;
 
@@ -74,13 +75,13 @@ void accept_memory(phys_addr_t start, ph
 	 * "guard" page is accepted in addition to the memory that needs to be
 	 * used:
 	 *
-	 * 1. Implicitly extend the range_contains_unaccepted_memory(start, end)
-	 *    checks up to end+unit_size if 'end' is aligned on a unit_size
-	 *    boundary.
+	 * 1. Implicitly extend the range_contains_unaccepted_memory(start, size)
+	 *    checks up to the next unit_size if 'start+size' is aligned on a
+	 *    unit_size boundary.
 	 *
-	 * 2. Implicitly extend accept_memory(start, end) to end+unit_size if
-	 *    'end' is aligned on a unit_size boundary. (immediately following
-	 *    this comment)
+	 * 2. Implicitly extend accept_memory(start, size) to the next unit_size
+	 *    if 'size+end' is aligned on a unit_size boundary. (immediately
+	 *    following this comment)
 	 */
 	if (!(end % unit_size))
 		end += unit_size;
@@ -156,9 +157,10 @@ retry:
 	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
 }
 
-bool range_contains_unaccepted_memory(phys_addr_t start, phys_addr_t end)
+bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 {
 	struct efi_unaccepted_memory *unaccepted;
+	phys_addr_t end = start + size;
 	unsigned long flags;
 	bool ret = false;
 	u64 unit_size;
--- a/include/linux/mm.h~mm-rework-accept-memory-helpers
+++ a/include/linux/mm.h
@@ -4062,18 +4062,18 @@ madvise_set_anon_name(struct mm_struct *
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 
-bool range_contains_unaccepted_memory(phys_addr_t start, phys_addr_t end);
-void accept_memory(phys_addr_t start, phys_addr_t end);
+bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
+void accept_memory(phys_addr_t start, unsigned long size);
 
 #else
 
 static inline bool range_contains_unaccepted_memory(phys_addr_t start,
-						    phys_addr_t end)
+						    unsigned long size)
 {
 	return false;
 }
 
-static inline void accept_memory(phys_addr_t start, phys_addr_t end)
+static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
@@ -4081,9 +4081,7 @@ static inline void accept_memory(phys_ad
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
 {
-	phys_addr_t paddr = pfn << PAGE_SHIFT;
-
-	return range_contains_unaccepted_memory(paddr, paddr + PAGE_SIZE);
+	return range_contains_unaccepted_memory(pfn << PAGE_SHIFT, PAGE_SIZE);
 }
 
 void vma_pgtable_walk_begin(struct vm_area_struct *vma);
--- a/mm/memblock.c~mm-rework-accept-memory-helpers
+++ a/mm/memblock.c
@@ -1500,7 +1500,7 @@ done:
 	 *
 	 * Accept the memory of the allocated buffer.
 	 */
-	accept_memory(found, found + size);
+	accept_memory(found, size);
 
 	return found;
 }
--- a/mm/mm_init.c~mm-rework-accept-memory-helpers
+++ a/mm/mm_init.c
@@ -1933,7 +1933,7 @@ static void __init deferred_free_pages(u
 	}
 
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
-	accept_memory(PFN_PHYS(pfn), PFN_PHYS(pfn + nr_pages));
+	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
--- a/mm/page_alloc.c~mm-rework-accept-memory-helpers
+++ a/mm/page_alloc.c
@@ -286,7 +286,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
-static void accept_page(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order);
 static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
@@ -1268,7 +1267,7 @@ void __meminit __free_pages_core(struct
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;
 
-		accept_page(page, order);
+		accept_memory(page_to_phys(page), PAGE_SIZE << order);
 	}
 
 	/*
@@ -6941,16 +6940,8 @@ early_param("accept_memory", accept_memo
 static bool page_contains_unaccepted(struct page *page, unsigned int order)
 {
 	phys_addr_t start = page_to_phys(page);
-	phys_addr_t end = start + (PAGE_SIZE << order);
 
-	return range_contains_unaccepted_memory(start, end);
-}
-
-static void accept_page(struct page *page, unsigned int order)
-{
-	phys_addr_t start = page_to_phys(page);
-
-	accept_memory(start, start + (PAGE_SIZE << order));
+	return range_contains_unaccepted_memory(start, PAGE_SIZE << order);
 }
 
 static bool try_to_accept_memory_one(struct zone *zone)
@@ -6975,7 +6966,7 @@ static bool try_to_accept_memory_one(str
 	__ClearPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	accept_page(page, MAX_PAGE_ORDER);
+	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
 	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
 
@@ -7047,10 +7038,6 @@ static bool page_contains_unaccepted(str
 	return false;
 }
 
-static void accept_page(struct page *page, unsigned int order)
-{
-}
-
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	return false;
--- a/tools/testing/memblock/internal.h~mm-rework-accept-memory-helpers
+++ a/tools/testing/memblock/internal.h
@@ -20,7 +20,7 @@ void memblock_free_pages(struct page *pa
 {
 }
 
-static inline void accept_memory(phys_addr_t start, phys_addr_t end)
+static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-endless-reclaim-on-machines-with-unaccepted-memory.patch
mm-reduce-deferred-struct-page-init-ifdeffery.patch
mm-accept-memory-in-__alloc_pages_bulk.patch
mm-introduce-pageunaccepted-page-type.patch
mm-rework-accept-memory-helpers.patch
mm-add-a-helper-to-accept-page.patch
mm-page_isolation-handle-unaccepted-memory-isolation.patch
mm-accept-to-promo-watermark.patch

