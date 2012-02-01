From: akpm@linux-foundation.org
Subject: + smp-start-up-non-boot-cpus-asynchronously.patch added to -mm tree
Date: Wed, 01 Feb 2012 15:01:13 -0800
Message-ID: <20120201230114.5BE52A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:38428 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2BAXBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 18:01:17 -0500
Received: by wgbds12 with SMTP id ds12so60994wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 15:01:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, a.p.zijlstra@chello.nl, arjan@linux.intel.com, hpa@zytor.com, miltonm@bga.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     Subject: smp: start up non-boot CPUs asynchronously
has been added to the -mm tree.  Its filename is
     smp-start-up-non-boot-cpus-asynchronously.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arjan van de Ven <arjan@infradead.org>
Subject: smp: start up non-boot CPUs asynchronously

The starting of the "not first" CPUs actually takes a lot of boot time of
the kernel...  upto "minutes" on some of the bigger SGI boxes.  Right now,
this is a fully sequential operation with the rest of the kernel boot.

This patch turns this bringup of the other cpus into an asynchronous
operat= ion.  With some other changes (not in this patch) this can save
significant kernel boot time (upto 40% on my laptop!!).  Basically now
CPUs could get brought up in parallel to disk enumeration, gr= aphic mode
bringup etc etc etc.

Note that the implementation in this patch still waits for all CPUs to be
brought up before starting userspace; I would love to remove that
restriction over time (technically that is simple), but that becomes then
a change in behavior...  I'd like to see more discussion on that being a
good idea before I write that patch.

Second note on version 2 of the patch: This patch does currently not save
any boot time, due to a situation where the cpu hotplug lock gets taken
for write by the cpu bringup code, which starves out readers of this lock
throughout the kernel.  Ingo specifically requested this behavior to
expose this lock problem.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously kernel/smp.c
--- a/kernel/smp.c~smp-start-up-non-boot-cpus-asynchronously
+++ a/kernel/smp.c
@@ -12,6 +12,8 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/async.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
@@ -664,17 +666,34 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __init async_cpu_up(void *data, async_cookie_t cookie)
+{
+	unsigned long nr = (unsigned long) data;
+	/*
+	 * we can only up one cpu at a time, as enforced by the hotplug
+	 * lock; it's better to wait for all earlier CPUs to be done before
+	 * we bring up ours, so that the bring up order is predictable.
+	 */
+	async_synchronize_cookie(cookie);
+	cpu_up(nr);
+}
+
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
 	unsigned int cpu;
 
 	/* FIXME: This should be done in userspace --RR */
+
+	/*
+	 * But until we do this in userspace, we're going to do this
+	 * in parallel to the rest of the kernel boot up.-- Arjan
+	 */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
-			cpu_up(cpu);
+			async_schedule(async_cpu_up, (void *) cpu);
 	}
 
 	/* Any cleanup work */
_
Subject: Subject: smp: start up non-boot CPUs asynchronously

Patches currently in -mm which might be from arjan@infradead.org are

hrtimers-special-case-zero-length-sleeps.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch

