From: akpm@linux-foundation.org
Subject: + thp-add-tlb_remove_pmd_tlb_entry.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:08:44 -0800
Message-ID: <201111222308.pAMN8jS6014656@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53195 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab1KVXIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:08:47 -0500
Received: by yenm12 with SMTP id m12so148099yen.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:08:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, aarcange@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: thp: add tlb_remove_pmd_tlb_entry
has been added to the -mm tree.  Its filename is
     thp-add-tlb_remove_pmd_tlb_entry.patch

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
From: Shaohua Li <shaohua.li@intel.com>
Subject: thp: add tlb_remove_pmd_tlb_entry

We have tlb_remove_tlb_entry to indicate a pte tlb flush entry should be
flushed, but not a corresponding API for pmd entry.  This isn't a problem
so far because THP is only for x86 currently and tlb_flush() under x86
will flush entire TLB.  But this is confusion and could be missed if thp
is ported to other arch.

Also convert tlb->need_flush = 1 to a VM_BUG_ON(!tlb->need_flush) in
__tlb_remove_page() as suggested by Andrea Arcangeli.  __tlb_remove_page()
is supposed to be called after tlb_remove_xxx_tlb_entry() and we can catch
any misuse.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   14 ++++++++++++++
 include/linux/huge_mm.h   |    2 +-
 mm/huge_memory.c          |    3 ++-
 mm/memory.c               |    4 ++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/tlb.h~thp-add-tlb_remove_pmd_tlb_entry include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~thp-add-tlb_remove_pmd_tlb_entry
+++ a/include/asm-generic/tlb.h
@@ -139,6 +139,20 @@ static inline void tlb_remove_page(struc
 		__tlb_remove_tlb_entry(tlb, ptep, address);	\
 	} while (0)
 
+/**
+ * tlb_remove_pmd_tlb_entry - remember a pmd mapping for later tlb invalidation
+ * This is a nop so far, because only x86 needs it.
+ */
+#ifndef __tlb_remove_pmd_tlb_entry
+#define __tlb_remove_pmd_tlb_entry(tlb, pmdp, address) do {} while (0)
+#endif
+
+#define tlb_remove_pmd_tlb_entry(tlb, pmdp, address)		\
+	do {							\
+		tlb->need_flush = 1;				\
+		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
+	} while (0)
+
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		tlb->need_flush = 1;				\
diff -puN include/linux/huge_mm.h~thp-add-tlb_remove_pmd_tlb_entry include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-add-tlb_remove_pmd_tlb_entry
+++ a/include/linux/huge_mm.h
@@ -18,7 +18,7 @@ extern struct page *follow_trans_huge_pm
 					  unsigned int flags);
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
-			pmd_t *pmd);
+			pmd_t *pmd, unsigned long addr);
 extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
diff -puN mm/huge_memory.c~thp-add-tlb_remove_pmd_tlb_entry mm/huge_memory.c
--- a/mm/huge_memory.c~thp-add-tlb_remove_pmd_tlb_entry
+++ a/mm/huge_memory.c
@@ -1026,7 +1026,7 @@ out:
 }
 
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		 pmd_t *pmd)
+		 pmd_t *pmd, unsigned long addr)
 {
 	int ret = 0;
 
@@ -1042,6 +1042,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			pgtable = get_pmd_huge_pte(tlb->mm);
 			page = pmd_page(*pmd);
 			pmd_clear(pmd);
+			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 			page_remove_rmap(page);
 			VM_BUG_ON(page_mapcount(page) < 0);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
diff -puN mm/memory.c~thp-add-tlb_remove_pmd_tlb_entry mm/memory.c
--- a/mm/memory.c~thp-add-tlb_remove_pmd_tlb_entry
+++ a/mm/memory.c
@@ -293,7 +293,7 @@ int __tlb_remove_page(struct mmu_gather 
 {
 	struct mmu_gather_batch *batch;
 
-	tlb->need_flush = 1;
+	VM_BUG_ON(!tlb->need_flush);
 
 	if (tlb_fast_mode(tlb)) {
 		free_page_and_swap_cache(page);
@@ -1231,7 +1231,7 @@ static inline unsigned long zap_pmd_rang
 			if (next-addr != HPAGE_PMD_SIZE) {
 				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
 				split_huge_page_pmd(vma->vm_mm, pmd);
-			} else if (zap_huge_pmd(tlb, vma, pmd))
+			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				continue;
 			/* fall through */
 		}
_
Subject: Subject: thp: add tlb_remove_pmd_tlb_entry

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

