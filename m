From: akpm@linux-foundation.org
Subject: + timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch added to -mm tree
Date: Thu, 29 Nov 2007 15:50:03 -0800
Message-ID: <200711292350.lATNo3Xf013586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763371AbXK2XvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 18:51:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timekeeping: rename timekeeping_is_continuous to timekeeping_valid_for_hres
has been added to the -mm tree.  Its filename is
     timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
 /**
diff -puN kernel/time/tick-sched.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres
+++ a/kernel/time/tick-sched.c
@@ -682,7 +682,7 @@ int tick_check_oneshot_change(int allow_
 	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
 		return 0;
 
-	if (!timekeeping_is_continuous() || !tick_is_oneshot_available())
+	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
 		return 0;
 
 	if (!allow_nohz)
diff -puN kernel/time/timekeeping.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres
+++ a/kernel/time/timekeeping.c
@@ -199,9 +199,9 @@ static inline s64 __get_nsec_offset(void
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

arm-fix-memset-size-error.patch
git-hid.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
