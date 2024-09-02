Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C25381E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247784; cv=none; b=u+CVMCnIEJJNs69FNpk9BMHGzLCjVh4CJNyCn1O0zhBLq8bWq7CjSucMBC8IxSsaVfglolT3L5+uTlbroRVEX39DURrSJbw6FRyWOssGfAq931/9Y68pQtUoo1JvlSf/KNTpOYZQ8rBeQiEPrhprtEjXdiwpXWBKca1KFnaswG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247784; c=relaxed/simple;
	bh=LVdmZwyQIGMzyBmM6lFDdG96pFeV1u3j7RRyavKFmMQ=;
	h=Date:To:From:Subject:Message-Id; b=QTiAC0MEui7rBw4wWqhvUIQeYK07l4tsMf3AaH5GJYNyjDIT0szbvD+LzevGCeMYXMzE/ti4ozNSRjyHaCk8Po/t+Y07w/OYO+APvb3s053hufysS8DfckaAbDsud+izDojZ4IzxNs574Nioy7tZSftXMU8gblj1pwXe0f3ykMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mYx4H1UV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mYx4H1UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C17FC4CEC2;
	Mon,  2 Sep 2024 03:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247784;
	bh=LVdmZwyQIGMzyBmM6lFDdG96pFeV1u3j7RRyavKFmMQ=;
	h=Date:To:From:Subject:From;
	b=mYx4H1UVhLtWTl2ZljIyPX0/Xis5vuy8amCYBP0tu8dzr7jncK/p88XQXm366kWa3
	 xgohGpvY+d7qvI6ezRgiUApb0LHo2hCIkNgDEZS8FXIPNELIH2bbtJssj0WlyfC1lX
	 WoH56exbU7DbMUBTfyUt+7NI5/15HioZavnZC97s=
Date: Sun, 01 Sep 2024 20:29:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,thomas.lendacky@amd.com,rppt@kernel.org,mgorman@suse.de,hannes@cmpxchg.org,david@redhat.com,bp@alien8.de,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rework-accept-memory-helpers.patch removed from -mm tree
Message-Id: <20240902032944.2C17FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rework accept memory helpers
has been removed from the -mm tree.  Its filename was
     mm-rework-accept-memory-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1939,7 +1939,7 @@ static void __init deferred_free_pages(u
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
@@ -6932,16 +6931,8 @@ early_param("accept_memory", accept_memo
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
@@ -6966,7 +6957,7 @@ static bool try_to_accept_memory_one(str
 	__ClearPageUnaccepted(page);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-	accept_page(page, MAX_PAGE_ORDER);
+	accept_memory(page_to_phys(page), PAGE_SIZE << MAX_PAGE_ORDER);
 
 	__free_pages_ok(page, MAX_PAGE_ORDER, FPI_TO_TAIL);
 
@@ -7038,10 +7029,6 @@ static bool page_contains_unaccepted(str
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


