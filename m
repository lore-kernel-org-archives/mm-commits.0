From: akpm@linux-foundation.org
Subject: - ntp-support-for-tai.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:08 -0700
Message-ID: <200805021942.m42Jg8Yj011146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043AbYEBTrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: support for TAI
has been removed from the -mm tree.  Its filename was
     ntp-support-for-tai.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: support for TAI
From: Roman Zippel <zippel@linux-m68k.org>

This adds support for setting the TAI value (International Atomic Time).  The
value is reported back to userspace via timex (as we don't have a
ntp_gettime() syscall).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    3 ++-
 include/linux/timex.h  |    5 ++++-
 kernel/compat.c        |    3 ++-
 kernel/time/ntp.c      |    7 +++++++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff -puN include/linux/compat.h~ntp-support-for-tai include/linux/compat.h
--- a/include/linux/compat.h~ntp-support-for-tai
+++ a/include/linux/compat.h
@@ -65,10 +65,11 @@ struct compat_timex {
 	compat_long_t calcnt;
 	compat_long_t errcnt;
 	compat_long_t stbcnt;
+	compat_int_t tai;
 
 	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
 	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
+	compat_int_t :32; compat_int_t :32; compat_int_t :32;
 };
 
 #define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
diff -puN include/linux/timex.h~ntp-support-for-tai include/linux/timex.h
--- a/include/linux/timex.h~ntp-support-for-tai
+++ a/include/linux/timex.h
@@ -121,9 +121,11 @@ struct timex {
 	long errcnt;            /* calibration errors (ro) */
 	long stbcnt;            /* stability limit exceeded (ro) */
 
+	int tai;		/* TAI offset (ro) */
+
 	int  :32; int  :32; int  :32; int  :32;
 	int  :32; int  :32; int  :32; int  :32;
-	int  :32; int  :32; int  :32; int  :32;
+	int  :32; int  :32; int  :32;
 };
 
 /*
@@ -135,6 +137,7 @@ struct timex {
 #define ADJ_ESTERROR		0x0008	/* estimated time error */
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
+#define ADJ_TAI			0x0080	/* set TAI offset */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
diff -puN kernel/compat.c~ntp-support-for-tai kernel/compat.c
--- a/kernel/compat.c~ntp-support-for-tai
+++ a/kernel/compat.c
@@ -955,7 +955,8 @@ asmlinkage long compat_sys_adjtimex(stru
 			__put_user(txc.jitcnt, &utp->jitcnt) ||
 			__put_user(txc.calcnt, &utp->calcnt) ||
 			__put_user(txc.errcnt, &utp->errcnt) ||
-			__put_user(txc.stbcnt, &utp->stbcnt))
+			__put_user(txc.stbcnt, &utp->stbcnt) ||
+			__put_user(txc.tai, &utp->tai))
 		ret = -EFAULT;
 
 	return ret;
diff -puN kernel/time/ntp.c~ntp-support-for-tai kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-support-for-tai
+++ a/kernel/time/ntp.c
@@ -35,6 +35,7 @@ static u64 tick_length, tick_length_base
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int time_state = TIME_OK;	/* clock synchronization status	*/
 int time_status = STA_UNSYNC;		/* clock status bits		*/
+static long time_tai;			/* TAI offset (s)		*/
 static s64 time_offset;			/* time adjustment (ns)		*/
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
@@ -162,6 +163,7 @@ void second_overflow(void)
 	case TIME_DEL:
 		if ((xtime.tv_sec + 1) % 86400 == 0) {
 			xtime.tv_sec++;
+			time_tai--;
 			wall_to_monotonic.tv_sec--;
 			time_state = TIME_WAIT;
 			printk(KERN_NOTICE "Clock: deleting leap second "
@@ -169,6 +171,7 @@ void second_overflow(void)
 		}
 		break;
 	case TIME_OOP:
+		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 	case TIME_WAIT:
@@ -340,6 +343,9 @@ int do_adjtimex(struct timex *txc)
 			time_constant = max(time_constant, 0l);
 		}
 
+		if (txc->modes & ADJ_TAI && txc->constant > 0)
+			time_tai = txc->constant;
+
 		if (txc->modes & ADJ_OFFSET) {
 			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
 				/* adjtime() is independent from ntp_adjtime() */
@@ -377,6 +383,7 @@ int do_adjtimex(struct timex *txc)
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
+	txc->tai	   = time_tai;
 
 	/* PPS is not implemented, so these are zero */
 	txc->ppsfreq	   = 0;
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

