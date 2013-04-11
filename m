From: akpm@linux-foundation.org
Subject: + mm-soft-dirty-bits-for-user-memory-changes-tracking.patch added to -mm tree
Date: Thu, 11 Apr 2013 14:25:13 -0700
Message-ID: <20130411212514.1025931C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41765 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161549Ab3DKVZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 17:25:15 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so188169yen.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 14:25:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, glommer@parallels.com, kosaki.motohiro@gmail.com, mpm@selenic.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm: soft-dirty bits for user memory changes tracking
has been added to the -mm tree.  Its filename is
     mm-soft-dirty-bits-for-user-memory-changes-tracking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: mm: soft-dirty bits for user memory changes tracking

The soft-dirty is a bit on a PTE which helps to track which pages a task
writes to. In order to do this tracking one should

  1. Clear soft-dirty bits from PTEs ("echo 4 > /proc/PID/clear_refs)
  2. Wait some time.
  3. Read soft-dirty bits (55'th in /proc/PID/pagemap2 entries)

To do this tracking, the writable bit is cleared from PTEs when the
soft-dirty bit is. Thus, after this, when the task tries to modify a page
at some virtual address the #PF occurs and the kernel sets the soft-dirty
bit on the respective PTE.

Note, that although all the task's address space is marked as r/o after the
soft-dirty bits clear, the #PF-s that occur after that are processed fast.
This is so, since the pages are still mapped to physical memory, and thus
all the kernel does is finds this fact out and puts back writable, dirty
and soft-dirty bits on the PTE.

Another thing to note, is that when mremap moves PTEs they are marked with
soft-dirty as well, since from the user perspective mremap modifies the
virtual memory at mremap's new address.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt   |    7 +++-
 Documentation/vm/pagemap.txt         |    4 +-
 Documentation/vm/soft-dirty.txt      |   36 +++++++++++++++++++++
 arch/x86/include/asm/pgtable.h       |   26 ++++++++++++++-
 arch/x86/include/asm/pgtable_types.h |   12 +++++++
 fs/proc/task_mmu.c                   |   42 ++++++++++++++++++++++---
 include/asm-generic/pgtable.h        |   22 +++++++++++++
 mm/Kconfig                           |   12 +++++++
 mm/huge_memory.c                     |    2 -
 mm/mremap.c                          |    2 -
 10 files changed, 154 insertions(+), 11 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-soft-dirty-bits-for-user-memory-changes-tracking Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/Documentation/filesystems/proc.txt
@@ -473,7 +473,8 @@ This file is only present if the CONFIG_
 enabled.
 
 The /proc/PID/clear_refs is used to reset the PG_Referenced and ACCESSED/YOUNG
-bits on both physical and virtual pages associated with a process.
+bits on both physical and virtual pages associated with a process, and the
+soft-dirty bit on pte (see Documentation/vm/soft-dirty.txt for details).
 To clear the bits for all the pages associated with the process
     > echo 1 > /proc/PID/clear_refs
 
@@ -482,6 +483,10 @@ To clear the bits for the anonymous page
 
 To clear the bits for the file mapped pages associated with the process
     > echo 3 > /proc/PID/clear_refs
+
+To clear the soft-dirty bit
+    > echo 4 > /proc/PID/clear_refs
+
 Any other value written to /proc/PID/clear_refs will have no effect.
 
 The /proc/pid/pagemap gives the PFN, which can be used to find the pageflags
diff -puN Documentation/vm/pagemap.txt~mm-soft-dirty-bits-for-user-memory-changes-tracking Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/Documentation/vm/pagemap.txt
@@ -31,7 +31,9 @@ There are three components to pagemap:
    skip over unmapped regions.
 
  * /proc/pid/pagemap2.  This file provides the same info as the pagemap
-   does, but bits 55-60 are reserved for future use and thus zero
+   does, but bits 56-60 are reserved for future use and thus zero
+
+      Bit 55 means pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
 
  * /proc/kpagecount.  This file contains a 64-bit count of the number of
    times each page is mapped, indexed by PFN.
diff -puN /dev/null Documentation/vm/soft-dirty.txt
--- /dev/null
+++ a/Documentation/vm/soft-dirty.txt
@@ -0,0 +1,36 @@
+                            SOFT-DIRTY PTEs
+
+  The soft-dirty is a bit on a PTE which helps to track which pages a task
+writes to. In order to do this tracking one should
+
+  1. Clear soft-dirty bits from the task's PTEs.
+
+     This is done by writing "4" into the /proc/PID/clear_refs file of the
+     task in question.
+
+  2. Wait some time.
+
+  3. Read soft-dirty bits from the PTEs.
+
+     This is done by reading from the /proc/PID/pagemap. The bit 55 of the
+     64-bit qword is the soft-dirty one. If set, the respective PTE was
+     written to since step 1.
+
+
+  Internally, to do this tracking, the writable bit is cleared from PTEs
+when the soft-dirty bit is cleared. So, after this, when the task tries to
+modify a page at some virtual address the #PF occurs and the kernel sets
+the soft-dirty bit on the respective PTE.
+
+  Note, that although all the task's address space is marked as r/o after the
+soft-dirty bits clear, the #PF-s that occur after that are processed fast.
+This is so, since the pages are still mapped to physical memory, and thus all
+the kernel does is finds this fact out and puts both writable and soft-dirty
+bits on the PTE.
+
+
+  This feature is actively used by the checkpoint-restore project. You
+can find more details about it on http://criu.org
+
+
+-- Pavel Emelyanov, Apr 9, 2013
diff -puN arch/x86/include/asm/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/arch/x86/include/asm/pgtable.h
@@ -207,7 +207,7 @@ static inline pte_t pte_mkexec(pte_t pte
 
 static inline pte_t pte_mkdirty(pte_t pte)
 {
-	return pte_set_flags(pte, _PAGE_DIRTY);
+	return pte_set_flags(pte, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
 static inline pte_t pte_mkyoung(pte_t pte)
@@ -271,7 +271,7 @@ static inline pmd_t pmd_wrprotect(pmd_t
 
 static inline pmd_t pmd_mkdirty(pmd_t pmd)
 {
-	return pmd_set_flags(pmd, _PAGE_DIRTY);
+	return pmd_set_flags(pmd, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
 static inline pmd_t pmd_mkhuge(pmd_t pmd)
@@ -294,6 +294,28 @@ static inline pmd_t pmd_mknotpresent(pmd
 	return pmd_clear_flags(pmd, _PAGE_PRESENT);
 }
 
+#define __HAVE_SOFT_DIRTY
+
+static inline int pte_soft_dirty(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
+}
+
+static inline int pmd_soft_dirty(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SOFT_DIRTY;
+}
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SOFT_DIRTY);
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
+}
+
 /*
  * Mask out unsupported bits in a present pgprot.  Non-present pgprots
  * can use those bits for other purposes, so leave them be.
diff -puN arch/x86/include/asm/pgtable_types.h~mm-soft-dirty-bits-for-user-memory-changes-tracking arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -55,6 +55,18 @@
 #define _PAGE_HIDDEN	(_AT(pteval_t, 0))
 #endif
 
+/*
+ * The same hidden bit is used by kmemcheck, but since kmemcheck
+ * works on kernel pages while soft-dirty engine on user space,
+ * they do not conflict with each other.
+ */
+
+#ifdef CONFIG_MEM_SOFT_DIRTY
+#define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
+#else
+#define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 0))
+#endif
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
 #else
diff -puN fs/proc/task_mmu.c~mm-soft-dirty-bits-for-user-memory-changes-tracking fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/fs/proc/task_mmu.c
@@ -692,13 +692,32 @@ enum clear_refs_types {
 	CLEAR_REFS_ALL = 1,
 	CLEAR_REFS_ANON,
 	CLEAR_REFS_MAPPED,
+	CLEAR_REFS_SOFT_DIRTY,
 	CLEAR_REFS_LAST,
 };
 
 struct clear_refs_private {
 	struct vm_area_struct *vma;
+	enum clear_refs_types type;
 };
 
+static inline void clear_soft_dirty(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *pte)
+{
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	/*
+	 * The soft-dirty tracker uses #PF-s to catch writes
+	 * to pages, so write-protect the pte as well. See the
+	 * Documentation/vm/soft-dirty.txt for full description
+	 * of how soft-dirty works.
+	 */
+	pte_t ptent = *pte;
+	ptent = pte_wrprotect(ptent);
+	ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
+	set_pte_at(vma->vm_mm, addr, pte, ptent);
+#endif
+}
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -718,6 +737,11 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pte_present(ptent))
 			continue;
 
+		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+			clear_soft_dirty(vma, addr, pte);
+			continue;
+		}
+
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
 			continue;
@@ -759,6 +783,7 @@ static ssize_t clear_refs_write(struct f
 	mm = get_task_mm(task);
 	if (mm) {
 		struct clear_refs_private cp = {
+			.type = type,
 		};
 		struct mm_walk clear_refs_walk = {
 			.pmd_entry = clear_refs_pte_range,
@@ -827,6 +852,7 @@ struct pagemapread {
 /* in pagemap2 pshift bits are occupied with more status bits */
 #define PM_STATUS2(v2, x)   (__PM_PSHIFT(v2 ? x : PAGE_SHIFT))
 
+#define __PM_SOFT_DIRTY      (1LL)
 #define PM_PRESENT          PM_STATUS(4LL)
 #define PM_SWAP             PM_STATUS(2LL)
 #define PM_FILE             PM_STATUS(1LL)
@@ -868,6 +894,7 @@ static void pte_to_pagemap_entry(pagemap
 {
 	u64 frame, flags;
 	struct page *page = NULL;
+	int flags2 = 0;
 
 	if (pte_present(pte)) {
 		frame = pte_pfn(pte);
@@ -888,13 +915,15 @@ static void pte_to_pagemap_entry(pagemap
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
+	if (pte_soft_dirty(pte))
+		flags2 |= __PM_SOFT_DIRTY;
 
-	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, 0) | flags);
+	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-					pmd_t pmd, int offset)
+		pmd_t pmd, int offset, int pmd_flags2)
 {
 	/*
 	 * Currently pmd for thp is always present because thp can not be
@@ -903,13 +932,13 @@ static void thp_pmd_to_pagemap_entry(pag
 	 */
 	if (pmd_present(pmd))
 		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
-				| PM_STATUS2(pm->v2, 0) | PM_PRESENT);
+				| PM_STATUS2(pm->v2, pmd_flags2) | PM_PRESENT);
 	else
 		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
 }
 #else
 static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-						pmd_t pmd, int offset)
+		pmd_t pmd, int offset, int pmd_flags2)
 {
 }
 #endif
@@ -926,12 +955,15 @@ static int pagemap_pte_range(pmd_t *pmd,
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
+		int pmd_flags2;
+
+		pmd_flags2 = (pmd_soft_dirty(*pmd) ? __PM_SOFT_DIRTY : 0);
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
-			thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset);
+			thp_pmd_to_pagemap_entry(&pme, pm, *pmd, offset, pmd_flags2);
 			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
diff -puN include/asm-generic/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/include/asm-generic/pgtable.h
@@ -396,6 +396,28 @@ static inline void ptep_modify_prot_comm
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
+#ifndef __HAVE_SOFT_DIRTY
+static inline int pte_soft_dirty(pte_t pte)
+{
+	return 0;
+}
+
+static inline int pmd_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of
diff -puN mm/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking mm/Kconfig
--- a/mm/Kconfig~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/mm/Kconfig
@@ -471,3 +471,15 @@ config FRONTSWAP
 	  and swap data is stored as normal on the matching swap device.
 
 	  If unsure, say Y to enable frontswap.
+
+config MEM_SOFT_DIRTY
+	bool "Track memory changes"
+	depends on CHECKPOINT_RESTORE && X86
+	select PROC_PAGE_MONITOR
+	help
+	  This option enables memory changes tracking by introducing a
+	  soft-dirty bit on pte-s. This bit it set when someone writes
+	  into a page just as regular dirty bit, but unlike the latter
+	  it can be cleared by hands.
+
+	  See Documentation/vm/soft-dirty.txt for more details.
diff -puN mm/huge_memory.c~mm-soft-dirty-bits-for-user-memory-changes-tracking mm/huge_memory.c
--- a/mm/huge_memory.c~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/mm/huge_memory.c
@@ -1430,7 +1430,7 @@ int move_huge_pmd(struct vm_area_struct
 	if (ret == 1) {
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
-		set_pmd_at(mm, new_addr, new_pmd, pmd);
+		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
 		spin_unlock(&mm->page_table_lock);
 	}
 out:
diff -puN mm/mremap.c~mm-soft-dirty-bits-for-user-memory-changes-tracking mm/mremap.c
--- a/mm/mremap.c~mm-soft-dirty-bits-for-user-memory-changes-tracking
+++ a/mm/mremap.c
@@ -126,7 +126,7 @@ static void move_ptes(struct vm_area_str
 			continue;
 		pte = ptep_get_and_clear(mm, old_addr, old_pte);
 		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
-		set_pte_at(mm, new_addr, new_pte, pte);
+		set_pte_at(mm, new_addr, new_pte, pte_mksoft_dirty(pte));
 	}
 
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from xemul@parallels.com are

linux-next.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-the-proc-pid-pagemap2-file.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

