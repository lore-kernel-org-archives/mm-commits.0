From: akpm@linux-foundation.org
Subject: + system-timer-fix-crash-in-100hz-system-timer.patch added to -mm tree
Date: Mon, 07 Jan 2008 16:09:59 -0800
Message-ID: <200801080009.m0809xlS019200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759071AbYAHAK0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 19:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     system timer: fix crash in <100Hz system timer
has been added to the -mm tree.  Its filename is
     system-timer-fix-crash-in-100hz-system-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: system timer: fix crash in <100Hz system timer
From: David Fries <david@fries.net>

The kernel has a divide by zero crash when trying to run the system timer
less than 100Hz.  The problem is x/(HZ/USER_HZ) and related.  Now
x*(USER_HZ/HZ) will be used if HZ<USER_HZ.

I'm running the Linux kernel under qemu and went to run a slower system
timer to take less CPU (and battery) on the host.  I found that the kernel
paniced under emulation because of a divide by zero in three places.  Here
is the patch.  The base git was updated today 01-05-2008.  I went for a
20Hz system time by adding config HZ_20 etc to kernel/Kconfig.hz.  With
this patch I verified the system timer by looking at /proc/interrupts.

Signed-off-by: David Fries <david@fries.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acct.h |    6 +++++-
 kernel/time.c        |   11 ++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN include/linux/acct.h~system-timer-fix-crash-in-100hz-system-timer include/linux/acct.h
--- a/include/linux/acct.h~system-timer-fix-crash-in-100hz-system-timer
+++ a/include/linux/acct.h
@@ -173,7 +173,11 @@ typedef struct acct acct_t;
 static inline u32 jiffies_to_AHZ(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / AHZ)) == 0
-	return x / (HZ / AHZ);
+	#if HZ < AHZ
+		return x * (AHZ / HZ);
+	#else
+		return x / (HZ / AHZ);
+	#endif
 #else
         u64 tmp = (u64)x * TICK_NSEC;
         do_div(tmp, (NSEC_PER_SEC / AHZ));
diff -puN kernel/time.c~system-timer-fix-crash-in-100hz-system-timer kernel/time.c
--- a/kernel/time.c~system-timer-fix-crash-in-100hz-system-timer
+++ a/kernel/time.c
@@ -565,7 +565,11 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 clock_t jiffies_to_clock_t(long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
+	#if HZ < USER_HZ
+	return x * (USER_HZ / HZ);
+	#else
 	return x / (HZ / USER_HZ);
+	#endif
 #else
 	u64 tmp = (u64)x * TICK_NSEC;
 	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
@@ -598,7 +602,12 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
 u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
-	do_div(x, HZ / USER_HZ);
+	#if HZ < USER_HZ
+		x *= USER_HZ;
+		do_div(x, HZ);
+	#else
+		do_div(x, HZ / USER_HZ);
+	#endif
 #else
 	/*
 	 * There are better ways that don't overflow early,
_

Patches currently in -mm which might be from david@fries.net are

system-timer-fix-crash-in-100hz-system-timer.patch
