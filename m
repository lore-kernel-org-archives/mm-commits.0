From: akpm@linux-foundation.org
Subject: + x86-fix-pgd_lock-deadlock.patch added to -mm tree
Date: Wed, 16 Feb 2011 15:45:22 -0800
Message-ID: <201102162345.p1GNjMjm021738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab1BPXq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Feb 2011 18:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, konrad.wilk@oracle.com, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     x86: fix pgd_lock deadlock
has been added to the -mm tree.  Its filename is
     x86-fix-pgd_lock-deadlock.patch

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
Subject: x86: fix pgd_lock deadlock
From: Andrea Arcangeli <aarcange@redhat.com>

It's forbidden to take the page_table_lock with the irq disabled or if
there's contention the IPIs (for tlb flushes) sent with the
page_table_lock held will never run leading to a deadlock.

Apparently nobody takes the pgd_lock from irq so the _irqsave can be
removed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c    |    7 +++----
 arch/x86/mm/init_64.c  |    6 +++---
 arch/x86/mm/pageattr.c |   18 ++++++++----------
 arch/x86/mm/pgtable.c  |   11 ++++-------
 arch/x86/xen/mmu.c     |   10 ++++------
 5 files changed, 22 insertions(+), 30 deletions(-)

diff -puN arch/x86/mm/fault.c~x86-fix-pgd_lock-deadlock arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-fix-pgd_lock-deadlock
+++ a/arch/x86/mm/fault.c
@@ -229,15 +229,14 @@ void vmalloc_sync_all(void)
 	for (address = VMALLOC_START & PMD_MASK;
 	     address >= TASK_SIZE && address < FIXADDR_TOP;
 	     address += PMD_SIZE) {
-
-		unsigned long flags;
 		struct page *page;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			spinlock_t *pgt_lock;
 			pmd_t *ret;
 
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
@@ -247,7 +246,7 @@ void vmalloc_sync_all(void)
 			if (!ret)
 				break;
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
diff -puN arch/x86/mm/init_64.c~x86-fix-pgd_lock-deadlock arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-fix-pgd_lock-deadlock
+++ a/arch/x86/mm/init_64.c
@@ -106,18 +106,18 @@ void sync_global_pgds(unsigned long star
 
 	for (address = start; address <= end; address += PGDIR_SIZE) {
 		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
 		struct page *page;
 
 		if (pgd_none(*pgd_ref))
 			continue;
 
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
 			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
@@ -129,7 +129,7 @@ void sync_global_pgds(unsigned long star
 
 			spin_unlock(pgt_lock);
 		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 }
 
diff -puN arch/x86/mm/pageattr.c~x86-fix-pgd_lock-deadlock arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~x86-fix-pgd_lock-deadlock
+++ a/arch/x86/mm/pageattr.c
@@ -57,12 +57,10 @@ static unsigned long direct_pages_count[
 
 void update_page_count(int level, unsigned long pages)
 {
-	unsigned long flags;
-
 	/* Protect against CPA */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -394,7 +392,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
@@ -403,7 +401,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -498,14 +496,14 @@ try_preserve_large_page(pte_t *kpte, uns
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return do_split;
 }
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	unsigned long flags, pfn, pfninc = 1;
+	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
@@ -519,7 +517,7 @@ static int split_large_page(pte_t *kpte,
 	if (!base)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -591,7 +589,7 @@ out_unlock:
 	 */
 	if (base)
 		__free_page(base);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
diff -puN arch/x86/mm/pgtable.c~x86-fix-pgd_lock-deadlock arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-fix-pgd_lock-deadlock
+++ a/arch/x86/mm/pgtable.c
@@ -121,14 +121,12 @@ static void pgd_ctor(struct mm_struct *m
 
 static void pgd_dtor(pgd_t *pgd)
 {
-	unsigned long flags; /* can be called from interrupt context */
-
 	if (SHARED_KERNEL_PMD)
 		return;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	pgd_list_del(pgd);
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -260,7 +258,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
 	pmd_t *pmds[PREALLOCATED_PMDS];
-	unsigned long flags;
 
 	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
 
@@ -280,12 +277,12 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 	 * respect to anything walking the pgd_list, so that they
 	 * never see a partially populated pgd.
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	pgd_ctor(mm, pgd);
 	pgd_prepopulate_pmd(mm, pgd, pmds);
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return pgd;
 
diff -puN arch/x86/xen/mmu.c~x86-fix-pgd_lock-deadlock arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c~x86-fix-pgd_lock-deadlock
+++ a/arch/x86/xen/mmu.c
@@ -1036,10 +1036,9 @@ static void xen_pgd_pin(struct mm_struct
  */
 void xen_mm_pin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (!PagePinned(page)) {
@@ -1048,7 +1047,7 @@ void xen_mm_pin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 /*
@@ -1149,10 +1148,9 @@ static void xen_pgd_unpin(struct mm_stru
  */
 void xen_mm_unpin_all(void)
 {
-	unsigned long flags;
 	struct page *page;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 
 	list_for_each_entry(page, &pgd_list, lru) {
 		if (PageSavePinned(page)) {
@@ -1162,7 +1160,7 @@ void xen_mm_unpin_all(void)
 		}
 	}
 
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next)
_

Patches currently in -mm which might be from aarcange@redhat.com are

x86-fix-pgd_lock-deadlock.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch

