From: akpm@linux-foundation.org
Subject: + powerpc-hugetlb-pgtable-cache-access-cleanup.patch added to -mm tree
Date: Tue, 04 Nov 2008 13:30:40 -0800
Message-ID: <200811042130.mA4LUeCS006238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbYKDVaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 16:30:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kniht@linux.vnet.ibm.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au, nickpiggin@yahoo.com.au, paulus@samba.org


The patch titled
     powerpc: hugetlb pgtable cache access cleanup
has been added to the -mm tree.  Its filename is
     powerpc-hugetlb-pgtable-cache-access-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

hugetlbfs-handle-pages-higher-order-than-max_order.patch
hugetlb-pull-gigantic-page-initialisation-out-of-the-default-path.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

