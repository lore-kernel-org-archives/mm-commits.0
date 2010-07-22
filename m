From: akpm@linux-foundation.org
Subject: + fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch added to -mm tree
Date: Thu, 22 Jul 2010 16:08:22 -0700
Message-ID: <201007222308.o6MN8N9v017583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0GVXIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 19:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, lkundrak@v3.sk


The patch titled
     fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch

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
Subject: fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#54: FILE: fs/sysv/super.c:457:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {

WARNING: braces {} are not necessary for single statement blocks
#54: FILE: fs/sysv/super.c:457:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+		return 0;
+	}

ERROR: code indent should use tabs where possible
#63: FILE: fs/sysv/super.c:466:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: please, no space for starting a line, 
				excluding comments
#63: FILE: fs/sysv/super.c:466:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: space prohibited between function name and open parenthesis '('
#63: FILE: fs/sysv/super.c:466:
+             sizeof (struct sysv_dir_entry))) {

total: 2 errors, 3 warnings, 72 lines checked

./patches/fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/sysv/super.c~fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
+++ a/fs/sysv/super.c
@@ -454,16 +454,16 @@ static int v7_sanity_check(struct super_
 
 	/* plausibility check on root inode: it is a directory,
 	   with a nonzero size that is a multiple of 16 */
-	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+	bh2 = sb_bread(sb, 2);
+	if (bh2 == NULL)
 		return 0;
-	}
 
 	v7i = (struct sysv_inode *)(bh2->b_data + 64);
 	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
 	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
 	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
 	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
-             sizeof (struct sysv_dir_entry))) {
+	     sizeof(struct sysv_dir_entry))) {
 		brelse(bh2);
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-driver-core-remove-config_sysfs_deprecated.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-squashfs-xattrc-fix-warning.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions.patch
serial-mmio32-support-for-8250_earlyc.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-disable.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
fs-sysv-v7-adjust-sanity-checks-for-some-volumes-checkpatch-fixes.patch
fs-sysv-v7-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch
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

