From: akpm@osdl.org
Subject: - introduce-time_data-a-new-structure-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenrun.patch removed from -mm tree
Date: Sat, 27 Jan 2007 18:12:46 -0800
Message-ID: <200701280212.l0S2CkJ2020758@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43370 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbXA1COF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 21:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, ak@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Introduce time_data, a new structure to hold jiffies, xtime, xtime=
_lock, wall_to_monotonic, calc_load_count and avenrun
has been removed from the -mm tree.  Its filename was
     introduce-time_data-a-new-structure-to-hold-jiffies-xtime-xtime_lo=
ck-wall_to_monotonic-calc_load_count-and-avenrun.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Introduce time_data, a new structure to hold jiffies, xtime, x=
time_lock, wall_to_monotonic, calc_load_count and avenrun
=46rom: Eric Dumazet <dada1@cosmosbay.com>

Introduce a new structure called time_data, where some time keeping rel=
ated
variables are put together to share as few cache lines as possible.  Th=
is
should reduce timer interrupt latency and cache lines ping pongs in SMP
machines.

struct time_data {
=A0 =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_jiffies_64;
=A0 =A0 =A0 =A0 struct timespec _xtime;
=A0 =A0 =A0 =A0 struct timespec _wall_to_monotonic;
=A0 =A0 =A0 =A0 seqlock_t =A0 =A0 =A0 =A0 =A0 lock;
=A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_load_c=
ount;
=A0 =A0 =A0 =A0 unsigned int =A0 =A0 _avenrun[3];
};

_jiffies_64 is a place holder so that arches can (optionally) aliases
jiffies_64/jiffies in time_data.  This patch does the thing for i386, x=
86_64
and ia64=20

avenrun, xtime, xtime_lock, wall_to_monotonic, are now temporary define=
d as
macros to make this patch not too invasive, but we can in future patche=
s
gradually deletes these macros.

=46or ia64, I added aliases for xtime, xtime_lock and wall_to_monotonic=
 because
arch/ia64/kernel/fsys.S uses these symbols.  This file might be changed=
 to
directly access time_data in the future (reducing registers use as well=
)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/vmlinux.lds.S   |    3 +
 arch/ia64/kernel/asm-offsets.c   |    3 +
 arch/ia64/kernel/vmlinux.lds.S   |    7 +++
 arch/s390/appldata/appldata_os.c |   18 ++++-----
 arch/x86_64/kernel/time.c        |    8 +++-
 arch/x86_64/kernel/vmlinux.lds.S |   14 ++-----
 arch/x86_64/kernel/vsyscall.c    |   15 +++-----
 include/asm-x86_64/vsyscall.h    |    8 +---
 include/linux/jiffies.h          |    2 -
 include/linux/sched.h            |   10 +++--
 include/linux/time.h             |   33 +++++++++++++++--
 kernel/timer.c                   |   54 ++++++++++++++---------------
 12 files changed, 101 insertions(+), 74 deletions(-)

diff -puN arch/i386/kernel/vmlinux.lds.S~introduce-time_data-a-new-stru=
cture-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_coun=
t-and-avenrun arch/i386/kernel/vmlinux.lds.S
--- a/arch/i386/kernel/vmlinux.lds.S~introduce-time_data-a-new-structur=
e-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-an=
d-avenrun
+++ a/arch/i386/kernel/vmlinux.lds.S
@@ -25,7 +25,8 @@
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies =3D jiffies_64;
+jiffies =3D time_data;
+jiffies_64 =3D time_data;
 _proxy_pda =3D 0;
=20
 PHDRS {
diff -puN arch/ia64/kernel/asm-offsets.c~introduce-time_data-a-new-stru=
cture-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_coun=
t-and-avenrun arch/ia64/kernel/asm-offsets.c
--- a/arch/ia64/kernel/asm-offsets.c~introduce-time_data-a-new-structur=
e-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-an=
d-avenrun
+++ a/arch/ia64/kernel/asm-offsets.c
@@ -268,4 +268,7 @@ void foo(void)
 	DEFINE(IA64_TIME_SOURCE_MMIO64, TIME_SOURCE_MMIO64);
 	DEFINE(IA64_TIME_SOURCE_MMIO32, TIME_SOURCE_MMIO32);
 	DEFINE(IA64_TIMESPEC_TV_NSEC_OFFSET, offsetof (struct timespec, tv_ns=
ec));
+	DEFINE(IA64_XTIME_OFFSET, offsetof (struct time_data, _xtime));
+	DEFINE(IA64_WALL_TO_MONOTONIC_OFFSET, offsetof (struct time_data, _wa=
ll_to_monotonic));
+	DEFINE(IA64_XTIME_LOCK_OFFSET, offsetof (struct time_data, lock));
 }
diff -puN arch/ia64/kernel/vmlinux.lds.S~introduce-time_data-a-new-stru=
cture-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_coun=
t-and-avenrun arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~introduce-time_data-a-new-structur=
e-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-an=
d-avenrun
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -3,6 +3,7 @@
 #include <asm/ptrace.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
+#include <asm/asm-offsets.h>
=20
 #define LOAD_OFFSET	(KERNEL_START - KERNEL_TR_PAGE_SIZE)
 #include <asm-generic/vmlinux.lds.h>
@@ -15,7 +16,11 @@
 OUTPUT_FORMAT("elf64-ia64-little")
 OUTPUT_ARCH(ia64)
 ENTRY(phys_start)
-jiffies =3D jiffies_64;
+jiffies =3D time_data;
+jiffies_64 =3D time_data;
+xtime =3D time_data + IA64_XTIME_OFFSET;
+wall_to_monotonic =3D time_data + IA64_WALL_TO_MONOTONIC_OFFSET;
+xtime_lock =3D time_data + IA64_XTIME_LOCK_OFFSET;
 PHDRS {
   code   PT_LOAD;
   percpu PT_LOAD;
diff -puN arch/s390/appldata/appldata_os.c~introduce-time_data-a-new-st=
ructure-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_co=
unt-and-avenrun arch/s390/appldata/appldata_os.c
--- a/arch/s390/appldata/appldata_os.c~introduce-time_data-a-new-struct=
ure-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-=
and-avenrun
+++ a/arch/s390/appldata/appldata_os.c
@@ -68,7 +68,7 @@ struct appldata_os_data {
=20
 	u32 nr_running;		/* number of runnable threads      */
 	u32 nr_threads;		/* number of threads               */
-	u32 avenrun[3];		/* average nr. of running processes during */
+	u32 _avenrun[3];		/* average nr. of running processes during */
 				/* the last 1, 5 and 15 minutes */
=20
 	/* New in 2.6 */
@@ -98,11 +98,11 @@ static inline void appldata_print_debug(
 	P_DEBUG("nr_threads   =3D %u\n", os_data->nr_threads);
 	P_DEBUG("nr_running   =3D %u\n", os_data->nr_running);
 	P_DEBUG("nr_iowait    =3D %u\n", os_data->nr_iowait);
-	P_DEBUG("avenrun(int) =3D %8x / %8x / %8x\n", os_data->avenrun[0],
-		os_data->avenrun[1], os_data->avenrun[2]);
-	a0 =3D os_data->avenrun[0];
-	a1 =3D os_data->avenrun[1];
-	a2 =3D os_data->avenrun[2];
+	P_DEBUG("avenrun(int) =3D %8x / %8x / %8x\n", os_data->_avenrun[0],
+		os_data->_avenrun[1], os_data->_avenrun[2]);
+	a0 =3D os_data->_avenrun[0];
+	a1 =3D os_data->_avenrun[1];
+	a2 =3D os_data->_avenrun[2];
 	P_DEBUG("avenrun(float) =3D %d.%02d / %d.%02d / %d.%02d\n",
 		LOAD_INT(a0), LOAD_FRAC(a0), LOAD_INT(a1), LOAD_FRAC(a1),
 		LOAD_INT(a2), LOAD_FRAC(a2));
@@ -145,9 +145,9 @@ static void appldata_get_os_data(void *d
 	os_data->nr_threads =3D nr_threads;
 	os_data->nr_running =3D nr_running();
 	os_data->nr_iowait  =3D nr_iowait();
-	os_data->avenrun[0] =3D avenrun[0] + (FIXED_1/200);
-	os_data->avenrun[1] =3D avenrun[1] + (FIXED_1/200);
-	os_data->avenrun[2] =3D avenrun[2] + (FIXED_1/200);
+	os_data->_avenrun[0] =3D avenrun[0] + (FIXED_1/200);
+	os_data->_avenrun[1] =3D avenrun[1] + (FIXED_1/200);
+	os_data->_avenrun[2] =3D avenrun[2] + (FIXED_1/200);
=20
 	j =3D 0;
 	for_each_online_cpu(i) {
diff -puN arch/x86_64/kernel/time.c~introduce-time_data-a-new-structure=
-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and=
-avenrun arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~introduce-time_data-a-new-structure-to-=
hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-ave=
nrun
+++ a/arch/x86_64/kernel/time.c
@@ -76,8 +76,12 @@ unsigned long long monotonic_base;
=20
 struct vxtime_data __vxtime __section_vxtime;	/* for vsyscalls */
=20
-volatile unsigned long __jiffies __section_jiffies =3D INITIAL_JIFFIES=
;
-struct timespec __xtime __section_xtime;
+struct time_data __time_data __section_time_data =3D {
+	._jiffies_64 =3D INITIAL_JIFFIES,
+	.lock =3D  __SEQLOCK_UNLOCKED(time_data.lock),
+	.calc_load_count =3D LOAD_FREQ,
+};
+
 struct timezone __sys_tz __section_sys_tz;
=20
 /*
diff -puN arch/x86_64/kernel/vmlinux.lds.S~introduce-time_data-a-new-st=
ructure-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_co=
unt-and-avenrun arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~introduce-time_data-a-new-struct=
ure-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-=
and-avenrun
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -12,7 +12,6 @@
 OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 =3D jiffies;
 _proxy_pda =3D 0;
 PHDRS {
 	text PT_LOAD FLAGS(5);	/* R_E */
@@ -88,8 +87,10 @@ SECTIONS
   __vsyscall_0 =3D VSYSCALL_VIRT_ADDR;
=20
   . =3D ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .xtime_lock : AT(VLOAD(.xtime_lock)) { *(.xtime_lock) }
-  xtime_lock =3D VVIRT(.xtime_lock);
+  .time_data : AT(VLOAD(.time_data)) { *(.time_data) }
+  time_data =3D VVIRT(.time_data);
+  jiffies =3D time_data;
+  jiffies_64 =3D time_data;
=20
   .vxtime : AT(VLOAD(.vxtime)) { *(.vxtime) }
   vxtime =3D VVIRT(.vxtime);
@@ -103,13 +104,6 @@ SECTIONS
   .sysctl_vsyscall : AT(VLOAD(.sysctl_vsyscall)) { *(.sysctl_vsyscall)=
 }
   sysctl_vsyscall =3D VVIRT(.sysctl_vsyscall);
=20
-  .xtime : AT(VLOAD(.xtime)) { *(.xtime) }
-  xtime =3D VVIRT(.xtime);
-
-  . =3D ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
-  jiffies =3D VVIRT(.jiffies);
-
   .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) { *(.vs=
yscall_1) }
   .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) { *(.vs=
yscall_2) }
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) { *(.vs=
yscall_3) }
diff -puN arch/x86_64/kernel/vsyscall.c~introduce-time_data-a-new-struc=
ture-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count=
-and-avenrun arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~introduce-time_data-a-new-structure=
-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and=
-avenrun
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -45,7 +45,6 @@
 #define __syscall_clobber "r11","rcx","memory"
=20
 int __sysctl_vsyscall __section_sysctl_vsyscall =3D 1;
-seqlock_t __xtime_lock __section_xtime_lock =3D SEQLOCK_UNLOCKED;
 int __vgetcpu_mode __section_vgetcpu_mode;
=20
 #include <asm/unistd.h>
@@ -67,10 +66,10 @@ static __always_inline void do_vgettimeo
 	unsigned long sec, usec;
=20
 	do {
-		sequence =3D read_seqbegin(&__xtime_lock);
+		sequence =3D read_seqbegin(&__time_data.lock);
 	=09
-		sec =3D __xtime.tv_sec;
-		usec =3D __xtime.tv_nsec / 1000;
+		sec =3D __time_data._xtime.tv_sec;
+		usec =3D __time_data._xtime.tv_nsec / 1000;
=20
 		if (__vxtime.mode !=3D VXTIME_HPET) {
 			t =3D get_cycles_sync();
@@ -84,7 +83,7 @@ static __always_inline void do_vgettimeo
 				   fix_to_virt(VSYSCALL_HPET) + 0xf0) -
 				  __vxtime.last) * __vxtime.quot) >> 32;
 		}
-	} while (read_seqretry(&__xtime_lock, sequence));
+	} while (read_seqretry(&__time_data.lock, sequence));
=20
 	tv->tv_sec =3D sec + usec / 1000000;
 	tv->tv_usec =3D usec % 1000000;
@@ -132,8 +131,8 @@ time_t __vsyscall(1) vtime(time_t *t)
 	if (!__sysctl_vsyscall)
 		return time_syscall(t);
 	else if (t)
-		*t =3D __xtime.tv_sec;	=09
-	return __xtime.tv_sec;
+		*t =3D __time_data._xtime.tv_sec;
+	return __time_data._xtime.tv_sec;
 }
=20
 /* Fast way to get current CPU and node.
@@ -158,7 +157,7 @@ vgetcpu(unsigned *cpu, unsigned *node, s
 	   We do this here because otherwise user space would do it on
 	   its own in a likely inferior way (no access to jiffies).
 	   If you don't like it pass NULL. */
-	if (tcache && tcache->blob[0] =3D=3D (j =3D __jiffies)) {
+	if (tcache && tcache->blob[0] =3D=3D (j =3D __time_data._jiffies_64))=
 {
 		p =3D tcache->blob[1];
 	} else if (__vgetcpu_mode =3D=3D VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
diff -puN include/asm-x86_64/vsyscall.h~introduce-time_data-a-new-struc=
ture-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count=
-and-avenrun include/asm-x86_64/vsyscall.h
--- a/include/asm-x86_64/vsyscall.h~introduce-time_data-a-new-structure=
-to-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and=
-avenrun
+++ a/include/asm-x86_64/vsyscall.h
@@ -18,11 +18,9 @@ enum vsyscall_num {
=20
 #define __section_vxtime __attribute__ ((unused, __section__ (".vxtime=
"), aligned(16)))
 #define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".=
vgetcpu_mode"), aligned(16)))
-#define __section_jiffies __attribute__ ((unused, __section__ (".jiffi=
es"), aligned(16)))
 #define __section_sys_tz __attribute__ ((unused, __section__ (".sys_tz=
"), aligned(16)))
 #define __section_sysctl_vsyscall __attribute__ ((unused, __section__ =
(".sysctl_vsyscall"), aligned(16)))
-#define __section_xtime __attribute__ ((unused, __section__ (".xtime")=
, aligned(16)))
-#define __section_xtime_lock __attribute__ ((unused, __section__ (".xt=
ime_lock"), aligned(16)))
+#define __section_time_data __attribute__ ((unused, __section__ (".tim=
e_data"), aligned(16)))
=20
 #define VXTIME_TSC	1
 #define VXTIME_HPET	2
@@ -44,12 +42,10 @@ struct vxtime_data {
 #define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(=
=46IX_HPET_BASE) + a)
=20
 /* vsyscall space (readonly) */
+extern struct time_data __time_data;
 extern struct vxtime_data __vxtime;
 extern int __vgetcpu_mode;
-extern struct timespec __xtime;
-extern volatile unsigned long __jiffies;
 extern struct timezone __sys_tz;
-extern seqlock_t __xtime_lock;
=20
 /* kernel space (writeable) */
 extern struct vxtime_data vxtime;
diff -puN include/linux/jiffies.h~introduce-time_data-a-new-structure-t=
o-hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-a=
venrun include/linux/jiffies.h
--- a/include/linux/jiffies.h~introduce-time_data-a-new-structure-to-ho=
ld-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenr=
un
+++ a/include/linux/jiffies.h
@@ -78,7 +78,7 @@
  * without sampling the sequence number in xtime_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
-extern u64 __jiffy_data jiffies_64;
+extern u64 __jiffy_data jiffies_64 __attribute__((weak));
 extern unsigned long volatile __jiffy_data jiffies;
=20
 #if (BITS_PER_LONG < 64)
diff -puN include/linux/sched.h~introduce-time_data-a-new-structure-to-=
hold-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-ave=
nrun include/linux/sched.h
--- a/include/linux/sched.h~introduce-time_data-a-new-structure-to-hold=
-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenrun
+++ a/include/linux/sched.h
@@ -105,7 +105,6 @@ struct futex_pi_state;
  *    the EXP_n values would be 1981, 2034 and 2043 if still using onl=
y
  *    11 bit fractions.
  */
-extern unsigned long avenrun[];		/* Load averages */
=20
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
@@ -115,9 +114,12 @@ extern unsigned long avenrun[];		/* Load
 #define EXP_15		2037		/* 1/exp(5sec/15min) */
=20
 #define CALC_LOAD(load,exp,n) \
-	load *=3D exp; \
-	load +=3D n*(FIXED_1-exp); \
-	load >>=3D FSHIFT;
+	{ \
+	unsigned long temp =3D load; \
+	temp *=3D exp; \
+	temp +=3D n*(FIXED_1-exp); \
+	load =3D temp >> FSHIFT; \
+	}
=20
 extern unsigned long total_forks;
 extern int nr_threads;
diff -puN include/linux/time.h~introduce-time_data-a-new-structure-to-h=
old-jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-aven=
run include/linux/time.h
--- a/include/linux/time.h~introduce-time_data-a-new-structure-to-hold-=
jiffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenrun
+++ a/include/linux/time.h
@@ -88,21 +88,44 @@ static inline struct timespec timespec_s
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >=3D 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER=
_SEC))
=20
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
+	 * in vmlinux.lds.S files (jiffies_64 =3D time_data)
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
=20
 void timekeeping_init(void);
=20
 static inline unsigned long get_seconds(void)
 {
-	return xtime.tv_sec;
+	return time_data._xtime.tv_sec;
 }
=20
 struct timespec current_kernel_time(void);
=20
 #define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { xtime.tv_sec, 0 })
+#define CURRENT_TIME_SEC	((struct timespec) { time_data._xtime.tv_sec,=
 0 })
=20
 extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(struct timespec *tv);
diff -puN kernel/timer.c~introduce-time_data-a-new-structure-to-hold-ji=
ffies-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenrun ke=
rnel/timer.c
--- a/kernel/timer.c~introduce-time_data-a-new-structure-to-hold-jiffie=
s-xtime-xtime_lock-wall_to_monotonic-calc_load_count-and-avenrun
+++ a/kernel/timer.c
@@ -41,7 +41,7 @@
 #include <asm/timex.h>
 #include <asm/io.h>
=20
-u64 jiffies_64 __cacheline_aligned_in_smp =3D INITIAL_JIFFIES;
+__attribute__((weak)) u64 jiffies_64 __cacheline_aligned_in_smp =3D IN=
ITIAL_JIFFIES;
=20
 EXPORT_SYMBOL(jiffies_64);
=20
@@ -702,10 +702,12 @@ found:
  * however, we will ALWAYS keep the tv_nsec part positive so we can us=
e
  * the usual normalization.
  */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
-
-EXPORT_SYMBOL(xtime);
+__attribute__((weak)) struct time_data time_data __cacheline_aligned =3D=
 {
+	._jiffies_64 =3D INITIAL_JIFFIES,
+	.lock =3D __SEQLOCK_UNLOCKED(time_data.lock),
+	.calc_load_count =3D LOAD_FREQ,
+};
+EXPORT_SYMBOL(time_data);
=20
=20
 /* XXX - all of this timekeeping code should be later moved to time.c =
*/
@@ -1133,9 +1135,6 @@ static unsigned long count_active_tasks(
  *
  * Requires xtime_lock to access.
  */
-unsigned long avenrun[3];
-
-EXPORT_SYMBOL(avenrun);
=20
 /*
  * calc_load - given tick count, update the avenrun load estimates.
@@ -1144,29 +1143,20 @@ EXPORT_SYMBOL(avenrun);
 static inline void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
-	static int count =3D LOAD_FREQ;
=20
-	count -=3D ticks;
-	if (unlikely(count < 0)) {
+	time_data.calc_load_count -=3D ticks;
+	if (unlikely(time_data.calc_load_count < 0)) {
 		active_tasks =3D count_active_tasks();
 		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
-			count +=3D LOAD_FREQ;
-		} while (count < 0);
+			CALC_LOAD(time_data._avenrun[0], EXP_1, active_tasks);
+			CALC_LOAD(time_data._avenrun[1], EXP_5, active_tasks);
+			CALC_LOAD(time_data._avenrun[2], EXP_15, active_tasks);
+			time_data.calc_load_count +=3D LOAD_FREQ;
+		} while (time_data.calc_load_count < 0);
 	}
 }
=20
 /*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
- */
-__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_=
lock);
-
-EXPORT_SYMBOL(xtime_lock);
-
-/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
@@ -1391,6 +1381,16 @@ asmlinkage long sys_gettid(void)
 }
=20
 /**
+ * avenrun_to_loads - convert an _avenrun[] to sysinfo.loads[]
+ * @idx: index (0..2) in time_data._avenrun[]
+ */
+static inline unsigned long avenrun_to_loads(unsigned int idx)
+{
+	unsigned long ret =3D time_data._avenrun[idx];
+	return ret << (SI_LOAD_SHIFT - FSHIFT);
+}
+
+/**
  * sys_sysinfo - fill in sysinfo struct
  * @info: pointer to buffer to fill
  */=20
@@ -1423,9 +1423,9 @@ asmlinkage long sys_sysinfo(struct sysin
 		}
 		val.uptime =3D tp.tv_sec + (tp.tv_nsec ? 1 : 0);
=20
-		val.loads[0] =3D avenrun[0] << (SI_LOAD_SHIFT - FSHIFT);
-		val.loads[1] =3D avenrun[1] << (SI_LOAD_SHIFT - FSHIFT);
-		val.loads[2] =3D avenrun[2] << (SI_LOAD_SHIFT - FSHIFT);
+		val.loads[0] =3D avenrun_to_loads(0);
+		val.loads[1] =3D avenrun_to_loads(1);
+		val.loads[2] =3D avenrun_to_loads(2);
=20
 		val.procs =3D nr_threads;
 	} while (read_seqretry(&xtime_lock, seq));
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

struct-vfsmount-keep-mnt_count-mnt_expiry_mark-away-from-mnt_flags.patc=
h
avoid-one-conditional-branch-in-touch_atime.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
