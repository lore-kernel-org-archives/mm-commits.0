From: akpm@linux-foundation.org
Subject: +
 mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
 added to -mm tree
Date: Tue, 07 Jul 2015 14:16:39 -0700
Message-ID: <559c41b7.sFrLc1qMgaB1Xjk9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbbGGVQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: introduce VM_LOCKONFAULT and add mlock flags to enable it
has been added to the -mm tree.  Its filename is
     mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch

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
Subject: mm: mlock: introduce VM_LOCKONFAULT and add mlock flags to enable it

The cost of faulting in all memory to be locked can be very high when
working with large mappings.  If only portions of the mapping will be used
this can incur a high penalty for locking.

For the example of a large file, this is the usage pattern for a large
statical language model (probably applies to other statical or graphical
models as well).  For the security example, any application transacting in
data that cannot be swapped out (credit card data, medical records, etc).

This patch introduces the ability to request that pages are not
pre-faulted, but are placed on the unevictable LRU when they are finally
faulted in.  This can be done area at a time via the mlock2(MLOCK_ONFAULT)
or the mlockall(MCL_ONFAULT) system calls.  These calls can be undone via
munlock2(MLOCK_ONFAULT) or munlockall2(MCL_ONFAULT).

To keep accounting checks out of the page fault path, users are billed for
the entire mapping lock as if MLOCK_LOCKED was used.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h   |    2 
 arch/mips/include/uapi/asm/mman.h    |    2 
 arch/parisc/include/uapi/asm/mman.h  |    2 
 arch/powerpc/include/uapi/asm/mman.h |    2 
 arch/sparc/include/uapi/asm/mman.h   |    2 
 arch/tile/include/uapi/asm/mman.h    |    3 +
 arch/xtensa/include/uapi/asm/mman.h  |    2 
 fs/proc/task_mmu.c                   |    1 
 include/linux/mm.h                   |    1 
 include/uapi/asm-generic/mman.h      |    2 
 mm/mlock.c                           |   72 ++++++++++++++++++-------
 mm/mmap.c                            |    4 -
 mm/swap.c                            |    3 -
 13 files changed, 75 insertions(+), 23 deletions(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -37,8 +37,10 @@
 
 #define MCL_CURRENT	 8192		/* lock all currently mapped pages */
 #define MCL_FUTURE	16384		/* lock all additions to address space */
+#define MCL_ONFAULT	32768		/* lock all pages that are faulted in */
 
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -61,11 +61,13 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 /*
  * Flags for mlock
  */
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -31,8 +31,10 @@
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL     0               /* no further special treatment */
 #define MADV_RANDOM     1               /* expect random page references */
diff -puN arch/powerpc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/powerpc/include/uapi/asm/mman.h
--- a/arch/powerpc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/powerpc/include/uapi/asm/mman.h
@@ -22,8 +22,10 @@
 
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
 
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
diff -puN arch/sparc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/sparc/include/uapi/asm/mman.h
--- a/arch/sparc/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/sparc/include/uapi/asm/mman.h
@@ -17,8 +17,10 @@
 
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
+#define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
 
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
diff -puN arch/tile/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/tile/include/uapi/asm/mman.h
--- a/arch/tile/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/tile/include/uapi/asm/mman.h
@@ -36,11 +36,14 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
+
 
 /*
  * Flags for mlock
  */
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 
 #endif /* _ASM_TILE_MMAN_H */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -74,11 +74,13 @@
  */
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 /*
  * Flags for mlock
  */
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #define MADV_NORMAL	0		/* no further special treatment */
 #define MADV_RANDOM	1		/* expect random page references */
diff -puN fs/proc/task_mmu.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/fs/proc/task_mmu.c
@@ -579,6 +579,7 @@ static void show_smap_vma_flags(struct s
 #ifdef CONFIG_X86_INTEL_MPX
 		[ilog2(VM_MPX)]		= "mp",
 #endif
+		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff -puN include/linux/mm.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it include/linux/mm.h
--- a/include/linux/mm.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/include/linux/mm.h
@@ -127,6 +127,7 @@ extern unsigned int kobjsize(const void
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
+#define VM_LOCKONFAULT	0x00001000	/* Lock the pages covered when they are faulted in */
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
diff -puN include/uapi/asm-generic/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it include/uapi/asm-generic/mman.h
--- a/include/uapi/asm-generic/mman.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/include/uapi/asm-generic/mman.h
@@ -17,7 +17,9 @@
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
+#define MCL_ONFAULT	4		/* lock all pages that are faulted in */
 
 #define MLOCK_LOCKED	0x01		/* Lock and populate the specified range */
+#define MLOCK_ONFAULT	0x02		/* Lock pages in range after they are faulted in, do not prefault */
 
 #endif /* __ASM_GENERIC_MMAN_H */
diff -puN mm/mlock.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it mm/mlock.c
--- a/mm/mlock.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/mm/mlock.c
@@ -502,11 +502,12 @@ static int mlock_fixup(struct vm_area_st
 	pgoff_t pgoff;
 	int nr_pages;
 	int ret = 0;
-	int lock = !!(newflags & VM_LOCKED);
+	int lock = !!(newflags & (VM_LOCKED | VM_LOCKONFAULT));
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
-		goto out;	/* don't set VM_LOCKED,  don't count */
+		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
+		goto out;
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	*prev = vma_merge(mm, *prev, start, end, newflags, vma->anon_vma,
@@ -581,10 +582,12 @@ static int apply_vma_flags(unsigned long
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
 		newflags = vma->vm_flags;
-		if (add_flags)
+		if (add_flags) {
+			newflags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 			newflags |= flags;
-		else
+		} else {
 			newflags &= ~flags;
+		}
 
 		tmp = vma->vm_end;
 		if (tmp > end)
@@ -637,9 +640,12 @@ static int do_mlock(unsigned long start,
 	if (error)
 		return error;
 
-	error = __mm_populate(start, len, 0);
-	if (error)
-		return __mlock_posix_error_return(error);
+	if (flags & VM_LOCKED) {
+		error = __mm_populate(start, len, 0);
+		if (error)
+			return __mlock_posix_error_return(error);
+	}
+
 	return 0;
 }
 
@@ -650,10 +656,14 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 SYSCALL_DEFINE3(mlock2, unsigned long, start, size_t, len, int, flags)
 {
-	if (!flags || flags & ~MLOCK_LOCKED)
+	if (!flags || (flags & ~(MLOCK_LOCKED | MLOCK_ONFAULT)) ||
+	    flags == (MLOCK_LOCKED | MLOCK_ONFAULT))
 		return -EINVAL;
 
-	return do_mlock(start, len, VM_LOCKED);
+	if (flags & MLOCK_LOCKED)
+		return do_mlock(start, len, VM_LOCKED);
+
+	return do_mlock(start, len, VM_LOCKONFAULT);
 }
 
 static int do_munlock(unsigned long start, size_t len, vm_flags_t flags)
@@ -677,26 +687,41 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 
 SYSCALL_DEFINE3(munlock2, unsigned long, start, size_t, len, int, flags)
 {
-	if (!flags || flags & ~MLOCK_LOCKED)
+	vm_flags_t to_clear = 0;
+
+	if (!flags || flags & ~(MLOCK_LOCKED | MLOCK_ONFAULT))
 		return -EINVAL;
-	return do_munlock(start, len, VM_LOCKED);
+
+	if (flags & MLOCK_LOCKED)
+		to_clear |= VM_LOCKED;
+	if (flags & MLOCK_ONFAULT)
+		to_clear |= VM_LOCKONFAULT;
+
+	return do_munlock(start, len, to_clear);
 }
 
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
+	vm_flags_t to_add;
 
 	if (flags & MCL_FUTURE)
 		current->mm->def_flags |= VM_LOCKED;
 	if (flags == MCL_FUTURE)
 		goto out;
 
+	if (flags & MCL_ONFAULT) {
+		current->mm->def_flags |= VM_LOCKONFAULT;
+		to_add = VM_LOCKONFAULT;
+	} else {
+		to_add = VM_LOCKED;
+	}
+
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags & ~VM_LOCKED;
-		if (flags & MCL_CURRENT)
-			newflags |= VM_LOCKED;
+		newflags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+		newflags |= to_add;
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
@@ -711,7 +736,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	unsigned long lock_limit;
 	int ret = -EINVAL;
 
-	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE)))
+	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT)) ||
+	    (flags & (MCL_FUTURE | MCL_ONFAULT)) == (MCL_FUTURE | MCL_ONFAULT))
 		goto out;
 
 	ret = -EPERM;
@@ -740,18 +766,24 @@ out:
 static int do_munlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
+	vm_flags_t to_clear = 0;
 
 	if (flags & MCL_FUTURE)
 		current->mm->def_flags &= ~VM_LOCKED;
+	if (flags & MCL_ONFAULT)
+		current->mm->def_flags &= ~VM_LOCKONFAULT;
 	if (flags == MCL_FUTURE)
 		goto out;
 
+	if (flags & MCL_CURRENT)
+		to_clear |= VM_LOCKED;
+	if (flags & MCL_ONFAULT)
+		to_clear |= VM_LOCKONFAULT;
+
 	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags;
-		if (flags & MCL_CURRENT)
-			newflags &= ~VM_LOCKED;
+		newflags = vma->vm_flags & ~to_clear;
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
@@ -766,7 +798,7 @@ SYSCALL_DEFINE0(munlockall)
 	int ret;
 
 	down_write(&current->mm->mmap_sem);
-	ret = do_munlockall(MCL_CURRENT | MCL_FUTURE);
+	ret = do_munlockall(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT);
 	up_write(&current->mm->mmap_sem);
 	return ret;
 }
@@ -775,7 +807,7 @@ SYSCALL_DEFINE1(munlockall2, int, flags)
 {
 	int ret = -EINVAL;
 
-	if (!flags || flags & ~(MCL_CURRENT | MCL_FUTURE))
+	if (!flags || flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT))
 		return ret;
 
 	down_write(&current->mm->mmap_sem);
diff -puN mm/mmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it mm/mmap.c
--- a/mm/mmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/mm/mmap.c
@@ -1232,8 +1232,8 @@ static inline int mlock_future_check(str
 {
 	unsigned long locked, lock_limit;
 
-	/*  mlock MCL_FUTURE? */
-	if (flags & VM_LOCKED) {
+	/*  mlock MCL_FUTURE or MCL_ONFAULT? */
+	if (flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 		locked = len >> PAGE_SHIFT;
 		locked += mm->locked_vm;
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
diff -puN mm/swap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it mm/swap.c
--- a/mm/swap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it
+++ a/mm/swap.c
@@ -710,7 +710,8 @@ void lru_cache_add_active_or_unevictable
 {
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED)) {
+	if (likely((vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) == 0) ||
+		   (vma->vm_flags & VM_SPECIAL)) {
 		SetPageActive(page);
 		lru_cache_add(page);
 		return;
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch

