From: akpm@linux-foundation.org
Subject: - convert-a-few-do_div-user.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:51 -0700
Message-ID: <200805021941.m42JfplB011119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416AbYEBTrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     convert a few do_div users
has been removed from the -mm tree.  Its filename was
     convert-a-few-do_div-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: convert a few do_div users
From: Roman Zippel <zippel@linux-m68k.org>

This converts a few users of do_div to div_[su]64 and this demonstrates nicely
how it can reduce some expressions to one-liners.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c     |   29 +++++++++--------------------
 kernel/time/ntp.c |   25 ++++++-------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

diff -puN kernel/time.c~convert-a-few-do_div-user kernel/time.c
--- a/kernel/time.c~convert-a-few-do_div-user
+++ a/kernel/time.c
@@ -36,6 +36,7 @@
 #include <linux/security.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/math64.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -587,9 +588,7 @@ clock_t jiffies_to_clock_t(long x)
 	return x / (HZ / USER_HZ);
 # endif
 #else
-	u64 tmp = (u64)x * TICK_NSEC;
-	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
-	return (long)tmp;
+	return div_u64((u64)x * TICK_NSEC, NSEC_PER_SEC / USER_HZ);
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_clock_t);
@@ -601,16 +600,12 @@ unsigned long clock_t_to_jiffies(unsigne
 		return ~0UL;
 	return x * (HZ / USER_HZ);
 #else
-	u64 jif;
-
 	/* Don't worry about loss of precision here .. */
 	if (x >= ~0UL / HZ * USER_HZ)
 		return ~0UL;
 
 	/* .. but do try to contain it here */
-	jif = x * (u64) HZ;
-	do_div(jif, USER_HZ);
-	return jif;
+	return div_u64((u64)x * HZ, USER_HZ);
 #endif
 }
 EXPORT_SYMBOL(clock_t_to_jiffies);
@@ -619,10 +614,9 @@ u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-	x *= USER_HZ;
-	do_div(x, HZ);
+	x = div_u64(x * USER_HZ, HZ);
 # elif HZ > USER_HZ
-	do_div(x, HZ / USER_HZ);
+	x = div_u64(x, HZ / USER_HZ);
 # else
 	/* Nothing to do */
 # endif
@@ -632,8 +626,7 @@ u64 jiffies_64_to_clock_t(u64 x)
 	 * but even this doesn't overflow in hundreds of years
 	 * in 64 bits, so..
 	 */
-	x *= TICK_NSEC;
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
+	x = div_u64(x * TICK_NSEC, (NSEC_PER_SEC / USER_HZ));
 #endif
 	return x;
 }
@@ -642,21 +635,17 @@ EXPORT_SYMBOL(jiffies_64_to_clock_t);
 u64 nsec_to_clock_t(u64 x)
 {
 #if (NSEC_PER_SEC % USER_HZ) == 0
-	do_div(x, (NSEC_PER_SEC / USER_HZ));
+	return div_u64(x, NSEC_PER_SEC / USER_HZ);
 #elif (USER_HZ % 512) == 0
-	x *= USER_HZ/512;
-	do_div(x, (NSEC_PER_SEC / 512));
+	return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
 #else
 	/*
          * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
          * overflow after 64.99 years.
          * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
          */
-	x *= 9;
-	do_div(x, (unsigned long)((9ull * NSEC_PER_SEC + (USER_HZ/2)) /
-				  USER_HZ));
+	return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
 #endif
-	return x;
 }
 
 #if (BITS_PER_LONG < 64)
diff -puN kernel/time/ntp.c~convert-a-few-do_div-user kernel/time/ntp.c
--- a/kernel/time/ntp.c~convert-a-few-do_div-user
+++ a/kernel/time/ntp.c
@@ -15,7 +15,7 @@
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
-#include <asm/div64.h>
+#include <linux/math64.h>
 #include <asm/timex.h>
 
 /*
@@ -53,10 +53,8 @@ static void ntp_update_frequency(void)
 
 	tick_length_base = second_length;
 
-	do_div(second_length, HZ);
-	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
-
-	do_div(tick_length_base, NTP_INTERVAL_FREQ);
+	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
+	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -237,7 +235,7 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	long mtemp, save_adjust, rem;
-	s64 freq_adj, temp64;
+	s64 freq_adj;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -342,19 +340,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-			u64 utemp64;
-			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
-			if (time_offset < 0) {
-			    utemp64 = -temp64;
-			    do_div(utemp64, mtemp);
-			    freq_adj -= utemp64;
-			} else {
-			    utemp64 = temp64;
-			    do_div(utemp64, mtemp);
-			    freq_adj += utemp64;
-			}
-		    }
+		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
+			freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

