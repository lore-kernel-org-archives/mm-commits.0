From: akpm@linux-foundation.org
Subject: + add-touch_all_softlockup_watchdogs.patch added to -mm tree
Date: Wed, 28 Mar 2007 18:43:37 -0700
Message-ID: <200703290143.l2T1hbbX024971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38294 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965884AbXC2Boc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 21:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, clalance@redhat.com, jeremy@xensource.com, mingo@elte.hu, prarit@redhat.com, ricklind@us.ibm.com


The patch titled
     add touch_all_softlockup_watchdogs()
has been added to the -mm tree.  Its filename is
     add-touch_all_softlockup_watchdogs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add touch_all_softlockup_watchdogs()
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add touch_all_softlockup_watchdogs() to allow the softlockup watchdog
timers on all cpus to be updated.  This is used to prevent sysrq-t from
generating a spurious watchdog message when generating lots of output.

Softlockup watchdogs use sched_clock() as its timebase, which is inherently
per-cpu (at least, when it is measuring unstolen time).  Because of this,
it isn't possible for one CPU to directly update the other CPU's timers,
but it is possible to tell the other CPUs to do update themselves
appropriately.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rick Lindsley <ricklind@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++++
 kernel/sched.c        |    2 ++
 kernel/softlockup.c   |   15 +++++++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~add-touch_all_softlockup_watchdogs include/linux/sched.h
--- a/include/linux/sched.h~add-touch_all_softlockup_watchdogs
+++ a/include/linux/sched.h
@@ -226,6 +226,7 @@ extern void scheduler_tick(void);
 extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
+extern void touch_all_softlockup_watchdogs(void);
 #else
 static inline void softlockup_tick(void)
 {
@@ -236,6 +237,9 @@ static inline void spawn_softlockup_task
 static inline void touch_softlockup_watchdog(void)
 {
 }
+static inline void touch_all_softlockup_watchdogs(void)
+{
+}
 #endif
 
 
diff -puN kernel/sched.c~add-touch_all_softlockup_watchdogs kernel/sched.c
--- a/kernel/sched.c~add-touch_all_softlockup_watchdogs
+++ a/kernel/sched.c
@@ -4784,6 +4784,8 @@ void show_state_filter(unsigned long sta
 			show_task(p);
 	} while_each_thread(g, p);
 
+	touch_all_softlockup_watchdogs();
+
 	read_unlock(&tasklist_lock);
 	/*
 	 * Only show locks if all tasks are dumped:
diff -puN kernel/softlockup.c~add-touch_all_softlockup_watchdogs kernel/softlockup.c
--- a/kernel/softlockup.c~add-touch_all_softlockup_watchdogs
+++ a/kernel/softlockup.c
@@ -50,6 +50,16 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
+void touch_all_softlockup_watchdogs(void)
+{
+	int cpu;
+
+	/* Cause each CPU to re-update its timestamp rather than complain */
+	for_each_online_cpu(cpu)
+		per_cpu(touch_timestamp, cpu) = 0;
+}
+EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
+
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
@@ -61,9 +71,10 @@ void softlockup_tick(void)
 	unsigned long print_timestamp;
 	unsigned long now;
 
-	/* watchdog task hasn't updated timestamp yet */
-	if (touch_timestamp == 0)
+	if (touch_timestamp == 0) {
+		touch_softlockup_watchdog();
 		return;
+	}
 
 	print_timestamp = __get_cpu_var(print_timestamp);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-simplify-smp_call_function-by-using-common-implementation.patch
i386-account-for-module-percpu-space-separately-from-kernel.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
