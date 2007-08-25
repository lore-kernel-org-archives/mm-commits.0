From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch removed from -mm tree
Date: Fri, 24 Aug 2007 22:18:49 -0700
Message-ID: <200708250518.l7P5InaV031911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbXHYFTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 25 Aug 2007 01:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     statistics infrastructure: convert printk_clock() into timestamp_clock()
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: statistics infrastructure: convert printk_clock() into timestamp_clock()
From: Martin Peschke <mp3@de.ibm.com>

This patch makes printk_clock() a generic kernel-wide nsec-resolution
timestamp_clock().  It's used both by printk() as well as the statistics
infrastructure to provide unified time stamps to users.

[jikos@jikos.cz: Rename forgotten occurence of ia64_printk_clock to ia64_timestamp_clock]
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Jiri Kosina <jikos@jikos.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c    |    4 ++--
 arch/ia64/kernel/time.c     |   15 ++++++++-------
 arch/ia64/sn/kernel/setup.c |    6 +++---
 include/linux/time.h        |    3 +++
 kernel/printk.c             |    7 +------
 kernel/time.c               |    5 +++++
 6 files changed, 22 insertions(+), 18 deletions(-)

diff -puN arch/ia64/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/arch/ia64/kernel/setup.c
@@ -71,7 +71,7 @@ unsigned long __per_cpu_offset[NR_CPUS];
 EXPORT_SYMBOL(__per_cpu_offset);
 #endif
 
-extern void ia64_setup_printk_clock(void);
+extern void ia64_setup_timestamp_clock(void);
 
 DEFINE_PER_CPU(struct cpuinfo_ia64, cpu_info);
 DEFINE_PER_CPU(unsigned long, local_per_cpu_offset);
@@ -521,7 +521,7 @@ setup_arch (char **cmdline_p)
 	/* process SAL system table: */
 	ia64_sal_init(__va(efi.sal_systab));
 
-	ia64_setup_printk_clock();
+	ia64_setup_timestamp_clock();
 
 #ifdef CONFIG_SMP
 	cpu_physical_id(0) = hard_smp_processor_id();
diff -puN arch/ia64/kernel/time.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/arch/ia64/kernel/time.c
@@ -282,29 +282,30 @@ udelay (unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
-static unsigned long long ia64_itc_printk_clock(void)
+static unsigned long long ia64_itc_timestamp_clock(void)
 {
 	if (ia64_get_kr(IA64_KR_PER_CPU_DATA))
 		return sched_clock();
 	return 0;
 }
 
-static unsigned long long ia64_default_printk_clock(void)
+static unsigned long long ia64_default_timestamp_clock(void)
 {
 	return (unsigned long long)(jiffies_64 - INITIAL_JIFFIES) *
 		(1000000000/HZ);
 }
 
-unsigned long long (*ia64_printk_clock)(void) = &ia64_default_printk_clock;
+unsigned long long (*ia64_timestamp_clock)(void) =
+						&ia64_default_timestamp_clock;
 
-unsigned long long printk_clock(void)
+unsigned long long timestamp_clock(void)
 {
-	return ia64_printk_clock();
+	return ia64_timestamp_clock();
 }
 
 void __init
-ia64_setup_printk_clock(void)
+ia64_setup_timestamp_clock(void)
 {
 	if (!(sal_platform_features & IA64_SAL_PLATFORM_FEATURE_ITC_DRIFT))
-		ia64_printk_clock = ia64_itc_printk_clock;
+		ia64_timestamp_clock = ia64_itc_timestamp_clock;
 }
diff -puN arch/ia64/sn/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/arch/ia64/sn/kernel/setup.c
@@ -65,7 +65,7 @@ extern void sn_timer_init(void);
 extern unsigned long last_time_offset;
 extern void (*ia64_mark_idle) (int);
 extern void snidle(int);
-extern unsigned long long (*ia64_printk_clock)(void);
+extern unsigned long long (*ia64_timestamp_clock)(void);
 
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
@@ -361,7 +361,7 @@ sn_scan_pcdp(void)
 
 static unsigned long sn2_rtc_initial;
 
-static unsigned long long ia64_sn2_printk_clock(void)
+static unsigned long long ia64_sn2_timestamp_clock(void)
 {
 	unsigned long rtc_now = rtc_time();
 
@@ -469,7 +469,7 @@ void __init sn_setup(char **cmdline_p)
 
 	platform_intr_list[ACPI_INTERRUPT_CPEI] = IA64_CPE_VECTOR;
 
-	ia64_printk_clock = ia64_sn2_printk_clock;
+	ia64_timestamp_clock = ia64_sn2_timestamp_clock;
 
 	printk("SGI SAL version %x.%02x\n", version >> 8, version & 0x00FF);
 
diff -puN include/linux/time.h~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution include/linux/time.h
--- a/include/linux/time.h~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/include/linux/time.h
@@ -178,6 +178,9 @@ static inline void timespec_add_ns(struc
 	}
 	a->tv_nsec = ns;
 }
+
+extern unsigned long long timestamp_clock(void);
+
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
diff -puN kernel/printk.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution kernel/printk.c
--- a/kernel/printk.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/kernel/printk.c
@@ -461,11 +461,6 @@ static int __init printk_time_setup(char
 
 __setup("time", printk_time_setup);
 
-__attribute__((weak)) unsigned long long printk_clock(void)
-{
-	return sched_clock();
-}
-
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -559,7 +554,7 @@ asmlinkage int vprintk(const char *fmt, 
 			if (printk_time) {
 				char tbuf[TIMESTAMP_SIZE], *tp;
 				printed_len += nsec_to_timestamp(tbuf,
-							printk_clock());
+							timestamp_clock());
 				for (tp = tbuf; *tp; tp++)
 					emit_log_char(*tp);
 				emit_log_char(' ');
diff -puN kernel/time.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution kernel/time.c
--- a/kernel/time.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution
+++ a/kernel/time.c
@@ -727,6 +727,11 @@ u64 nsec_to_clock_t(u64 x)
 	return x;
 }
 
+__attribute__((weak)) unsigned long long timestamp_clock(void)
+{
+	return sched_clock();
+}
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
_

Patches currently in -mm which might be from mp3@de.ibm.com are
