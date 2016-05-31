From: akpm@linux-foundation.org
Subject: + powerpc-get-rid-of-superfluous-__gfp_repeat.patch added to -mm
 tree
Date: Tue, 31 May 2016 12:53:33 -0700
Message-ID: <574debbd.0H4WvU48yeU/y6L3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcEaTxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: get rid of superfluous __GFP_REPEAT
has been added to the -mm tree.  Its filename is
     powerpc-get-rid-of-superfluous-__gfp_repeat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-get-rid-of-superfluous-__gfp_repeat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-get-rid-of-superfluous-__gfp_repeat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom_reaper-do-not-use-siglock-in-try_oom_reaper.patch
tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch

