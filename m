From: akpm@linux-foundation.org
Subject: + mmc-move-regulator-handling-closer-to-core-v3-fix.patch added to -mm tree
Date: Wed, 08 Sep 2010 16:03:19 -0700
Message-ID: <201009082303.o88N3Jht015009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606Ab0IHXEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 19:04:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adrian.hunter@nokia.com, broonie@opensource.wolfsonmicro.com, cbrake@bec-systems.com, daniel@caiaq.de, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com, jarkko.lavinen@nokia.com, linus.walleij@stericsson.com, linux-mmc@vger.kernel.org, lrg@slimlogic.co.uk, matt@console-pimps.org, pierre@ossman.eu, rmk+kernel@arm.linux.org.uk, robert.jarzmik@free.fr, sundar.iyer@stericsson.com, tony@atomide.com


The patch titled
     mmc-move-regulator-handling-closer-to-core-v3-fix
has been added to the -mm tree.  Its filename is
     mmc-move-regulator-handling-closer-to-core-v3-fix.patch

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
Subject: mmc-move-regulator-handling-closer-to-core-v3-fix
From: Andrew Morton <akpm@linux-foundation.org>

- regularise the inline definitions

- make them static

- fixes a checkpatch warning

Cc: <linux-mmc@vger.kernel.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Cliff Brake <cbrake@bec-systems.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmc/host.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmc/host.h~mmc-move-regulator-handling-closer-to-core-v3-fix include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-move-regulator-handling-closer-to-core-v3-fix
+++ a/include/linux/mmc/host.h
@@ -265,12 +265,12 @@ int mmc_regulator_set_ocr(struct mmc_hos
 			struct regulator *supply,
 			unsigned short vdd_bit);
 #else
-int inline mmc_regulator_get_ocrmask(struct regulator *supply)
+static inline int mmc_regulator_get_ocrmask(struct regulator *supply)
 {
 	return 0;
 }
 
-int inline mmc_regulator_set_ocr(struct mmc_host *mmc,
+static inline int mmc_regulator_set_ocr(struct mmc_host *mmc,
 				 struct regulator *supply,
 				 unsigned short vdd_bit)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
cgroups-fix-api-thinko-fix.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-vmap-area-cache.patch
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
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
sdhci-support-10-bit-divided-clock-mode-for-spec-30-checkpatch-fixes.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
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

