From: akpm@linux-foundation.org
Subject: [folded] init-skip-calibration-delay-if-previously-done-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:01:59 -0700
Message-ID: <201107260001.p6Q01x9p006553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab1GZACG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amworsley@gmail.com, ddaney@caviumnetworks.com, ext-phil.2.carmody@nokia.com, snanda@chromium.org, mm-commits@vger.kernel.org


The patch titled
     init-skip-calibration-delay-if-previously-done-fix
has been removed from the -mm tree.  Its filename was
     init-skip-calibration-delay-if-previously-done-fix.patch

This patch was dropped because it was folded into init-skip-calibration-delay-if-previously-done.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-skip-calibration-delay-if-previously-done-fix
From: Andrew Morton <akpm@linux-foundation.org>

make cpu_loops_per_jiffy static

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix init/calibrate.c
--- a/init/calibrate.c~init-skip-calibration-delay-if-previously-done-fix
+++ a/init/calibrate.c
@@ -243,7 +243,7 @@ recalibrate:
 	return lpj;
 }
 
-DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
+static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
 void __cpuinit calibrate_delay(void)
 {
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
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

