From: akpm@linux-foundation.org
Subject: [merged] mm-remove-free_area_cache.patch removed from -mm tree
Date: Thu, 11 Jul 2013 13:16:37 -0700
Message-ID: <51df12a5.hYoaD5HfbtawMRhW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3GKUQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 16:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, rth@twiddle.net, riel@redhat.com, paulus@samba.org, mattst88@gmail.com, jejb@parisc-linux.org, ink@jurassic.park.msu.ru, dhowells@redhat.com, deller@gmx.de, benh@kernel.crashing.org, walken@google.com

Subject: [merged] mm-remove-free_area_cache.patch removed from -mm tree
To: walken@google.com,benh@kernel.crashing.org,deller@gmx.de,dhowells@redhat.com,ink@jurassic.park.msu.ru,jejb@parisc-linux.org,mattst88@gmail.com,paulus@samba.org,riel@redhat.com,rth@twiddle.net,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 13:16:37 -0700


The patch titled
     Subject: mm: remove free_area_cache
has been removed from the -mm tree.  Its filename was
     mm-remove-free_area_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: remove free_area_cache

Since all architectures have been converted to use vm_unmapped_area(),
there is no remaining use for the free_area_cache.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c               |    2 --
 arch/arm64/mm/mmap.c             |    2 --
 arch/mips/mm/mmap.c              |    2 --
 arch/powerpc/mm/mmap.c           |    2 --
 arch/s390/mm/mmap.c              |    4 ----
 arch/sparc/kernel/sys_sparc_64.c |    2 --
 arch/tile/mm/mmap.c              |    2 --
 arch/x86/ia32/ia32_aout.c        |    2 --
 arch/x86/mm/mmap.c               |    2 --
 fs/binfmt_aout.c                 |    2 --
 fs/binfmt_elf.c                  |    2 --
 include/linux/mm_types.h         |    3 ---
 include/linux/sched.h            |    2 --
 kernel/fork.c                    |    4 ----
 mm/mmap.c                        |   28 ----------------------------
 mm/nommu.c                       |    4 ----
 mm/util.c                        |    1 -
 17 files changed, 66 deletions(-)

diff -puN arch/arm/mm/mmap.c~mm-remove-free_area_cache arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/arm/mm/mmap.c
@@ -181,11 +181,9 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 
diff -puN arch/arm64/mm/mmap.c~mm-remove-free_area_cache arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/arm64/mm/mmap.c
@@ -90,11 +90,9 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
diff -puN arch/mips/mm/mmap.c~mm-remove-free_area_cache arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/mips/mm/mmap.c
@@ -158,11 +158,9 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 
diff -puN arch/powerpc/mm/mmap.c~mm-remove-free_area_cache arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/powerpc/mm/mmap.c
@@ -92,10 +92,8 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
diff -puN arch/s390/mm/mmap.c~mm-remove-free_area_cache arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/s390/mm/mmap.c
@@ -91,11 +91,9 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 
@@ -176,11 +174,9 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = s390_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = s390_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 
diff -puN arch/sparc/kernel/sys_sparc_64.c~mm-remove-free_area_cache arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-remove-free_area_cache
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -290,7 +290,6 @@ void arch_pick_mmap_layout(struct mm_str
 	    sysctl_legacy_va_layout) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		/* We know it's 32-bit */
 		unsigned long task_size = STACK_TOP32;
@@ -302,7 +301,6 @@ void arch_pick_mmap_layout(struct mm_str
 
 		mm->mmap_base = PAGE_ALIGN(task_size - gap - random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
 
diff -puN arch/tile/mm/mmap.c~mm-remove-free_area_cache arch/tile/mm/mmap.c
--- a/arch/tile/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/tile/mm/mmap.c
@@ -66,10 +66,8 @@ void arch_pick_mmap_layout(struct mm_str
 	if (!is_32bit || rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base(mm);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
diff -puN arch/x86/ia32/ia32_aout.c~mm-remove-free_area_cache arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~mm-remove-free_area_cache
+++ a/arch/x86/ia32/ia32_aout.c
@@ -308,8 +308,6 @@ static int load_aout_binary(struct linux
 		(current->mm->start_data = N_DATADDR(ex));
 	current->mm->brk = ex.a_bss +
 		(current->mm->start_brk = N_BSSADDR(ex));
-	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
-	current->mm->cached_hole_size = 0;
 
 	retval = setup_arg_pages(bprm, IA32_STACK_TOP, EXSTACK_DEFAULT);
 	if (retval < 0) {
diff -puN arch/x86/mm/mmap.c~mm-remove-free_area_cache arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~mm-remove-free_area_cache
+++ a/arch/x86/mm/mmap.c
@@ -115,10 +115,8 @@ void arch_pick_mmap_layout(struct mm_str
 	if (mmap_is_legacy()) {
 		mm->mmap_base = mmap_legacy_base();
 		mm->get_unmapped_area = arch_get_unmapped_area;
-		mm->unmap_area = arch_unmap_area;
 	} else {
 		mm->mmap_base = mmap_base();
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
-		mm->unmap_area = arch_unmap_area_topdown;
 	}
 }
diff -puN fs/binfmt_aout.c~mm-remove-free_area_cache fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~mm-remove-free_area_cache
+++ a/fs/binfmt_aout.c
@@ -255,8 +255,6 @@ static int load_aout_binary(struct linux
 		(current->mm->start_data = N_DATADDR(ex));
 	current->mm->brk = ex.a_bss +
 		(current->mm->start_brk = N_BSSADDR(ex));
-	current->mm->free_area_cache = current->mm->mmap_base;
-	current->mm->cached_hole_size = 0;
 
 	retval = setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
 	if (retval < 0) {
diff -puN fs/binfmt_elf.c~mm-remove-free_area_cache fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-remove-free_area_cache
+++ a/fs/binfmt_elf.c
@@ -738,8 +738,6 @@ static int load_elf_binary(struct linux_
 
 	/* Do this so that we can load the interpreter, if need be.  We will
 	   change some of these later */
-	current->mm->free_area_cache = current->mm->mmap_base;
-	current->mm->cached_hole_size = 0;
 	retval = setup_arg_pages(bprm, randomize_stack_top(STACK_TOP),
 				 executable_stack);
 	if (retval < 0) {
diff -puN include/linux/mm_types.h~mm-remove-free_area_cache include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-free_area_cache
+++ a/include/linux/mm_types.h
@@ -330,12 +330,9 @@ struct mm_struct {
 	unsigned long (*get_unmapped_area) (struct file *filp,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags);
-	void (*unmap_area) (struct mm_struct *mm, unsigned long addr);
 #endif
 	unsigned long mmap_base;		/* base of mmap area */
 	unsigned long task_size;		/* size of task vm space */
-	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
-	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
 	unsigned long highest_vm_end;		/* highest vma end address */
 	pgd_t * pgd;
 	atomic_t mm_users;			/* How many users with user space? */
diff -puN include/linux/sched.h~mm-remove-free_area_cache include/linux/sched.h
--- a/include/linux/sched.h~mm-remove-free_area_cache
+++ a/include/linux/sched.h
@@ -322,8 +322,6 @@ extern unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags);
-extern void arch_unmap_area(struct mm_struct *, unsigned long);
-extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 #endif
diff -puN kernel/fork.c~mm-remove-free_area_cache kernel/fork.c
--- a/kernel/fork.c~mm-remove-free_area_cache
+++ a/kernel/fork.c
@@ -365,8 +365,6 @@ static int dup_mmap(struct mm_struct *mm
 	mm->locked_vm = 0;
 	mm->mmap = NULL;
 	mm->mmap_cache = NULL;
-	mm->free_area_cache = oldmm->mmap_base;
-	mm->cached_hole_size = ~0UL;
 	mm->map_count = 0;
 	cpumask_clear(mm_cpumask(mm));
 	mm->mm_rb = RB_ROOT;
@@ -540,8 +538,6 @@ static struct mm_struct *mm_init(struct
 	mm->nr_ptes = 0;
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
-	mm->free_area_cache = TASK_UNMAPPED_BASE;
-	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
 
diff -puN mm/mmap.c~mm-remove-free_area_cache mm/mmap.c
--- a/mm/mmap.c~mm-remove-free_area_cache
+++ a/mm/mmap.c
@@ -1878,15 +1878,6 @@ arch_get_unmapped_area(struct file *filp
 }
 #endif	
 
-void arch_unmap_area(struct mm_struct *mm, unsigned long addr)
-{
-	/*
-	 * Is this a new hole at the lowest possible address?
-	 */
-	if (addr >= TASK_UNMAPPED_BASE && addr < mm->free_area_cache)
-		mm->free_area_cache = addr;
-}
-
 /*
  * This mmap-allocator allocates new areas top-down from below the
  * stack's low limit (the base):
@@ -1943,19 +1934,6 @@ arch_get_unmapped_area_topdown(struct fi
 }
 #endif
 
-void arch_unmap_area_topdown(struct mm_struct *mm, unsigned long addr)
-{
-	/*
-	 * Is this a new hole at the highest possible address?
-	 */
-	if (addr > mm->free_area_cache)
-		mm->free_area_cache = addr;
-
-	/* dont allow allocations above current base */
-	if (mm->free_area_cache > mm->mmap_base)
-		mm->free_area_cache = mm->mmap_base;
-}
-
 unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
@@ -2376,7 +2354,6 @@ detach_vmas_to_be_unmapped(struct mm_str
 {
 	struct vm_area_struct **insertion_point;
 	struct vm_area_struct *tail_vma = NULL;
-	unsigned long addr;
 
 	insertion_point = (prev ? &prev->vm_next : &mm->mmap);
 	vma->vm_prev = NULL;
@@ -2393,11 +2370,6 @@ detach_vmas_to_be_unmapped(struct mm_str
 	} else
 		mm->highest_vm_end = prev ? prev->vm_end : 0;
 	tail_vma->vm_next = NULL;
-	if (mm->unmap_area == arch_unmap_area)
-		addr = prev ? prev->vm_end : mm->mmap_base;
-	else
-		addr = vma ?  vma->vm_start : mm->mmap_base;
-	mm->unmap_area(mm, addr);
 	mm->mmap_cache = NULL;		/* Kill the cache. */
 }
 
diff -puN mm/nommu.c~mm-remove-free_area_cache mm/nommu.c
--- a/mm/nommu.c~mm-remove-free_area_cache
+++ a/mm/nommu.c
@@ -1871,10 +1871,6 @@ unsigned long arch_get_unmapped_area(str
 	return -ENOMEM;
 }
 
-void arch_unmap_area(struct mm_struct *mm, unsigned long addr)
-{
-}
