From: akpm@linux-foundation.org
Subject: - x86-lockless-get_user_pages_fast.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:15:47 -0700
Message-ID: <200807262115.m6QLFll5019766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782AbYGZVRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, za


The patch titled
     x86: lockless get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     x86-lockless-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: lockless get_user_pages_fast()
From: Nick Piggin <npiggin@suse.de>

Implement get_user_pages_fast without locking in the fastpath on x86.

Do an optimistic lockless pagetable walk, without taking mmap_sem or any
page table locks or even mmap_sem.  Page table existence is guaranteed by
turning interrupts off (combined with the fact that we're always looking
up the current mm, means we can do the lockless page table walk within the
constraints of the TLB shootdown design).  Basically we can do this
lockless pagetable walk in a similar manner to the way the CPU's pagetable
walker does not have to take any locks to find present ptes.

This patch (combined with the subsequent ones to convert direct IO to use
it) was found to give about 10% performance improvement on a 2 socket 8
core Intel Xeon system running an OLTP workload on DB2 v9.5

 "To test the effects of the patch, an OLTP workload was run on an IBM
 x3850 M2 server with 2 processors (quad-core Intel Xeon processors at
 2.93 GHz) using IBM DB2 v9.5 running Linux 2.6.24rc7 kernel.  Comparing
 runs with and without the patch resulted in an overall performance
 benefit of ~9.8%.  Correspondingly, oprofiles showed that samples from
 __up_read and __down_read routines that is seen during thread contention
 for system resources was reduced from 2.8% down to .05%.  Monitoring the
 /proc/vmstat output from the patched run showed that the counter for
 fast_gup contained a very high number while the fast_gup_slow value was
 zero."

(fast_gup is the old name for get_user_pages_fast, fast_gup_slow is a
counter we had for the number of times the slowpath was invoked).

The main reason for the improvement is that DB2 has multiple threads each
issuing direct-IO.  Direct-IO uses get_user_pages, and thus the threads
contend the mmap_sem cacheline, and can also contend on page table locks.

I would anticipate larger performance gains on larger systems, however I
think DB2 uses an adaptive mix of threads and processes, so it could be
that thread contention remains pretty constant as machine size increases. 
In which case, we stuck with "only" a 10% gain.

The downside of using get_user_pages_fast is that if there is not a pte
with the correct permissions for the access, we end up falling back to
get_user_pages and so the get_user_pages_fast is a bit of extra work. 
However this should not be the common case in most performance critical
code.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: Kconfig fix]
[akpm@linux-foundation.org: Makefile fix/cleanup]
[akpm@linux-foundation.org: warning fix]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig          |    1 
 arch/x86/mm/Makefile      |    1 
 arch/x86/mm/gup.c         |  258 ++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess.h |    1 
 mm/Kconfig                |    3 
 5 files changed, 264 insertions(+)

diff -puN arch/x86/Kconfig~x86-lockless-get_user_pages_fast arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-lockless-get_user_pages_fast
+++ a/arch/x86/Kconfig
@@ -22,6 +22,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
+	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB if !X86_RDC321X
 	select HAVE_KRETPROBES
diff -puN arch/x86/mm/Makefile~x86-lockless-get_user_pages_fast arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~x86-lockless-get_user_pages_fast
+++ a/arch/x86/mm/Makefile
@@ -1,6 +1,7 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o
 
+obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff -puN /dev/null arch/x86/mm/gup.c
--- /dev/null
+++ a/arch/x86/mm/gup.c
@@ -0,0 +1,258 @@
+/*
+ * Lockless get_user_pages_fast for x86
+ *
+ * Copyright (C) 2008 Nick Piggin
+ * Copyright (C) 2008 Novell Inc.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/highmem.h>
+
+#include <asm/pgtable.h>
+
+static inline pte_t gup_get_pte(pte_t *ptep)
+{
+#ifndef CONFIG_X86_PAE
+	return *ptep;
+#else
+	/*
+	 * With get_user_pages_fast, we walk down the pagetables without taking
+	 * any locks.  For this we would like to load the pointers atoimcally,
+	 * but that is not possible (without expensive cmpxchg8b) on PAE.  What
+	 * we do have is the guarantee that a pte will only either go from not
+	 * present to present, or present to not present or both -- it will not
+	 * switch to a completely different present page without a TLB flush in
+	 * between; something that we are blocking by holding interrupts off.
+	 *
+	 * Setting ptes from not present to present goes:
+	 * ptep->pte_high = h;
+	 * smp_wmb();
+	 * ptep->pte_low = l;
+	 *
+	 * And present to not present goes:
+	 * ptep->pte_low = 0;
+	 * smp_wmb();
+	 * ptep->pte_high = 0;
+	 *
+	 * We must ensure here that the load of pte_low sees l iff pte_high
+	 * sees h. We load pte_high *after* loading pte_low, which ensures we
+	 * don't see an older value of pte_high.  *Then* we recheck pte_low,
+	 * which ensures that we haven't picked up a changed pte high. We might
+	 * have got rubbish values from pte_low and pte_high, but we are
+	 * guaranteed that pte_low will not have the present bit set *unless*
+	 * it is 'l'. And get_user_pages_fast only operates on present ptes, so
+	 * we're safe.
+	 *
+	 * gup_get_pte should not be used or copied outside gup.c without being
+	 * very careful -- it does not atomically load the pte or anything that
+	 * is likely to be useful for you.
+	 */
+	pte_t pte;
+
+retry:
+	pte.pte_low = ptep->pte_low;
+	smp_rmb();
+	pte.pte_high = ptep->pte_high;
+	smp_rmb();
+	if (unlikely(pte.pte_low != ptep->pte_low))
+		goto retry;
+
+	return pte;
+#endif
+}
+
+/*
+ * The performance critical leaf functions are made noinline otherwise gcc
+ * inlines everything into a single function which results in too much
+ * register pressure.
+ */
+static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
+		unsigned long end, int write, struct page **pages, int *nr)
+{
+	unsigned long mask;
+	pte_t *ptep;
+
+	mask = _PAGE_PRESENT|_PAGE_USER;
+	if (write)
+		mask |= _PAGE_RW;
+
+	ptep = pte_offset_map(&pmd, addr);
+	do {
+		pte_t pte = gup_get_pte(ptep);
+		struct page *page;
+
+		if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask) {
+			pte_unmap(ptep);
+			return 0;
+		}
+		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+		page = pte_page(pte);
+		get_page(page);
+		pages[*nr] = page;
+		(*nr)++;
+
+	} while (ptep++, addr += PAGE_SIZE, addr != end);
+	pte_unmap(ptep - 1);
+
+	return 1;
+}
+
+static inline void get_head_page_multiple(struct page *page, int nr)
+{
+	VM_BUG_ON(page != compound_head(page));
+	VM_BUG_ON(page_count(page) == 0);
+	atomic_add(nr, &page->_count);
+}
+
+static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
+		unsigned long end, int write, struct page **pages, int *nr)
+{
+	unsigned long mask;
+	pte_t pte = *(pte_t *)&pmd;
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
+	page = head + ((addr & ~HPAGE_MASK) >> PAGE_SHIFT);
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
+		if (unlikely(pmd_large(pmd))) {
+			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
+				return 0;
+		} else {
+			if (!gup_pte_range(pmd, addr, next, write, pages, nr))
+				return 0;
+		}
+	} while (pmdp++, addr = next, addr != end);
+
+	return 1;
+}
+
+static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
+			int write, struct page **pages, int *nr)
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
+int get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long end = start + (nr_pages << PAGE_SHIFT);
+	unsigned long addr = start;
+	unsigned long next;
+	pgd_t *pgdp;
+	int nr = 0;
+
+	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
+					start, nr_pages*PAGE_SIZE)))
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
+	 * the pagetables and pages from being freed on x86.
+	 *
+	 * So long as we atomically load page table pointers versus teardown
+	 * (which we do on x86, with the above PAE exception), we can follow the
+	 * address down to the the page and take a ref on it.
+	 */
+	local_irq_disable();
+	pgdp = pgd_offset(mm, addr);
+	do {
+		pgd_t pgd = *pgdp;
+
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(pgd))
+			goto slow;
+		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+			goto slow;
+	} while (pgdp++, addr = next, addr != end);
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
diff -puN include/asm-x86/uaccess.h~x86-lockless-get_user_pages_fast include/asm-x86/uaccess.h
--- a/include/asm-x86/uaccess.h~x86-lockless-get_user_pages_fast
+++ a/include/asm-x86/uaccess.h
@@ -451,3 +451,4 @@ extern struct movsl_mask {
 #endif
 
 #endif
+
diff -puN mm/Kconfig~x86-lockless-get_user_pages_fast mm/Kconfig
--- a/mm/Kconfig~x86-lockless-get_user_pages_fast
+++ a/mm/Kconfig
@@ -77,6 +77,9 @@ config FLAT_NODE_MEM_MAP
 	def_bool y
 	depends on !SPARSEMEM
 
+config HAVE_GET_USER_PAGES_FAST
+	bool
+
 #
 # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
 # to represent different areas of memory.  This variable allows
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

