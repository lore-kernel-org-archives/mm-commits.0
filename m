From: akpm@linux-foundation.org
Subject: + ignore-stolen-time-in-the-softlockup-watchdog.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:25:58 -0700
Message-ID: <200703282325.l2SNPwIQ022613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796AbXC1X1Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, clalance@redhat.com, dada1@cosmosbay.com, dhecht@vmware.com, jeremy@xensource.com, jmorris@namei.org, johnstul@us.ibm.com, mingo@elte.hu, paulus@samba.org, prarit@redhat.com, ricklind@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, zach@vmware.com


The patch titled
     Ignore stolen time in the softlockup watchdog
has been added to the -mm tree.  Its filename is
     ignore-stolen-time-in-the-softlockup-watchdog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Ignore stolen time in the softlockup watchdog
From: Jeremy Fitzhardinge <jeremy@goop.org>

The softlockup watchdog is currently a nuisance in a virtual machine, since
the whole system could have the CPU stolen from it for a long period of
time.  While it would be unlikely for a guest domain to be denied timer
interrupts for over 10s, it could happen and any softlockup message would
be completely spurious.

Earlier I proposed that sched_clock() return time in unstolen nanoseconds,
which is how Xen and VMI currently implement it.  If the softlockup
watchdog uses sched_clock() to measure time, it would automatically ignore
stolen time, and therefore only report when the guest itself locked up. 
When running native, sched_clock() returns real-time nanoseconds, so the
behaviour would be unchanged.

Note that sched_clock() used this way is inherently per-cpu, so this patch
makes sure that the per-processor watchdog thread initialized its own
timestamp.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: James Morris <jmorris@namei.org>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Rick Lindsley <ricklind@us.ibm.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   39 +++++++++++++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 8 deletions(-)

diff -puN kernel/softlockup.c~ignore-stolen-time-in-the-softlockup-watchdog kernel/softlockup.c
--- a/kernel/softlockup.c~ignore-stolen-time-in-the-softlockup-watchdog
+++ a/kernel/softlockup.c
@@ -35,9 +35,19 @@ static struct notifier_block panic_block
 	.notifier_call = softlock_panic,
 };
 
+/*
+ * Returns seconds, approximately.  We don't need nanosecond
+ * resolution, and we don't need to waste time with a big divide when
+ * 2^30ns == 1.074s.
+ */
+static unsigned long get_timestamp(void)
+{
+	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+}
+
 void touch_cpu_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = jiffies;
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_cpu_softlockup_watchdog);
 
@@ -46,7 +56,7 @@ void touch_softlockup_watchdog(void)
 	int cpu;
 
 	for_each_online_cpu(cpu)
-		per_cpu(touch_timestamp, cpu) = jiffies;
+		per_cpu(touch_timestamp, cpu) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -57,10 +67,18 @@ EXPORT_SYMBOL(touch_softlockup_watchdog)
 void softlockup_tick(void)
 {
 	int this_cpu = smp_processor_id();
-	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
+	unsigned long touch_timestamp = __get_cpu_var(touch_timestamp);
+	unsigned long print_timestamp;
+	unsigned long now;
 
-	/* prevent double reports: */
-	if (per_cpu(print_timestamp, this_cpu) == touch_timestamp ||
+	/* watchdog task hasn't updated timestamp yet */
+	if (touch_timestamp == 0)
+		return;
+
+	print_timestamp = __get_cpu_var(print_timestamp);
+
+	/* report at most once a second */
+	if (print_timestamp < (touch_timestamp + 1) ||
 		did_panic ||
 			!per_cpu(watchdog_task, this_cpu))
 		return;
@@ -71,12 +89,14 @@ void softlockup_tick(void)
 		return;
 	}
 
+	now = get_timestamp();
+
 	/* Wake up the high-prio watchdog task every second: */
-	if (time_after(jiffies, touch_timestamp + HZ))
+	if (now > (touch_timestamp + 1))
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (time_after(jiffies, touch_timestamp + 10*HZ)) {
+	if (now > (touch_timestamp + 10)) {
 		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 		spin_lock(&print_lock);
@@ -97,6 +117,9 @@ static int watchdog(void * __bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
+	/* initialize timestamp */
+	touch_softlockup_watchdog();
+
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 10 seconds then the
@@ -128,7 +151,7 @@ cpu_callback(struct notifier_block *nfb,
 			printk("watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = jiffies;
+  		per_cpu(touch_timestamp, hotcpu) = 0;
   		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
  		break;
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-simplify-smp_call_function-by-using-common-implementation.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
