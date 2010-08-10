From: akpm@linux-foundation.org
Subject: + fix-hwmon-coretemp-update-hotplug-condition-check.patch added to -mm tree
Date: Tue, 10 Aug 2010 14:14:45 -0700
Message-ID: <201008102114.o7ALEltw016513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932210Ab0HJVQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Aug 2010 17:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz, rjw@sisk.pl


The patch titled
     fix "hwmon: coretemp: update hotplug condition check"
has been added to the -mm tree.  Its filename is
     fix-hwmon-coretemp-update-hotplug-condition-check.patch

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
Subject: fix "hwmon: coretemp: update hotplug condition check"
From: Andrew Morton <akpm@linux-foundation.org>

With

: commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae
: Author: Chen Gong <gong.chen@linux.intel.com>
: Date:   Mon Aug 9 17:21:09 2010 -0700
:
:    hwmon: coretemp: update hotplug condition check

we merged v2 of this patch.  Update that to v3.

The difference is to remove the new and unnecesary references to
CPU_*_FROZEN.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/hwmon/coretemp.c~fix-hwmon-coretemp-update-hotplug-condition-check drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~fix-hwmon-coretemp-update-hotplug-condition-check
+++ a/drivers/hwmon/coretemp.c
@@ -501,13 +501,10 @@ static int __cpuinit coretemp_cpu_callba
 
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		coretemp_device_add(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		coretemp_device_remove(cpu);
 		break;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-hwmon-coretemp-update-hotplug-condition-check.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages-update.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
drivers-video-igafbc-make-igafb_setup-and-igafb_init-static.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-cleanups.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
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

