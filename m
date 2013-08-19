From: akpm@linux-foundation.org
Subject: + mm-track-vma-changes-with-vm_softdirty-bit.patch added to -mm
 tree
Date: Mon, 19 Aug 2013 14:08:31 -0700
Message-ID: <5212894f.Di0eXv3a1QvGwcu5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HSVIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 17:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, sfr@canb.auug.org.au, peterz@infradead.org, mtosatti@redhat.com, mpm@selenic.com, luto@amacapital.net, kosaki.motohiro@gmail.com, gorcunov@openvz.org, aneesh.kumar@linux.vnet.ibm.com, gorcunov@gmail.com

Subject: + mm-track-vma-changes-with-vm_softdirty-bit.patch added to -mm tree
To: gorcunov@gmail.com,aneesh.kumar@linux.vnet.ibm.com,gorcunov@openvz.org,kosaki.motohiro@gmail.com,luto@amacapital.net,mpm@selenic.com,mtosatti@redhat.com,peterz@infradead.org,sfr@canb.auug.org.au,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 14:08:31 -0700


The patch titled
     Subject: mm: track vma changes with VM_SOFTDIRTY bit
has been added to the -mm tree.  Its filename is
     mm-track-vma-changes-with-vm_softdirty-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-vma-changes-with-vm_softdirty-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-vma-changes-with-vm_softdirty-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: track vma changes with VM_SOFTDIRTY bit

Pavel reported that in case if vma area get unmapped and then mapped (or
expanded) in-place, the soft dirty tracker won't be able to recognize this
situation since it works on pte level and ptes are get zapped on unmap,
loosing soft dirty bit of course.

So to resolve this situation we need to track actions on vma level, there
VM_SOFTDIRTY flag comes in.  When new vma area created (or old expanded)
we set this bit, and keep it here until application calls for clearing
soft dirty bit.

Thus when user space application track memory changes now it can detect if
vma area is renewed.

Reported-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 -
 fs/proc/task_mmu.c |   46 +++++++++++++++++++++++++++++++++----------
 include/linux/mm.h |    6 +++++
 mm/mmap.c          |   12 ++++++++++-
 4 files changed, 54 insertions(+), 12 deletions(-)

diff -puN fs/exec.c~mm-track-vma-changes-with-vm_softdirty-bit fs/exec.c
--- a/fs/exec.c~mm-track-vma-changes-with-vm_softdirty-bit
+++ a/fs/exec.c
@@ -266,7 +266,7 @@ static int __bprm_mm_init(struct linux_b
 	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
-	vma->vm_flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
+	vma->vm_flags = VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 
diff -puN fs/proc/task_mmu.c~mm-track-vma-changes-with-vm_softdirty-bit fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-track-vma-changes-with-vm_softdirty-bit
+++ a/fs/proc/task_mmu.c
@@ -740,6 +740,9 @@ static inline void clear_soft_dirty(stru
 		ptent = pte_file_clear_soft_dirty(ptent);
 	}
 
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma->vm_flags &= ~VM_SOFTDIRTY;
+
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
 #endif
 }
@@ -949,13 +952,15 @@ static void pte_to_pagemap_entry(pagemap
 		if (is_migration_entry(entry))
 			page = migration_entry_to_page(entry);
 	} else {
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
+		if (vma->vm_flags & VM_SOFTDIRTY)
+			flags2 |= __PM_SOFT_DIRTY;
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
 		return;
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (pte_soft_dirty(pte))
+	if ((vma->vm_flags & VM_SOFTDIRTY) || pte_soft_dirty(pte))
 		flags2 |= __PM_SOFT_DIRTY;
 
 	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);
@@ -974,7 +979,7 @@ static void thp_pmd_to_pagemap_entry(pag
 		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
 				| PM_STATUS2(pm->v2, pmd_flags2) | PM_PRESENT);
 	else
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, pmd_flags2));
 }
 #else
 static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
@@ -997,7 +1002,11 @@ static int pagemap_pte_range(pmd_t *pmd,
 	if (vma && pmd_trans_huge_lock(pmd, vma) == 1) {
 		int pmd_flags2;
 
-		pmd_flags2 = (pmd_soft_dirty(*pmd) ? __PM_SOFT_DIRTY : 0);
+		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
+			pmd_flags2 = __PM_SOFT_DIRTY;
+		else
+			pmd_flags2 = 0;
+
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset;
 
@@ -1015,12 +1024,17 @@ static int pagemap_pte_range(pmd_t *pmd,
 	if (pmd_trans_unstable(pmd))
 		return 0;
 	for (; addr != end; addr += PAGE_SIZE) {
+		int flags2;
 
 		/* check to see if we've left 'vma' behind
 		 * and need a new, higher one */
 		if (vma && (addr >= vma->vm_end)) {
 			vma = find_vma(walk->mm, addr);
-			pme = make_pme(PM_NOT_PRESENT(pm->v2));
+			if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+				flags2 = __PM_SOFT_DIRTY;
+			else
+				flags2 = 0;
+			pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
 		}
 
 		/* check that 'vma' actually covers this address,
@@ -1044,13 +1058,15 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 #ifdef CONFIG_HUGETLB_PAGE
 static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
-					pte_t pte, int offset)
+					pte_t pte, int offset, int flags2)
 {
 	if (pte_present(pte))
-		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)
-				| PM_STATUS2(pm->v2, 0) | PM_PRESENT);
+		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)	|
+				PM_STATUS2(pm->v2, flags2)		|
+				PM_PRESENT);
 	else
-		*pme = make_pme(PM_NOT_PRESENT(pm->v2));
+		*pme = make_pme(PM_NOT_PRESENT(pm->v2)			|
+				PM_STATUS2(pm->v2, flags2));
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -1059,12 +1075,22 @@ static int pagemap_hugetlb_range(pte_t *
 				 struct mm_walk *walk)
 {
 	struct pagemapread *pm = walk->private;
+	struct vm_area_struct *vma;
 	int err = 0;
+	int flags2;
 	pagemap_entry_t pme;
 
+	vma = find_vma(walk->mm, addr);
+	WARN_ON_ONCE(!vma);
+
+	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+		flags2 = __PM_SOFT_DIRTY;
+	else
+		flags2 = 0;
+
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
-		huge_pte_to_pagemap_entry(&pme, pm, *pte, offset);
+		huge_pte_to_pagemap_entry(&pme, pm, *pte, offset, flags2);
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
diff -puN include/linux/mm.h~mm-track-vma-changes-with-vm_softdirty-bit include/linux/mm.h
--- a/include/linux/mm.h~mm-track-vma-changes-with-vm_softdirty-bit
+++ a/include/linux/mm.h
@@ -115,6 +115,12 @@ extern unsigned int kobjsize(const void
 #define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
 #define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
 
+#ifdef CONFIG_MEM_SOFT_DIRTY
+# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+#else
+# define VM_SOFTDIRTY	0
+#endif
+
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
diff -puN mm/mmap.c~mm-track-vma-changes-with-vm_softdirty-bit mm/mmap.c
--- a/mm/mmap.c~mm-track-vma-changes-with-vm_softdirty-bit
+++ a/mm/mmap.c
@@ -1609,6 +1609,15 @@ out:
 	if (file)
 		uprobe_mmap(vma);
 
+	/*
+	 * New (or expanded) vma always get soft dirty status.
+	 * Otherwise user-space soft-dirty page tracker won't
+	 * be able to distinguish situation when vma area unmapped,
+	 * then new mapped in-place (which must be aimed as
+	 * a completely new data area).
+	 */
+	vma->vm_flags |= VM_SOFTDIRTY;
+
 	return addr;
 
 unmap_and_free_vma:
@@ -2652,6 +2661,7 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
+	vma->vm_flags |= VM_SOFTDIRTY;
 	return addr;
 }
 
@@ -2916,7 +2926,7 @@ int install_special_mapping(struct mm_st
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 
-	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND;
+	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = &special_mapping_vmops;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

arch-x86-include-asm-pgtable-2levelh-clean-up-pte_to_pgoff-and-pgoff_to_pte-helpers.patch
mm-track-vma-changes-with-vm_softdirty-bit.patch

