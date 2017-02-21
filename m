From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 21 Feb 2017 11:31:08 -0800
Message-ID: <58ac957c.3T2GH9UKoLYrGNfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdBUTbK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2017 14:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/configs/lemote2f_defconfig     |    4 -
 arch/openrisc/include/asm/Kbuild         |    3 
 arch/powerpc/kernel/asm-offsets.c        |   30 --------
 arch/x86/Kconfig.debug                   |   14 ----
 drivers/gpu/drm/ttm/ttm_bo.c             |   33 ---------
 drivers/misc/lkdtm_bugs.c                |   50 --------------
 kernel/extable.c                         |    9 --
 kernel/fork.c                            |    4 -
 security/apparmor/include/apparmor.h     |   72 ---------------------
 tools/arch/x86/include/asm/cpufeatures.h |    5 -
 10 files changed, 1 insertion(+), 223 deletions(-)

diff -puN arch/mips/configs/lemote2f_defconfig~linux-next-git-rejects arch/mips/configs/lemote2f_defconfig
--- a/arch/mips/configs/lemote2f_defconfig~linux-next-git-rejects
+++ a/arch/mips/configs/lemote2f_defconfig
@@ -39,11 +39,7 @@ CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION="/dev/hda3"
 CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_DEBUG=y
-<<<<<<< HEAD
-CONFIG_CPU_FREQ_STAT=m
-=======
 CONFIG_CPU_FREQ_STAT=y
->>>>>>> linux-next/akpm-base
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=m
 CONFIG_CPU_FREQ_GOV_USERSPACE=m
diff -puN arch/openrisc/include/asm/Kbuild~linux-next-git-rejects arch/openrisc/include/asm/Kbuild
--- a/arch/openrisc/include/asm/Kbuild~linux-next-git-rejects
+++ a/arch/openrisc/include/asm/Kbuild
@@ -9,11 +9,8 @@ generic-y += bugs.h
 generic-y += cacheflush.h
 generic-y += checksum.h
 generic-y += clkdev.h
-<<<<<<< HEAD
 generic-y += cmpxchg-local.h
 generic-y += cmpxchg.h
-=======
->>>>>>> linux-next/akpm-base
 generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
diff -puN arch/powerpc/kernel/asm-offsets.c~linux-next-git-rejects arch/powerpc/kernel/asm-offsets.c
--- a/arch/powerpc/kernel/asm-offsets.c~linux-next-git-rejects
+++ a/arch/powerpc/kernel/asm-offsets.c
@@ -231,35 +231,6 @@ int main(void)
 #endif /* CONFIG_PPC_STD_MMU_64 */
 	OFFSET(PACAEMERGSP, paca_struct, emergency_sp);
 #ifdef CONFIG_PPC_BOOK3S_64
-<<<<<<< HEAD
-	DEFINE(PACAMCEMERGSP, offsetof(struct paca_struct, mc_emergency_sp));
-	DEFINE(PACA_IN_MCE, offsetof(struct paca_struct, in_mce));
-#endif
-	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));
-	DEFINE(PACAKEXECSTATE, offsetof(struct paca_struct, kexec_state));
-	DEFINE(PACA_DSCR_DEFAULT, offsetof(struct paca_struct, dscr_default));
-	DEFINE(ACCOUNT_STARTTIME,
-	       offsetof(struct paca_struct, accounting.starttime));
-	DEFINE(ACCOUNT_STARTTIME_USER,
-	       offsetof(struct paca_struct, accounting.starttime_user));
-	DEFINE(ACCOUNT_USER_TIME,
-	       offsetof(struct paca_struct, accounting.utime));
-	DEFINE(ACCOUNT_SYSTEM_TIME,
-	       offsetof(struct paca_struct, accounting.stime));
-	DEFINE(PACA_TRAP_SAVE, offsetof(struct paca_struct, trap_save));
-	DEFINE(PACA_NAPSTATELOST, offsetof(struct paca_struct, nap_state_lost));
-	DEFINE(PACA_SPRG_VDSO, offsetof(struct paca_struct, sprg_vdso));
-#else /* CONFIG_PPC64 */
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
-	DEFINE(ACCOUNT_STARTTIME,
-	       offsetof(struct thread_info, accounting.starttime));
-	DEFINE(ACCOUNT_STARTTIME_USER,
-	       offsetof(struct thread_info, accounting.starttime_user));
-	DEFINE(ACCOUNT_USER_TIME,
-	       offsetof(struct thread_info, accounting.utime));
-	DEFINE(ACCOUNT_SYSTEM_TIME,
-	       offsetof(struct thread_info, accounting.stime));
-=======
 	OFFSET(PACAMCEMERGSP, paca_struct, mc_emergency_sp);
 	OFFSET(PACA_IN_MCE, paca_struct, in_mce);
 #endif
@@ -279,7 +250,6 @@ int main(void)
 	OFFSET(ACCOUNT_STARTTIME_USER, thread_info, accounting.starttime_user);
 	OFFSET(ACCOUNT_USER_TIME, thread_info, accounting.utime);
 	OFFSET(ACCOUNT_SYSTEM_TIME, thread_info, accounting.stime);
->>>>>>> linux-next/akpm-base
 #endif
 #endif /* CONFIG_PPC64 */
 
diff -puN arch/x86/Kconfig.debug~linux-next-git-rejects arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~linux-next-git-rejects
+++ a/arch/x86/Kconfig.debug
@@ -109,20 +109,6 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-<<<<<<< HEAD
-config DEBUG_SET_MODULE_RONX
-	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES
-	---help---
-	  This option helps catch unintended modifications to loadable
-	  kernel module's text and read-only data. It also prevents execution
-	  of module data. Such protection may interfere with run-time code
-	  patching and dynamic kernel tracing - and they might also protect
-	  against certain classes of kernel exploits.
-	  If in doubt, say "N".
-
-=======
->>>>>>> linux-next/akpm-base
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EXPERT
diff -puN drivers/gpu/drm/ttm/ttm_bo.c~linux-next-git-rejects drivers/gpu/drm/ttm/ttm_bo.c
--- a/drivers/gpu/drm/ttm/ttm_bo.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/ttm/ttm_bo.c
@@ -185,25 +185,12 @@ void ttm_bo_add_to_lru(struct ttm_buffer
 EXPORT_SYMBOL(ttm_bo_add_to_lru);
 
 static void ttm_bo_ref_bug(struct kref *list_kref)
-<<<<<<< HEAD
 {
 	BUG();
 }
 
 void ttm_bo_del_from_lru(struct ttm_buffer_object *bo)
 {
-	struct ttm_bo_device *bdev = bo->bdev;
-
-	if (bdev->driver->lru_removal)
-		bdev->driver->lru_removal(bo);
-=======
-{
-	BUG();
-}
->>>>>>> linux-next/akpm-base
-
-void ttm_bo_del_from_lru(struct ttm_buffer_object *bo)
-{
 	if (!list_empty(&bo->swap)) {
 		list_del_init(&bo->swap);
 		kref_put(&bo->list_kref, ttm_bo_ref_bug);
@@ -212,14 +199,11 @@ void ttm_bo_del_from_lru(struct ttm_buff
 		list_del_init(&bo->lru);
 		kref_put(&bo->list_kref, ttm_bo_ref_bug);
 	}
-<<<<<<< HEAD
-=======
 
 	/*
 	 * TODO: Add a driver hook to delete from
 	 * driver-specific LRU's here.
 	 */
->>>>>>> linux-next/akpm-base
 }
 
 void ttm_bo_del_sub_from_lru(struct ttm_buffer_object *bo)
@@ -232,18 +216,8 @@ EXPORT_SYMBOL(ttm_bo_del_sub_from_lru);
 
 void ttm_bo_move_to_lru_tail(struct ttm_buffer_object *bo)
 {
-<<<<<<< HEAD
-	struct ttm_bo_device *bdev = bo->bdev;
-
-	lockdep_assert_held(&bo->resv->lock.base);
-
-	if (bdev->driver->lru_removal)
-		bdev->driver->lru_removal(bo);
-
-=======
 	lockdep_assert_held(&bo->resv->lock.base);
 
->>>>>>> linux-next/akpm-base
 	ttm_bo_del_from_lru(bo);
 	ttm_bo_add_to_lru(bo);
 }
@@ -731,10 +705,7 @@ static int ttm_mem_evict_first(struct tt
 	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
 	struct ttm_buffer_object *bo;
 	int ret = -EBUSY;
-<<<<<<< HEAD
-=======
 	unsigned i;
->>>>>>> linux-next/akpm-base
 
 	spin_lock(&glob->lru_lock);
 	for (i = 0; i < TTM_MAX_BO_PRIORITY; ++i) {
@@ -1670,11 +1641,7 @@ static int ttm_bo_swapout(struct ttm_mem
 	    container_of(shrink, struct ttm_bo_global, shrink);
 	struct ttm_buffer_object *bo;
 	int ret = -EBUSY;
-<<<<<<< HEAD
-	uint32_t swap_placement = (TTM_PL_FLAG_CACHED | TTM_PL_FLAG_SYSTEM);
-=======
 	unsigned i;
->>>>>>> linux-next/akpm-base
 
 	spin_lock(&glob->lru_lock);
 	for (i = 0; i < TTM_MAX_BO_PRIORITY; ++i) {
diff -puN kernel/extable.c~linux-next-git-rejects kernel/extable.c
--- a/kernel/extable.c~linux-next-git-rejects
+++ a/kernel/extable.c
@@ -21,10 +21,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
-<<<<<<< HEAD
-=======
 #include <linux/filter.h>
->>>>>>> linux-next/akpm-base
 #include <linux/kprobes.h>
 
 #include <asm/sections.h>
@@ -110,11 +107,8 @@ int __kernel_text_address(unsigned long
 		return 1;
 	if (is_ftrace_trampoline(addr))
 		return 1;
-<<<<<<< HEAD
-=======
 	if (is_bpf_text_address(addr))
 		return 1;
->>>>>>> linux-next/akpm-base
 	if (is_kprobe_optinsn_slot(addr) || is_kprobe_insn_slot(addr))
 		return 1;
 	/*
@@ -138,11 +132,8 @@ int kernel_text_address(unsigned long ad
 		return 1;
 	if (is_ftrace_trampoline(addr))
 		return 1;
-<<<<<<< HEAD
-=======
 	if (is_bpf_text_address(addr))
 		return 1;
->>>>>>> linux-next/akpm-base
 	if (is_kprobe_optinsn_slot(addr) || is_kprobe_insn_slot(addr))
 		return 1;
 	return 0;
diff -puN kernel/fork.c~linux-next-git-rejects kernel/fork.c
--- a/kernel/fork.c~linux-next-git-rejects
+++ a/kernel/fork.c
@@ -435,11 +435,7 @@ void __init fork_init(void)
 #ifndef ARCH_MIN_TASKALIGN
 #define ARCH_MIN_TASKALIGN	0
 #endif
-<<<<<<< HEAD
-	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
-=======
 	int align = min_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
->>>>>>> linux-next/akpm-base
 
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep = kmem_cache_create("task_struct",
diff -puN security/apparmor/include/apparmor.h~linux-next-git-rejects security/apparmor/include/apparmor.h
--- a/security/apparmor/include/apparmor.h~linux-next-git-rejects
+++ a/security/apparmor/include/apparmor.h
@@ -40,76 +40,4 @@ extern bool aa_g_logsyscall;
 extern bool aa_g_paranoid_load;
 extern unsigned int aa_g_path_max;
 
-<<<<<<< HEAD
-/*
- * DEBUG remains global (no per profile flag) since it is mostly used in sysctl
- * which is not related to profile accesses.
- */
-
-#define AA_DEBUG(fmt, args...)						\
-	do {								\
-		if (aa_g_debug && printk_ratelimit())			\
-			printk(KERN_DEBUG "AppArmor: " fmt, ##args);	\
-	} while (0)
-
-#define AA_ERROR(fmt, args...)						\
-	do {								\
-		if (printk_ratelimit())					\
-			printk(KERN_ERR "AppArmor: " fmt, ##args);	\
-	} while (0)
-
-/* Flag indicating whether initialization completed */
-extern int apparmor_initialized __initdata;
-
-/* fn's in lib */
-char *aa_split_fqname(char *args, char **ns_name);
-void aa_info_message(const char *str);
-void *__aa_kvmalloc(size_t size, gfp_t flags);
-
-static inline void *kvmalloc(size_t size)
-{
-	return __aa_kvmalloc(size, 0);
-}
-
-static inline void *kvzalloc(size_t size)
-{
-	return __aa_kvmalloc(size, __GFP_ZERO);
-}
-
-/**
- * aa_strneq - compare null terminated @str to a non null terminated substring
- * @str: a null terminated string
- * @sub: a substring, not necessarily null terminated
- * @len: length of @sub to compare
- *
- * The @str string must be full consumed for this to be considered a match
- */
-static inline bool aa_strneq(const char *str, const char *sub, int len)
-{
-	return !strncmp(str, sub, len) && !str[len];
-}
-
-/**
- * aa_dfa_null_transition - step to next state after null character
- * @dfa: the dfa to match against
- * @start: the state of the dfa to start matching in
- *
- * aa_dfa_null_transition transitions to the next state after a null
- * character which is not used in standard matching and is only
- * used to separate pairs.
- */
-static inline unsigned int aa_dfa_null_transition(struct aa_dfa *dfa,
-						  unsigned int start)
-{
-	/* the null transition only needs the string's null terminator byte */
-	return aa_dfa_next(dfa, start, 0);
-}
-
-static inline bool mediated_filesystem(struct dentry *dentry)
-{
-	return !(dentry->d_sb->s_flags & MS_NOUSER);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 #endif /* __APPARMOR_H */
diff -puN tools/arch/x86/include/asm/cpufeatures.h~linux-next-git-rejects tools/arch/x86/include/asm/cpufeatures.h
--- a/tools/arch/x86/include/asm/cpufeatures.h~linux-next-git-rejects
+++ a/tools/arch/x86/include/asm/cpufeatures.h
@@ -288,11 +288,8 @@
 #define X86_FEATURE_AVX512VBMI  (16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
 #define X86_FEATURE_PKU		(16*32+ 3) /* Protection Keys for Userspace */
 #define X86_FEATURE_OSPKE	(16*32+ 4) /* OS Protection Keys Enable */
-<<<<<<< HEAD
 #define X86_FEATURE_AVX512_VPOPCNTDQ (16*32+14) /* POPCNT for vectors of DW/QW */
-=======
->>>>>>> linux-next/akpm-base
-#define X86_FEATURE_RDPID	(16*32+ 22) /* RDPID instruction */
+#define X86_FEATURE_RDPID	(16*33+ 22) /* RDPID instruction */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (ebx), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV (17*32+0) /* MCA overflow recovery support */
diff -puN drivers/misc/lkdtm_bugs.c~linux-next-git-rejects drivers/misc/lkdtm_bugs.c
--- a/drivers/misc/lkdtm_bugs.c~linux-next-git-rejects
+++ a/drivers/misc/lkdtm_bugs.c
@@ -150,7 +150,6 @@ void lkdtm_REFCOUNT_SATURATE_INC(void)
 		pr_err("Correctly stayed saturated, but no BUG?!\n");
 	else
 		pr_err("Fail: refcount wrapped\n");
-<<<<<<< HEAD
 }
 
 void lkdtm_REFCOUNT_SATURATE_ADD(void)
@@ -198,55 +197,6 @@ void lkdtm_REFCOUNT_ZERO_INC(void)
 {
 	refcount_t zero = REFCOUNT_INIT(0);
 
-=======
-}
-
-void lkdtm_REFCOUNT_SATURATE_ADD(void)
-{
-	refcount_t over = REFCOUNT_INIT(UINT_MAX - 1);
-
-	pr_info("attempting good refcount decrement\n");
-	refcount_dec(&over);
-	refcount_inc(&over);
-
-	pr_info("attempting bad refcount add overflow\n");
-	refcount_add(2, &over);
-	if (refcount_read(&over) == UINT_MAX)
-		pr_err("Correctly stayed saturated, but no BUG?!\n");
-	else
-		pr_err("Fail: refcount wrapped\n");
-}
-
-void lkdtm_REFCOUNT_ZERO_DEC(void)
-{
-	refcount_t zero = REFCOUNT_INIT(1);
-
-	pr_info("attempting bad refcount decrement to zero\n");
-	refcount_dec(&zero);
-	if (refcount_read(&zero) == 0)
-		pr_err("Stayed at zero, but no BUG?!\n");
-	else
-		pr_err("Fail: refcount went crazy\n");
-}
-
-void lkdtm_REFCOUNT_ZERO_SUB(void)
-{
-	refcount_t zero = REFCOUNT_INIT(1);
-
-	pr_info("attempting bad refcount subtract past zero\n");
-	if (!refcount_sub_and_test(2, &zero))
-		pr_info("wrap attempt was noticed\n");
-	if (refcount_read(&zero) == 1)
-		pr_err("Correctly stayed above 0, but no BUG?!\n");
-	else
-		pr_err("Fail: refcount wrapped\n");
-}
-
-void lkdtm_REFCOUNT_ZERO_INC(void)
-{
-	refcount_t zero = REFCOUNT_INIT(0);
-
->>>>>>> linux-next/akpm-base
 	pr_info("attempting bad refcount increment from zero\n");
 	refcount_inc(&zero);
 	if (refcount_read(&zero) == 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
scripts-spellingtxt-fix-incorrect-typo-words-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
slub-make-sysfs-directories-for-memcg-sub-caches-optional-fix.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath-fix.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

