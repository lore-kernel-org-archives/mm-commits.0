From: akpm@linux-foundation.org
Subject: [alternative-merged] oprofile-fix-hang-while-offline-the-cpu.patch removed from -mm tree
Date: Fri, 29 Oct 2010 16:12:10 -0700
Message-ID: <201010292312.o9TNCAHH022341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0J2XMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Oct 2010 19:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santosh.shilimkar@ti.com, r.sricharan@ti.com, robert.richter@amd.com, s-jan@ti.com, mm-commits@vger.kernel.org


The patch titled
     oprofile: fix hang while offline the cpu
has been removed from the -mm tree.  Its filename was
     oprofile-fix-hang-while-offline-the-cpu.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oprofile: fix hang while offline the cpu
From: Santosh Shilimkar <santosh.shilimkar@ti.com>

The kernel is built with CONFIG_OPROFILE and CPU_HOTPLUG enabled. 
oprofile is initialised using system timer in absence of hardware counters
supports.  Oprofile isn't started from userland.

In this setup while doing a CPU offline the kernel hangs in an infinite
loop in lock_hrtimer_base().

This happens because as part of oprofile_cpu_notify(, it tries to stop an
hrtimer which was never started.  These per-cpu hrtimers are started when
the oprfile is started.

	echo 1	> /dev/oprofile/enable

Fix this issue by adding a state variable so that these hrtimer start/stop
is only attempted when oprofile is started

Reported-by: Jan Sebastien <s-jan@ti.com>
Signed-off-by: sricharan <r.sricharan@ti.com>
Tested-by: sricharan <r.sricharan@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/timer_int.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/oprofile/timer_int.c~oprofile-fix-hang-while-offline-the-cpu drivers/oprofile/timer_int.c
--- a/drivers/oprofile/timer_int.c~oprofile-fix-hang-while-offline-the-cpu
+++ a/drivers/oprofile/timer_int.c
@@ -21,6 +21,7 @@
 #include "oprof.h"
 
 static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
+static int oprofile_hrtimer_started;
 
 static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
 {
@@ -33,6 +34,9 @@ static void __oprofile_hrtimer_start(voi
 {
 	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
 
+	if (!oprofile_hrtimer_started)
+		return;
+
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = oprofile_hrtimer_notify;
 
@@ -42,6 +46,7 @@ static void __oprofile_hrtimer_start(voi
 
 static int oprofile_hrtimer_start(void)
 {
+	oprofile_hrtimer_started = 1;
 	on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
 	return 0;
 }
@@ -50,6 +55,9 @@ static void __oprofile_hrtimer_stop(int 
 {
 	struct hrtimer *hrtimer = &per_cpu(oprofile_hrtimer, cpu);
 
+	if (!oprofile_hrtimer_started)
+		return;
+
 	hrtimer_cancel(hrtimer);
 }
 
@@ -59,6 +67,7 @@ static void oprofile_hrtimer_stop(void)
 
 	for_each_online_cpu(cpu)
 		__oprofile_hrtimer_stop(cpu);
+	oprofile_hrtimer_started = 0;
 }
 
 static int __cpuinit oprofile_cpu_notify(struct notifier_block *self,
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
linux-next.patch

