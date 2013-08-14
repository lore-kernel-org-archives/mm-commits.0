From: akpm@linux-foundation.org
Subject: [merged] mm-save-soft-dirty-bits-on-file-pages.patch removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:31 -0700
Message-ID: <520bdc03.Cmhlsspo8wgG8vH4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab3HNTfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, sfr@canb.auug.org.au, peterz@infradead.org, mtosatti@redhat.com, mpm@selenic.com, minchan@kernel.org, luto@amacapital.net, liwanp@linux.vnet.ibm.com, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, gorcunov@gmail.com

Subject: [merged] mm-save-soft-dirty-bits-on-file-pages.patch removed from -mm tree
To: gorcunov@gmail.com,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,liwanp@linux.vnet.ibm.com,luto@amacapital.net,minchan@kernel.org,mpm@selenic.com,mtosatti@redhat.com,peterz@infradead.org,sfr@canb.auug.org.au,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:31 -0700


The patch titled
     Subject: mm: save soft-dirty bits on file pages
has been removed from the -mm tree.  Its filename was
     mm-save-soft-dirty-bits-on-file-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: save soft-dirty bits on file pages

Andy reported that if file page get reclaimed we lose the soft-dirty bit
if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address get
encoded into pte entry.  Thus when #pf happens on such non-present pte we
can restore it back.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |   48 +++++++++++++++++++++++-
 arch/x86/include/asm/pgtable-3level.h |    3 +
 arch/x86/include/asm/pgtable.h        |   15 +++++++
 arch/x86/include/asm/pgtable_types.h  |    4 +-
 fs/proc/task_mmu.c                    |    2 +
 include/asm-generic/pgtable.h         |   15 +++++++
 mm/fremap.c                           |   11 ++++-
 mm/memory.c                           |   11 ++++-
 mm/rmap.c                             |    8 +++-
 9 files changed, 107 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~mm-save-soft-dirty-bits-on-file-pages arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~mm-save-soft-dirty-bits-on-file-pages
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -55,9 +55,53 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+#ifdef CONFIG_MEM_SOFT_DIRTY
+
+/*
+ * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE, _PAGE_BIT_SOFT_DIRTY and
+ * _PAGE_BIT_PROTNONE are taken, split up the 28 bits of offset
+ * into this range.
+ */
+#define PTE_FILE_MAX_BITS	28
+#define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
+#define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
+#define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
+#define PTE_FILE_SHIFT4		(_PAGE_BIT_SOFT_DIRTY + 1)
+#define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
+#define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
+#define PTE_FILE_BITS3		(PTE_FILE_SHIFT4 - PTE_FILE_SHIFT3 - 1)
+
+#define pte_to_pgoff(pte)						\
+	((((pte).pte_low >> (PTE_FILE_SHIFT1))				\
+	  & ((1U << PTE_FILE_BITS1) - 1)))				\
+	+ ((((pte).pte_low >> (PTE_FILE_SHIFT2))			\
+	    & ((1U << PTE_FILE_BITS2) - 1))				\
+	   << (PTE_FILE_BITS1))						\
+	+ ((((pte).pte_low >> (PTE_FILE_SHIFT3))			\
+	    & ((1U << PTE_FILE_BITS3) - 1))				\
+	   << (PTE_FILE_BITS1 + PTE_FILE_BITS2))			\
+	+ ((((pte).pte_low >> (PTE_FILE_SHIFT4)))			\
+	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3))
+
+#define pgoff_to_pte(off)						\
+	((pte_t) { .pte_low =						\
+	 ((((off)) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
+	 + ((((off) >> PTE_FILE_BITS1)					\
+	     & ((1U << PTE_FILE_BITS2) - 1))				\
+	    << PTE_FILE_SHIFT2)						\
+	 + ((((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
+	     & ((1U << PTE_FILE_BITS3) - 1))				\
+	    << PTE_FILE_SHIFT3)						\
+	 + ((((off) >>							\
+	      (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)))	\
+	    << PTE_FILE_SHIFT4)						\
+	 + _PAGE_FILE })
+
+#else /* CONFIG_MEM_SOFT_DIRTY */
+
 /*
  * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
- * split up the 29 bits of offset into this range:
+ * split up the 29 bits of offset into this range.
  */
 #define PTE_FILE_MAX_BITS	29
 #define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
@@ -88,6 +132,8 @@ static inline pmd_t native_pmdp_get_and_
 	    << PTE_FILE_SHIFT3)						\
 	 + _PAGE_FILE })
 
+#endif /* CONFIG_MEM_SOFT_DIRTY */
+
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
diff -puN arch/x86/include/asm/pgtable-3level.h~mm-save-soft-dirty-bits-on-file-pages arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~mm-save-soft-dirty-bits-on-file-pages
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -179,6 +179,9 @@ static inline pmd_t native_pmdp_get_and_
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
+ *
+ * For soft-dirty tracking 11 bit is taken from
+ * the low part of pte as well.
  */
 #define pte_to_pgoff(pte) ((pte).pte_high)
 #define pgoff_to_pte(off)						\
diff -puN arch/x86/include/asm/pgtable.h~mm-save-soft-dirty-bits-on-file-pages arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-save-soft-dirty-bits-on-file-pages
+++ a/arch/x86/include/asm/pgtable.h
@@ -329,6 +329,21 @@ static inline pte_t pte_swp_clear_soft_d
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
 
+static inline pte_t pte_file_clear_soft_dirty(pte_t pte)
+{
+	return pte_clear_flags(pte, _PAGE_SOFT_DIRTY);
+}
+
+static inline pte_t pte_file_mksoft_dirty(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SOFT_DIRTY);
+}
+
+static inline int pte_file_soft_dirty(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
+}
+
 /*
  * Mask out unsupported bits in a present pgprot.  Non-present pgprots
  * can use those bits for other purposes, so leave them be.
diff -puN arch/x86/include/asm/pgtable_types.h~mm-save-soft-dirty-bits-on-file-pages arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-save-soft-dirty-bits-on-file-pages
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -61,8 +61,10 @@
  * they do not conflict with each other.
  */
 
+#define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_HIDDEN
+
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
+#define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 1) << _PAGE_BIT_SOFT_DIRTY)
 #else
 #define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 0))
 #endif
diff -puN fs/proc/task_mmu.c~mm-save-soft-dirty-bits-on-file-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-save-soft-dirty-bits-on-file-pages
+++ a/fs/proc/task_mmu.c
@@ -736,6 +736,8 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
 	} else if (is_swap_pte(ptent)) {
 		ptent = pte_swp_clear_soft_dirty(ptent);
+	} else if (pte_file(ptent)) {
+		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
diff -puN include/asm-generic/pgtable.h~mm-save-soft-dirty-bits-on-file-pages include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-save-soft-dirty-bits-on-file-pages
+++ a/include/asm-generic/pgtable.h
@@ -432,6 +432,21 @@ static inline pte_t pte_swp_clear_soft_d
 {
 	return pte;
 }
+
+static inline pte_t pte_file_clear_soft_dirty(pte_t pte)
+{
+       return pte;
+}
+
+static inline pte_t pte_file_mksoft_dirty(pte_t pte)
+{
+       return pte;
+}
+
+static inline int pte_file_soft_dirty(pte_t pte)
+{
+       return 0;
+}
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff -puN mm/fremap.c~mm-save-soft-dirty-bits-on-file-pages mm/fremap.c
--- a/mm/fremap.c~mm-save-soft-dirty-bits-on-file-pages
+++ a/mm/fremap.c
@@ -57,17 +57,22 @@ static int install_file_pte(struct mm_st
 		unsigned long addr, unsigned long pgoff, pgprot_t prot)
 {
 	int err = -ENOMEM;
-	pte_t *pte;
+	pte_t *pte, ptfile;
 	spinlock_t *ptl;
 
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
 		goto out;
 
-	if (!pte_none(*pte))
+	ptfile = pgoff_to_pte(pgoff);
+
+	if (!pte_none(*pte)) {
+		if (pte_present(*pte) && pte_soft_dirty(*pte))
+			pte_file_mksoft_dirty(ptfile);
 		zap_pte(mm, vma, addr, pte);
+	}
 
-	set_pte_at(mm, addr, pte, pgoff_to_pte(pgoff));
+	set_pte_at(mm, addr, pte, ptfile);
 	/*
 	 * We don't need to run update_mmu_cache() here because the "file pte"
 	 * being installed by install_file_pte() is not a real pte - it's a
diff -puN mm/memory.c~mm-save-soft-dirty-bits-on-file-pages mm/memory.c
--- a/mm/memory.c~mm-save-soft-dirty-bits-on-file-pages
+++ a/mm/memory.c
@@ -1141,9 +1141,12 @@ again:
 				continue;
 			if (unlikely(details) && details->nonlinear_vma
 			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index)
-				set_pte_at(mm, addr, pte,
-					   pgoff_to_pte(page->index));
+						addr) != page->index) {
+				pte_t ptfile = pgoff_to_pte(page->index);
+				if (pte_soft_dirty(ptent))
+					pte_file_mksoft_dirty(ptfile);
+				set_pte_at(mm, addr, pte, ptfile);
+			}
 			if (PageAnon(page))
 				rss[MM_ANONPAGES]--;
 			else {
@@ -3410,6 +3413,8 @@ static int __do_fault(struct mm_struct *
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		else if (pte_file(orig_pte) && pte_file_soft_dirty(orig_pte))
+			pte_mksoft_dirty(entry);
 		if (anon) {
 			inc_mm_counter_fast(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
diff -puN mm/rmap.c~mm-save-soft-dirty-bits-on-file-pages mm/rmap.c
--- a/mm/rmap.c~mm-save-soft-dirty-bits-on-file-pages
+++ a/mm/rmap.c
@@ -1405,8 +1405,12 @@ static int try_to_unmap_cluster(unsigned
 		pteval = ptep_clear_flush(vma, address, pte);
 
 		/* If nonlinear, store the file page offset in the pte. */
-		if (page->index != linear_page_index(vma, address))
-			set_pte_at(mm, address, pte, pgoff_to_pte(page->index));
+		if (page->index != linear_page_index(vma, address)) {
+			pte_t ptfile = pgoff_to_pte(page->index);
+			if (pte_soft_dirty(pteval))
+				pte_file_mksoft_dirty(ptfile);
+			set_pte_at(mm, address, pte, ptfile);
+		}
 
 		/* Move the dirty bit to the physical page now the pte is gone. */
 		if (pte_dirty(pteval))
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch

