From: akpm@linux-foundation.org
Subject: [merged] init-skip-calibration-delay-if-previously-done.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:20 -0700
Message-ID: <201107260755.p6Q7tNwt003461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab1GZH4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snanda@chromium.org, amworsley@gmail.com, ddaney@caviumnetworks.com, ext-phil.2.carmody@nokia.com, mm-commits@vger.kernel.org


The patch titled
     init: skip calibration delay if previously done
has been removed from the -mm tree.  Its filename was
     init-skip-calibration-delay-if-previously-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: skip calibration delay if previously done
From: Sameer Nanda <snanda@chromium.org>

For each CPU, do the calibration delay only once.  For subsequent calls,
use the cached per-CPU value of loops_per_jiffy.

This saves about 200ms of resume time on dual core Intel Atom N5xx based
systems.  This helps bring down the kernel resume time on such systems
from about 500ms to about 300ms.

[akpm@linux-foundation.org: make cpu_loops_per_jiffy static]
[akpm@linux-foundation.org: clean up message text]
[akpm@linux-foundation.org: fix things up after upstream rmk changes]
Signed-off-by: Sameer Nanda <snanda@chromium.org>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Andrew Worsley <amworsley@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done
+++ a/init/calibrate.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>
 
 unsigned long lpj_fine;
 unsigned long preset_lpj;
@@ -243,12 +244,19 @@ recalibrate:
 	return lpj;
 }
 
+static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+
 void __cpuinit calibrate_delay(void)
 {
 	unsigned long lpj;
 	static bool printed;
+	int this_cpu = smp_processor_id();
 
-	if (preset_lpj) {
+	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
+		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
+		pr_info("Calibrating delay loop (skipped) "
+				"already calibrated this CPU");
+	} else if (preset_lpj) {
 		lpj = preset_lpj;
 		if (!printed)
 			pr_info("Calibrating delay loop (skipped) "
@@ -266,6 +274,7 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay loop... ");
 		lpj = calibrate_delay_converge();
 	}
+	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			lpj/(500000/HZ),
_

Patches currently in -mm which might be from snanda@chromium.org are

origin.patch

