From: akpm@linux-foundation.org
Subject: + ignore-stolen-time-in-the-softlockup-watchdog.patch added to -mm tree
Date: Tue, 24 Apr 2007 13:44:22 -0700
Message-ID: <200704242044.l3OKiMad018801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbXDXUpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 16:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, clalance@redhat.com, dada1@cosmosbay.com, dhecht@vmware.com, jeremy@xensource.com, jmorris@namei.org, johnstul@us.ibm.com, mingo@elte.hu, paulus@samba.org, prarit@redhat.com, ricklind@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, zach@vmware.com


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

(akpm: this patch, when combined with Andi's sched_clock() rewrite causes six
mysterious errors in the locking API selftests.  We don't know where the
problem lies, but we want to find out).

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff -puN kernel/softlockup.c~ignore-stolen-time-in-the-softlockup-watchdog kernel/softlockup.c
--- a/kernel/softlockup.c~ignore-stolen-time-in-the-softlockup-watchdog
+++ a/kernel/softlockup.c
@@ -34,9 +34,19 @@ static struct notifier_block panic_block
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
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = jiffies;
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -47,10 +57,18 @@ EXPORT_SYMBOL(touch_softlockup_watchdog)
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
@@ -61,12 +79,14 @@ void softlockup_tick(void)
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
@@ -87,6 +107,9 @@ static int watchdog(void * __bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
+	/* initialize timestamp */
+	touch_softlockup_watchdog();
+
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 10 seconds then the
@@ -118,7 +141,7 @@ cpu_callback(struct notifier_block *nfb,
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

revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
