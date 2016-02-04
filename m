From: akpm@linux-foundation.org
Subject: + kernel-lockdep-eliminate-lockdep_init.patch added to -mm tree
Date: Thu, 04 Feb 2016 11:29:36 -0800
Message-ID: <56b3a6a0.QIEcf5NHxQA3jp7r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcBDT3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 14:29:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, krinkin.m.u@gmail.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/lockdep: eliminate lockdep_init()
has been added to the -mm tree.  Its filename is
     kernel-lockdep-eliminate-lockdep_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-lockdep-eliminate-lockdep_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-lockdep-eliminate-lockdep_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kernel/lockdep: eliminate lockdep_init()

Lockdep is initialized at compile time now.  Get rid of lockdep_init().

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Krinkin <krinkin.m.u@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/kernel/setup.c                       |    2 
 arch/microblaze/kernel/setup.c                |    2 
 arch/powerpc/kernel/setup_32.c                |    2 
 arch/powerpc/kernel/setup_64.c                |    3 
 arch/s390/kernel/early.c                      |    1 
 arch/sparc/kernel/head_64.S                   |    8 --
 arch/x86/lguest/boot.c                        |    6 -
 include/linux/lockdep.h                       |    2 
 init/main.c                                   |    5 -
 kernel/locking/lockdep.c                      |   59 ----------------
 tools/lib/lockdep/common.c                    |    5 -
 tools/lib/lockdep/include/liblockdep/common.h |    1 
 tools/lib/lockdep/preload.c                   |    2 
 13 files changed, 98 deletions(-)

diff -puN arch/c6x/kernel/setup.c~kernel-lockdep-eliminate-lockdep_init arch/c6x/kernel/setup.c
--- a/arch/c6x/kernel/setup.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/c6x/kernel/setup.c
@@ -281,8 +281,6 @@ notrace void __init machine_init(unsigne
 	 */
 	set_ist(_vectors_start);
 
-	lockdep_init();
-
 	/*
 	 * dtb is passed in from bootloader.
 	 * fdt is linked in blob.
diff -puN arch/microblaze/kernel/setup.c~kernel-lockdep-eliminate-lockdep_init arch/microblaze/kernel/setup.c
--- a/arch/microblaze/kernel/setup.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/microblaze/kernel/setup.c
@@ -130,8 +130,6 @@ void __init machine_early_init(const cha
 	memset(__bss_start, 0, __bss_stop-__bss_start);
 	memset(_ssbss, 0, _esbss-_ssbss);
 
-	lockdep_init();
-
 /* initialize device tree for usage in early_printk */
 	early_init_devtree(_fdt_start);
 
diff -puN arch/powerpc/kernel/setup_32.c~kernel-lockdep-eliminate-lockdep_init arch/powerpc/kernel/setup_32.c
--- a/arch/powerpc/kernel/setup_32.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/powerpc/kernel/setup_32.c
@@ -114,8 +114,6 @@ extern unsigned int memset_nocache_branc
 
 notrace void __init machine_init(u64 dt_ptr)
 {
-	lockdep_init();
-
 	/* Enable early debugging if any specified (see udbg.h) */
 	udbg_early_init();
 
diff -puN arch/powerpc/kernel/setup_64.c~kernel-lockdep-eliminate-lockdep_init arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/powerpc/kernel/setup_64.c
@@ -255,9 +255,6 @@ void __init early_setup(unsigned long dt
 	setup_paca(&boot_paca);
 	fixup_boot_paca();
 
-	/* Initialize lockdep early or else spinlocks will blow */
-	lockdep_init();
-
 	/* -------- printk is now safe to use ------- */
 
 	/* Enable early debugging if any specified (see udbg.h) */
diff -puN arch/s390/kernel/early.c~kernel-lockdep-eliminate-lockdep_init arch/s390/kernel/early.c
--- a/arch/s390/kernel/early.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/s390/kernel/early.c
@@ -448,7 +448,6 @@ void __init startup_init(void)
 	rescue_initrd();
 	clear_bss_section();
 	init_kernel_storage_key();
-	lockdep_init();
 	lockdep_off();
 	setup_lowcore_early();
 	setup_facility_list();
diff -puN arch/sparc/kernel/head_64.S~kernel-lockdep-eliminate-lockdep_init arch/sparc/kernel/head_64.S
--- a/arch/sparc/kernel/head_64.S~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/sparc/kernel/head_64.S
@@ -696,14 +696,6 @@ tlb_fixup_done:
 	call	__bzero
 	 sub	%o1, %o0, %o1
 
-#ifdef CONFIG_LOCKDEP
-	/* We have this call this super early, as even prom_init can grab
-	 * spinlocks and thus call into the lockdep code.
-	 */
-	call	lockdep_init
-	 nop
-#endif
-
 	call	prom_init
 	 mov	%l7, %o0			! OpenPROM cif handler
 
diff -puN arch/x86/lguest/boot.c~kernel-lockdep-eliminate-lockdep_init arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c~kernel-lockdep-eliminate-lockdep_init
+++ a/arch/x86/lguest/boot.c
@@ -1520,12 +1520,6 @@ __init void lguest_init(void)
 	 */
 	reserve_top_address(lguest_data.reserve_mem);
 
-	/*
-	 * If we don't initialize the lock dependency checker now, it crashes
-	 * atomic_notifier_chain_register, then paravirt_disable_iospace.
-	 */
-	lockdep_init();
-
 	/* Hook in our special panic hypercall code. */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
 
diff -puN include/linux/lockdep.h~kernel-lockdep-eliminate-lockdep_init include/linux/lockdep.h
--- a/include/linux/lockdep.h~kernel-lockdep-eliminate-lockdep_init
+++ a/include/linux/lockdep.h
@@ -261,7 +261,6 @@ struct held_lock {
 /*
  * Initialization, self-test and debugging-output methods:
  */
-extern void lockdep_init(void);
 extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
@@ -392,7 +391,6 @@ static inline void lockdep_on(void)
 # define lockdep_set_current_reclaim_state(g)	do { } while (0)
 # define lockdep_clear_current_reclaim_state()	do { } while (0)
 # define lockdep_trace_alloc(g)			do { } while (0)
-# define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub) \
 		do { (void)(name); (void)(key); } while (0)
diff -puN init/main.c~kernel-lockdep-eliminate-lockdep_init init/main.c
--- a/init/main.c~kernel-lockdep-eliminate-lockdep_init
+++ a/init/main.c
@@ -499,11 +499,6 @@ asmlinkage __visible void __init start_k
 	char *command_line;
 	char *after_dashes;
 
-	/*
-	 * Need to run as early as possible, to initialize the
-	 * lockdep hash:
-	 */
-	lockdep_init();
 	set_task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 	debug_objects_early_init();
diff -puN kernel/locking/lockdep.c~kernel-lockdep-eliminate-lockdep_init kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~kernel-lockdep-eliminate-lockdep_init
+++ a/kernel/locking/lockdep.c
@@ -123,8 +123,6 @@ static inline int debug_locks_off_graph_
 	return ret;
 }
 
-static int lockdep_initialized;
-
 unsigned long nr_list_entries;
 static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 
@@ -434,19 +432,6 @@ unsigned int max_lockdep_depth;
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
- * We cannot printk in early bootup code. Not even early_printk()
- * might work. So we mark any initialization errors and printk
- * about it later on, in lockdep_info().
- */
-static int lockdep_init_error;
-static const char *lock_init_error;
-static unsigned long lockdep_init_trace_data[20];
-static struct stack_trace lockdep_init_trace = {
-	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
-	.entries = lockdep_init_trace_data,
-};
-
-/*
  * Various lockdep statistics:
  */
 DEFINE_PER_CPU(struct lockdep_stats, lockdep_stats);
@@ -669,20 +654,6 @@ look_up_lock_class(struct lockdep_map *l
 	struct hlist_head *hash_head;
 	struct lock_class *class;
 
-#ifdef CONFIG_DEBUG_LOCKDEP
-	/*
-	 * If the architecture calls into lockdep before initializing
-	 * the hashes then we'll warn about it later. (we cannot printk
-	 * right now)
-	 */
-	if (unlikely(!lockdep_initialized)) {
-		lockdep_init();
-		lockdep_init_error = 1;
-		lock_init_error = lock->name;
-		save_stack_trace(&lockdep_init_trace);
-	}
-#endif
-
 	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
 		debug_locks_off();
 		printk(KERN_ERR
@@ -4009,28 +3980,6 @@ out_restore:
 	raw_local_irq_restore(flags);
 }
 
-void lockdep_init(void)
-{
-	int i;
-
-	/*
-	 * Some architectures have their own start_kernel()
-	 * code which calls lockdep_init(), while we also
-	 * call lockdep_init() from the start_kernel() itself,
-	 * and we want to initialize the hashes only once:
-	 */
-	if (lockdep_initialized)
-		return;
-
-	for (i = 0; i < CLASSHASH_SIZE; i++)
-		INIT_HLIST_HEAD(classhash_table + i);
-
-	for (i = 0; i < CHAINHASH_SIZE; i++)
-		INIT_HLIST_HEAD(chainhash_table + i);
-
-	lockdep_initialized = 1;
-}
-
 void __init lockdep_info(void)
 {
 	printk("Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar\n");
@@ -4057,14 +4006,6 @@ void __init lockdep_info(void)
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
-
-#ifdef CONFIG_DEBUG_LOCKDEP
-	if (lockdep_init_error) {
-		printk("WARNING: lockdep init error: lock '%s' was acquired before lockdep_init().\n", lock_init_error);
-		printk("Call stack leading to lockdep invocation was:\n");
-		print_stack_trace(&lockdep_init_trace, 0);
-	}
-#endif
 }
 
 static void
diff -puN tools/lib/lockdep/common.c~kernel-lockdep-eliminate-lockdep_init tools/lib/lockdep/common.c
--- a/tools/lib/lockdep/common.c~kernel-lockdep-eliminate-lockdep_init
+++ a/tools/lib/lockdep/common.c
@@ -11,11 +11,6 @@ static __thread struct task_struct curre
 bool debug_locks = true;
 bool debug_locks_silent;
 
-__attribute__((constructor)) static void liblockdep_init(void)
-{
-	lockdep_init();
-}
-
 __attribute__((destructor)) static void liblockdep_exit(void)
 {
 	debug_check_no_locks_held();
diff -puN tools/lib/lockdep/include/liblockdep/common.h~kernel-lockdep-eliminate-lockdep_init tools/lib/lockdep/include/liblockdep/common.h
--- a/tools/lib/lockdep/include/liblockdep/common.h~kernel-lockdep-eliminate-lockdep_init
+++ a/tools/lib/lockdep/include/liblockdep/common.h
@@ -44,7 +44,6 @@ void lock_acquire(struct lockdep_map *lo
 void lock_release(struct lockdep_map *lock, int nested,
 			unsigned long ip);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
-extern void lockdep_init(void);
 
 #define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
 	{ .name = (_name), .key = (void *)(_key), }
diff -puN tools/lib/lockdep/preload.c~kernel-lockdep-eliminate-lockdep_init tools/lib/lockdep/preload.c
--- a/tools/lib/lockdep/preload.c~kernel-lockdep-eliminate-lockdep_init
+++ a/tools/lib/lockdep/preload.c
@@ -439,7 +439,5 @@ __attribute__((constructor)) static void
 	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
 #endif
 
-	lockdep_init();
