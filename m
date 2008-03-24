From: akpm@linux-foundation.org
Subject: - proc-pid-pagemap-change-pagemap-output-format-to-allow-for-future-reporting-of-huge-pages.patch removed from -mm tree
Date: Mon, 24 Mar 2008 12:24:49 -0700
Message-ID: <200803241924.m2OJOnOa021451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759834AbYCXTZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 15:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hans.rosenfeld@amd.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     /proc/pid/pagemap: change pagemap output format to allow for future reporting of huge pages
has been removed from the -mm tree.  Its filename was
     proc-pid-pagemap-change-pagemap-output-format-to-allow-for-future-reporting-of-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/pid/pagemap: change pagemap output format to allow for future reporting of huge pages
From: Hans Rosenfeld <hans.rosenfeld@amd.com>

Change pagemap output format to allow for future reporting of huge pages.

(Format comment and minor cleanups: mpm@selenic.com)

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   50 +++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pid-pagemap-change-pagemap-output-format-to-allow-for-future-reporting-of-huge-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-pagemap-change-pagemap-output-format-to-allow-for-future-reporting-of-huge-pages
+++ a/fs/proc/task_mmu.c
@@ -527,13 +527,21 @@ struct pagemapread {
 	char __user *out, *end;
 };
 
-#define PM_ENTRY_BYTES sizeof(u64)
-#define PM_RESERVED_BITS    3
-#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
-#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) & PM_RESERVED_MASK)
-#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
-#define PM_SWAP             PM_SPECIAL(2LL)
+#define PM_ENTRY_BYTES      sizeof(u64)
+#define PM_STATUS_BITS      3
+#define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
+#define PM_STATUS_MASK      (((1LL << PM_STATUS_BITS) - 1) << PM_STATUS_OFFSET)
+#define PM_STATUS(nr)       (((nr) << PM_STATUS_OFFSET) & PM_STATUS_MASK)
+#define PM_PSHIFT_BITS      6
+#define PM_PSHIFT_OFFSET    (PM_STATUS_OFFSET - PM_PSHIFT_BITS)
+#define PM_PSHIFT_MASK      (((1LL << PM_PSHIFT_BITS) - 1) << PM_PSHIFT_OFFSET)
+#define PM_PSHIFT(x)        (((u64) (x) << PM_PSHIFT_OFFSET) & PM_PSHIFT_MASK)
+#define PM_PFRAME_MASK      ((1LL << PM_PSHIFT_OFFSET) - 1)
+#define PM_PFRAME(x)        ((x) & PM_PFRAME_MASK)
+
+#define PM_PRESENT          PM_STATUS(4LL)
+#define PM_SWAP             PM_STATUS(2LL)
+#define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
 #define PM_END_OF_BUFFER    1
 
 static int add_to_pagemap(unsigned long addr, u64 pfn,
@@ -574,7 +582,7 @@ static int pagemap_pte_hole(unsigned lon
 u64 swap_pte_to_pagemap_entry(pte_t pte)
 {
 	swp_entry_t e = pte_to_swp_entry(pte);
-	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
+	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
@@ -588,9 +596,11 @@ static int pagemap_pte_range(pmd_t *pmd,
 		u64 pfn = PM_NOT_PRESENT;
 		pte = pte_offset_map(pmd, addr);
 		if (is_swap_pte(*pte))
-			pfn = swap_pte_to_pagemap_entry(*pte);
+			pfn = PM_PFRAME(swap_pte_to_pagemap_entry(*pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
 		else if (pte_present(*pte))
-			pfn = pte_pfn(*pte);
+			pfn = PM_PFRAME(pte_pfn(*pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
 		/* unmap so we're not in atomic when we copy to userspace */
 		pte_unmap(pte);
 		err = add_to_pagemap(addr, pfn, pm);
@@ -611,12 +621,20 @@ static struct mm_walk pagemap_walk = {
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
- * For each page in the address space, this file contains one 64-bit
- * entry representing the corresponding physical page frame number
- * (PFN) if the page is present. If there is a swap entry for the
- * physical page, then an encoding of the swap file number and the
- * page's offset into the swap file are returned. If no page is
- * present at all, PM_NOT_PRESENT is returned. This allows determining
+ * For each page in the address space, this file contains one 64-bit entry
+ * consisting of the following:
+ *
+ * Bits 0-55  page frame number (PFN) if present
+ * Bits 0-4   swap type if swapped
+ * Bits 5-55  swap offset if swapped
+ * Bits 55-60 page shift (page size = 1<<page shift)
+ * Bit  61    reserved for future use
+ * Bit  62    page swapped
+ * Bit  63    page present
+ *
+ * If the page is not present but in swap, then the PFN contains an
+ * encoding of the swap file number and the page's offset into the
+ * swap. Unmapped pages return a null PFN. This allows determining
  * precisely which pages are mapped (or in swap) and comparing mapped
  * pages between processes.
  *
_

Patches currently in -mm which might be from hans.rosenfeld@amd.com are

origin.patch

