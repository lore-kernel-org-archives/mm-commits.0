From: akpm@linux-foundation.org
Subject: + arch-x86-charge-page-tables-to-kmemcg.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:09:13 -0700
Message-ID: <5750bc99.BeMLvG5cSbkz8zG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbcFBXJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, hpa@zytor.com, mhocko@kernel.org, minchan@kernel.org, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch: x86: charge page tables to kmemcg
has been added to the -mm tree.  Its filename is
     arch-x86-charge-page-tables-to-kmemcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-charge-page-tables-to-kmemcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-charge-page-tables-to-kmemcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: arch: x86: charge page tables to kmemcg

Page tables can bite a relatively big chunk off system memory and their
allocations are easy to trigger from userspace, so they should be
accounted to kmemcg.

This patch marks page table allocations as __GFP_ACCOUNT for x86. Note
we must not charge allocations of kernel page tables, because they can
be shared among processes from different cgroups so accounting them to a
particular one can pin other cgroups for indefinitely long. So we clear
__GFP_ACCOUNT flag if a page table is allocated for the kernel.

Link: http://lkml.kernel.org/r/7d5c54f6a2bcbe76f03171689440003d87e6c742.1464079538.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgalloc.h |   12 ++++++++++--
 arch/x86/mm/pgtable.c          |   10 +++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/pgalloc.h~arch-x86-charge-page-tables-to-kmemcg arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~arch-x86-charge-page-tables-to-kmemcg
+++ a/arch/x86/include/asm/pgalloc.h
@@ -81,7 +81,11 @@ static inline void pmd_populate(struct m
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *page;
-	page = alloc_pages(GFP_KERNEL |  __GFP_ZERO, 0);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
+
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	page = alloc_pages(gfp, 0);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
@@ -125,7 +129,11 @@ static inline void pgd_populate(struct m
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return (pud_t *)get_zeroed_page(GFP_KERNEL);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	return (pud_t *)get_zeroed_page(gfp);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
diff -puN arch/x86/mm/pgtable.c~arch-x86-charge-page-tables-to-kmemcg arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~arch-x86-charge-page-tables-to-kmemcg
+++ a/arch/x86/mm/pgtable.c
@@ -6,7 +6,7 @@
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO
+#define PGALLOC_GFP (GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | __GFP_ZERO)
 
 #ifdef CONFIG_HIGHPTE
 #define PGALLOC_USER_GFP __GFP_HIGHMEM
@@ -18,7 +18,7 @@ gfp_t __userpte_alloc_gfp = PGALLOC_GFP
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
-	return (pte_t *)__get_free_page(PGALLOC_GFP);
+	return (pte_t *)__get_free_page(PGALLOC_GFP & ~__GFP_ACCOUNT);
 }
 
 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
@@ -207,9 +207,13 @@ static int preallocate_pmds(struct mm_st
 {
 	int i;
 	bool failed = false;
+	gfp_t gfp = PGALLOC_GFP;
+
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
 
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
-		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
+		pmd_t *pmd = (pmd_t *)__get_free_page(gfp);
 		if (!pmd)
 			failed = true;
 		if (pmd && !pgtable_pmd_page_ctor(virt_to_page(pmd))) {
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch
mm-remove-pointless-struct-in-struct-page-definition.patch
mm-clean-up-non-standard-page-_mapcount-users.patch
mm-memcontrol-cleanup-kmem-charge-functions.patch
mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch
mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch
arch-x86-charge-page-tables-to-kmemcg.patch
pipe-account-to-kmemcg.patch
af_unix-charge-buffers-to-kmemcg.patch

