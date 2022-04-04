Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A079C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiDDXJC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiDDXIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2437F55485
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 15:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B1C6164D
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 22:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18A2C2BBE4;
        Mon,  4 Apr 2022 22:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649111796;
        bh=+DlJeXWn46+48l3sbSkhkOJKMT0hI3Qpe2ilZ2CpoAE=;
        h=Date:To:From:Subject:From;
        b=EG6unArEF22wqaL61ya1F6xUQTGI7Curj/+63aBYVn1gzFIWR7SpnaUeSrj1fgeQ6
         Tf8x+KoyxA+bEGVPD3hrQsXq8z7y/Wvp59LY9e8+d7dF9pPMDTAZNHzTDDNIe0feZV
         5sGjvQol+Xz9QKQhx/V9g6OoL42z6qMFmVO7aQhY=
Date:   Mon, 04 Apr 2022 15:36:35 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, peterx@redhat.com,
        npiggin@gmail.com, luto@kernel.org, dave.hansen@linux.intel.com,
        andrew.cooper3@citrix.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-mmu_gather.patch added to -mm tree
Message-Id: <20220404223635.F18A2C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: use mmu_gather
has been added to the -mm tree.  Its filename is
     mm-mprotect-use-mmu_gather.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mprotect-use-mmu_gather.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotect-use-mmu_gather.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm/mprotect: use mmu_gather

Patch series "mm/mprotect: avoid unnecessary TLB flushes", v6.

This patchset is intended to remove unnecessary TLB flushes during
mprotect() syscalls.  Once this patch-set make it through, similar and
further optimizations for MADV_COLD and userfaultfd would be possible.

Basically, there are 3 optimizations in this patch-set:

1. Use TLB batching infrastructure to batch flushes across VMAs and do
   better/fewer flushes.  This would also be handy for later userfaultfd
   enhancements.

2. Avoid unnecessary TLB flushes.  This optimization is the one that
   provides most of the performance benefits.  Unlike previous versions,
   we now only avoid flushes that would not result in spurious
   page-faults.

3. Avoiding TLB flushes on change_huge_pmd() that are only needed to
   prevent the A/D bits from changing.

Andrew asked for some benchmark numbers.  I do not have an easy
determinate macrobenchmark in which it is easy to show benefit.  I
therefore ran a microbenchmark: a loop that does the following on
anonymous memory, just as a sanity check to see that time is saved by
avoiding TLB flushes.  The loop goes:

	mprotect(p, PAGE_SIZE, PROT_READ)
	mprotect(p, PAGE_SIZE, PROT_READ|PROT_WRITE)
	*p = 0; // make the page writable

The test was run in KVM guest with 1 or 2 threads (the second thread was
busy-looping).  I measured the time (cycles) of each operation:

		1 thread		2 threads
		mmots	+patch		mmots	+patch
PROT_READ	3494	2725 (-22%)	8630	7788 (-10%)
PROT_READ|WRITE	3952	2724 (-31%)	9075	2865 (-68%)

[ mmots = v5.17-rc6-mmots-2022-03-06-20-38 ]

The exact numbers are really meaningless, but the benefit is clear.  There
are 2 interesting results though.  

(1) PROT_READ is cheaper, while one can expect it not to be affected. 
This is presumably due to TLB miss that is saved

(2) Without memory access (*p = 0), the speedup of the patch is even
greater.  In that scenario mprotect(PROT_READ) also avoids the TLB flush. 
As a result both operations on the patched kernel take roughly ~1500
cycles (with either 1 or 2 threads), whereas on mmotm their cost is as
high as presented in the table.


This patch (of 3):

change_pXX_range() currently does not use mmu_gather, but instead
implements its own deferred TLB flushes scheme.  This both complicates the
code, as developers need to be aware of different invalidation schemes,
and prevents opportunities to avoid TLB flushes or perform them in finer
granularity.

The use of mmu_gather for modified PTEs has benefits in various scenarios
even if pages are not released.  For instance, if only a single page needs
to be flushed out of a range of many pages, only that page would be
flushed.  If a THP page is flushed, on x86 a single TLB invlpg instruction
can be used instead of 512 instructions (or a full TLB flush, which would
Linux would actually use by default).  mprotect() over multiple VMAs
requires a single flush.

Use mmu_gather in change_pXX_range().  As the pages are not released, only
record the flushed range using tlb_flush_pXX_range().

Handle THP similarly and get rid of flush_cache_range() which becomes
redundant since tlb_start_vma() calls it when needed.

Link: https://lkml.kernel.org/r/20220401180821.1986781-1-namit@vmware.com
Link: https://lkml.kernel.org/r/20220401180821.1986781-2-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    6 ++
 include/linux/huge_mm.h |    5 +-
 include/linux/mm.h      |    5 +-
 mm/huge_memory.c        |   10 +++-
 mm/mempolicy.c          |    9 +++
 mm/mprotect.c           |   92 ++++++++++++++++++++------------------
 mm/userfaultfd.c        |    6 ++
 7 files changed, 82 insertions(+), 51 deletions(-)

--- a/fs/exec.c~mm-mprotect-use-mmu_gather
+++ a/fs/exec.c
@@ -758,6 +758,7 @@ int setup_arg_pages(struct linux_binprm
 	unsigned long stack_size;
 	unsigned long stack_expand;
 	unsigned long rlim_stack;
+	struct mmu_gather tlb;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size */
@@ -812,8 +813,11 @@ int setup_arg_pages(struct linux_binprm
 	vm_flags |= mm->def_flags;
 	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
 
-	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end,
+	tlb_gather_mmu(&tlb, mm);
+	ret = mprotect_fixup(&tlb, vma, &prev, vma->vm_start, vma->vm_end,
 			vm_flags);
+	tlb_finish_mmu(&tlb);
+
 	if (ret)
 		goto out_unlock;
 	BUG_ON(prev != vma);
--- a/include/linux/huge_mm.h~mm-mprotect-use-mmu_gather
+++ a/include/linux/huge_mm.h
@@ -36,8 +36,9 @@ int zap_huge_pud(struct mmu_gather *tlb,
 		 unsigned long addr);
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		   unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd);
-int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
-		    pgprot_t newprot, unsigned long cp_flags);
+int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
+		    unsigned long cp_flags);
 vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
 				   pgprot_t pgprot, bool write);
 
--- a/include/linux/mm.h~mm-mprotect-use-mmu_gather
+++ a/include/linux/mm.h
@@ -1970,10 +1970,11 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
-extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+extern unsigned long change_protection(struct mmu_gather *tlb,
+			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
 			      unsigned long cp_flags);
-extern int mprotect_fixup(struct vm_area_struct *vma,
+extern int mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
--- a/mm/huge_memory.c~mm-mprotect-use-mmu_gather
+++ a/mm/huge_memory.c
@@ -1709,8 +1709,9 @@ bool move_huge_pmd(struct vm_area_struct
  *      or if prot_numa but THP migration is not supported
  *  - HPAGE_PMD_NR if protections changed and TLB flush necessary
  */
-int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, pgprot_t newprot, unsigned long cp_flags)
+int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
+		    unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
@@ -1721,6 +1722,8 @@ int change_huge_pmd(struct vm_area_struc
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
+	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
+
 	if (prot_numa && !thp_migration_supported())
 		return 1;
 
@@ -1819,6 +1822,9 @@ int change_huge_pmd(struct vm_area_struc
 	}
 	ret = HPAGE_PMD_NR;
 	set_pmd_at(mm, addr, pmd, entry);
+
+	tlb_flush_pmd_range(tlb, addr, HPAGE_PMD_SIZE);
+
 	BUG_ON(vma_is_anonymous(vma) && !preserve_write && pmd_write(entry));
 unlock:
 	spin_unlock(ptl);
--- a/mm/mempolicy.c~mm-mprotect-use-mmu_gather
+++ a/mm/mempolicy.c
@@ -104,6 +104,7 @@
 #include <linux/swapops.h>
 
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
 #include <linux/uaccess.h>
 
 #include "internal.h"
@@ -636,12 +637,18 @@ unlock:
 unsigned long change_prot_numa(struct vm_area_struct *vma,
 			unsigned long addr, unsigned long end)
 {
+	struct mmu_gather tlb;
 	int nr_updated;
 
-	nr_updated = change_protection(vma, addr, end, PAGE_NONE, MM_CP_PROT_NUMA);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+
+	nr_updated = change_protection(&tlb, vma, addr, end, PAGE_NONE,
+				       MM_CP_PROT_NUMA);
 	if (nr_updated)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
+	tlb_finish_mmu(&tlb);
+
 	return nr_updated;
 }
 #else
--- a/mm/mprotect.c~mm-mprotect-use-mmu_gather
+++ a/mm/mprotect.c
@@ -33,12 +33,13 @@
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
-static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+static unsigned long change_pte_range(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
@@ -49,6 +50,8 @@ static unsigned long change_pte_range(st
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
+	tlb_change_page_size(tlb, PAGE_SIZE);
+
 	/*
 	 * Can be called with only the mmap_lock for reading by
 	 * prot_numa so we must check the pmd isn't constantly
@@ -149,6 +152,7 @@ static unsigned long change_pte_range(st
 				ptent = pte_mkwrite(ptent);
 			}
 			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
+			tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
@@ -234,9 +238,9 @@ static inline int pmd_none_or_clear_bad_
 	return 0;
 }
 
-static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
-		pud_t *pud, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline unsigned long change_pmd_range(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -276,8 +280,12 @@ static inline unsigned long change_pmd_r
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
-				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-							      newprot, cp_flags);
+				/*
+				 * change_huge_pmd() does not defer TLB flushes,
+				 * so no need to propagate the tlb argument.
+				 */
+				int nr_ptes = change_huge_pmd(tlb, vma, pmd,
+						addr, newprot, cp_flags);
 
 				if (nr_ptes) {
 					if (nr_ptes == HPAGE_PMD_NR) {
@@ -291,8 +299,8 @@ static inline unsigned long change_pmd_r
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-					      cp_flags);
+		this_pages = change_pte_range(tlb, vma, pmd, addr, next,
+					      newprot, cp_flags);
 		pages += this_pages;
 next:
 		cond_resched();
@@ -306,9 +314,9 @@ next:
 	return pages;
 }
 
-static inline unsigned long change_pud_range(struct vm_area_struct *vma,
-		p4d_t *p4d, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline unsigned long change_pud_range(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -319,16 +327,16 @@ static inline unsigned long change_pud_r
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		pages += change_pmd_range(vma, pud, addr, next, newprot,
+		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
 					  cp_flags);
 	} while (pud++, addr = next, addr != end);
 
 	return pages;
 }
 
-static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
-		pgd_t *pgd, unsigned long addr, unsigned long end,
-		pgprot_t newprot, unsigned long cp_flags)
+static inline unsigned long change_p4d_range(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pgd_t *pgd, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -339,44 +347,40 @@ static inline unsigned long change_p4d_r
 		next = p4d_addr_end(addr, end);
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
-		pages += change_pud_range(vma, p4d, addr, next, newprot,
+		pages += change_pud_range(tlb, vma, p4d, addr, next, newprot,
 					  cp_flags);
 	} while (p4d++, addr = next, addr != end);
 
 	return pages;
 }
 
-static unsigned long change_protection_range(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+static unsigned long change_protection_range(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start = addr;
 	unsigned long pages = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
-	flush_cache_range(vma, addr, end);
-	inc_tlb_flush_pending(mm);
+	tlb_start_vma(tlb, vma);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		pages += change_p4d_range(vma, pgd, addr, next, newprot,
+		pages += change_p4d_range(tlb, vma, pgd, addr, next, newprot,
 					  cp_flags);
 	} while (pgd++, addr = next, addr != end);
 
-	/* Only flush the TLB if we actually modified any entries: */
-	if (pages)
-		flush_tlb_range(vma, start, end);
-	dec_tlb_flush_pending(mm);
+	tlb_end_vma(tlb, vma);
 
 	return pages;
 }
 
-unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
+unsigned long change_protection(struct mmu_gather *tlb,
+		       struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
 		       unsigned long cp_flags)
 {
@@ -387,7 +391,7 @@ unsigned long change_protection(struct v
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);
 	else
-		pages = change_protection_range(vma, start, end, newprot,
+		pages = change_protection_range(tlb, vma, start, end, newprot,
 						cp_flags);
 
 	return pages;
@@ -421,8 +425,9 @@ static const struct mm_walk_ops prot_non
 };
 
 int
-mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
-	unsigned long start, unsigned long end, unsigned long newflags)
+mprotect_fixup(struct mmu_gather *tlb, struct vm_area_struct *vma,
+	       struct vm_area_struct **pprev, unsigned long start,
+	       unsigned long end, unsigned long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
@@ -509,7 +514,7 @@ success:
 	dirty_accountable = vma_wants_writenotify(vma, vma->vm_page_prot);
 	vma_set_page_prot(vma);
 
-	change_protection(vma, start, end, vma->vm_page_prot,
+	change_protection(tlb, vma, start, end, vma->vm_page_prot,
 			  dirty_accountable ? MM_CP_DIRTY_ACCT : 0);
 
 	/*
@@ -543,6 +548,7 @@ static int do_mprotect_pkey(unsigned lon
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
+	struct mmu_gather tlb;
 
 	start = untagged_addr(start);
 
@@ -602,6 +608,7 @@ static int do_mprotect_pkey(unsigned lon
 	else
 		prev = vma->vm_prev;
 
+	tlb_gather_mmu(&tlb, current->mm);
 	for (nstart = start ; ; ) {
 		unsigned long mask_off_old_flags;
 		unsigned long newflags;
@@ -628,18 +635,18 @@ static int do_mprotect_pkey(unsigned lon
 		/* newflags >> 4 shift VM_MAY% in place of VM_% */
 		if ((newflags & ~(newflags >> 4)) & VM_ACCESS_FLAGS) {
 			error = -EACCES;
-			goto out;
+			break;
 		}
 
 		/* Allow architectures to sanity-check the new flags */
 		if (!arch_validate_flags(newflags)) {
 			error = -EINVAL;
-			goto out;
+			break;
 		}
 
 		error = security_file_mprotect(vma, reqprot, prot);
 		if (error)
-			goto out;
+			break;
 
 		tmp = vma->vm_end;
 		if (tmp > end)
@@ -648,27 +655,28 @@ static int do_mprotect_pkey(unsigned lon
 		if (vma->vm_ops && vma->vm_ops->mprotect) {
 			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
 			if (error)
-				goto out;
+				break;
 		}
 
-		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
+		error = mprotect_fixup(&tlb, vma, &prev, nstart, tmp, newflags);
 		if (error)
-			goto out;
+			break;
 
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
 			nstart = prev->vm_end;
 		if (nstart >= end)
-			goto out;
+			break;
 
 		vma = prev->vm_next;
 		if (!vma || vma->vm_start != nstart) {
 			error = -ENOMEM;
-			goto out;
+			break;
 		}
 		prot = reqprot;
 	}
+	tlb_finish_mmu(&tlb);
 out:
 	mmap_write_unlock(current->mm);
 	return error;
--- a/mm/userfaultfd.c~mm-mprotect-use-mmu_gather
+++ a/mm/userfaultfd.c
@@ -16,6 +16,7 @@
 #include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
 #include "internal.h"
 
 static __always_inline
@@ -687,6 +688,7 @@ int mwriteprotect_range(struct mm_struct
 			atomic_t *mmap_changing)
 {
 	struct vm_area_struct *dst_vma;
+	struct mmu_gather tlb;
 	pgprot_t newprot;
 	int err;
 
@@ -728,8 +730,10 @@ int mwriteprotect_range(struct mm_struct
 	else
 		newprot = vm_get_page_prot(dst_vma->vm_flags);
 
-	change_protection(dst_vma, start, start + len, newprot,
+	tlb_gather_mmu(&tlb, dst_mm);
+	change_protection(&tlb, dst_vma, start, start + len, newprot,
 			  enable_wp ? MM_CP_UFFD_WP : MM_CP_UFFD_WP_RESOLVE);
+	tlb_finish_mmu(&tlb);
 
 	err = 0;
 out_unlock:
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
mm-mprotect-use-mmu_gather.patch
mm-mprotect-do-not-flush-when-not-required-architecturally.patch
mm-avoid-unnecessary-flush-on-change_huge_pmd.patch

