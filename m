From: akpm@linux-foundation.org
Subject: + fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch added to -mm tree
Date: Mon, 26 Jul 2010 17:29:30 -0700
Message-ID: <201007270029.o6R0TaeO018577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab0G0A3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 20:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, lkundrak@v3.sk, viro@ZenIV.linux.org.uk


The patch titled
     fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes.patch

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
Subject: fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#52: FILE: fs/sysv/super.c:456:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {

WARNING: braces {} are not necessary for single statement blocks
#52: FILE: fs/sysv/super.c:456:
+	if ((bh2 = sb_bread(sb, 2)) == NULL) {
+		return 0;
+	}

ERROR: code indent should use tabs where possible
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: please, no space for starting a line, 
				excluding comments
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {$

WARNING: space prohibited between function name and open parenthesis '('
#61: FILE: fs/sysv/super.c:465:
+             sizeof (struct sysv_dir_entry))) {

WARNING: space prohibited between function name and open parenthesis '('
#97: FILE: fs/sysv/super.c:504:
+	if (v7_sanity_check (sb, bh))

WARNING: space prohibited between function name and open parenthesis '('
#115: FILE: fs/sysv/super.c:509:
+	if (v7_sanity_check (sb, bh))

WARNING: printk() should include KERN_ facility level
#128: FILE: fs/sysv/super.c:521:
+	printk("VFS: could not find a valid V7 on %s.\n", sb->s_id);

total: 2 errors, 6 warnings, 109 lines checked

./patches/fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/sysv/super.c~fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes fs/sysv/super.c
--- a/fs/sysv/super.c~fs-sysv-superc-add-support-for-non-pdp11-v7-filesystems-checkpatch-fixes
+++ a/fs/sysv/super.c
@@ -453,16 +453,16 @@ static int v7_sanity_check(struct super_
 
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
@@ -501,12 +501,12 @@ static int v7_fill_super(struct super_bl
 
 	/* Try PDP-11 UNIX */
 	sbi->s_bytesex = BYTESEX_PDP;
-	if (v7_sanity_check (sb, bh))
+	if (v7_sanity_check(sb, bh))
 		goto detected;
 
 	/* Try PC/IX, v7/x86 */
 	sbi->s_bytesex = BYTESEX_LE;
-	if (v7_sanity_check (sb, bh))
+	if (v7_sanity_check(sb, bh))
 		goto detected;
 
 	goto failed;
@@ -518,7 +518,8 @@ detected:
 		return 0;
 
 failed:
-	printk("VFS: could not find a valid V7 on %s.\n", sb->s_id);
+	printk(KERN_ERR "VFS: could not find a valid V7 on %s.\n",
+		sb->s_id);
 	brelse(bh);
 	kfree(sbi);
 	return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
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
fs-squashfs-xattrc-fix-warning.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
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
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
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

