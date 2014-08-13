From: akpm@linux-foundation.org
Subject: + x86mm-fix-pte_special-versus-pte_numa.patch added to -mm tree
Date: Wed, 13 Aug 2014 14:45:15 -0700
Message-ID: <53ebdc6b.TTydQHRwqgokTFJp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:44520 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaHMVpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 17:45:16 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so296932igd.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 14:45:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, gorcunov@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, peterz@infradead.org, riel@redhat.com, sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86,mm: fix pte_special versus pte_numa
has been added to the -mm tree.  Its filename is
     x86mm-fix-pte_special-versus-pte_numa.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86mm-fix-pte_special-versus-pte_numa.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86mm-fix-pte_special-versus-pte_numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
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
