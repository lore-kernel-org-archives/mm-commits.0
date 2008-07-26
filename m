From: akpm@linux-foundation.org
Subject: - x86-support-1gb-hugepages-with-get_user_pages_lockless.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:55 -0700
Message-ID: <200807262115.m6QLFtpL019777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672AbYGZVQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, andi@firstfloor.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: support 1GB hugepages with get_user_pages_lockless()
has been removed from the -mm tree.  Its filename was
     x86-support-1gb-hugepages-with-get_user_pages_lockless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: support 1GB hugepages with get_user_pages_lockless()
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/gup.c~x86-support-1gb-hugepages-with-get_user_pages_lockless arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~x86-support-1gb-hugepages-with-get_user_pages_lockless
+++ a/arch/x86/mm/gup.c
@@ -124,7 +124,7 @@ static noinline int gup_huge_pmd(pmd_t p
 
 	refs = 0;
 	head = pte_page(pte);
-	page = head + ((addr & ~HPAGE_MASK) >> PAGE_SHIFT);
+	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -162,6 +162,38 @@ static int gup_pmd_range(pud_t pud, unsi
 	return 1;
 }
 
+static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
+		unsigned long end, int write, struct page **pages, int *nr)
+{
+	unsigned long mask;
+	pte_t pte = *(pte_t *)&pud;
+	struct page *head, *page;
+	int refs;
+
+	mask = _PAGE_PRESENT|_PAGE_USER;
+	if (write)
+		mask |= _PAGE_RW;
+	if ((pte_val(pte) & mask) != mask)
+		return 0;
+	/* hugepages are never "special" */
+	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+
+	refs = 0;
+	head = pte_page(pte);
+	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	do {
+		VM_BUG_ON(compound_head(page) != head);
+		pages[*nr] = page;
+		(*nr)++;
+		page++;
+		refs++;
+	} while (addr += PAGE_SIZE, addr != end);
+	get_head_page_multiple(head, refs);
+
+	return 1;
+}
+
 static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 			int write, struct page **pages, int *nr)
 {
@@ -175,8 +207,13 @@ static int gup_pud_range(pgd_t pgd, unsi
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
 			return 0;
-		if (!gup_pmd_range(pud, addr, next, write, pages, nr))
-			return 0;
+		if (unlikely(pud_large(pud))) {
+			if (!gup_huge_pud(pud, addr, next, write, pages, nr))
+				return 0;
+		} else {
+			if (!gup_pmd_range(pud, addr, next, write, pages, nr))
+				return 0;
+		}
 	} while (pudp++, addr = next, addr != end);
 
 	return 1;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

