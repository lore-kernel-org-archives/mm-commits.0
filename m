From: akpm@linux-foundation.org
Subject: + avoid-overflows-in-kernel-timec.patch added to -mm tree
Date: Thu, 29 Nov 2007 17:54:55 -0800
Message-ID: <200711300154.lAU1stGq018094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759739AbXK3Bzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 20:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Avoid overflows in kernel/time.c
has been added to the -mm tree.  Its filename is
     avoid-overflows-in-kernel-timec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid overflows in kernel/time.c
From: "H. Peter Anvin" <hpa@zytor.com>

When the conversion factor between jiffies and milli- or microseconds is
not a single multiply or divide, as for the case of HZ == 300, we currently
do a multiply followed by a divide.  The intervening result, however, is
subject to overflows, especially since the fraction is not simplified (for
HZ == 300, we multiply by 300 and divide by 1000).

This is exposed to the user when passing a large timeout to poll(),
for example.

This patch replaces the multiply-divide with a reciprocal multiplication on
32-bit platforms.  When the input is an unsigned long, there is no portable
way to do this on 64-bit platforms there is no portable way to do this
since it requires a 128-bit intermediate result (which gcc does support on
64-bit platforms but may generate libgcc calls, e.g.  on 64-bit s390), but
since the output is a 32-bit integer in the cases affected, just simplify
the multiply-divide (*3/10 instead of *300/1000).

The reciprocal multiply used can have off-by-one errors in the upper half
of the valid output range.  This could be avoided at the expense of having
to deal with a potential 65-bit intermediate result.  Since the intent is
to avoid overflow problems and most of the other time conversions are only
semiexact, the off-by-one errors were considered an acceptable tradeoff.

NOTE: This patch uses a bc(1) script to compute the appropriate
constants.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile     |    8 ++
 kernel/time.c       |   29 +++++++--
 kernel/timeconst.bc |  123 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 8 deletions(-)

diff -puN kernel/Makefile~avoid-overflows-in-kernel-timec kernel/Makefile
--- a/kernel/Makefile~avoid-overflows-in-kernel-timec
+++ a/kernel/Makefile
@@ -80,3 +80,11 @@ quiet_cmd_ikconfiggz = IKCFG   $@
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call if_changed,ikconfiggz)
+
+$(obj)/time.o: $(obj)/timeconst.h
+
+quiet_cmd_timeconst  = BC      $@
+      cmd_timeconst = (echo $(CONFIG_HZ) | bc -q $<) > $@
+targets += timeconst.h
+$(obj)/timeconst.h: $(src)/timeconst.bc $(wildcard include/config/hz.h) FORCE
+	$(call if_changed,timeconst)
diff -puN kernel/time.c~avoid-overflows-in-kernel-timec kernel/time.c
--- a/kernel/time.c~avoid-overflows-in-kernel-timec
+++ a/kernel/time.c
@@ -39,6 +39,8 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
+#include "timeconst.h"
+
 /*
  * The timezone where the local system is located.  Used as a default by some
  * programs who obtain this value by using gettimeofday.
@@ -93,7 +95,8 @@ asmlinkage long sys_stime(time_t __user 
 
 #endif /* __ARCH_WANT_SYS_TIME */
 
-asmlinkage long sys_gettimeofday(struct timeval __user *tv, struct timezone __user *tz)
+asmlinkage long sys_gettimeofday(struct timeval __user *tv,
+				 struct timezone __user *tz)
 {
 	if (likely(tv != NULL)) {
 		struct timeval ktv;
@@ -118,7 +121,7 @@ asmlinkage long sys_gettimeofday(struct 
  * hard to make the program warp the clock precisely n hours)  or
  * compile in the timezone information into the kernel.  Bad, bad....
  *
- *              				- TYT, 1992-01-01
+ *						- TYT, 1992-01-01
  *
  * The best thing to do is to keep the CMOS clock in universal time (UTC)
  * as real UNIX machines always do it. This avoids all headaches about
@@ -239,7 +242,11 @@ unsigned int inline jiffies_to_msecs(con
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
 	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
 #else
-	return (j * MSEC_PER_SEC) / HZ;
+# if BITS_PER_LONG == 32
+	return ((u64)HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+# else
+	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
+# endif
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
@@ -251,7 +258,11 @@ unsigned int inline jiffies_to_usecs(con
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
-	return (j * USEC_PER_SEC) / HZ;
+# if BITS_PER_LONG == 32
+	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+# else
+	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
+# endif
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
@@ -351,7 +362,7 @@ EXPORT_SYMBOL(mktime);
  * normalize to the timespec storage format
  *
  * Note: The tv_nsec part is always in the range of
- * 	0 <= tv_nsec < NSEC_PER_SEC
+ *	0 <= tv_nsec < NSEC_PER_SEC
  * For negative values only the tv_sec field is negative !
  */
 void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec)
@@ -452,12 +463,13 @@ unsigned long msecs_to_jiffies(const uns
 	/*
 	 * Generic case - multiply, round and divide. But first
 	 * check that if we are doing a net multiplication, that
-	 * we wouldnt overflow:
+	 * we wouldn't overflow:
 	 */
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
+	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+		>> MSEC_TO_HZ_SHR32;
 #endif
 }
 EXPORT_SYMBOL(msecs_to_jiffies);
@@ -471,7 +483,8 @@ unsigned long usecs_to_jiffies(const uns
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return (u * HZ + USEC_PER_SEC - 1) / USEC_PER_SEC;
+	return ((u64)USEC_TO_HZ_MUL32 * m + USEC_TO_HZ_ADJ32)
+		>> USEC_TO_HZ_SHR32;
 #endif
 }
 EXPORT_SYMBOL(usecs_to_jiffies);
diff -puN /dev/null kernel/timeconst.bc
--- /dev/null
+++ a/kernel/timeconst.bc
@@ -0,0 +1,123 @@
+hz=read()
+scale=0
+
+define gcd(a,b) {
+	auto t;
+	while (b) {
+		t = b;
+		b = a % b;
+		a = t;
+	}
+	return a;
+}
+
+/* Division by reciprocal multiplication. */
+define fmul(b,n,d) {
+       return (2^b*n+d-1)/d;
+}
+
+/* Adjustment factor when a ceiling value is used.  Use as:
+   (imul * n) + (fmulxx * n + fadjxx) >> xx) */
+define fadj(b,n,d) {
+	auto v;
+	d = d/gcd(n,d);
+	v = 2^b*(d-1)/d;
+	return v;
+}
+
+/* Compute the appropriate mul/adj values as well as a shift count,
+   which brings the mul value into the range 2^b-1 <= x < 2^b.  Such
+   a shift value will be correct in the signed integer range and off
+   by at most one in the upper half of the unsigned range. */
+define fmuls(b,n,d) {
+	auto s, m;
+	for (s = 0; 1; s++) {
+		m = fmul(s,n,d);
+		if (m >= 2^(b-1))
+			return s;
+	}
+	return 0;
+}
+
+print "/* Automatically generated from timeconst.bc */\n"
+print "/* Time conversion constants for HZ == ", hz, " */\n"
+print "\n"
+
+print "#ifndef KERNEL_TIMECONST_H\n"
+print "#define KERNEL_TIMECONST_H\n\n"
+
+s=fmuls(32,1000,hz)
+obase=16
+print "#define HZ_TO_MSEC_MUL32 0x", fmul(s,1000,hz), "\n"
+print "#define HZ_TO_MSEC_ADJ32 0x", fadj(s,1000,hz), "\n"
+obase=10
+print "#define HZ_TO_MSEC_SHR32 ", s, "\n"
+
+s=fmuls(64,1000,hz)
+obase=16
+print "#define HZ_TO_MSEC_MUL64 0x", fmul(s,1000,hz), "\n"
+print "#define HZ_TO_MSEC_ADJ64 0x", fadj(s,1000,hz), "\n"
+obase=10
+print "#define HZ_TO_MSEC_SHR64 ", s, "\n"
+
+s=fmuls(32,hz,1000)
+obase=16
+print "#define MSEC_TO_HZ_MUL32 0x", fmul(s,hz,1000), "\n"
+print "#define MSEC_TO_HZ_ADJ32 0x", fadj(s,hz,1000), "\n"
+obase=10
+print "#define MSEC_TO_HZ_SHR32 ", s, "\n"
+
+s=fmuls(64,hz,1000)
+obase=16
+print "#define MSEC_TO_HZ_MUL64 0x", fmul(s,hz,1000), "\n"
+print "#define MSEC_TO_HZ_ADJ64 0x", fadj(s,hz,1000), "\n"
+obase=10
+print "#define MSEC_TO_HZ_SHR64 ", s, "\n"
+
+obase=10
+cd=gcd(hz,1000)
+print "#define HZ_TO_MSEC_NUM ", 1000/cd, "\n"
+print "#define HZ_TO_MSEC_DEN ", hz/cd, "\n"
+print "#define MSEC_TO_HZ_NUM ", hz/cd, "\n"
+print "#define MSEC_TO_HZ_DEN ", 1000/cd, "\n"
+print "\n"
+
+s=fmuls(32,1000000,hz)
+obase=16
+print "#define HZ_TO_USEC_MUL32 0x", fmul(s,1000000,hz), "\n"
+print "#define HZ_TO_USEC_ADJ32 0x", fadj(s,1000000,hz), "\n"
+obase=10
+print "#define HZ_TO_USEC_SHR32 ", s, "\n"
+
+s=fmuls(64,1000000,hz)
+obase=16
+print "#define HZ_TO_USEC_MUL64 0x", fmul(s,1000000,hz), "\n"
+print "#define HZ_TO_USEC_ADJ64 0x", fadj(s,1000000,hz), "\n"
+obase=10
+print "#define HZ_TO_USEC_SHR64 ", s, "\n"
+
+s=fmuls(32,hz,1000000)
+obase=16
+print "#define USEC_TO_HZ_MUL32 0x", fmul(s,hz,1000000), "\n"
+print "#define USEC_TO_HZ_ADJ32 0x", fadj(s,hz,1000000), "\n"
+obase=10
+print "#define USEC_TO_HZ_SHR32 ", s, "\n"
+
+s=fmuls(64,hz,1000000)
+obase=16
+print "#define USEC_TO_HZ_MUL64 0x", fmul(s,hz,1000000), "\n"
+print "#define USEC_TO_HZ_ADJ64 0x", fadj(s,hz,1000000), "\n"
+obase=10
+print "#define USEC_TO_HZ_SHR64 ", s, "\n"
+
+obase=10
+cd=gcd(hz,1000000)
+print "#define HZ_TO_USEC_NUM ", 1000000/cd, "\n"
+print "#define HZ_TO_USEC_DEN ", hz/cd, "\n"
+print "#define USEC_TO_HZ_NUM ", hz/cd, "\n"
+print "#define USEC_TO_HZ_DEN ", 1000000/cd, "\n"
+print "\n"
+
+print "#endif\n"
+
+halt
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
git-kvm.patch
git-x86.patch
git-newsetup.patch
avoid-overflows-in-kernel-timec.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
