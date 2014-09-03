From: akpm@linux-foundation.org
Subject: [merged] x86mm-fix-pte_special-versus-pte_numa.patch removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:33 -0700
Message-ID: <5407568d.Edm3cGOavtlk9GCn%akpm__105.498874518339$1409767070$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbaICR5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, gorcunov@gmail.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, peterz@infradead.org, riel@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86,mm: fix pte_special versus pte_numa
has been removed from the -mm tree.  Its filename was
     x86mm-fix-pte_special-versus-pte_numa.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: x86,mm: fix pte_special versus pte_numa

Sasha Levin has shown oopses on ffffea0003480048 and ffffea0003480008 at
mm/memory.c:1132, running Trinity on different 3.16-rc-next kernels: where
zap_pte_range() checks page->mapping to see if PageAnon(page).

Those addresses fit struct pages for pfns d2001 and d2000, and in each
dump a register or a stack slot showed d2001730 or d2000730: pte flags
0x730 are PCD ACCESSED PROTNONE SPECIAL IOMAP; and Sasha's e820 map has a
hole between cfffffff and 100000000, which would need special access.

Commit c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on
the PMD and PTE levels") has broken vm_normal_page(): a PROTNONE SPECIAL
pte no longer passes the pte_special() test, so zap_pte_range() goes on to
try to access a non-existent struct page.

Fix this by refining pte_special() (SPECIAL with PRESENT or PROTNONE) to
complement pte_numa() (SPECIAL with neither PRESENT nor PROTNONE).  A hint
that this was a problem was that c46a7c817e66 added pte_numa() test to
vm_normal_page(), and moved its is_zero_pfn() test from slow to fast path:
This was papering over a pte_special() snag when the zero page was
encountered during zap.  This patch reverts vm_normal_page() to how it was
before, relying on pte_special().

It still appears that this patch may be incomplete: aren't there other
places which need to be handling PROTNONE along with PRESENT?  For
example, pte_mknuma() clears _PAGE_PRESENT and sets _PAGE_NUMA, but on a
PROT_NONE area, that would make it pte_special().  This is side-stepped by
the fact that NUMA hinting faults skipped PROT_NONE VMAs and there are no
grounds where a NUMA hinting fault on a PROT_NONE VMA would be
interesting.

Fixes: c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels")
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: <stable@vger.kernel.org>	[3.16]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    9 +++++++--
 mm/memory.c                    |    7 +++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~x86mm-fix-pte_special-versus-pte_numa arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86mm-fix-pte_special-versus-pte_numa
+++ a/arch/x86/include/asm/pgtable.h
@@ -131,8 +131,13 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return (pte_flags(pte) & (_PAGE_PRESENT|_PAGE_SPECIAL)) ==
-				 (_PAGE_PRESENT|_PAGE_SPECIAL);
+	/*
+	 * See CONFIG_NUMA_BALANCING pte_numa in include/asm-generic/pgtable.h.
+	 * On x86 we have _PAGE_BIT_NUMA == _PAGE_BIT_GLOBAL+1 ==
+	 * __PAGE_BIT_SOFTW1 == _PAGE_BIT_SPECIAL.
+	 */
+	return (pte_flags(pte) & _PAGE_SPECIAL) &&
+		(pte_flags(pte) & (_PAGE_PRESENT|_PAGE_PROTNONE));
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
diff -puN mm/memory.c~x86mm-fix-pte_special-versus-pte_numa mm/memory.c
--- a/mm/memory.c~x86mm-fix-pte_special-versus-pte_numa
+++ a/mm/memory.c
@@ -751,7 +751,7 @@ struct page *vm_normal_page(struct vm_ar
 	unsigned long pfn = pte_pfn(pte);
 
 	if (HAVE_PTE_SPECIAL) {
-		if (likely(!pte_special(pte) || pte_numa(pte)))
+		if (likely(!pte_special(pte)))
 			goto check_pfn;
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
@@ -777,15 +777,14 @@ struct page *vm_normal_page(struct vm_ar
 		}
 	}
 
+	if (is_zero_pfn(pfn))
+		return NULL;
 check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
 
-	if (is_zero_pfn(pfn))
-		return NULL;
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

