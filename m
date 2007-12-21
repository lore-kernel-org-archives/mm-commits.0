From: akpm@linux-foundation.org
Subject: + avoid-overflows-in-kernel-timec.patch added to -mm tree
Date: Thu, 20 Dec 2007 18:54:22 -0800
Message-ID: <200712210254.lBL2sMjL026326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbXLUCzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 21:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, johnstul@us.ibm.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, zippel@linux-m68k.org


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

This is exposed to the user when passing a large timeout to poll(), for
example.

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

NOTE: This patch uses a bc-based shell script to compute the appropriate
constants.  This script should be run by hand if new HZ values are created,
as doing it automatically introduces a dependency on bc, and has been shown
to be unreliable in some environments.  The flipside, unfortunately, is
that this may cause problems for "make randconfig" on MIPS and OMAP, which
appear to allow arbitrary values to be entered into CONFIG_HZ.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c       |   29 +-
 kernel/timeconst.h  |  482 ++++++++++++++++++++++++++++++++++++++++++
 kernel/timeconst.sh |  158 +++++++++++++
 3 files changed, 661 insertions(+), 8 deletions(-)

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
diff -puN /dev/null kernel/timeconst.h
--- /dev/null
+++ a/kernel/timeconst.h
@@ -0,0 +1,482 @@
+/* Automatically generated by kernel/timeconst.sh */
+
+#ifndef KERNEL_TIMECONST_H
+#define KERNEL_TIMECONST_H
+
+#include <linux/param.h>
+
+#if HZ == 24
+
+#define HZ_TO_MSEC_MUL32 0xA6AAAAAB
+#define HZ_TO_MSEC_ADJ32 0x2AAAAAA
+#define HZ_TO_MSEC_SHR32 26
+#define HZ_TO_MSEC_MUL64 0xA6AAAAAAAAAAAAAB
+#define HZ_TO_MSEC_ADJ64 0x2AAAAAAAAAAAAAA
+#define HZ_TO_MSEC_SHR64 58
+#define MSEC_TO_HZ_MUL32 0xC49BA5E4
+#define MSEC_TO_HZ_ADJ32 0x1FBE76C8B4
+#define MSEC_TO_HZ_SHR32 37
+#define MSEC_TO_HZ_MUL64 0xC49BA5E353F7CEDA
+#define MSEC_TO_HZ_ADJ64 0x1FBE76C8B439581062
+#define MSEC_TO_HZ_SHR64 69
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 3
+#define MSEC_TO_HZ_NUM 3
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xA2C2AAAB
+#define HZ_TO_USEC_ADJ32 0xAAAA
+#define HZ_TO_USEC_SHR32 16
+#define HZ_TO_USEC_MUL64 0xA2C2AAAAAAAAAAAB
+#define HZ_TO_USEC_ADJ64 0xAAAAAAAAAAAA
+#define HZ_TO_USEC_SHR64 48
+#define USEC_TO_HZ_MUL32 0xC9539B89
+#define USEC_TO_HZ_ADJ32 0x7FFFBCE4217D
+#define USEC_TO_HZ_SHR32 47
+#define USEC_TO_HZ_MUL64 0xC9539B8887229E91
+#define USEC_TO_HZ_ADJ64 0x7FFFBCE4217D2849CB25
+#define USEC_TO_HZ_SHR64 79
+#define HZ_TO_USEC_NUM 125000
+#define HZ_TO_USEC_DEN 3
+#define USEC_TO_HZ_NUM 3
+#define USEC_TO_HZ_DEN 125000
+
+#elif HZ == 32
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0x6000000
+#define HZ_TO_MSEC_SHR32 27
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0x600000000000000
+#define HZ_TO_MSEC_SHR64 59
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0xFDF3B645A
+#define MSEC_TO_HZ_SHR32 36
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0xFDF3B645A1CAC0831
+#define MSEC_TO_HZ_SHR64 68
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 4
+#define MSEC_TO_HZ_NUM 4
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 17
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 49
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0x3FFF79C842FA
+#define USEC_TO_HZ_SHR32 46
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0x3FFF79C842FA5093964A
+#define USEC_TO_HZ_SHR64 78
+#define HZ_TO_USEC_NUM 31250
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 31250
+
+#elif HZ == 48
+
+#define HZ_TO_MSEC_MUL32 0xA6AAAAAB
+#define HZ_TO_MSEC_ADJ32 0x6AAAAAA
+#define HZ_TO_MSEC_SHR32 27
+#define HZ_TO_MSEC_MUL64 0xA6AAAAAAAAAAAAAB
+#define HZ_TO_MSEC_ADJ64 0x6AAAAAAAAAAAAAA
+#define HZ_TO_MSEC_SHR64 59
+#define MSEC_TO_HZ_MUL32 0xC49BA5E4
+#define MSEC_TO_HZ_ADJ32 0xFDF3B645A
+#define MSEC_TO_HZ_SHR32 36
+#define MSEC_TO_HZ_MUL64 0xC49BA5E353F7CEDA
+#define MSEC_TO_HZ_ADJ64 0xFDF3B645A1CAC0831
+#define MSEC_TO_HZ_SHR64 68
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 6
+#define MSEC_TO_HZ_NUM 6
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xA2C2AAAB
+#define HZ_TO_USEC_ADJ32 0x15555
+#define HZ_TO_USEC_SHR32 17
+#define HZ_TO_USEC_MUL64 0xA2C2AAAAAAAAAAAB
+#define HZ_TO_USEC_ADJ64 0x1555555555555
+#define HZ_TO_USEC_SHR64 49
+#define USEC_TO_HZ_MUL32 0xC9539B89
+#define USEC_TO_HZ_ADJ32 0x3FFFBCE4217D
+#define USEC_TO_HZ_SHR32 46
+#define USEC_TO_HZ_MUL64 0xC9539B8887229E91
+#define USEC_TO_HZ_ADJ64 0x3FFFBCE4217D2849CB25
+#define USEC_TO_HZ_SHR64 78
+#define HZ_TO_USEC_NUM 62500
+#define HZ_TO_USEC_DEN 3
+#define USEC_TO_HZ_NUM 3
+#define USEC_TO_HZ_DEN 62500
+
+#elif HZ == 64
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0xE000000
+#define HZ_TO_MSEC_SHR32 28
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0xE00000000000000
+#define HZ_TO_MSEC_SHR64 60
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0x7EF9DB22D
+#define MSEC_TO_HZ_SHR32 35
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0x7EF9DB22D0E560418
+#define MSEC_TO_HZ_SHR64 67
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 8
+#define MSEC_TO_HZ_NUM 8
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 18
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 50
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0x1FFF79C842FA
+#define USEC_TO_HZ_SHR32 45
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0x1FFF79C842FA5093964A
+#define USEC_TO_HZ_SHR64 77
+#define HZ_TO_USEC_NUM 15625
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 15625
+
+#elif HZ == 100
+
+#define HZ_TO_MSEC_MUL32 0xA0000000
+#define HZ_TO_MSEC_ADJ32 0x0
+#define HZ_TO_MSEC_SHR32 28
+#define HZ_TO_MSEC_MUL64 0xA000000000000000
+#define HZ_TO_MSEC_ADJ64 0x0
+#define HZ_TO_MSEC_SHR64 60
+#define MSEC_TO_HZ_MUL32 0xCCCCCCCD
+#define MSEC_TO_HZ_ADJ32 0x733333333
+#define MSEC_TO_HZ_SHR32 35
+#define MSEC_TO_HZ_MUL64 0xCCCCCCCCCCCCCCCD
+#define MSEC_TO_HZ_ADJ64 0x73333333333333333
+#define MSEC_TO_HZ_SHR64 67
+#define HZ_TO_MSEC_NUM 10
+#define HZ_TO_MSEC_DEN 1
+#define MSEC_TO_HZ_NUM 1
+#define MSEC_TO_HZ_DEN 10
+
+#define HZ_TO_USEC_MUL32 0x9C400000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 18
+#define HZ_TO_USEC_MUL64 0x9C40000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 50
+#define USEC_TO_HZ_MUL32 0xD1B71759
+#define USEC_TO_HZ_ADJ32 0x1FFF2E48E8A7
+#define USEC_TO_HZ_SHR32 45
+#define USEC_TO_HZ_MUL64 0xD1B71758E219652C
+#define USEC_TO_HZ_ADJ64 0x1FFF2E48E8A71DE69AD4
+#define USEC_TO_HZ_SHR64 77
+#define HZ_TO_USEC_NUM 10000
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 10000
+
+#elif HZ == 128
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0x1E000000
+#define HZ_TO_MSEC_SHR32 29
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0x1E00000000000000
+#define HZ_TO_MSEC_SHR64 61
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0x3F7CED916
+#define MSEC_TO_HZ_SHR32 34
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0x3F7CED916872B020C
+#define MSEC_TO_HZ_SHR64 66
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 16
+#define MSEC_TO_HZ_NUM 16
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0x40000
+#define HZ_TO_USEC_SHR32 19
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0x4000000000000
+#define HZ_TO_USEC_SHR64 51
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0xFFFBCE4217D
+#define USEC_TO_HZ_SHR32 44
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0xFFFBCE4217D2849CB25
+#define USEC_TO_HZ_SHR64 76
+#define HZ_TO_USEC_NUM 15625
+#define HZ_TO_USEC_DEN 2
+#define USEC_TO_HZ_NUM 2
+#define USEC_TO_HZ_DEN 15625
+
+#elif HZ == 200
+
+#define HZ_TO_MSEC_MUL32 0xA0000000
+#define HZ_TO_MSEC_ADJ32 0x0
+#define HZ_TO_MSEC_SHR32 29
+#define HZ_TO_MSEC_MUL64 0xA000000000000000
+#define HZ_TO_MSEC_ADJ64 0x0
+#define HZ_TO_MSEC_SHR64 61
+#define MSEC_TO_HZ_MUL32 0xCCCCCCCD
+#define MSEC_TO_HZ_ADJ32 0x333333333
+#define MSEC_TO_HZ_SHR32 34
+#define MSEC_TO_HZ_MUL64 0xCCCCCCCCCCCCCCCD
+#define MSEC_TO_HZ_ADJ64 0x33333333333333333
+#define MSEC_TO_HZ_SHR64 66
+#define HZ_TO_MSEC_NUM 5
+#define HZ_TO_MSEC_DEN 1
+#define MSEC_TO_HZ_NUM 1
+#define MSEC_TO_HZ_DEN 5
+
+#define HZ_TO_USEC_MUL32 0x9C400000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 19
+#define HZ_TO_USEC_MUL64 0x9C40000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 51
+#define USEC_TO_HZ_MUL32 0xD1B71759
+#define USEC_TO_HZ_ADJ32 0xFFF2E48E8A7
+#define USEC_TO_HZ_SHR32 44
+#define USEC_TO_HZ_MUL64 0xD1B71758E219652C
+#define USEC_TO_HZ_ADJ64 0xFFF2E48E8A71DE69AD4
+#define USEC_TO_HZ_SHR64 76
+#define HZ_TO_USEC_NUM 5000
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 5000
+
+#elif HZ == 250
+
+#define HZ_TO_MSEC_MUL32 0x80000000
+#define HZ_TO_MSEC_ADJ32 0x0
+#define HZ_TO_MSEC_SHR32 29
+#define HZ_TO_MSEC_MUL64 0x8000000000000000
+#define HZ_TO_MSEC_ADJ64 0x0
+#define HZ_TO_MSEC_SHR64 61
+#define MSEC_TO_HZ_MUL32 0x80000000
+#define MSEC_TO_HZ_ADJ32 0x180000000
+#define MSEC_TO_HZ_SHR32 33
+#define MSEC_TO_HZ_MUL64 0x8000000000000000
+#define MSEC_TO_HZ_ADJ64 0x18000000000000000
+#define MSEC_TO_HZ_SHR64 65
+#define HZ_TO_MSEC_NUM 4
+#define HZ_TO_MSEC_DEN 1
+#define MSEC_TO_HZ_NUM 1
+#define MSEC_TO_HZ_DEN 4
+
+#define HZ_TO_USEC_MUL32 0xFA000000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 20
+#define HZ_TO_USEC_MUL64 0xFA00000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 52
+#define USEC_TO_HZ_MUL32 0x83126E98
+#define USEC_TO_HZ_ADJ32 0x7FF7CED9168
+#define USEC_TO_HZ_SHR32 43
+#define USEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define USEC_TO_HZ_ADJ64 0x7FF7CED916872B020C4
+#define USEC_TO_HZ_SHR64 75
+#define HZ_TO_USEC_NUM 4000
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 4000
+
+#elif HZ == 256
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0x3E000000
+#define HZ_TO_MSEC_SHR32 30
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0x3E00000000000000
+#define HZ_TO_MSEC_SHR64 62
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0x1FBE76C8B
+#define MSEC_TO_HZ_SHR32 33
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0x1FBE76C8B43958106
+#define MSEC_TO_HZ_SHR64 65
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 32
+#define MSEC_TO_HZ_NUM 32
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0xC0000
+#define HZ_TO_USEC_SHR32 20
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0xC000000000000
+#define HZ_TO_USEC_SHR64 52
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0x7FFDE7210BE
+#define USEC_TO_HZ_SHR32 43
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0x7FFDE7210BE9424E592
+#define USEC_TO_HZ_SHR64 75
+#define HZ_TO_USEC_NUM 15625
+#define HZ_TO_USEC_DEN 4
+#define USEC_TO_HZ_NUM 4
+#define USEC_TO_HZ_DEN 15625
+
+#elif HZ == 300
+
+#define HZ_TO_MSEC_MUL32 0xD5555556
+#define HZ_TO_MSEC_ADJ32 0x2AAAAAAA
+#define HZ_TO_MSEC_SHR32 30
+#define HZ_TO_MSEC_MUL64 0xD555555555555556
+#define HZ_TO_MSEC_ADJ64 0x2AAAAAAAAAAAAAAA
+#define HZ_TO_MSEC_SHR64 62
+#define MSEC_TO_HZ_MUL32 0x9999999A
+#define MSEC_TO_HZ_ADJ32 0x1CCCCCCCC
+#define MSEC_TO_HZ_SHR32 33
+#define MSEC_TO_HZ_MUL64 0x999999999999999A
+#define MSEC_TO_HZ_ADJ64 0x1CCCCCCCCCCCCCCCC
+#define MSEC_TO_HZ_SHR64 65
+#define HZ_TO_MSEC_NUM 10
+#define HZ_TO_MSEC_DEN 3
+#define MSEC_TO_HZ_NUM 3
+#define MSEC_TO_HZ_DEN 10
+
+#define HZ_TO_USEC_MUL32 0xD0555556
+#define HZ_TO_USEC_ADJ32 0xAAAAA
+#define HZ_TO_USEC_SHR32 20
+#define HZ_TO_USEC_MUL64 0xD055555555555556
+#define HZ_TO_USEC_ADJ64 0xAAAAAAAAAAAAA
+#define HZ_TO_USEC_SHR64 52
+#define USEC_TO_HZ_MUL32 0x9D495183
+#define USEC_TO_HZ_ADJ32 0x7FFCB923A29
+#define USEC_TO_HZ_SHR32 43
+#define USEC_TO_HZ_MUL64 0x9D495182A9930BE1
+#define USEC_TO_HZ_ADJ64 0x7FFCB923A29C779A6B5
+#define USEC_TO_HZ_SHR64 75
+#define HZ_TO_USEC_NUM 10000
+#define HZ_TO_USEC_DEN 3
+#define USEC_TO_HZ_NUM 3
+#define USEC_TO_HZ_DEN 10000
+
+#elif HZ == 512
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0x7E000000
+#define HZ_TO_MSEC_SHR32 31
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0x7E00000000000000
+#define HZ_TO_MSEC_SHR64 63
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0xFDF3B645
+#define MSEC_TO_HZ_SHR32 32
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0xFDF3B645A1CAC083
+#define MSEC_TO_HZ_SHR64 64
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 64
+#define MSEC_TO_HZ_NUM 64
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0x1C0000
+#define HZ_TO_USEC_SHR32 21
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0x1C000000000000
+#define HZ_TO_USEC_SHR64 53
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0x3FFEF39085F
+#define USEC_TO_HZ_SHR32 42
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0x3FFEF39085F4A1272C9
+#define USEC_TO_HZ_SHR64 74
+#define HZ_TO_USEC_NUM 15625
+#define HZ_TO_USEC_DEN 8
+#define USEC_TO_HZ_NUM 8
+#define USEC_TO_HZ_DEN 15625
+
+#elif HZ == 1000
+
+#define HZ_TO_MSEC_MUL32 0x80000000
+#define HZ_TO_MSEC_ADJ32 0x0
+#define HZ_TO_MSEC_SHR32 31
+#define HZ_TO_MSEC_MUL64 0x8000000000000000
+#define HZ_TO_MSEC_ADJ64 0x0
+#define HZ_TO_MSEC_SHR64 63
+#define MSEC_TO_HZ_MUL32 0x80000000
+#define MSEC_TO_HZ_ADJ32 0x0
+#define MSEC_TO_HZ_SHR32 31
+#define MSEC_TO_HZ_MUL64 0x8000000000000000
+#define MSEC_TO_HZ_ADJ64 0x0
+#define MSEC_TO_HZ_SHR64 63
+#define HZ_TO_MSEC_NUM 1
+#define HZ_TO_MSEC_DEN 1
+#define MSEC_TO_HZ_NUM 1
+#define MSEC_TO_HZ_DEN 1
+
+#define HZ_TO_USEC_MUL32 0xFA000000
+#define HZ_TO_USEC_ADJ32 0x0
+#define HZ_TO_USEC_SHR32 22
+#define HZ_TO_USEC_MUL64 0xFA00000000000000
+#define HZ_TO_USEC_ADJ64 0x0
+#define HZ_TO_USEC_SHR64 54
+#define USEC_TO_HZ_MUL32 0x83126E98
+#define USEC_TO_HZ_ADJ32 0x1FF7CED9168
+#define USEC_TO_HZ_SHR32 41
+#define USEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define USEC_TO_HZ_ADJ64 0x1FF7CED916872B020C4
+#define USEC_TO_HZ_SHR64 73
+#define HZ_TO_USEC_NUM 1000
+#define HZ_TO_USEC_DEN 1
+#define USEC_TO_HZ_NUM 1
+#define USEC_TO_HZ_DEN 1000
+
+#elif HZ == 1024
+
+#define HZ_TO_MSEC_MUL32 0xFA000000
+#define HZ_TO_MSEC_ADJ32 0xFE000000
+#define HZ_TO_MSEC_SHR32 32
+#define HZ_TO_MSEC_MUL64 0xFA00000000000000
+#define HZ_TO_MSEC_ADJ64 0xFE00000000000000
+#define HZ_TO_MSEC_SHR64 64
+#define MSEC_TO_HZ_MUL32 0x83126E98
+#define MSEC_TO_HZ_ADJ32 0x7EF9DB22
+#define MSEC_TO_HZ_SHR32 31
+#define MSEC_TO_HZ_MUL64 0x83126E978D4FDF3C
+#define MSEC_TO_HZ_ADJ64 0x7EF9DB22D0E56041
+#define MSEC_TO_HZ_SHR64 63
+#define HZ_TO_MSEC_NUM 125
+#define HZ_TO_MSEC_DEN 128
+#define MSEC_TO_HZ_NUM 128
+#define MSEC_TO_HZ_DEN 125
+
+#define HZ_TO_USEC_MUL32 0xF4240000
+#define HZ_TO_USEC_ADJ32 0x3C0000
+#define HZ_TO_USEC_SHR32 22
+#define HZ_TO_USEC_MUL64 0xF424000000000000
+#define HZ_TO_USEC_ADJ64 0x3C000000000000
+#define HZ_TO_USEC_SHR64 54
+#define USEC_TO_HZ_MUL32 0x8637BD06
+#define USEC_TO_HZ_ADJ32 0x1FFF79C842F
+#define USEC_TO_HZ_SHR32 41
+#define USEC_TO_HZ_MUL64 0x8637BD05AF6C69B6
+#define USEC_TO_HZ_ADJ64 0x1FFF79C842FA5093964
+#define USEC_TO_HZ_SHR64 73
+#define HZ_TO_USEC_NUM 15625
+#define HZ_TO_USEC_DEN 16
+#define USEC_TO_HZ_NUM 16
+#define USEC_TO_HZ_DEN 15625
+
+#else
+
+#error "Update kernel/timeconst.h for your value of HZ"
+
+#endif /* HZ */
+
+#endif /* KERNEL_TIMECONST_H */
diff -puN /dev/null kernel/timeconst.sh
--- /dev/null
+++ a/kernel/timeconst.sh
@@ -0,0 +1,158 @@
+#!/bin/sh
+#
+# Script to generate kernel/timeconst.h.
+# Requires a working GNU bc on the system.
+#
+# This script needs to be done manually if new HZ values are
+# created.
+#
+
+# kernel/Kconfig.hz defines 100, 250, 300, and 1000.
+# arch/mips/Kconfig adds 48, 128, 256, and 1024 (and "arbitrary"...)
+# arch/arm/Kconfig adds 128 and 200.
+# arch/arm/plat-omap/Kconfig adds 32, 64, 128, 256, 512 and 1024.
+# include/asm-alpha/param.h adds 1024.
+# include/asm-ia64/param.h adds 32.
+# include/asm-v850/sim*.h adds 24.
+HZ_LIST='24 32 48 64 100 128 200 250 256 300 512 1000 1024'
+
+echo '/* Automatically generated by kernel/timeconst.sh */'
+echo ''
+echo '#ifndef KERNEL_TIMECONST_H'
+echo '#define KERNEL_TIMECONST_H'
+echo ''
+echo '#include <linux/param.h>'
+echo ''
+
+my_if='#if'
+
+for h in $HZ_LIST; do
+    echo "$my_if HZ == $h"
+    bc -q <<EOF
+hz=$h
+scale=0
+
+define gcd(a,b) {
+	auto t;
+	while (b) {
+		t = b;
+		b = a % b;
+		a = t;
+	}
+	return(a);
+}
+
+/* Division by reciprocal multiplication. */
+define fmul(b,n,d) {
+       return((2^b*n+d-1)/d);
+}
+
+/* Adjustment factor when a ceiling value is used.  Use as:
+   (imul * n) + (fmulxx * n + fadjxx) >> xx) */
+define fadj(b,n,d) {
+	auto v;
+	d = d/gcd(n,d);
+	v = 2^b*(d-1)/d;
+	return(v);
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
+			return(s);
+	}
+	return(0);
+}
+
+print "\n"
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
+quit
+EOF
+my_if='#elif'
+done
+
+echo '#else'
+echo ''
+echo '#error "Update kernel/timeconst.h for your value of HZ"'
+echo ''
+echo '#endif /* HZ */'
+echo ''
+echo '#endif /* KERNEL_TIMECONST_H */'
_

Patches currently in -mm which might be from hpa@zytor.com are

git-kvm.patch
git-sh.patch
git-x86.patch
drivers-char-tty_ioc-remove-pty_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
avoid-overflows-in-kernel-timec.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
