Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AE4C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4479B61C6C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGFTKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhGFTKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8883761C56;
        Tue,  6 Jul 2021 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598449;
        bh=+Gns2kndGOhxwnKeSBvbluoJw0pQWziD8AywboK+23I=;
        h=Date:From:To:Subject:From;
        b=Sx5pVfJFFbZLfa73saWEieY7lutNqfyM++IgCmuKamYoMVnnUSxRCCJyW7xHE5mrz
         qXikdL2xuST68THAvrRujoEgl2MMEesyqJmghLbRw6T8sDTBElMqg+pgJ+YuFaZh3b
         yuBCIOlCHKBQJCPaIVtXgfT+wjqkpMYzd34PnVvE=
Date:   Tue, 06 Jul 2021 12:07:29 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210706190729.wpztaiq4O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/smp.c      |    5 +++-
 arch/riscv/Kconfig             |    1 
 drivers/block/zram/zram_drv.h  |    2 -
 include/linux/compiler_types.h |    2 -
 lib/dump_stack.c               |   38 +------------------------------
 mm/kasan/sw_tags.c             |    7 +++++
 mm/memcontrol.c                |    6 ++--
 7 files changed, 19 insertions(+), 42 deletions(-)

--- a/arch/powerpc/kernel/smp.c~linux-next-rejects
+++ a/arch/powerpc/kernel/smp.c
@@ -1552,13 +1552,16 @@ void start_secondary(void *unused)
 {
 	unsigned int cpu = raw_smp_processor_id();
 
+	/* PPC64 calls setup_kup() in early_setup_secondary() */
+	if (IS_ENABLED(CONFIG_PPC32))
+		setup_kup();
+
 	mmgrab_lazy_tlb(&init_mm);
 	current->active_mm = &init_mm;
 
 	smp_store_cpu_info(cpu);
 	set_dec(tb_ticks_per_jiffy);
 	rcu_cpu_starting(cpu);
-	preempt_disable();
 	cpu_callin_map[cpu] = 1;
 
 	if (smp_ops->setup_cpu)
--- a/arch/riscv/Kconfig~linux-next-rejects
+++ a/arch/riscv/Kconfig
@@ -81,6 +81,7 @@ config RISCV
 	select HAVE_GENERIC_VDSO if MMU && 64BIT
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KPROBES if !XIP_KERNEL
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 	select HAVE_KPROBES_ON_FTRACE if !XIP_KERNEL
 	select HAVE_KRETPROBES if !XIP_KERNEL
 	select HAVE_MOVE_PMD
--- a/drivers/block/zram/zram_drv.h~linux-next-rejects
+++ a/drivers/block/zram/zram_drv.h
@@ -112,7 +112,7 @@ struct zram {
 	/*
 	 * zram is claimed so open request will be failed
 	 */
-	bool claim; /* Protected by bdev->bd_mutex */
+	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
--- a/lib/dump_stack.c~linux-next-rejects
+++ a/lib/dump_stack.c
@@ -84,52 +84,18 @@ static void __dump_stack(const char *log
  *
  * Architectures can override this implementation by implementing its own.
  */
-#ifdef CONFIG_SMP
-static atomic_t dump_lock = ATOMIC_INIT(-1);
-
 asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
 {
 	unsigned long flags;
-	int was_locked;
-	int old;
-	int cpu;
 
 	/*
 	 * Permit this cpu to perform nested stack dumps while serialising
 	 * against other CPUs
 	 */
-retry:
-	local_irq_save(flags);
-	cpu = smp_processor_id();
-	old = atomic_cmpxchg(&dump_lock, -1, cpu);
-	if (old == -1) {
-		was_locked = 0;
-	} else if (old == cpu) {
-		was_locked = 1;
-	} else {
-		local_irq_restore(flags);
-		/*
-		 * Wait for the lock to release before jumping to
-		 * atomic_cmpxchg() in order to mitigate the thundering herd
-		 * problem.
-		 */
-		do { cpu_relax(); } while (atomic_read(&dump_lock) != -1);
-		goto retry;
-	}
-
-	__dump_stack(log_lvl);
-
-	if (!was_locked)
-		atomic_set(&dump_lock, -1);
-
-	local_irq_restore(flags);
-}
-#else
-asmlinkage __visible void dump_stack_lvl(const char *log_lvl)
-{
+	printk_cpu_lock_irqsave(flags);
 	__dump_stack(log_lvl);
+	printk_cpu_unlock_irqrestore(flags);
 }
-#endif
 EXPORT_SYMBOL(dump_stack_lvl);
 
 asmlinkage __visible void dump_stack(void)
--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -81,14 +81,14 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
 EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
 
 /* Socket memory accounting disabled? */
-static bool cgroup_memory_nosocket;
+static bool cgroup_memory_nosocket __ro_after_init;
 
 /* Kernel memory accounting disabled? */
-bool cgroup_memory_nokmem;
+bool cgroup_memory_nokmem __ro_after_init;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-bool cgroup_memory_noswap __read_mostly;
+bool cgroup_memory_noswap __ro_after_init;
 #else
 #define cgroup_memory_noswap		1
 #endif
--- a/include/linux/compiler_types.h~linux-next-rejects
+++ a/include/linux/compiler_types.h
@@ -210,7 +210,7 @@ struct ftrace_likely_data {
 /* Section for code which can't be instrumented at all */
 #define noinstr								\
 	noinline notrace __attribute((__section__(".noinstr.text")))	\
-	__no_kcsan __no_sanitize_address __no_sanitize_coverage
+	__no_kcsan __no_sanitize_address __no_sanitize_coverage __no_profile
 
 #endif /* __KERNEL__ */
 
--- a/mm/kasan/sw_tags.c~linux-next-rejects
+++ a/mm/kasan/sw_tags.c
@@ -166,3 +166,10 @@ void __hwasan_tag_memory(unsigned long a
 	kasan_poison((void *)addr, size, tag, false);
 }
 EXPORT_SYMBOL(__hwasan_tag_memory);
+
+void kasan_tag_mismatch(unsigned long addr, unsigned long access_info,
+			unsigned long ret_ip)
+{
+	kasan_report(addr, 1 << (access_info & 0xf), access_info & 0x10,
+		     ret_ip);
+}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

