From: akpm@linux-foundation.org
Subject: - powerpc-hugetlb-pgtable-cache-access-cleanup.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:59 -0800
Message-ID: <200811102033.mAAKXxsY024809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYKJUel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kniht@linux.vnet.ibm.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au, nickpiggin@yahoo.com.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: hugetlb pgtable cache access cleanup
has been removed from the -mm tree.  Its filename was
     powerpc-hugetlb-pgtable-cache-access-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: hugetlb pgtable cache access cleanup
From: Jon Tollefson <kniht@linux.vnet.ibm.com>

It was suggested by Andrew that using a macro that made an array look like
a function call made it harder to understand the code.  Cleaned up use of
macro.  We now reference the pgtable_cache array directly instead of using
a macro.

Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-hugetlb-pgtable-cache-access-cleanup arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-hugetlb-pgtable-cache-access-cleanup
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -53,8 +53,7 @@ unsigned int mmu_huge_psizes[MMU_PAGE_CO
 
 /* Subtract one from array size because we don't need a cache for 4K since
  * is not a huge page size */
-#define huge_pgtable_cache(psize)	(pgtable_cache[HUGEPTE_CACHE_NUM \
-							+ psize-1])
+#define HUGE_PGTABLE_INDEX(psize)	(HUGEPTE_CACHE_NUM + psize - 1)
 #define HUGEPTE_CACHE_NAME(psize)	(huge_pgtable_cache_name[psize])
 
 static const char *huge_pgtable_cache_name[MMU_PAGE_COUNT] = {
@@ -113,7 +112,7 @@ static inline pte_t *hugepte_offset(huge
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int psize)
 {
-	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
+	pte_t *new = kmem_cache_zalloc(pgtable_cache[HUGE_PGTABLE_INDEX(psize)],
 				      GFP_KERNEL|__GFP_REPEAT);
 
 	if (! new)
@@ -121,7 +120,7 @@ static int __hugepte_alloc(struct mm_str
 
 	spin_lock(&mm->page_table_lock);
 	if (!hugepd_none(*hpdp))
-		kmem_cache_free(huge_pgtable_cache(psize), new);
+		kmem_cache_free(pgtable_cache[HUGE_PGTABLE_INDEX(psize)], new);
 	else
 		hpdp->pd = (unsigned long)new | HUGEPD_OK;
 	spin_unlock(&mm->page_table_lock);
@@ -760,13 +759,14 @@ static int __init hugetlbpage_init(void)
 
 	for (psize = 0; psize < MMU_PAGE_COUNT; ++psize) {
 		if (mmu_huge_psizes[psize]) {
-			huge_pgtable_cache(psize) = kmem_cache_create(
-						HUGEPTE_CACHE_NAME(psize),
-						HUGEPTE_TABLE_SIZE(psize),
-						HUGEPTE_TABLE_SIZE(psize),
-						0,
-						NULL);
-			if (!huge_pgtable_cache(psize))
+			pgtable_cache[HUGE_PGTABLE_INDEX(psize)] =
+				kmem_cache_create(
+					HUGEPTE_CACHE_NAME(psize),
+					HUGEPTE_TABLE_SIZE(psize),
+					HUGEPTE_TABLE_SIZE(psize),
+					0,
+					NULL);
+			if (!pgtable_cache[HUGE_PGTABLE_INDEX(psize)])
 				panic("hugetlbpage_init(): could not create %s"\
 				      "\n", HUGEPTE_CACHE_NAME(psize));
 		}
_

Patches currently in -mm which might be from kniht@linux.vnet.ibm.com are

hugetlb-make-unmap_ref_private-multi-size-aware.patch
linux-next.patch

