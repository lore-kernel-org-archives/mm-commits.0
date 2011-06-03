From: akpm@linux-foundation.org
Subject: + init-skip-calibration-delay-if-previously-done.patch added to -mm tree
Date: Fri, 03 Jun 2011 14:01:09 -0700
Message-ID: <201106032101.p53L1AXh007384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756286Ab1FCVBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 17:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snanda@chromium.org, amworsley@gmail.com, ext-phil.2.carmody@nokia.com


The patch titled
     init: skip calibration delay if previously done
has been added to the -mm tree.  Its filename is
     init-skip-calibration-delay-if-previously-done.patch

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
Subject: init: skip calibration delay if previously done
From: Sameer Nanda <snanda@chromium.org>

For each CPU, do the calibration delay only once.  For subsequent calls,
use the cached per-CPU value of loops_per_jiffy.

This saves about 200ms of resume time on dual core Intel Atom N5xx based
systems.  This helps bring down the kernel resume time on such systems
from about 500ms to about 300ms.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done
+++ a/init/calibrate.c
@@ -246,11 +246,18 @@ recalibrate:
 	return lpj;
 }
 
+DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+
 void __cpuinit calibrate_delay(void)
 {
 	static bool printed;
+	int this_cpu = smp_processor_id();
 
-	if (preset_lpj) {
+	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
+		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
+		pr_info("Calibrating delay loop (skipped) "
+				"already calibrated this CPU previously.. ");
+	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
@@ -268,6 +275,7 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay loop... ");
 		loops_per_jiffy = calibrate_delay_converge();
 	}
+	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			loops_per_jiffy/(500000/HZ),
_

Patches currently in -mm which might be from snanda@chromium.org are

init-skip-calibration-delay-if-previously-done.patch
init-skip-calibration-delay-if-previously-done-fix.patch

