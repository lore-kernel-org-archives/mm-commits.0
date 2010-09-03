From: akpm@linux-foundation.org
Subject: + mmc-make-id-freq-configurable-checkpatch-fixes.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:25:11 -0700
Message-ID: <201009032325.o83NPCwt018719__38396.5463763618$1283556384$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754639Ab0ICXZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adrian.hunter@nokia.com, bn@niasdigital.com, cjb@laptop.org, hein_tibosch@yahoo.es, linux-mmc@vger.kernel.org, matt@console-pimps.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     mmc-make-id-freq-configurable-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mmc-make-id-freq-configurable-checkpatch-fixes.patch

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
Subject: mmc-make-id-freq-configurable-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#76: FILE: drivers/mmc/core/core.c:1453:
+		printk ("mmc_rescan: trying %u Hz\n", host->f_init);

WARNING: line over 80 characters
#100: FILE: drivers/mmc/core/core.c:1467:
+				/* try SDMEM (but not MMC) even if SDIO is broken */

total: 0 errors, 2 warnings, 131 lines checked

./patches/mmc-make-id-freq-configurable.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <linux-mmc@vger.kernel.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Ben Nizette <bn@niasdigital.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-make-id-freq-configurable-checkpatch-fixes drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-make-id-freq-configurable-checkpatch-fixes
+++ a/drivers/mmc/core/core.c
@@ -1450,7 +1450,9 @@ void mmc_rescan(struct work_struct *work
 		else
 			host->f_init = host->f_min;
 
-		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
+		pr_info("%s: %s: trying to init card at %u Hz\n",
+			mmc_hostname(host), __func__, host->f_init);
+
 		mmc_power_up(host);
 		sdio_reset(host);
 		mmc_go_idle(host);
@@ -1464,7 +1466,10 @@ void mmc_rescan(struct work_struct *work
 		if (!err) {
 			if (mmc_attach_sdio(host, ocr)) {
 				mmc_claim_host(host);
-				/* try SDMEM (but not MMC) even if SDIO is broken */
+				/*
+				 * Try SDMEM (but not MMC) even if SDIO is
+				 * broken.
+				 */
 				if (mmc_send_app_op_cond(host, 0, &ocr))
 					goto out_fail;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-i915-intel_overlayc-needs-seq_fileh.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc-make-id-freq-configurable-checkpatch-fixes.patch
sdhci-get-rid-of-card-detect-work-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

