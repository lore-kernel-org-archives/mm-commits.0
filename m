From: akpm@linux-foundation.org
Subject: + mm-remove-free_area_cache.patch added to -mm tree
Date: Thu, 31 Jan 2013 13:55:54 -0800
Message-ID: <20130131215554.A584431C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51158 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3AaVz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 16:55:56 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so357382vch.2
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 13:55:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, benh@kernel.crashing.org, deller@gmx.de, dhowells@redhat.com, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, mattst88@gmail.com, paulus@samba.org, riel@redhat.com, rth@twiddle.net, tony.luck@intel.com


The patch titled
     Subject: mm: remove free_area_cache
has been added to the -mm tree.  Its filename is
     mm-remove-free_area_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 arch/powerpc/mm/mmap_64.c        |    2 --
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
 
diff -puN arch/powerpc/mm/mmap_64.c~mm-remove-free_area_cache arch/powerpc/mm/mmap_64.c
--- a/arch/powerpc/mm/mmap_64.c~mm-remove-free_area_cache
+++ a/arch/powerpc/mm/mmap_64.c
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
 
@@ -173,11 +171,9 @@ void arch_pick_mmap_layout(struct mm_str
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
@@ -309,8 +309,6 @@ static int load_aout_binary(struct linux
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
@@ -256,8 +256,6 @@ static int load_aout_binary(struct linux
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
@@ -730,8 +730,6 @@ static int load_elf_binary(struct linux_
 
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
@@ -367,8 +367,6 @@ extern unsigned long
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
@@ -364,8 +364,6 @@ static int dup_mmap(struct mm_struct *mm
 	mm->locked_vm = 0;
 	mm->mmap = NULL;
 	mm->mmap_cache = NULL;
-	mm->free_area_cache = oldmm->mmap_base;
-	mm->cached_hole_size = ~0UL;
 	mm->map_count = 0;
 	cpumask_clear(mm_cpumask(mm));
 	mm->mm_rb = RB_ROOT;
@@ -539,8 +537,6 @@ static struct mm_struct *mm_init(struct 
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
@@ -1815,15 +1815,6 @@ arch_get_unmapped_area(struct file *filp
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
@@ -1880,19 +1871,6 @@ arch_get_unmapped_area_topdown(struct fi
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
@@ -2289,7 +2267,6 @@ detach_vmas_to_be_unmapped(struct mm_str
 {
 	struct vm_area_struct **insertion_point;
 	struct vm_area_struct *tail_vma = NULL;
-	unsigned long addr;
 
 	insertion_point = (prev ? &prev->vm_next : &mm->mmap);
 	vma->vm_prev = NULL;
@@ -2306,11 +2283,6 @@ detach_vmas_to_be_unmapped(struct mm_str
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
@@ -1855,10 +1855,6 @@ unsigned long arch_get_unmapped_area(str
 	return -ENOMEM;
 }
 
-void arch_unmap_area(struct mm_struct *mm, unsigned long addr)
-{
-}
-
 void unmap_mapping_range(struct address_space *mapping,
 			 loff_t const holebegin, loff_t const holelen,
 			 int even_cows)
diff -puN mm/util.c~mm-remove-free_area_cache mm/util.c
--- a/mm/util.c~mm-remove-free_area_cache
+++ a/mm/util.c
@@ -295,7 +295,6 @@ void arch_pick_mmap_layout(struct mm_str
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
 }
 #endif
 
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

