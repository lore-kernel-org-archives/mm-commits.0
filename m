From: akpm@linux-foundation.org
Subject: - autofs4-collect-version-check-return-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 06 Nov 2008 12:46:40 -0800
Message-ID: <200811062046.mA6Kke83010173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYKFUr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 15:47:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmoyer@redhat.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4-collect-version-check-return-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     autofs4-collect-version-check-return-checkpatch-fixes.patch

This patch was dropped because it was folded into autofs4-collect-version-check-return.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4-collect-version-check-return-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#25: FILE: fs/autofs4/dev-ioctl.c:121:
+	if ((err = check_dev_ioctl_version(cmd, param))) {

total: 1 errors, 0 warnings, 11 lines checked

./patches/autofs4-collect-version-check-return.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return-checkpatch-fixes fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-collect-version-check-return-checkpatch-fixes
+++ a/fs/autofs4/dev-ioctl.c
@@ -130,7 +130,8 @@ static int validate_dev_ioctl(int cmd, s
 {
 	int err;
 
-	if ((err = check_dev_ioctl_version(cmd, param))) {
+	err = check_dev_ioctl_version(cmd, param);
+	if (err) {
 		AUTOFS_WARN("invalid device control module version "
 		     "supplied for cmd(0x%08x)", cmd);
 		goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
binfmtsh-include-listh-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
alsa-fix-snd_bug_on-and-friends.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch
ext4-quota-handling-for-delayed-allocation-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

