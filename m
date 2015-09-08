From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:03:10 -0700
Message-ID: <55ef22de.lfpd/I6Qf6J65QQA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, a.p.zijlstra@chello.nl, atomlin@redhat.com, cmetcalf@ezchip.com, dzickus@redhat.com, eranian@google.com, fweisbec@gmail.com, jolsa@kernel.org, linux@roeck-us.net, mhocko@suse.cz, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: introduce watchdog_park_threads() and watchdog_unpark_threads()
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: watchdog: introduce watchdog_park_threads() and watchdog_unpark_threads()

Originally watchdog_nmi_enable(cpu) and watchdog_nmi_disable(cpu) were
only called in watchdog thread context.  However, the following commits
utilize these functions outside of watchdog thread context too.

  commit 9809b18fcf6b8d8ec4d3643677345907e6b50eca
  Author: Michal Hocko <mhocko@suse.cz>
  Date:   Tue Sep 24 15:27:30 2013 -0700

      watchdog: update watchdog_thresh properly

  commit b3738d29323344da3017a91010530cf3a58590fc
  Author: Stephane Eranian <eranian@google.com>
  Date:   Mon Nov 17 20:07:03 2014 +0100

      watchdog: Add watchdog enable/disable all functions

Hence, it is now possible that these functions execute concurrently with
the same 'cpu' argument.  This concurrency is problematic because per-cpu
'watchdog_ev' can be accessed/modified without adequate synchronization.

The patch series aims to address the above problem.  However, instead of
introducing locks to protect per-cpu 'watchdog_ev' a different approach is
taken: Invoke these functions by parking and unparking the watchdog
threads (to ensure they are always called in watchdog thread context).

  static struct smp_hotplug_thread watchdog_threads = {
           ...
          .park   = watchdog_disable, // calls watchdog_nmi_disable()
          .unpark = watchdog_enable,  // calls watchdog_nmi_enable()
  };

Both previously mentioned commits call these functions in a similar way
and thus in principle contain some duplicate code.  The patch series also
avoids this duplication by providing a commonly usable mechanism.

- Patch 1/4 introduces the watchdog_{park|unpark}_threads functions that
  park/unpark all watchdog threads specified in 'watchdog_cpumask'. They
  are intended to be called inside of kernel/watchdog.c only.

- Patch 2/4 introduces the watchdog_{suspend|resume} functions which can
  be utilized by external callers to deactivate the hard and soft lockup
  detector temporarily.

- Patch 3/4 utilizes watchdog_{park|unpark}_threads to replace some code
  that was introduced by commit 9809b18fcf6b8d8ec4d3643677345907e6b50eca.

- Patch 4/4 utilizes watchdog_{suspend|resume} to replace some code that
  was introduced by commit b3738d29323344da3017a91010530cf3a58590fc.

A few corner cases should be mentioned here for completeness.

- kthread_park() of watchdog/N could hang if cpu N is already locked up.
  However, if watchdog is enabled the lockup will be detected anyway.

- kthread_unpark() of watchdog/N could hang if cpu N got locked up after
  kthread_park(). The occurrence of this scenario should be _very_ rare
  in practice, in particular because it is not expected that temporary
  deactivation will happen frequently, and if it happens at all it is
  expected that the duration of deactivation will be short.


This patch (of 4): introduce watchdog_park_threads() and watchdog_unpark_threads()

These functions are intended to be used only from inside kernel/watchdog.c
to park/unpark all watchdog threads that are specified in
watchdog_cpumask.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephane Eranian <eranian@google.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN kernel/watchdog.c~watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads
+++ a/kernel/watchdog.c
@@ -24,6 +24,7 @@
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
 #include <linux/perf_event.h>
+#include <linux/kthread.h>
 
 /*
  * The run state of the lockup detectors is controlled by the content of the
@@ -664,6 +665,41 @@ static struct smp_hotplug_thread watchdo
 	.unpark			= watchdog_enable,
 };
 
+/*
+ * park all watchdog threads that are specified in 'watchdog_cpumask'
+ */
+static int watchdog_park_threads(void)
+{
+	int cpu, ret = 0;
+
+	get_online_cpus();
+	for_each_watchdog_cpu(cpu) {
+		ret = kthread_park(per_cpu(softlockup_watchdog, cpu));
+		if (ret)
+			break;
+	}
+	if (ret) {
+		for_each_watchdog_cpu(cpu)
+			kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+	}
+	put_online_cpus();
+
+	return ret;
+}
+
+/*
+ * unpark all watchdog threads that are specified in 'watchdog_cpumask'
+ */
+static void watchdog_unpark_threads(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_watchdog_cpu(cpu)
+		kthread_unpark(per_cpu(softlockup_watchdog, cpu));
+	put_online_cpus();
+}
+
 static void restart_watchdog_hrtimer(void *info)
 {
 	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
_

Patches currently in -mm which might be from uobergfe@redhat.com are


