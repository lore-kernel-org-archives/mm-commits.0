From: akpm@linux-foundation.org
Subject: + kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch added
 to -mm tree
Date: Tue, 10 Oct 2017 15:02:30 -0700
Message-ID: <59dd4376.f72TcBZZ40AB95LZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756506AbdJJWCb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 18:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.levin@verizon.com, devtimhansen@gmail.com, ebiederm@xmission.com, glider@google.com, mhocko@kernel.org, penberg@kernel.org, rostedt@goodmis.org, vegardno@ifi.uio.no, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcheck: stop using GFP_NOTRACK and SLAB_NOTRACK
has been added to the -mm tree.  Its filename is
     kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemcheck-stop-using-gfp_notrack-and-slab_notrack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>
Subject: kmemcheck: stop using GFP_NOTRACK and SLAB_NOTRACK

Convert all allocations that used a NOTRACK flag to stop using it.

Link: http://lkml.kernel.org/r/20171007030159.22241-3-alexander.levin@verizon.com
Signed-off-by: Sasha Levin <alexander.levin@verizon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Hansen <devtimhansen@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgalloc.h       |    2 +-
 arch/arm64/include/asm/pgalloc.h     |    2 +-
 arch/powerpc/include/asm/pgalloc.h   |    2 +-
 arch/sh/kernel/dwarf.c               |    4 ++--
 arch/sh/kernel/process.c             |    2 +-
 arch/sparc/mm/init_64.c              |    4 ++--
 arch/unicore32/include/asm/pgalloc.h |    2 +-
 arch/x86/kernel/espfix_64.c          |    2 +-
 arch/x86/mm/init.c                   |    3 +--
 arch/x86/mm/init_64.c                |    2 +-
 arch/x86/mm/pageattr.c               |   10 +++++-----
 arch/x86/mm/pgtable.c                |    2 +-
 arch/x86/platform/efi/efi_64.c       |    2 +-
 crypto/xor.c                         |    7 +------
 include/linux/thread_info.h          |    5 ++---
 init/do_mounts.c                     |    3 +--
 kernel/fork.c                        |   12 ++++++------
 kernel/signal.c                      |    3 +--
 mm/kmemcheck.c                       |    2 +-
 mm/slab.c                            |    2 +-
 mm/slab.h                            |    5 ++---
 mm/slab_common.c                     |    2 +-
 mm/slub.c                            |    4 +---
 23 files changed, 36 insertions(+), 48 deletions(-)

diff -puN arch/arm64/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/arm64/include/asm/pgalloc.h
--- a/arch/arm64/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -26,7 +26,7 @@
 
 #define check_pgt_cache()		do { } while (0)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 #define PGD_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
 
 #if CONFIG_PGTABLE_LEVELS > 2
diff -puN arch/arm/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/arm/include/asm/pgalloc.h
--- a/arch/arm/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/arm/include/asm/pgalloc.h
@@ -57,7 +57,7 @@ static inline void pud_populate(struct m
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 
 static inline void clean_pte_table(pte_t *pte)
 {
diff -puN arch/powerpc/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/powerpc/include/asm/pgalloc.h
--- a/arch/powerpc/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/powerpc/include/asm/pgalloc.h
@@ -17,7 +17,7 @@ static inline gfp_t pgtable_gfp_flags(st
 }
 #endif /* MODULE */
 
-#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_ZERO)
 
 #ifdef CONFIG_PPC_BOOK3S
 #include <asm/book3s/pgalloc.h>
diff -puN arch/sh/kernel/dwarf.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/sh/kernel/dwarf.c
--- a/arch/sh/kernel/dwarf.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/sh/kernel/dwarf.c
@@ -1172,11 +1172,11 @@ static int __init dwarf_unwinder_init(vo
 
 	dwarf_frame_cachep = kmem_cache_create("dwarf_frames",
 			sizeof(struct dwarf_frame), 0,
-			SLAB_PANIC | SLAB_HWCACHE_ALIGN | SLAB_NOTRACK, NULL);
+			SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
 
 	dwarf_reg_cachep = kmem_cache_create("dwarf_regs",
 			sizeof(struct dwarf_reg), 0,
-			SLAB_PANIC | SLAB_HWCACHE_ALIGN | SLAB_NOTRACK, NULL);
+			SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
 
 	dwarf_frame_pool = mempool_create_slab_pool(DWARF_FRAME_MIN_REQ,
 						    dwarf_frame_cachep);
diff -puN arch/sh/kernel/process.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/sh/kernel/process.c
--- a/arch/sh/kernel/process.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/sh/kernel/process.c
@@ -58,7 +58,7 @@ void arch_task_cache_init(void)
 
 	task_xstate_cachep = kmem_cache_create("task_xstate", xstate_size,
 					       __alignof__(union thread_xstate),
-					       SLAB_PANIC | SLAB_NOTRACK, NULL);
+					       SLAB_PANIC, NULL);
 }
 
 #ifdef CONFIG_SH_FPU_EMU
diff -puN arch/sparc/mm/init_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/sparc/mm/init_64.c
@@ -2926,7 +2926,7 @@ void __flush_tlb_all(void)
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 			    unsigned long address)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	pte_t *pte = NULL;
 
 	if (page)
@@ -2938,7 +2938,7 @@ pte_t *pte_alloc_one_kernel(struct mm_st
 pgtable_t pte_alloc_one(struct mm_struct *mm,
 			unsigned long address)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO);
+	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
diff -puN arch/unicore32/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/unicore32/include/asm/pgalloc.h
--- a/arch/unicore32/include/asm/pgalloc.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/unicore32/include/asm/pgalloc.h
@@ -28,7 +28,7 @@ extern void free_pgd_slow(struct mm_stru
 #define pgd_alloc(mm)			get_pgd_slow(mm)
 #define pgd_free(mm, pgd)		free_pgd_slow(mm, pgd)
 
-#define PGALLOC_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP	(GFP_KERNEL | __GFP_ZERO)
 
 /*
  * Allocate one PTE table.
diff -puN arch/x86/kernel/espfix_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/kernel/espfix_64.c
--- a/arch/x86/kernel/espfix_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/kernel/espfix_64.c
@@ -57,7 +57,7 @@
 # error "Need more virtual address space for the ESPFIX hack"
 #endif
 
-#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_ZERO)
 
 /* This contains the *bottom* address of the espfix stack */
 DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
diff -puN arch/x86/mm/init_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/mm/init_64.c
@@ -184,7 +184,7 @@ static __ref void *spp_getpage(void)
 	void *ptr;
 
 	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
+		ptr = (void *) get_zeroed_page(GFP_ATOMIC);
 	else
 		ptr = alloc_bootmem_pages(PAGE_SIZE);
 
diff -puN arch/x86/mm/init.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/mm/init.c
@@ -92,8 +92,7 @@ __ref void *alloc_low_pages(unsigned int
 		unsigned int order;
 
 		order = get_order((unsigned long)num << PAGE_SHIFT);
-		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_NOTRACK |
-						__GFP_ZERO, order);
+		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 	}
 
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
diff -puN arch/x86/mm/pageattr.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/mm/pageattr.c
@@ -753,7 +753,7 @@ static int split_large_page(struct cpa_d
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
-	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
+	base = alloc_pages(GFP_KERNEL, 0);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!base)
@@ -904,7 +904,7 @@ static void unmap_pud_range(p4d_t *p4d,
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
 	if (!pte)
 		return -1;
 
@@ -914,7 +914,7 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
 	if (!pmd)
 		return -1;
 
@@ -1120,7 +1120,7 @@ static int populate_pgd(struct cpa_data
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
 		if (!p4d)
 			return -1;
 
@@ -1132,7 +1132,7 @@ static int populate_pgd(struct cpa_data
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
 		if (!pud)
 			return -1;
 
diff -puN arch/x86/mm/pgtable.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/mm/pgtable.c
@@ -6,7 +6,7 @@
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
 
-#define PGALLOC_GFP (GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | __GFP_ZERO)
+#define PGALLOC_GFP (GFP_KERNEL_ACCOUNT | __GFP_ZERO)
 
 #ifdef CONFIG_HIGHPTE
 #define PGALLOC_USER_GFP __GFP_HIGHMEM
diff -puN arch/x86/platform/efi/efi_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack arch/x86/platform/efi/efi_64.c
--- a/arch/x86/platform/efi/efi_64.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/arch/x86/platform/efi/efi_64.c
@@ -205,7 +205,7 @@ int __init efi_alloc_page_tables(void)
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return 0;
 
-	gfp_mask = GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO;
+	gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	efi_pgd = (pgd_t *)__get_free_page(gfp_mask);
 	if (!efi_pgd)
 		return -ENOMEM;
diff -puN crypto/xor.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack crypto/xor.c
--- a/crypto/xor.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/crypto/xor.c
@@ -122,12 +122,7 @@ calibrate_xor_blocks(void)
 		goto out;
 	}
 
-	/*
-	 * Note: Since the memory is not actually used for _anything_ but to
-	 * test the XOR speed, we don't really want kmemcheck to warn about
-	 * reading uninitialized bytes here.
-	 */
-	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 2);
+	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
 	if (!b1) {
 		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
diff -puN include/linux/thread_info.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack include/linux/thread_info.h
--- a/include/linux/thread_info.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/include/linux/thread_info.h
@@ -43,10 +43,9 @@ enum {
 #endif
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_NOTRACK | \
-				 __GFP_ZERO)
+# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
 #else
-# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_NOTRACK)
+# define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
 #endif
 
 /*
diff -puN init/do_mounts.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack init/do_mounts.c
--- a/init/do_mounts.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/init/do_mounts.c
@@ -380,8 +380,7 @@ static int __init do_mount_root(char *na
 
 void __init mount_block_root(char *name, int flags)
 {
-	struct page *page = alloc_page(GFP_KERNEL |
-					__GFP_NOTRACK_FALSE_POSITIVE);
+	struct page *page = alloc_page(GFP_KERNEL);
 	char *fs_names = page_address(page);
 	char *p;
 #ifdef CONFIG_BLOCK
diff -puN kernel/fork.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack kernel/fork.c
--- a/kernel/fork.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/kernel/fork.c
@@ -707,7 +707,7 @@ void __init fork_init(void)
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep = kmem_cache_create("task_struct",
 			arch_task_struct_size, align,
-			SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT, NULL);
+			SLAB_PANIC|SLAB_ACCOUNT, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -2234,18 +2234,18 @@ void __init proc_caches_init(void)
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
-			SLAB_NOTRACK|SLAB_ACCOUNT, sighand_ctor);
+			SLAB_ACCOUNT, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
 	/*
 	 * FIXME! The "sizeof(struct mm_struct)" currently includes the
@@ -2256,7 +2256,7 @@ void __init proc_caches_init(void)
 	 */
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
 	mmap_init();
diff -puN kernel/signal.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack kernel/signal.c
--- a/kernel/signal.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/kernel/signal.c
@@ -1036,8 +1036,7 @@ static int __send_signal(int sig, struct
 	else
 		override_rlimit = 0;
 
-	q = __sigqueue_alloc(sig, t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
-		override_rlimit);
+	q = __sigqueue_alloc(sig, t, GFP_ATOMIC, override_rlimit);
 	if (q) {
 		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
diff -puN mm/kmemcheck.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack mm/kmemcheck.c
--- a/mm/kmemcheck.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/mm/kmemcheck.c
@@ -17,7 +17,7 @@ void kmemcheck_alloc_shadow(struct page
 	 * With kmemcheck enabled, we need to allocate a memory area for the
 	 * shadow bits as well.
 	 */
-	shadow = alloc_pages_node(node, flags | __GFP_NOTRACK, order);
+	shadow = alloc_pages_node(node, flags, order);
 	if (!shadow) {
 		if (printk_ratelimit())
 			pr_err("kmemcheck: failed to allocate shadow bitmap\n");
diff -puN mm/slab.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack mm/slab.c
--- a/mm/slab.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/mm/slab.c
@@ -1411,7 +1411,7 @@ static struct page *kmem_getpages(struct
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	page = __alloc_pages_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
+	page = __alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page) {
 		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
diff -puN mm/slab_common.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack mm/slab_common.c
--- a/mm/slab_common.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/mm/slab_common.c
@@ -43,7 +43,7 @@ static DECLARE_WORK(slab_caches_to_rcu_d
 		SLAB_FAILSLAB | SLAB_KASAN)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_NOTRACK | SLAB_ACCOUNT)
+			 SLAB_ACCOUNT)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
diff -puN mm/slab.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack mm/slab.h
--- a/mm/slab.h~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/mm/slab.h
@@ -140,10 +140,10 @@ static inline unsigned long kmem_cache_f
 #if defined(CONFIG_SLAB)
 #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
 			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
-			  SLAB_NOTRACK | SLAB_ACCOUNT)
+			  SLAB_ACCOUNT)
 #elif defined(CONFIG_SLUB)
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
-			  SLAB_TEMPORARY | SLAB_NOTRACK | SLAB_ACCOUNT)
+			  SLAB_TEMPORARY | SLAB_ACCOUNT)
 #else
 #define SLAB_CACHE_FLAGS (0)
 #endif
@@ -162,7 +162,6 @@ static inline unsigned long kmem_cache_f
 			      SLAB_NOLEAKTRACE | \
 			      SLAB_RECLAIM_ACCOUNT | \
 			      SLAB_TEMPORARY | \
-			      SLAB_NOTRACK | \
 			      SLAB_ACCOUNT)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
diff -puN mm/slub.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack mm/slub.c
--- a/mm/slub.c~kmemcheck-stop-using-gfp_notrack-and-slab_notrack
+++ a/mm/slub.c
@@ -1433,8 +1433,6 @@ static inline struct page *alloc_slab_pa
 	struct page *page;
 	int order = oo_order(oo);
 
-	flags |= __GFP_NOTRACK;
