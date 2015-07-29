From: akpm@linux-foundation.org
Subject: + mm-introduce-vm_lockonfault.patch added to -mm tree
Date: Wed, 29 Jul 2015 11:21:14 -0700
Message-ID: <55b9199a.HdDKSa1uMkiUATXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbG2SVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce VM_LOCKONFAULT
has been added to the -mm tree.  Its filename is
     mm-introduce-vm_lockonfault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-vm_lockonfault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-vm_lockonfault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 drivers/gpu/drm/drm_vm.c |    8 +++++++-
 fs/proc/task_mmu.c       |    1 +
 include/linux/mm.h       |    2 ++
 kernel/fork.c            |    3 ++-
 mm/debug.c               |    1 +
 mm/gup.c                 |   10 ++++++++--
 mm/huge_memory.c         |    2 +-
 mm/hugetlb.c             |    4 ++--
 mm/mlock.c               |    2 +-
 mm/mmap.c                |    2 +-
 mm/rmap.c                |    4 ++--
 11 files changed, 28 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/drm_vm.c~mm-introduce-vm_lockonfault drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~mm-introduce-vm_lockonfault
+++ a/drivers/gpu/drm/drm_vm.c
@@ -699,9 +699,15 @@ int drm_vma_info(struct seq_file *m, voi
 		   (void *)(unsigned long)virt_to_phys(high_memory));
 
 	list_for_each_entry(pt, &dev->vmalist, head) {
+		char lock_flag = '-';
+
 		vma = pt->vma;
 		if (!vma)
 			continue;
+		if (vma->vm_flags & VM_LOCKONFAULT)
+			lock_flag = 'f';
+		else if (vma->vm_flags & VM_LOCKED)
+			lock_flag = 'l';
 		seq_printf(m,
 			   "\n%5d 0x%pK-0x%pK %c%c%c%c%c%c 0x%08lx000",
 			   pt->pid,
@@ -710,7 +716,7 @@ int drm_vma_info(struct seq_file *m, voi
 			   vma->vm_flags & VM_WRITE ? 'w' : '-',
 			   vma->vm_flags & VM_EXEC ? 'x' : '-',
 			   vma->vm_flags & VM_MAYSHARE ? 's' : 'p',
-			   vma->vm_flags & VM_LOCKED ? 'l' : '-',
+			   lock_flag,
 			   vma->vm_flags & VM_IO ? 'i' : '-',
 			   vma->vm_pgoff);
 
diff -puN fs/proc/task_mmu.c~mm-introduce-vm_lockonfault fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-introduce-vm_lockonfault
+++ a/fs/proc/task_mmu.c
@@ -579,6 +579,7 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_X86_INTEL_MPX
 		[ilog2(VM_MPX)]		= "mp",
 #endif
+		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff -puN include/linux/mm.h~mm-introduce-vm_lockonfault include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-vm_lockonfault
+++ a/include/linux/mm.h
@@ -129,6 +129,7 @@ extern unsigned int kobjsize(const void
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
+#define VM_LOCKONFAULT	0x00001000	/* Lock the pages covered when they are faulted in */
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
@@ -2045,6 +2046,7 @@ static inline struct page *follow_page(s
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
+#define FOLL_MLOCK	0x1000	/* lock present pages */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN kernel/fork.c~mm-introduce-vm_lockonfault kernel/fork.c
--- a/kernel/fork.c~mm-introduce-vm_lockonfault
+++ a/kernel/fork.c
@@ -455,7 +455,8 @@ static int dup_mmap(struct mm_struct *mm
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED|VM_UFFD_MISSING|VM_UFFD_WP);
+		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT |
+				   VM_UFFD_MISSING | VM_UFFD_WP);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
diff -puN mm/debug.c~mm-introduce-vm_lockonfault mm/debug.c
--- a/mm/debug.c~mm-introduce-vm_lockonfault
+++ a/mm/debug.c
@@ -121,6 +121,7 @@ static const struct trace_print_flags vm
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
@@ -92,7 +92,7 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_POPULATE) && (vma->vm_flags & VM_LOCKED)) {
+	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
 		 * The preliminary mapping check is mainly to avoid the
 		 * pointless overhead of lock_page on the ZERO_PAGE
@@ -265,6 +265,9 @@ static int faultin_page(struct task_stru
 	unsigned int fault_flags = 0;
 	int ret;
 
+	/* mlock all present pages, but do not fault in new pages */
+	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
+		return -ENOENT;
 	/* For mm_populate(), just skip the stack guard page. */
 	if ((*flags & FOLL_POPULATE) &&
 			(stack_guard_page_start(vma, address) ||
@@ -850,7 +853,10 @@ long populate_vma_page_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_POPULATE;
+	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
+	if ((vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) == VM_LOCKED)
+		gup_flags |= FOLL_POPULATE;
+
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
diff -puN mm/huge_memory.c~mm-introduce-vm_lockonfault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-vm_lockonfault
+++ a/mm/huge_memory.c
@@ -1265,7 +1265,7 @@ struct page *follow_trans_huge_pmd(struc
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
@@ -3764,8 +3764,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;
-	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED;
+	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 
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
+	vma->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 
 	while (start < end) {
 		struct page *page = NULL;
diff -puN mm/mmap.c~mm-introduce-vm_lockonfault mm/mmap.c
--- a/mm/mmap.c~mm-introduce-vm_lockonfault
+++ a/mm/mmap.c
@@ -1664,7 +1664,7 @@ out:
 					vma == get_gate_vma(current->mm)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 		else
-			vma->vm_flags &= ~VM_LOCKED;
+			vma->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 	}
 
 	if (file)
diff -puN mm/rmap.c~mm-introduce-vm_lockonfault mm/rmap.c
--- a/mm/rmap.c~mm-introduce-vm_lockonfault
+++ a/mm/rmap.c
@@ -744,7 +744,7 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			spin_unlock(ptl);
-			pra->vm_flags |= VM_LOCKED;
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -765,7 +765,7 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & VM_LOCKED) {
 			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |= VM_LOCKED;
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch

