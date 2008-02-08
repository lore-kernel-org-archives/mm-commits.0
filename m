From: akpm@linux-foundation.org
Subject: - timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:48 -0800
Message-ID: <200802082014.m18KETwj010450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbYBHVIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:08:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timekeeping: rename timekeeping_is_continuous to timekeeping_valid_for_hres
has been removed from the -mm tree.  Its filename was
     timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timekeeping: rename timekeeping_is_continuous to timekeeping_valid_for_hres
From: Li Zefan <lizf@cn.fujitsu.com>

Function timekeeping_is_continuous() no longer checks flag
CLOCK_IS_CONTINUOUS, and it checks CLOCK_SOURCE_VALID_FOR_HRES now.  So rename
the function accordingly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h      |    2 +-
 kernel/time/tick-sched.c  |    2 +-
 kernel/time/timekeeping.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/time.h~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres include/linux/time.h
--- a/include/linux/time.h~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres
+++ a/include/linux/time.h
@@ -120,7 +120,7 @@ extern void getboottime(struct timespec 
 extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
-extern int timekeeping_is_continuous(void);
+extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
 
diff -puN kernel/time/tick-sched.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres
+++ a/kernel/time/tick-sched.c
@@ -681,7 +681,7 @@ int tick_check_oneshot_change(int allow_
 	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
 		return 0;
 
-	if (!timekeeping_is_continuous() || !tick_is_oneshot_available())
+	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
 		return 0;
 
 	if (!allow_nohz)
diff -puN kernel/time/timekeeping.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres
+++ a/kernel/time/timekeeping.c
@@ -201,9 +201,9 @@ static inline s64 __get_nsec_offset(void
 #endif
 
 /**
- * timekeeping_is_continuous - check to see if timekeeping is free running
+ * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
-int timekeeping_is_continuous(void)
+int timekeeping_valid_for_hres(void)
 {
 	unsigned long seq;
 	int ret;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
