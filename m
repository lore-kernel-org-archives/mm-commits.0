From: akpm@linux-foundation.org
Subject: [patch 14/41] powerpc: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:12 -0700
Message-ID: <576daad8.AWOZf6tJ2AhBkdGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbcFXVtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, benh@kernel.crashing.org

From: Michal Hocko <mhocko@suse.com>
Subject: powerpc: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

{pud,pmd}_alloc_one are allocating from {PGT,PUD}_CACHE initialized in
pgtable_cache_init which doesn't have larger than sizeof(void *) << 12
size and that fits into !costly allocation request size.

PGALLOC_GFP is used only in radix__pgd_alloc which uses either order-0 or
order-4 requests.  The first one doesn't need the flag while the second
does.  Drop __GFP_REPEAT from PGALLOC_GFP and add it for the order-4 one.

This means that this flag has never been actually useful here because it
has always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-12-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgalloc.h |   10 ++++------
 arch/powerpc/include/asm/nohash/64/pgalloc.h |    6 ++----
 arch/powerpc/mm/hugetlbpage.c                |    2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgalloc.h~powerpc-get-rid-of-superfluous-__gfp_repeat arch/powerpc/include/asm/book3s/64/pgalloc.h
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h~powerpc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -41,7 +41,7 @@ extern struct kmem_cache *pgtable_cache[
 			pgtable_cache[(shift) - 1];	\
 		})
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
+#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO
 
 extern pte_t *pte_fragment_alloc(struct mm_struct *, unsigned long, int);
 extern void pte_fragment_free(unsigned long *, int);
@@ -56,7 +56,7 @@ static inline pgd_t *radix__pgd_alloc(st
 	return (pgd_t *)__get_free_page(PGALLOC_GFP);
 #else
 	struct page *page;
-	page = alloc_pages(PGALLOC_GFP, 4);
+	page = alloc_pages(PGALLOC_GFP | __GFP_REPEAT, 4);
 	if (!page)
 		return NULL;
 	return (pgd_t *) page_address(page);
@@ -93,8 +93,7 @@ static inline void pgd_populate(struct m
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE),
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE), GFP_KERNEL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -115,8 +114,7 @@ static inline void __pud_free_tlb(struct
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PMD_CACHE_INDEX),
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(PGT_CACHE(PMD_CACHE_INDEX), GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
diff -puN arch/powerpc/include/asm/nohash/64/pgalloc.h~powerpc-get-rid-of-superfluous-__gfp_repeat arch/powerpc/include/asm/nohash/64/pgalloc.h
--- a/arch/powerpc/include/asm/nohash/64/pgalloc.h~powerpc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/powerpc/include/asm/nohash/64/pgalloc.h
@@ -57,8 +57,7 @@ static inline void pgd_free(struct mm_st
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE),
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(PGT_CACHE(PUD_INDEX_SIZE), GFP_KERNEL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -190,8 +189,7 @@ static inline void __pte_free_tlb(struct
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(PGT_CACHE(PMD_CACHE_INDEX),
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(PGT_CACHE(PMD_CACHE_INDEX), GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-get-rid-of-superfluous-__gfp_repeat arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -73,7 +73,7 @@ static int __hugepte_alloc(struct mm_str
 	cachep = PGT_CACHE(pdshift - pshift);
 #endif
 
-	new = kmem_cache_zalloc(cachep, GFP_KERNEL|__GFP_REPEAT);
+	new = kmem_cache_zalloc(cachep, GFP_KERNEL);
 
 	BUG_ON(pshift > HUGEPD_SHIFT_MASK);
 	BUG_ON((unsigned long)new & HUGEPD_SHIFT_MASK);
_
