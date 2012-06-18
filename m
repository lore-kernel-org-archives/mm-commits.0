From: akpm@linux-foundation.org
Subject: [merged] watchdog-quiet-down-the-boot-messages.patch removed from -mm tree
Date: Mon, 18 Jun 2012 14:32:11 -0700
Message-ID: <20120618213211.772AAA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34669 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2FRVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jun 2012 17:32:13 -0400
Received: by wibhn6 with SMTP id hn6so123724wib.1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jun 2012 14:32:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, joe@perches.com, mingo@elte.hu, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi watchdog: quiet down the boot messages
has been removed from the -mm tree.  Its filename was
     watchdog-quiet-down-the-boot-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Don Zickus <dzickus@redhat.com>
Subject: nmi watchdog: quiet down the boot messages

A bunch of bugzillas have complained how noisy the nmi_watchdog is during
boot-up especially with its expected failure cases (like virt and bios
resource contention).

This is my attempt to quiet them down and keep it less confusing for the
end user.  What I did is print the message for cpu0 and save it for future
comparisons.  If future cpus have an identical message as cpu0, then don't
print the redundant info.  However, if a future cpu has a different
message, happily print that loudly.

Before the change, you would see something like:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog enabled, takes one hw-pmu counter.
    Booting Node   0, Processors  #1
    NMI watchdog enabled, takes one hw-pmu counter.
     #2
    NMI watchdog enabled, takes one hw-pmu counter.
     #3 Ok.
    NMI watchdog enabled, takes one hw-pmu counter.
    Brought up 4 CPUs
    Total of 4 processors activated (22607.24 BogoMIPS).

After the change, it is simplified to:

    ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
    CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
    Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
    ... version:                2
    ... bit width:              40
    ... generic registers:      2
    ... value mask:             000000ffffffffff
    ... max period:             000000007fffffff
    ... fixed-purpose events:   3
    ... event mask:             0000000700000003
    NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
    Booting Node   0, Processors  #1 #2 #3 Ok.
    Brought up 4 CPUs

Reported-and-tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-quiet-down-the-boot-messages kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-quiet-down-the-boot-messages
+++ a/kernel/watchdog.c
@@ -372,6 +372,13 @@ static int watchdog(void *unused)
 
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+/*
+ * People like the simple clean cpu node info on boot.
+ * Reduce the watchdog noise by only printing messages
+ * that are different from what cpu0 displayed.
+ */
+static unsigned long cpu0_err;
+
 static int watchdog_nmi_enable(int cpu)
 {
 	struct perf_event_attr *wd_attr;
@@ -390,11 +397,21 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
+
+	/* save cpu0 error for future comparision */
+	if (cpu == 0 && IS_ERR(event))
+		cpu0_err = PTR_ERR(event);
+
 	if (!IS_ERR(event)) {
-		pr_info("enabled, takes one hw-pmu counter.\n");
+		/* only print for cpu0 or different than cpu0 */
+		if (cpu == 0 || cpu0_err)
+			pr_info("enabled on all CPUs, permanently consumes one hw-PMU counter.\n");
 		goto out_save;
 	}
 
+	/* skip displaying the same error again */
+	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
+		return PTR_ERR(event);
 
 	/* vary the KERN level based on the returned errno */
 	if (PTR_ERR(event) == -EOPNOTSUPP)
_

Patches currently in -mm which might be from dzickus@redhat.com are

nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

