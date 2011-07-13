From: akpm@linux-foundation.org
Subject: + sparc64-implement-get_user_pages_fast.patch added to -mm tree
Date: Wed, 13 Jul 2011 15:34:02 -0700
Message-ID: <201107132234.p6DMY2v1007449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367Ab1GMWeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 18:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, a.p.zijlstra@chello.nl


The patch titled
     sparc64: implement get_user_pages_fast()
has been added to the -mm tree.  Its filename is
     sparc64-implement-get_user_pages_fast.patch

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
Subject: sparc64: implement get_user_pages_fast()
From: David S. Miller <davem@davemloft.net>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/Makefile |    2 
 arch/sparc/mm/gup.c    |  181 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+), 1 deletion(-)

diff -puN arch/sparc/mm/Makefile~sparc64-implement-get_user_pages_fast arch/sparc/mm/Makefile
--- a/arch/sparc/mm/Makefile~sparc64-implement-get_user_pages_fast
+++ a/arch/sparc/mm/Makefile
@@ -4,7 +4,7 @@
 asflags-y := -ansi
 ccflags-y := -Werror
 
-obj-$(CONFIG_SPARC64)   += ultra.o tlb.o tsb.o
+obj-$(CONFIG_SPARC64)   += ultra.o tlb.o tsb.o gup.o
 obj-y                   += fault_$(BITS).o
 obj-y                   += init_$(BITS).o
 obj-$(CONFIG_SPARC32)   += loadmmu.o
diff -puN /dev/null arch/sparc/mm/gup.c
--- /dev/null
+++ a/arch/sparc/mm/gup.c
@@ -0,0 +1,181 @@
+/*
+ * Lockless get_user_pages_fast for sparc, cribbed from powerpc
+ *
+ * Copyright (C) 2008 Nick Piggin
+ * Copyright (C) 2008 Novell Inc.
+ */
+
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
+	if (tlb_type == hypervisor) {
+		result = _PAGE_PRESENT_4V|_PAGE_P_4V;
+		if (write)
+			result |= _PAGE_WRITE_4V;
+	} else {
+		result = _PAGE_PRESENT_4U|_PAGE_P_4U;
+		if (write)
+			result |= _PAGE_WRITE_4U;
+	}
+	mask = result | _PAGE_SPECIAL;
+
+	ptep = pte_offset_kernel(&pmd, addr);
+	do {
+		struct page *page, *head;
+		pte_t pte = *ptep;
+
+		if ((pte_val(pte) & mask) != result)
+			return 0;
+		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+
+		/* The hugepage case is simplified on sparc64 because
+		 * we encode the sub-page pfn offsets into the
+		 * hugepage PTEs.  We could optimize this in the future
+		 * use page_cache_add_speculative() for the hugepage case.
+		 */
+		page = pte_page(pte);
+		head = compound_head(page);
+		if (!page_cache_get_speculative(head))
+			return 0;
+		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+			put_page(head);
+			return 0;
+		}
+
+		pages[*nr] = page;
+		(*nr)++;
+	} while (ptep++, addr += PAGE_SIZE, addr != end);
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
+int get_user_pages_fast(unsigned long start, int nr_pages, int write,
+			struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr, len, end;
+	unsigned long next;
+	pgd_t *pgdp;
+	int nr = 0;
+
+	start &= PAGE_MASK;
+	addr = start;
+	len = (unsigned long) nr_pages << PAGE_SHIFT;
+	end = start + len;
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
+	 * the pagetables from being freed on sparc.
+	 *
+	 * So long as we atomically load page table pointers versus teardown,
+	 * we can follow the address down to the the page and take a ref on it.
+	 */
+	local_irq_disable();
+
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
+
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
+
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
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
maintainers-orphan-framerelay-dlci.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
sparc-exec-remove-redundant-addr_limit-assignment.patch
sparc64-kill-page-table-quicklists.patch
sparc64-use-rcu-page-table-freeing.patch
sparc64-add-support-for-_page_special.patch
sparc64-implement-get_user_pages_fast.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-pm-move-pm-notifiers-into-suspendh-update.patch
notifiers-vt-move-vt-notifiers-into-vth.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch

