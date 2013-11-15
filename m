From: akpm@linux-foundation.org
Subject: [merged] kernel-remove-config_use_generic_smp_helpers.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:15 -0800
Message-ID: <52867f6b.VitcIIap0mZyBL0W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3KOUJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: [merged] kernel-remove-config_use_generic_smp_helpers.patch removed from -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:15 -0800


The patch titled
     Subject: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS
has been removed from the -mm tree.  Its filename was
     kernel-remove-config_use_generic_smp_helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS

We've switched over every architecture that supports SMP to it, so remove
the new useless config variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig          |    3 ---
 arch/alpha/Kconfig    |    1 -
 arch/arc/Kconfig      |    1 -
 arch/arm/Kconfig      |    1 -
 arch/arm64/Kconfig    |    1 -
 arch/blackfin/Kconfig |    1 -
 arch/hexagon/Kconfig  |    1 -
 arch/ia64/Kconfig     |    1 -
 arch/m32r/Kconfig     |    1 -
 arch/metag/Kconfig    |    1 -
 arch/mips/Kconfig     |    1 -
 arch/mn10300/Kconfig  |    1 -
 arch/parisc/Kconfig   |    1 -
 arch/powerpc/Kconfig  |    1 -
 arch/s390/Kconfig     |    1 -
 arch/sh/Kconfig       |    1 -
 arch/sparc/Kconfig    |    1 -
 arch/tile/Kconfig     |    1 -
 arch/x86/Kconfig      |    1 -
 block/blk-mq.c        |    4 ++--
 block/blk-softirq.c   |    4 ++--
 block/blk-sysfs.c     |    2 +-
 include/linux/smp.h   |    4 ----
 kernel/Kconfig.hz     |    2 +-
 kernel/smp.c          |    2 --
 25 files changed, 6 insertions(+), 33 deletions(-)

diff -puN arch/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/Kconfig
--- a/arch/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/Kconfig
@@ -207,9 +207,6 @@ config HAVE_DMA_ATTRS
 config HAVE_DMA_CONTIGUOUS
 	bool
 
-config USE_GENERIC_SMP_HELPERS
-	bool
-
 config GENERIC_SMP_IDLE_THREAD
        bool
 
diff -puN arch/alpha/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/alpha/Kconfig
@@ -522,7 +522,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/arc/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/arc/Kconfig
--- a/arch/arc/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/arc/Kconfig
@@ -125,7 +125,6 @@ config ARC_PLAT_NEEDS_CPU_TO_DMA
 config SMP
 	bool "Symmetric Multi-Processing (Incomplete)"
 	default n
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/arm/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/arm/Kconfig
--- a/arch/arm/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/arm/Kconfig
@@ -1432,7 +1432,6 @@ config SMP
 	depends on GENERIC_CLOCKEVENTS
 	depends on HAVE_SMP
 	depends on MMU || ARM_MPU
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/arm64/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/arm64/Kconfig
@@ -143,7 +143,6 @@ config CPU_BIG_ENDIAN
 
 config SMP
 	bool "Symmetric Multi-Processing"
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU.  If
 	  you say N here, the kernel will run on single and
diff -puN arch/blackfin/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/blackfin/Kconfig
@@ -34,7 +34,6 @@ config BLACKFIN
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
diff -puN arch/hexagon/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/hexagon/Kconfig
--- a/arch/hexagon/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/hexagon/Kconfig
@@ -4,7 +4,6 @@ comment "Linux Kernel Configuration for
 config HEXAGON
 	def_bool y
 	select HAVE_OPROFILE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	# Other pending projects/to-do items.
 	# select HAVE_REGS_AND_STACK_ACCESS_API
 	# select HAVE_HW_BREAKPOINT if PERF_EVENTS
diff -puN arch/ia64/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/ia64/Kconfig
@@ -343,7 +343,6 @@ config FORCE_MAX_ZONEORDER
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, say N.  If you have a system with more
diff -puN arch/m32r/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/m32r/Kconfig
@@ -275,7 +275,6 @@ source "kernel/Kconfig.preempt"
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/metag/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/metag/Kconfig
--- a/arch/metag/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/metag/Kconfig
@@ -111,7 +111,6 @@ config METAG_META21
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on METAG_META21 && METAG_META21_MMU
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one thread running
 	  Linux. If you have a system with only one thread running Linux,
diff -puN arch/mips/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/mips/Kconfig
--- a/arch/mips/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/mips/Kconfig
@@ -2125,7 +2125,6 @@ source "mm/Kconfig"
 config SMP
 	bool "Multi-Processing support"
 	depends on SYS_SUPPORTS_SMP
-	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/mn10300/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/mn10300/Kconfig
@@ -181,7 +181,6 @@ endmenu
 config SMP
 	bool "Symmetric multi-processing support"
 	default y
-	select USE_GENERIC_SMP_HELPERS
 	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
diff -puN arch/parisc/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/parisc/Kconfig
@@ -226,7 +226,6 @@ endchoice
 
 config SMP
 	bool "Symmetric multi-processing support"
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/powerpc/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/powerpc/Kconfig
@@ -106,7 +106,6 @@ config PPC
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
 	select HAVE_DEBUG_KMEMLEAK
 	select GENERIC_ATOMIC64 if PPC32
diff -puN arch/s390/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/s390/Kconfig
--- a/arch/s390/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/s390/Kconfig
@@ -141,7 +141,6 @@ config S390
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select SYSCTL_EXCEPTION_TRACE
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
 
diff -puN arch/sh/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/sh/Kconfig
--- a/arch/sh/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/sh/Kconfig
@@ -711,7 +711,6 @@ config CC_STACKPROTECTOR
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
-	select USE_GENERIC_SMP_HELPERS
 	---help---
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
diff -puN arch/sparc/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/sparc/Kconfig
@@ -28,7 +28,6 @@ config SPARC
 	select HAVE_ARCH_JUMP_LABEL
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select HAVE_BPF_JIT
diff -puN arch/tile/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/tile/Kconfig
--- a/arch/tile/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/tile/Kconfig
@@ -8,7 +8,6 @@ config TILE
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
 	select SYSCTL_EXCEPTION_TRACE
-	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_DEBUG_KMEMLEAK
 	select GENERIC_IRQ_PROBE
diff -puN arch/x86/Kconfig~kernel-remove-config_use_generic_smp_helpers arch/x86/Kconfig
--- a/arch/x86/Kconfig~kernel-remove-config_use_generic_smp_helpers
+++ a/arch/x86/Kconfig
@@ -90,7 +90,6 @@ config X86
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CLOCKEVENTS_MIN_ADJUST
 	select IRQ_FORCED_THREADING
-	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select CLKEVT_I8253
diff -puN block/blk-mq.c~kernel-remove-config_use_generic_smp_helpers block/blk-mq.c
--- a/block/blk-mq.c~kernel-remove-config_use_generic_smp_helpers
+++ a/block/blk-mq.c
@@ -319,7 +319,7 @@ void __blk_mq_end_io(struct request *rq,
 		blk_mq_complete_request(rq, error);
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#if defined(CONFIG_SMP)
 
 /*
  * Called with interrupts disabled.
@@ -361,7 +361,7 @@ static int ipi_remote_cpu(struct blk_mq_
 
 	return true;
 }
-#else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#else /* CONFIG_SMP */
 static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
 			  struct request *rq, const int error)
 {
diff -puN block/blk-softirq.c~kernel-remove-config_use_generic_smp_helpers block/blk-softirq.c
--- a/block/blk-softirq.c~kernel-remove-config_use_generic_smp_helpers
+++ a/block/blk-softirq.c
@@ -36,7 +36,7 @@ static void blk_done_softirq(struct soft
 	}
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 static void trigger_softirq(void *data)
 {
 	struct request *rq = data;
@@ -71,7 +71,7 @@ static int raise_blk_irq(int cpu, struct
 
 	return 1;
 }
-#else /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#else /* CONFIG_SMP */
 static int raise_blk_irq(int cpu, struct request *rq)
 {
 	return 1;
diff -puN block/blk-sysfs.c~kernel-remove-config_use_generic_smp_helpers block/blk-sysfs.c
--- a/block/blk-sysfs.c~kernel-remove-config_use_generic_smp_helpers
+++ a/block/blk-sysfs.c
@@ -288,7 +288,7 @@ static ssize_t
 queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 {
 	ssize_t ret = -EINVAL;
-#if defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 	unsigned long val;
 
 	ret = queue_var_store(&val, page, count);
diff -puN include/linux/smp.h~kernel-remove-config_use_generic_smp_helpers include/linux/smp.h
--- a/include/linux/smp.h~kernel-remove-config_use_generic_smp_helpers
+++ a/include/linux/smp.h
@@ -106,14 +106,10 @@ void kick_all_cpus_sync(void);
 /*
  * Generic and arch helpers
  */
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void __init call_function_init(void);
 void generic_smp_call_function_single_interrupt(void);
 #define generic_smp_call_function_interrupt \
 	generic_smp_call_function_single_interrupt
-#else
-static inline void call_function_init(void) { }
-#endif
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
diff -puN kernel/Kconfig.hz~kernel-remove-config_use_generic_smp_helpers kernel/Kconfig.hz
--- a/kernel/Kconfig.hz~kernel-remove-config_use_generic_smp_helpers
+++ a/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
+	def_bool HIGH_RES_TIMERS
diff -puN kernel/smp.c~kernel-remove-config_use_generic_smp_helpers kernel/smp.c
--- a/kernel/smp.c~kernel-remove-config_use_generic_smp_helpers
+++ a/kernel/smp.c
@@ -15,7 +15,6 @@
 
 #include "smpboot.h"
 
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 enum {
 	CSD_FLAG_LOCK		= 0x01,
 	CSD_FLAG_WAIT		= 0x02,
@@ -464,7 +463,6 @@ int smp_call_function(smp_call_func_t fu
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
-#endif /* USE_GENERIC_SMP_HELPERS */
 
 /* Setup configured maximum number of CPUs to activate */
 unsigned int setup_max_cpus = NR_CPUS;
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
linux-next.patch

