From: akpm@linux-foundation.org
Subject: - utimensat-non-conformances-and-fixes-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 30 Apr 2008 10:49:00 -0700
Message-ID: <200804301749.m3UHn0uj026630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758246AbYD3Rtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mtk.manpages@gmail.com, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     utimensat-non-conformances-and-fixes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     utimensat-non-conformances-and-fixes-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utimensat-non-conformances-and-fixes-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited after that '!' (ctx:WxW)
#429: FILE: fs/utimes.c:102:
+	if (times && ! ((times[0].tv_nsec == UTIME_NOW &&
 	             ^

ERROR: code indent should use tabs where possible
#436: FILE: fs/utimes.c:108:
+                        goto mnt_drop_write_and_out;$

total: 2 errors, 0 warnings, 59 lines checked

./patches/utimensat-non-conformances-and-fixes.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/utimes.c~utimensat-non-conformances-and-fixes-checkpatch-fixes fs/utimes.c
--- a/fs/utimes.c~utimensat-non-conformances-and-fixes-checkpatch-fixes
+++ a/fs/utimes.c
@@ -99,13 +99,13 @@ long do_utimes(int dfd, char __user *fil
 
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
-	if (times && ! ((times[0].tv_nsec == UTIME_NOW &&
+	if (times && !((times[0].tv_nsec == UTIME_NOW &&
 			 times[1].tv_nsec == UTIME_NOW) ||
 			(times[0].tv_nsec == UTIME_OMIT &&
 			 times[1].tv_nsec == UTIME_OMIT))) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-                        goto mnt_drop_write_and_out;
+			goto mnt_drop_write_and_out;
 
 		if (times[0].tv_nsec == UTIME_OMIT) {
 			newattrs.ia_atime = inode->i_atime;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
fuse-fix-race-in-llseek.patch
basic-braille-screen-reader-support.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
revert-memory-hotplug-allocate-usemap-on-the-section-with-pgdat.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
git-arm-fixup.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
tuner_symbol_probe-dont-do-symbol_put-if-symbol_request-failed.patch
drivers-media-video-tuner-corec-tuner_probe-fix-error-check.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

