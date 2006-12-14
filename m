From: akpm@osdl.org
Subject: + introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:29:38 -0800
Message-ID: <200612140029.kBE0TdFi026252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbWLNAaV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Introduce time_data: a new structure to hold jiffies, xtime,  xtime_lock, wall_to_monotonic, calc_load_count and avenrun
has been added to the -mm tree.  Its filename is
     introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce time_data: a new structure to hold jiffies, xtime,  xtime_lock, wall_to_monotonic, calc_load_count and avenrun
From: Eric Dumazet <dada1@cosmosbay.com>

This patch introduces a new structure called time_data, where some time
keeping related variables are put together to share as few cache lines as
possible.  This should reduce timer interrupt latency and cache lines ping
pongs in SMP machines.

struct time_data {
        u64                    _jiffies_64;
        struct timespec _xtime;
        struct timespec _wall_to_monotonic;
        seqlock_t           lock;
        int                     calc_load_count;
        unsigned int     _avenrun[3];
};

_jiffies_64 is a place holder so that arches can (optionally) aliases
jiffies_64/jiffies in time_data.  This patch does the thing for i386 and
x86_64.

avenrun, xtime, xtime_lock, wall_to_monotonic, are now temporary defined as
macros to make this patch not too invasive, but we can in future patches
gradually deletes these macros.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmlinux.lds.S   |    3 +
 arch/s390/appldata/appldata_os.c |   18 ++++-----
 arch/x86_64/kernel/time.c        |    8 +++-
 arch/x86_64/kernel/vmlinux.lds.S |   14 ++-----
 arch/x86_64/kernel/vsyscall.c    |   15 +++-----
 include/asm-x86_64/vsyscall.h    |    8 +---
 include/linux/jiffies.h          |    2 -
 include/linux/sched.h            |   10 +++--
 include/linux/time.h             |   33 +++++++++++++++--
 kernel/timer.c                   |   54 ++++++++++++++---------------
 10 files changed, 92 insertions(+), 73 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~introduce-time_data-a-new-structure-to-hold-jiffies-xtime arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -25,7 +25,8 @@
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
+jiffies = time_data;
+jiffies_64 = time_data;
 _proxy_pda = 0;
 
 PHDRS {
diff -puN arch/s390/appldata/appldata_os.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime arch/s390/appldata/appldata_os.c
--- a/arch/s390/appldata/appldata_os.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/arch/s390/appldata/appldata_os.c
@@ -68,7 +68,7 @@ struct appldata_os_data {
 
 	u32 nr_running;		/* number of runnable threads      */
 	u32 nr_threads;		/* number of threads               */
-	u32 avenrun[3];		/* average nr. of running processes during */
+	u32 _avenrun[3];		/* average nr. of running processes during */
 				/* the last 1, 5 and 15 minutes */
 
 	/* New in 2.6 */
@@ -98,11 +98,11 @@ static inline void appldata_print_debug(
 	P_DEBUG("nr_threads   = %u\n", os_data->nr_threads);
 	P_DEBUG("nr_running   = %u\n", os_data->nr_running);
 	P_DEBUG("nr_iowait    = %u\n", os_data->nr_iowait);
-	P_DEBUG("avenrun(int) = %8x / %8x / %8x\n", os_data->avenrun[0],
-		os_data->avenrun[1], os_data->avenrun[2]);
-	a0 = os_data->avenrun[0];
-	a1 = os_data->avenrun[1];
-	a2 = os_data->avenrun[2];
+	P_DEBUG("avenrun(int) = %8x / %8x / %8x\n", os_data->_avenrun[0],
+		os_data->_avenrun[1], os_data->_avenrun[2]);
+	a0 = os_data->_avenrun[0];
+	a1 = os_data->_avenrun[1];
+	a2 = os_data->_avenrun[2];
 	P_DEBUG("avenrun(float) = %d.%02d / %d.%02d / %d.%02d\n",
 		LOAD_INT(a0), LOAD_FRAC(a0), LOAD_INT(a1), LOAD_FRAC(a1),
 		LOAD_INT(a2), LOAD_FRAC(a2));
@@ -145,9 +145,9 @@ static void appldata_get_os_data(void *d
 	os_data->nr_threads = nr_threads;
 	os_data->nr_running = nr_running();
 	os_data->nr_iowait  = nr_iowait();
-	os_data->avenrun[0] = avenrun[0] + (FIXED_1/200);
-	os_data->avenrun[1] = avenrun[1] + (FIXED_1/200);
-	os_data->avenrun[2] = avenrun[2] + (FIXED_1/200);
+	os_data->_avenrun[0] = avenrun[0] + (FIXED_1/200);
+	os_data->_avenrun[1] = avenrun[1] + (FIXED_1/200);
+	os_data->_avenrun[2] = avenrun[2] + (FIXED_1/200);
 
 	j = 0;
 	for_each_online_cpu(i) {
diff -puN arch/x86_64/kernel/time.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/arch/x86_64/kernel/time.c
@@ -76,8 +76,12 @@ unsigned long long monotonic_base;
 
 struct vxtime_data __vxtime __section_vxtime;	/* for vsyscalls */
 
-volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
-struct timespec __xtime __section_xtime;
+struct time_data __time_data __section_time_data = {
+	._jiffies_64 = INITIAL_JIFFIES,
+	.lock =  __SEQLOCK_UNLOCKED(time_data.lock),
+	.calc_load_count = LOAD_FREQ,
+};
+
 struct timezone __sys_tz __section_sys_tz;
 
 /*
diff -puN arch/x86_64/kernel/vmlinux.lds.S~introduce-time_data-a-new-structure-to-hold-jiffies-xtime arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -12,7 +12,6 @@
 OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 _proxy_pda = 0;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
@@ -88,8 +87,10 @@ SECTIONS
   __vsyscall_0 = VSYSCALL_VIRT_ADDR;
 
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .xtime_lock : AT(VLOAD(.xtime_lock)) { *(.xtime_lock) }
-  xtime_lock = VVIRT(.xtime_lock);
+  .time_data : AT(VLOAD(.time_data)) { *(.time_data) }
+  time_data = VVIRT(.time_data);
+  jiffies = time_data;
+  jiffies_64 = time_data;
 
   .vxtime : AT(VLOAD(.vxtime)) { *(.vxtime) }
   vxtime = VVIRT(.vxtime);
@@ -103,13 +104,6 @@ SECTIONS
   .sysctl_vsyscall : AT(VLOAD(.sysctl_vsyscall)) { *(.sysctl_vsyscall) }
   sysctl_vsyscall = VVIRT(.sysctl_vsyscall);
 
-  .xtime : AT(VLOAD(.xtime)) { *(.xtime) }
-  xtime = VVIRT(.xtime);
-
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
-  jiffies = VVIRT(.jiffies);
-
   .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) { *(.vsyscall_1) }
   .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) { *(.vsyscall_2) }
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) { *(.vsyscall_3) }
diff -puN arch/x86_64/kernel/vsyscall.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -45,7 +45,6 @@
 #define __syscall_clobber "r11","rcx","memory"
 
 int __sysctl_vsyscall __section_sysctl_vsyscall = 1;
-seqlock_t __xtime_lock __section_xtime_lock = SEQLOCK_UNLOCKED;
 int __vgetcpu_mode __section_vgetcpu_mode;
 
 #include <asm/unistd.h>
@@ -67,10 +66,10 @@ static __always_inline void do_vgettimeo
 	unsigned long sec, usec;
 
 	do {
-		sequence = read_seqbegin(&__xtime_lock);
+		sequence = read_seqbegin(&__time_data.lock);
 		
-		sec = __xtime.tv_sec;
-		usec = __xtime.tv_nsec / 1000;
+		sec = __time_data._xtime.tv_sec;
+		usec = __time_data._xtime.tv_nsec / 1000;
 
 		if (__vxtime.mode != VXTIME_HPET) {
 			t = get_cycles_sync();
@@ -84,7 +83,7 @@ static __always_inline void do_vgettimeo
 				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
 				  __vxtime.last) * __vxtime.quot) >> 32;
 		}
-	} while (read_seqretry(&__xtime_lock, sequence));
+	} while (read_seqretry(&__time_data.lock, sequence));
 
 	tv->tv_sec = sec + usec / 1000000;
 	tv->tv_usec = usec % 1000000;
@@ -132,8 +131,8 @@ time_t __vsyscall(1) vtime(time_t *t)
 	if (!__sysctl_vsyscall)
 		return time_syscall(t);
 	else if (t)
-		*t = __xtime.tv_sec;		
-	return __xtime.tv_sec;
+		*t = __time_data._xtime.tv_sec;
+	return __time_data._xtime.tv_sec;
 }
 
 /* Fast way to get current CPU and node.
@@ -158,7 +157,7 @@ vgetcpu(unsigned *cpu, unsigned *node, s
 	   We do this here because otherwise user space would do it on
 	   its own in a likely inferior way (no access to jiffies).
 	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] == (j = __jiffies)) {
+	if (tcache && tcache->blob[0] == (j = __time_data._jiffies_64)) {
 		p = tcache->blob[1];
 	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
diff -puN include/asm-x86_64/vsyscall.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime include/asm-x86_64/vsyscall.h
--- a/include/asm-x86_64/vsyscall.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/include/asm-x86_64/vsyscall.h
@@ -18,11 +18,9 @@ enum vsyscall_num {
 
 #define __section_vxtime __attribute__ ((unused, __section__ (".vxtime"), aligned(16)))
 #define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
-#define __section_jiffies __attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
 #define __section_sys_tz __attribute__ ((unused, __section__ (".sys_tz"), aligned(16)))
 #define __section_sysctl_vsyscall __attribute__ ((unused, __section__ (".sysctl_vsyscall"), aligned(16)))
-#define __section_xtime __attribute__ ((unused, __section__ (".xtime"), aligned(16)))
-#define __section_xtime_lock __attribute__ ((unused, __section__ (".xtime_lock"), aligned(16)))
+#define __section_time_data __attribute__ ((unused, __section__ (".time_data"), aligned(16)))
 
 #define VXTIME_TSC	1
 #define VXTIME_HPET	2
@@ -44,12 +42,10 @@ struct vxtime_data {
 #define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
 
 /* vsyscall space (readonly) */
+extern struct time_data __time_data;
 extern struct vxtime_data __vxtime;
 extern int __vgetcpu_mode;
-extern struct timespec __xtime;
-extern volatile unsigned long __jiffies;
 extern struct timezone __sys_tz;
-extern seqlock_t __xtime_lock;
 
 /* kernel space (writeable) */
 extern struct vxtime_data vxtime;
diff -puN include/linux/jiffies.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime include/linux/jiffies.h
--- a/include/linux/jiffies.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/include/linux/jiffies.h
@@ -78,7 +78,7 @@
  * without sampling the sequence number in xtime_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
-extern u64 __jiffy_data jiffies_64;
+extern u64 __jiffy_data jiffies_64 __attribute__((weak));
 extern unsigned long volatile __jiffy_data jiffies;
 
 #if (BITS_PER_LONG < 64)
diff -puN include/linux/sched.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime include/linux/sched.h
--- a/include/linux/sched.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/include/linux/sched.h
@@ -105,7 +105,6 @@ struct futex_pi_state;
  *    the EXP_n values would be 1981, 2034 and 2043 if still using only
  *    11 bit fractions.
  */
-extern unsigned long avenrun[];		/* Load averages */
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
@@ -115,9 +114,12 @@ extern unsigned long avenrun[];		/* Load
 #define EXP_15		2037		/* 1/exp(5sec/15min) */
 
 #define CALC_LOAD(load,exp,n) \
-	load *= exp; \
-	load += n*(FIXED_1-exp); \
-	load >>= FSHIFT;
+	{ \
+	unsigned long temp = load; \
+	temp *= exp; \
+	temp += n*(FIXED_1-exp); \
+	load = temp >> FSHIFT; \
+	}
 
 extern unsigned long total_forks;
 extern int nr_threads;
diff -puN include/linux/time.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime include/linux/time.h
--- a/include/linux/time.h~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/include/linux/time.h
@@ -88,21 +88,44 @@ static inline struct timespec timespec_s
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern struct timespec xtime;
-extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock __attribute__((weak));
+/*
+ * Structure time_data holds most timekeeping related variables
+ * to make them share as few cache lines as possible.
+ */
+struct time_data {
+	/*
+	 * We want to alias jiffies_64 to time_data._jiffies_64,
+	 * in vmlinux.lds.S files (jiffies_64 = time_data)
+	 * so keep _jiffies_64 at the beginning of time_data
+	 */
+	u64		_jiffies_64;
+	struct timespec _xtime;
+	struct timespec _wall_to_monotonic;
+	seqlock_t	lock;
+	int		calc_load_count;
+	unsigned int	_avenrun[3];
+};
+/*
+ * time_data has weak attribute because some arches (x86_64) want
+ * to have a read_only version in their vsyscall page
+ */
+extern struct time_data time_data __attribute__((weak));
+#define xtime             time_data._xtime
+#define wall_to_monotonic time_data._wall_to_monotonic
+#define xtime_lock        time_data.lock
+#define avenrun           time_data._avenrun
 
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	return time_data._xtime.tv_sec;
 }
 
 struct timespec current_kernel_time(void);
 
 #define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { xtime.tv_sec, 0 })
+#define CURRENT_TIME_SEC	((struct timespec) { time_data._xtime.tv_sec, 0 })
 
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
diff -puN kernel/timer.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime kernel/timer.c
--- a/kernel/timer.c~introduce-time_data-a-new-structure-to-hold-jiffies-xtime
+++ a/kernel/timer.c
@@ -41,7 +41,7 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
-u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
+__attribute__((weak)) u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
@@ -702,10 +702,12 @@ found:
  * however, we will ALWAYS keep the tv_nsec part positive so we can use
  * the usual normalization.
  */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-
-EXPORT_SYMBOL(xtime);
+__attribute__((weak)) struct time_data time_data __cacheline_aligned = {
+	._jiffies_64 = INITIAL_JIFFIES,
+	.lock = __SEQLOCK_UNLOCKED(time_data.lock),
+	.calc_load_count = LOAD_FREQ,
+};
+EXPORT_SYMBOL(time_data);
 
 
 /* XXX - all of this timekeeping code should be later moved to time.c */
@@ -1133,9 +1135,6 @@ static unsigned long count_active_tasks(
  *
  * Requires xtime_lock to access.
  */
-unsigned long avenrun[3];
-
-EXPORT_SYMBOL(avenrun);
 
 /*
  * calc_load - given tick count, update the avenrun load estimates.
@@ -1144,29 +1143,20 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
 
-	count -= ticks;
-	if (unlikely(count < 0)) {
+	time_data.calc_load_count -= ticks;
+	if (unlikely(time_data.calc_load_count < 0)) {
 		active_tasks = count_active_tasks();
 		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
-			count += LOAD_FREQ;
-		} while (count < 0);
+			CALC_LOAD(time_data._avenrun[0], EXP_1, active_tasks);
+			CALC_LOAD(time_data._avenrun[1], EXP_5, active_tasks);
+			CALC_LOAD(time_data._avenrun[2], EXP_15, active_tasks);
+			time_data.calc_load_count += LOAD_FREQ;
+		} while (time_data.calc_load_count < 0);
 	}
 }
 
 /*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
- */
-__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-EXPORT_SYMBOL(xtime_lock);
-
-/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
@@ -1391,6 +1381,16 @@ asmlinkage long sys_gettid(void)
 }
 
 /**
+ * avenrun_to_loads - convert an _avenrun[] to sysinfo.loads[]
+ * @idx: index (0..2) in time_data._avenrun[]
+ */
+static inline unsigned long avenrun_to_loads(unsigned int idx)
+{
+	unsigned long ret = time_data._avenrun[idx];
+	return ret << (SI_LOAD_SHIFT - FSHIFT);
+}
+
+/**
  * sys_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
  */ 
@@ -1423,9 +1423,9 @@ asmlinkage long sys_sysinfo(struct sysin
 		}
 		val.uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
 
-		val.loads[0] = avenrun[0] << (SI_LOAD_SHIFT - FSHIFT);
-		val.loads[1] = avenrun[1] << (SI_LOAD_SHIFT - FSHIFT);
-		val.loads[2] = avenrun[2] << (SI_LOAD_SHIFT - FSHIFT);
+		val.loads[0] = avenrun_to_loads(0);
+		val.loads[1] = avenrun_to_loads(1);
+		val.loads[2] = avenrun_to_loads(2);
 
 		val.procs = nr_threads;
 	} while (read_seqretry(&xtime_lock, seq));
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
constify-pipe_buf_operations.patch
reorder-struct-pipe_buf_operations.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
optimize-calc_load.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch

