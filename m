From: akpm@linux-foundation.org
Subject: + powerpc-lockless-get_user_pages_fast.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:35:13 -0700
Message-ID: <200806052035.m55KZDUV028522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYFEUgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     powerpc: lockless get_user_pages_fast
has been added to the -mm tree.  Its filename is
     powerpc-lockless-get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: lockless get_user_pages_fast
From: Nick Piggin <npiggin@suse.de>

Implement lockless get_user_pages_fast for powerpc.  Page table existence
is guaranteed with RCU, and speculative page references are used to take a
reference to the pages without having a prior existence guarantee on them.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/Makefile      |    2 
 arch/powerpc/mm/gup.c         |  230 ++++++++++++++++++++++++++++++++
 include/asm-powerpc/uaccess.h |    6 
 include/linux/mm.h            |    2 
 include/linux/pagemap.h       |   23 +++
 5 files changed, 261 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/Makefile~powerpc-lockless-get_user_pages_fast arch/powerpc/mm/Makefile
--- a/arch/powerpc/mm/Makefile~powerpc-lockless-get_user_pages_fast
+++ a/arch/powerpc/mm/Makefile
@@ -6,7 +6,7 @@ ifeq ($(CONFIG_PPC64),y)
 EXTRA_CFLAGS	+= -mno-minimal-toc
 endif
 
-obj-y				:= fault.o mem.o \
+obj-y				:= fault.o mem.o gup.o \
 				   init_$(CONFIG_WORD_SIZE).o \
 				   pgtable_$(CONFIG_WORD_SIZE).o \
 				   mmu_context_$(CONFIG_WORD_SIZE).o
diff -puN /dev/null arch/powerpc/mm/gup.c
--- /dev/null
+++ a/arch/powerpc/mm/gup.c
@@ -0,0 +1,230 @@
+/*
+ * Lockless get_user_pages_fast for powerpc
+ *
+ * Copyright (C) 2008 Nick Piggin
+ * Copyright (C) 2008 Novell Inc.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/pagemap.h>
+#include <linux/rwsem.h>
+#include <asm/pgtable.h>
+
+/*
+ * The performance critical leaf functions are made noinline otherwise gcc
+ * inlines everything into a single function which results in too much
+ * register pressure.
+ */
+static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
+		unsigned long end, int write, struct page **pages, int *nr)
+{
+	unsigned long mask, result;
+	pte_t *ptep;
+
+	result = _PAGE_PRESENT|_PAGE_USER;
+	if (write)
+		result |= _PAGE_RW;
+	mask = result | _PAGE_SPECIAL;
+
+	ptep = pte_offset_kernel(&pmd, addr);
+	do {
+		pte_t pte = *ptep;
+		struct page *page;
+
+		if ((pte_val(pte) & mask) != result)
+			return 0;
+		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+		page = pte_page(pte);
+		if (!page_cache_get_speculative(page))
+			return 0;
+		if (unlikely(pte != *ptep)) {
+			put_page(page);
+			return 0;
+		}
+		pages[*nr] = page;
+		(*nr)++;
+
+	} while (ptep++, addr += PAGE_SIZE, addr != end);
+
+	return 1;
+}
+
+static noinline int gup_huge_pte(pte_t *ptep, unsigned long *addr,
+		unsigned long end, int write, struct page **pages, int *nr)
+{
+	unsigned long mask;
+	unsigned long pte_end;
+	struct page *head, *page;
+	pte_t pte;
+	int refs;
+
+	pte_end = (*addr + HPAGE_SIZE) & HPAGE_MASK;
+	if (pte_end < end)
+		end = pte_end;
+
+	pte = *ptep;
+	mask = _PAGE_PRESENT|_PAGE_USER;
+	if (write)
+		mask |= _PAGE_RW;
+	if ((pte_val(pte) & mask) != mask)
+		return 0;
+	/* hugepages are never "special" */
+	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+
+	refs = 0;
+	head = pte_page(pte);
+	page = head + ((*addr & ~HPAGE_MASK) >> PAGE_SHIFT);
+	do {
+		VM_BUG_ON(compound_head(page) != head);
+		pages[*nr] = page;
+		(*nr)++;
+		page++;
+		refs++;
+	} while (*addr += PAGE_SIZE, *addr != end);
+
+	if (!page_cache_add_speculative(head, refs)) {
+		*nr -= refs;
+		return 0;
+	}
+	if (unlikely(pte != *ptep)) {
+		/* Could be optimized better */
+		while (*nr) {
+			put_page(page);
+			(*nr)--;
+		}
+	}
+
+	return 1;
+}
+
+static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
+		int write, struct page **pages, int *nr)
+{
+	unsigned long next;
+	pmd_t *pmdp;
+
+	pmdp = pmd_offset(&pud, addr);
+	do {
+		pmd_t pmd = *pmdp;
+
+		next = pmd_addr_end(addr, end);
+		if (pmd_none(pmd))
+			return 0;
+		if (!gup_pte_range(pmd, addr, next, write, pages, nr))
+			return 0;
+	} while (pmdp++, addr = next, addr != end);
+
+	return 1;
+}
+
+static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
+		int write, struct page **pages, int *nr)
+{
+	unsigned long next;
+	pud_t *pudp;
+
+	pudp = pud_offset(&pgd, addr);
+	do {
+		pud_t pud = *pudp;
+
+		next = pud_addr_end(addr, end);
+		if (pud_none(pud))
+			return 0;
+		if (!gup_pmd_range(pud, addr, next, write, pages, nr))
+			return 0;
+	} while (pudp++, addr = next, addr != end);
+
+	return 1;
+}
+
+int get_user_pages_fast(unsigned long start, int nr_pages, int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long end = start + (nr_pages << PAGE_SHIFT);
+	unsigned long addr = start;
+	unsigned long next;
+	pgd_t *pgdp;
+	int nr = 0;
+
+
+	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+					start, nr_pages*PAGE_SIZE)))
+		goto slow_irqon;
+
+	/* Cross a slice boundary? */
+	if (unlikely(addr < SLICE_LOW_TOP && end >= SLICE_LOW_TOP))
+		goto slow_irqon;
+
+	/*
+	 * XXX: batch / limit 'nr', to avoid large irq off latency
+	 * needs some instrumenting to determine the common sizes used by
+	 * important workloads (eg. DB2), and whether limiting the batch size
+	 * will decrease performance.
+	 *
+	 * It seems like we're in the clear for the moment. Direct-IO is
+	 * the main guy that batches up lots of get_user_pages, and even
+	 * they are limited to 64-at-a-time which is not so many.
+	 */
+	/*
+	 * This doesn't prevent pagetable teardown, but does prevent
+	 * the pagetables from being freed on powerpc.
+	 *
+	 * So long as we atomically load page table pointers versus teardown,
+	 * we can follow the address down to the the page and take a ref on it.
+	 */
+	local_irq_disable();
+
+	if (get_slice_psize(mm, addr) == mmu_huge_psize) {
+		pte_t *ptep;
+		unsigned long a = addr;
+
+		ptep = huge_pte_offset(mm, a);
+		do {
+			if (!gup_huge_pte(ptep, &a, end, write, pages, &nr))
+				goto slow;
+			ptep++;
+		} while (a != end);
+	} else {
+		pgdp = pgd_offset(mm, addr);
+		do {
+			pgd_t pgd = *pgdp;
+
+			next = pgd_addr_end(addr, end);
+			if (pgd_none(pgd))
+				goto slow;
+			if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+				goto slow;
+		} while (pgdp++, addr = next, addr != end);
+	}
+	local_irq_enable();
+
+	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
+	return nr;
+
+	{
+		int ret;
+
+slow:
+		local_irq_enable();
+slow_irqon:
+		/* Try to get the remaining pages with get_user_pages */
+		start += nr << PAGE_SHIFT;
+		pages += nr;
+
+		down_read(&mm->mmap_sem);
+		ret = get_user_pages(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
+		up_read(&mm->mmap_sem);
+
+		/* Have to be a bit careful with return values */
+		if (nr > 0) {
+			if (ret < 0)
+				ret = nr;
+			else
+				ret += nr;
+		}
+
+		return ret;
+	}
+}
diff -puN include/asm-powerpc/uaccess.h~powerpc-lockless-get_user_pages_fast include/asm-powerpc/uaccess.h
--- a/include/asm-powerpc/uaccess.h~powerpc-lockless-get_user_pages_fast
+++ a/include/asm-powerpc/uaccess.h
@@ -493,6 +493,12 @@ static inline int strnlen_user(const cha
 
 #define strlen_user(str)	strnlen_user((str), 0x7ffffffe)
 
+#ifdef __powerpc64__
+#define __HAVE_ARCH_GET_USER_PAGES_FAST
+struct page;
+int get_user_pages_fast(unsigned long start, int nr_pages, int write, struct page **pages);
+#endif
+
 #endif  /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
diff -puN include/linux/mm.h~powerpc-lockless-get_user_pages_fast include/linux/mm.h
--- a/include/linux/mm.h~powerpc-lockless-get_user_pages_fast
+++ a/include/linux/mm.h
@@ -250,7 +250,7 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageTail(page));
+	VM_BUG_ON(PageCompound(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 
diff -puN include/linux/pagemap.h~powerpc-lockless-get_user_pages_fast include/linux/pagemap.h
--- a/include/linux/pagemap.h~powerpc-lockless-get_user_pages_fast
+++ a/include/linux/pagemap.h
@@ -142,6 +142,29 @@ static inline int page_cache_get_specula
 	return 1;
 }
 
+/*
+ * Same as above, but add instead of inc (could just be merged)
+ */
+static inline int page_cache_add_speculative(struct page *page, int count)
+{
+	VM_BUG_ON(in_interrupt());
+
+#ifndef CONFIG_SMP
+# ifdef CONFIG_PREEMPT
+	VM_BUG_ON(!in_atomic());
+# endif
+	VM_BUG_ON(page_count(page) == 0);
+	atomic_add(count, &page->_count);
+
+#else
+	if (unlikely(!atomic_add_unless(&page->_count, count, 0)))
+		return 0;
+#endif
+	VM_BUG_ON(PageCompound(page) && page != compound_head(page));
+
+	return 1;
+}
+
 static inline int page_freeze_refs(struct page *page, int count)
 {
 	return likely(atomic_cmpxchg(&page->_count, count, 0) == count);
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

