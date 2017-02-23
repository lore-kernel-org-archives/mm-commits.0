From: akpm@linux-foundation.org
Subject: [merged]
 kernel-watchdogc-do-not-hardcode-cpu-0-as-the-initial-thread.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:12:07 -0800
Message-ID: <58af5027.GBitNTkqZPkn068P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdBWVMS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@linux.intel.com, babu.moger@oracle.com, bp@suse.de, dzickus@redhat.com, hidehiro.kawai.ez@hitachi.com, johunt@akamai.com, mingo@kernel.org, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: do not hardcode CPU 0 as the initial thread
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-do-not-hardcode-cpu-0-as-the-initial-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: kernel/watchdog.c: do not hardcode CPU 0 as the initial thread

When CONFIG_BOOTPARAM_HOTPLUG_CPU0 is enabled, the socket containing the
boot cpu can be replaced.  During the hot add event, the message

NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.

is output implying that the NMI watchdog was disabled at some point.  This
is not the case and the message has caused confusion for users of systems
that support the removal of the boot cpu socket.

The watchdog code is coded to assume that cpu 0 is always the first cpu to
initialize the watchdog, and the last to stop its watchdog thread.  That
is not the case for initializing if cpu 0 has been removed and added.  The
removal case has never been correct because the smpboot code will remove
the watchdog threads starting with the lowest cpu number.

This patch adds watchdog_cpus to track the number of cpus with active NMI
watchdog threads so that the first and last thread can be used to set and
clear the value of firstcpu_err.  firstcpu_err is set when the first
watchdog thread is enabled, and cleared when the last watchdog thread is
disabled.

Link: http://lkml.kernel.org/r/1480425321-32296-1-git-send-email-prarit@redhat.com
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joshua Hunt <johunt@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_hld.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN kernel/watchdog_hld.c~kernel-watchdogc-do-not-hardcode-cpu-0-as-the-initial-thread kernel/watchdog_hld.c
--- a/kernel/watchdog_hld.c~kernel-watchdogc-do-not-hardcode-cpu-0-as-the-initial-thread
+++ a/kernel/watchdog_hld.c
@@ -137,12 +137,14 @@ static void watchdog_overflow_callback(s
  * Reduce the watchdog noise by only printing messages
  * that are different from what cpu0 displayed.
  */
-static unsigned long cpu0_err;
+static unsigned long firstcpu_err;
+static atomic_t watchdog_cpus;
 
 int watchdog_nmi_enable(unsigned int cpu)
 {
 	struct perf_event_attr *wd_attr;
 	struct perf_event *event = per_cpu(watchdog_ev, cpu);
+	int firstcpu = 0;
 
 	/* nothing to do if the hard lockup detector is disabled */
 	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
@@ -156,19 +158,22 @@ int watchdog_nmi_enable(unsigned int cpu
 	if (event != NULL)
 		goto out_enable;
 
+	if (atomic_inc_return(&watchdog_cpus) == 1)
+		firstcpu = 1;
+
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 
-	/* save cpu0 error for future comparision */
-	if (cpu == 0 && IS_ERR(event))
-		cpu0_err = PTR_ERR(event);
+	/* save the first cpu's error for future comparision */
+	if (firstcpu && IS_ERR(event))
+		firstcpu_err = PTR_ERR(event);
 
 	if (!IS_ERR(event)) {
-		/* only print for cpu0 or different than cpu0 */
-		if (cpu == 0 || cpu0_err)
+		/* only print for the first cpu initialized */
+		if (firstcpu || firstcpu_err)
 			pr_info("enabled on all CPUs, permanently consumes one hw-PMU counter.\n");
 		goto out_save;
 	}
@@ -186,7 +191,7 @@ int watchdog_nmi_enable(unsigned int cpu
 	smp_mb__after_atomic();
 
 	/* skip displaying the same error again */
-	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
+	if (!firstcpu && (PTR_ERR(event) == firstcpu_err))
 		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
@@ -222,9 +227,9 @@ void watchdog_nmi_disable(unsigned int c
 
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
-	}
-	if (cpu == 0) {
+
 		/* watchdog_nmi_enable() expects this to be zero initially. */
-		cpu0_err = 0;
+		if (atomic_dec_and_test(&watchdog_cpus))
+			firstcpu_err = 0;
 	}
 }
_

Patches currently in -mm which might be from prarit@redhat.com are


