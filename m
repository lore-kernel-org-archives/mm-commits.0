From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-vm_lockonfault.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:18:04 -0800
Message-ID: <563d0afc.Y6nnsJPJdyuoArTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161810AbbKFUSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:18:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_LOCKONFAULT
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_lockonfault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: introduce VM_LOCKONFAULT

The cost of faulting in all memory to be locked can be very high when
working with large mappings.  If only portions of the mapping will be used
this can incur a high penalty for locking.

For the example of a large file, this is the usage pattern for a large
statical language model (probably applies to other statical or graphical
models as well).  For the security example, any application transacting in
data that cannot be swapped out (credit card data, medical records, etc).

This patch introduces the ability to request that pages are not
pre-faulted, but are placed on the unevictable LRU when they are finally
faulted in.  The VM_LOCKONFAULT flag will be used together with VM_LOCKED
and has no effect when set without VM_LOCKED.  Setting the VM_LOCKONFAULT
flag for a VMA will cause pages faulted into that VMA to be added to the
unevictable LRU when they are faulted or if they are already present, but
will not cause any missing pages to be faulted in.

Exposing this new lock state means that we cannot overload the meaning of
the FOLL_POPULATE flag any longer.  Prior to this patch it was used to
mean that the VMA for a fault was locked.  This means we need the new
FOLL_MLOCK flag to communicate the locked state of a VMA.  FOLL_POPULATE
will now only control if the VMA should be populated and in the case of
VM_LOCKONFAULT, it will not be set.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 kernel/fork.c      |    3 ++-
 mm/debug.c         |    1 +
 mm/gup.c           |   10 ++++++++--
 mm/huge_memory.c   |    2 +-
 mm/hugetlb.c       |    4 ++--
 mm/mlock.c         |    2 +-
 mm/mmap.c          |    2 +-
 8 files changed, 21 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-vm_lockonfault include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vm_lockonfault
+++ a/include/linux/mm.h
@@ -139,6 +139,7 @@ extern unsigned int kobjsize(const void
 
 #define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
 #define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
@@ -202,6 +203,9 @@ extern unsigned int kobjsize(const void
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
+/* This mask is used to clear all the VMA flags used by mlock */
+#define VM_LOCKED_CLEAR_MASK	(~(VM_LOCKED | VM_LOCKONFAULT))
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
@@ -2137,6 +2141,7 @@ static inline struct page *follow_page(s
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
+#define FOLL_MLOCK	0x1000	/* lock present pages */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN kernel/fork.c~mm-introduce-vm_lockonfault kernel/fork.c
--- a/kernel/fork.c~mm-introduce-vm_lockonfault
+++ a/kernel/fork.c
@@ -454,7 +454,8 @@ static int dup_mmap(struct mm_struct *mm
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED|VM_UFFD_MISSING|VM_UFFD_WP);
+		tmp->vm_flags &=
+			~(VM_LOCKED|VM_LOCKONFAULT|VM_UFFD_MISSING|VM_UFFD_WP);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
diff -puN mm/debug.c~mm-introduce-vm_lockonfault mm/debug.c
--- a/mm/debug.c~mm-introduce-vm_lockonfault
+++ a/mm/debug.c
@@ -125,6 +125,7 @@ static const struct trace_print_flags vm
 	{VM_GROWSDOWN,			"growsdown"	},
 	{VM_PFNMAP,			"pfnmap"	},
 	{VM_DENYWRITE,			"denywrite"	},
+	{VM_LOCKONFAULT,		"lockonfault"	},
 	{VM_LOCKED,			"locked"	},
 	{VM_IO,				"io"		},
 	{VM_SEQ_READ,			"seqread"	},
diff -puN mm/gup.c~mm-introduce-vm_lockonfault mm/gup.c
--- a/mm/gup.c~mm-introduce-vm_lockonfault
+++ a/mm/gup.c
@@ -129,7 +129,7 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
@@ -299,6 +299,9 @@ static int faultin_page(struct task_stru
 	unsigned int fault_flags = 0;
 	int ret;
 
+	/* mlock all present pages, but do not fault in new pages */
+	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
+		return -ENOENT;
 	/* For mm_populate(), just skip the stack guard page. */
 	if ((*flags & FOLL_POPULATE) &&
 			(stack_guard_page_start(vma, address) ||
@@ -890,7 +893,10 @@ long populate_vma_page_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
+	if (vma->vm_flags & VM_LOCKONFAULT)
+		gup_flags &= ~FOLL_POPULATE;
+
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
diff -puN mm/huge_memory.c~mm-introduce-vm_lockonfault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-vm_lockonfault
+++ a/mm/huge_memory.c
@@ -1307,7 +1307,7 @@ struct page *follow_trans_huge_pmd(struc
 					  pmd, _pmd,  1))
 			update_mmu_cache_pmd(vma, addr, pmd);
 	}
-	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		if (page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
diff -puN mm/hugetlb.c~mm-introduce-vm_lockonfault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-introduce-vm_lockonfault
+++ a/mm/hugetlb.c
@@ -4137,8 +4137,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
-	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+	unsigned long vm_flags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	unsigned long svm_flags = svma->vm_flags & VM_LOCKED_CLEAR_MASK;
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN mm/mlock.c~mm-introduce-vm_lockonfault mm/mlock.c
--- a/mm/mlock.c~mm-introduce-vm_lockonfault
+++ a/mm/mlock.c
@@ -422,7 +422,7 @@ static unsigned long __munlock_pagevec_f
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
-	vma->vm_flags &= ~VM_LOCKED;
+	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
 	while (start < end) {
 		struct page *page = NULL;
diff -puN mm/mmap.c~mm-introduce-vm_lockonfault mm/mmap.c
--- a/mm/mmap.c~mm-introduce-vm_lockonfault
+++ a/mm/mmap.c
@@ -1661,7 +1661,7 @@ out:
 					vma == get_gate_vma(current->mm)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 		else
-			vma->vm_flags &= ~VM_LOCKED;
+			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 	}
 
 	if (file)
_

Patches currently in -mm which might be from emunson@akamai.com are

mips-add-entry-for-new-mlock2-syscall.patch

