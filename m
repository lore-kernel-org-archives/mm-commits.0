From: akpm@linux-foundation.org
Subject: - remove-hardcoding-of-hard_smp_processor_id-on-up.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:42 -0700
Message-ID: <200705092149.l49Lngte002719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbXEIVt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, ak@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Remove hardcoding of hard_smp_processor_id on UP systems
has been removed from the -mm tree.  Its filename was
     remove-hardcoding-of-hard_smp_processor_id-on-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove hardcoding of hard_smp_processor_id on UP systems
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

With the advent of kdump, the assumption that the boot CPU when booting an UP
kernel is always the CPU with a particular hardware ID (often 0) (usually
referred to as BSP on some architectures) is not valid anymore.  The reason
being that the dump capture kernel boots on the crashed CPU (the CPU that
invoked crash_kexec), which may be or may not be that particular CPU.

Move definition of hard_smp_processor_id for the UP case to
architecture-specific code ("asm/smp.h") where it belongs, so that each
architecture can provide its own implementation.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/traps.c |    1 +
 include/asm-alpha/smp.h     |    1 +
 include/asm-i386/smp.h      |    3 ++-
 include/asm-ia64/smp.h      |    3 ++-
 include/asm-m32r/smp.h      |    6 +++++-
 include/asm-powerpc/smp.h   |    1 +
 include/asm-s390/smp.h      |    1 +
 include/asm-sparc/smp.h     |    1 +
 include/asm-sparc64/smp.h   |    1 +
 include/asm-um/smp.h        |    4 ++++
 include/asm-x86_64/smp.h    |    4 +++-
 include/linux/smp.h         |    1 -
 12 files changed, 22 insertions(+), 5 deletions(-)

diff -puN arch/sparc64/kernel/traps.c~remove-hardcoding-of-hard_smp_processor_id-on-up arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/arch/sparc64/kernel/traps.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/kdebug.h>
 
+#include <asm/smp.h>
 #include <asm/delay.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
diff -puN include/asm-alpha/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-alpha/smp.h
--- a/include/asm-alpha/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-alpha/smp.h
@@ -51,6 +51,7 @@ int smp_call_function_on_cpu(void (*func
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
diff -puN include/asm-i386/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-i386/smp.h
--- a/include/asm-i386/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-i386/smp.h
@@ -147,12 +147,13 @@ extern unsigned int num_processors;
 
 #else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define safe_smp_processor_id()		0
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#endif /* CONFIG_SMP */
 
 #ifndef __ASSEMBLY__
 
diff -puN include/asm-ia64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-ia64/smp.h
@@ -128,8 +128,9 @@ extern void unlock_ipi_calllock(void);
 extern void identify_siblings (struct cpuinfo_ia64 *);
 extern int is_multithreading_enabled(void);
 
-#else
+#else /* CONFIG_SMP */
 
+#define hard_smp_processor_id()		0
 #define cpu_logical_id(i)		0
 #define cpu_physical_id(i)		ia64_get_lid()
 
diff -puN include/asm-m32r/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-m32r/smp.h
--- a/include/asm-m32r/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-m32r/smp.h
@@ -108,6 +108,10 @@ extern unsigned long send_IPI_mask_phys(
 #define IPI_SHIFT	(0)
 #define NR_IPIS		(8)
 
-#endif	/* CONFIG_SMP */
+#else	/* CONFIG_SMP */
+
+#define hard_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
 
 #endif	/* _ASM_M32R_SMP_H */
diff -puN include/asm-powerpc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-powerpc/smp.h
@@ -83,6 +83,7 @@ extern void __cpu_die(unsigned int cpu);
 
 #else
 /* for UP */
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_maps()
 
 #endif /* CONFIG_SMP */
diff -puN include/asm-s390/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-s390/smp.h
--- a/include/asm-s390/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-s390/smp.h
@@ -110,6 +110,7 @@ static inline void smp_send_stop(void)
 	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
 }
 
+#define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #define smp_setup_cpu_possible_map()	do { } while (0)
 #endif
diff -puN include/asm-sparc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-sparc/smp.h
--- a/include/asm-sparc/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-sparc/smp.h
@@ -165,6 +165,7 @@ void smp_setup_cpu_possible_map(void);
 
 #else /* SMP */
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 
 #endif /* !(SMP) */
diff -puN include/asm-sparc64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-sparc64/smp.h
--- a/include/asm-sparc64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-sparc64/smp.h
@@ -48,6 +48,7 @@ extern unsigned char boot_cpu_id;
 
 #else
 
+#define hard_smp_processor_id()		0
 #define smp_setup_cpu_possible_map() do { } while (0)
 #define boot_cpu_id	(0)
 
diff -puN include/asm-um/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-um/smp.h
--- a/include/asm-um/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-um/smp.h
@@ -24,6 +24,10 @@ extern inline void smp_cpus_done(unsigne
 
 extern struct task_struct *idle_threads[NR_CPUS];
 
+#else
+
+#define hard_smp_processor_id()		0
+
 #endif
 
 #endif
diff -puN include/asm-x86_64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/asm-x86_64/smp.h
@@ -71,7 +71,9 @@ extern unsigned __cpuinitdata disabled_c
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
-#endif
+#else /* CONFIG_SMP */
+#define hard_smp_processor_id() 0
+#endif /* CONFIG_SMP */
 
 /*
  * Some lowlevel functions might want to know about
diff -puN include/linux/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up include/linux/smp.h
--- a/include/linux/smp.h~remove-hardcoding-of-hard_smp_processor_id-on-up
+++ a/include/linux/smp.h
@@ -83,7 +83,6 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-#define hard_smp_processor_id()			0
 static inline int up_smp_call_function(void)
 {
 	return 0;
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch
