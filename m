From: akpm@linux-foundation.org
Subject: [merged] powerpc-get-rid-of-superfluous-__gfp_repeat.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:02:11 -0700
Message-ID: <57732c23.//YGX6WrR7WXQqaZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbcF2CCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     powerpc-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

