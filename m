From: akpm@linux-foundation.org
Subject: [folded] init-skip-calibration-delay-if-previously-done-4.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:02:10 -0700
Message-ID: <201107260002.p6Q02Anq006641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab1GZACR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amworsley@gmail.com, ddaney@caviumnetworks.com, ext-phil.2.carmody@nokia.com, snanda@chromium.org, mm-commits@vger.kernel.org


The patch titled
     init-skip-calibration-delay-if-previously-done-4
has been removed from the -mm tree.  Its filename was
     init-skip-calibration-delay-if-previously-done-4.patch

This patch was dropped because it was folded into init-skip-calibration-delay-if-previously-done.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-skip-calibration-delay-if-previously-done-4
From: Andrew Morton <akpm@linux-foundation.org>

fix things up after upstream rmk changes

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done-4 init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-4
+++ a/init/calibrate.c
@@ -253,7 +253,7 @@ void __cpuinit calibrate_delay(void)
 	int this_cpu = smp_processor_id();
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
-		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
+		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
 		pr_info("Calibrating delay loop (skipped) "
 				"already calibrated this CPU");
 	} else if (preset_lpj) {
@@ -274,7 +274,7 @@ void __cpuinit calibrate_delay(void)
 			pr_info("Calibrating delay loop... ");
 		lpj = calibrate_delay_converge();
 	}
-	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
+	per_cpu(cpu_loops_per_jiffy, this_cpu) = lpj;
 	if (!printed)
 		pr_cont("%lu.%02lu BogoMIPS (lpj=%lu)\n",
 			lpj/(500000/HZ),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
pagewalk-add-locking-rule-comments.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young.patch
drivers-misc-add-support-the-fsa9480-usb-switch.patch
lib-make-_tolower-public.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

