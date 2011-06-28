From: akpm@linux-foundation.org
Subject: [withdrawn] init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch removed from -mm tree
Date: Tue, 28 Jun 2011 12:39:43 -0700
Message-ID: <201106281939.p5SJdPF6030018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab1F1TkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 15:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amworsley@gmail.com, ddaney@caviumnetworks.com, ext-phil.2.carmody@nokia.com, snanda@chromium.org, mm-commits@vger.kernel.org


The patch titled
     init/calibrate.c: calibrate_delay(): tidy up the pr_info messages
has been removed from the -mm tree.  Its filename was
     init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/calibrate.c: calibrate_delay(): tidy up the pr_info messages
From: Andrew Morton <akpm@linux-foundation.org>

Make these messages more gramatically pleasing, more consistent and remove
strange ellipses.

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages init/calibrate.c
--- a/init/calibrate.c~init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages
+++ a/init/calibrate.c
@@ -253,24 +253,24 @@ void __cpuinit calibrate_delay(void)
 
 	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
 		loops_per_jiffy = per_cpu(cpu_loops_per_jiffy, this_cpu);
-		pr_info("Calibrating delay loop (skipped) "
-				"already calibrated this CPU");
+		pr_info("Calibrating delay loop.  Skipped: already calibrated "
+				"this CPU");
 	} else if (preset_lpj) {
 		loops_per_jiffy = preset_lpj;
 		if (!printed)
-			pr_info("Calibrating delay loop (skipped) "
-				"preset value.. ");
+			pr_info("Calibrating delay loop.  Skipped: "
+				"preset value");
 	} else if ((!printed) && lpj_fine) {
 		loops_per_jiffy = lpj_fine;
-		pr_info("Calibrating delay loop (skipped), "
-			"value calculated using timer frequency.. ");
+		pr_info("Calibrating delay loop.  Skipped: value calculated "
+				"using timer frequency");
 	} else if ((loops_per_jiffy = calibrate_delay_direct()) != 0) {
 		if (!printed)
-			pr_info("Calibrating delay using timer "
-				"specific routine.. ");
+			pr_info("Calibrating delay loop using timer-specific "
+					"routine");
 	} else {
 		if (!printed)
-			pr_info("Calibrating delay loop... ");
+			pr_info("Calibrating delay loop");
 		loops_per_jiffy = calibrate_delay_converge();
 	}
 	per_cpu(cpu_loops_per_jiffy, this_cpu) = loops_per_jiffy;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

