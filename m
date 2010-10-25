From: akpm@linux-foundation.org
Subject: + oprofile-fix-hang-while-offline-the-cpu.patch added to -mm tree
Date: Mon, 25 Oct 2010 16:33:52 -0700
Message-ID: <201010252333.o9PNXqhJ022710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab0JYXe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 19:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santosh.shilimkar@ti.com, r.sricharan@ti.com, robert.richter@amd.com, s-jan@ti.com


The patch titled
     oprofile: fix hang while offline the cpu
has been added to the -mm tree.  Its filename is
     oprofile-fix-hang-while-offline-the-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
oprofile-fix-hang-while-offline-the-cpu.patch

