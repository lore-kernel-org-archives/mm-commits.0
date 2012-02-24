From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 24 Feb 2012 13:15:23 -0800
Message-ID: <20120224215840.4CCAC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47709 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2BXV6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 16:58:42 -0500
Received: by werb13 with SMTP id b13so103804wer.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 13:58:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_trans_dquot.c      |   20 --------------------
 sound/pci/hda/patch_realtek.c |   11 -----------
 2 files changed, 31 deletions(-)

diff -puN fs/xfs/xfs_trans_dquot.c~linux-next-git-rejects fs/xfs/xfs_trans_dquot.c
--- a/fs/xfs/xfs_trans_dquot.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_trans_dquot.c
@@ -648,22 +648,12 @@ xfs_trans_dqresv(
 			 * hardlimit or exceed the timelimit if we allocate
 			 * nblks.
 			 */
-<<<<<<< HEAD
-			if (hardlimit > 0ULL &&
-			    hardlimit < nblks + *resbcountp) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
-				goto error_return;
-			}
-			if (softlimit > 0ULL &&
-			    softlimit < nblks + *resbcountp) {
-=======
 			total_count = *resbcountp + nblks;
 			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
->>>>>>> linux-next/akpm-end
 				if ((timer != 0 && get_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
@@ -686,21 +676,11 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-<<<<<<< HEAD
-			if (hardlimit > 0ULL &&
-			    hardlimit < ninos + count) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
-				goto error_return;
-			}
-			if (softlimit > 0ULL &&
-			    softlimit < ninos + count) {
-=======
 			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
->>>>>>> linux-next/akpm-end
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -3461,21 +3461,10 @@ static int alc_auto_fill_dac_nids(struct
 			alc_look_for_out_vol_nid(codec, cfg->line_out_pins[0],
 						 spec->multiout.dac_nids[0]);
 
-<<<<<<< HEAD
-static inline unsigned int get_ctl_pos(unsigned int data)
-{
-	hda_nid_t nid = get_amp_nid_(data);
-	unsigned int dir;
-	if (snd_BUG_ON(nid >= MAX_VOL_NIDS))
-		return 0;
-	dir = get_amp_direction_(data);
-	return (nid << 1) | dir;
-=======
 	/* clear the bitmap flags for creating controls */
 	clear_vol_marks(codec);
 	kfree(best_cfg);
 	return 0;
->>>>>>> linux-next/akpm-end
 }
 
 static int alc_auto_add_vol_ctl(struct hda_codec *codec,
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
ata-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics-v2-fix.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines-fix-fix.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
percpu-remove-percpu_xxx-functions-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

