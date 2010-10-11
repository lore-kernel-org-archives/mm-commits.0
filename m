From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 Oct 2010 16:01:28 -0700
Message-ID: <201010112301.o9BN1SxV023251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab0JKXC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, atul.dahiya@samsung.com, ben-linux@fluff.org, chaos.youn@samsung.com, kgene.kim@samsung.com, mcuos.com@gmail.com


The patch titled
     rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch

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
Subject: rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open brace '{'
#60: FILE: drivers/rtc/rtc-s3c.c:408:
+		if ((readw(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0){

ERROR: space required before the open brace '{'
#70: FILE: drivers/rtc/rtc-s3c.c:415:
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)){

WARNING: line over 80 characters
#76: FILE: drivers/rtc/rtc-s3c.c:419:
+			writew(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);

ERROR: need consistent spacing around '&' (ctx:VxW)
#76: FILE: drivers/rtc/rtc-s3c.c:419:
+			writew(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);
 			          ^

ERROR: space required before the open brace '{'
#80: FILE: drivers/rtc/rtc-s3c.c:422:
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)){

WARNING: line over 80 characters
#86: FILE: drivers/rtc/rtc-s3c.c:426:
+			writew(tmp & ~S3C2410_RTCCON_CLKRST, base+S3C2410_RTCCON);

total: 4 errors, 2 warnings, 91 lines checked

./patches/rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Atul Dahiya <atul.dahiya@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Changhwan Youn <chaos.youn@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes
+++ a/drivers/rtc/rtc-s3c.c
@@ -405,25 +405,28 @@ static void s3c_rtc_enable(struct platfo
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((readw(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0){
+		if ((readw(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
 			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
 
 			tmp = readw(base + S3C2410_RTCCON);
-			writew(tmp|S3C2410_RTCCON_RTCEN, base+S3C2410_RTCCON);
+			writew(tmp | S3C2410_RTCCON_RTCEN,
+				base + S3C2410_RTCCON);
 		}
 
-		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)){
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
 			dev_info(&pdev->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(base + S3C2410_RTCCON);
-			writew(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);
+			writew(tmp & ~S3C2410_RTCCON_CNTSEL,
+				base + S3C2410_RTCCON);
 		}
 
-		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)){
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
 			dev_info(&pdev->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(base + S3C2410_RTCCON);
-			writew(tmp & ~S3C2410_RTCCON_CLKRST, base+S3C2410_RTCCON);
+			writew(tmp & ~S3C2410_RTCCON_CLKRST,
+				base + S3C2410_RTCCON);
 		}
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-mips-include-asm-fcntlh-needs-typesh.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
kernel-auditscc-audit_inc_name_count-add-stack-backtrace.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
serial8250-ratelimit-too-much-work-error-fix.patch
serial8250-ratelimit-too-much-work-error-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-fix.patch
rmap-make-anon_vma_free-static-fix.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
fs-fs-writebackc-restore-lost-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

