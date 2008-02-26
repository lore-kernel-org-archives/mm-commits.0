From: akpm@linux-foundation.org
Subject: + sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:58 -0800
Message-ID: <200802261916.m1QJGopY004212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758376AbYBZTRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben-linux@fluff.org, syrjala@sci.fi


The patch titled
     sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need spaces around that '=' (ctx:VxV)
#185: FILE: drivers/mfd/sm501.c:563:
+			reg=to.shift & 0x07;/* bottom 3 bits are shift */
 			   ^

ERROR: need spaces around that '=' (ctx:VxV)
#195: FILE: drivers/mfd/sm501.c:573:
+			reg=to.shift & 0x07;/* bottom 3 bits are shift */
 			   ^

total: 2 errors, 0 warnings, 250 lines checked

./patches/sm501-add-support-for-the-sm502-programmable-pll.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes
+++ a/drivers/mfd/sm501.c
@@ -560,7 +560,7 @@ unsigned long sm501_set_clock(struct dev
 			/* SM502 -> use the programmable PLL */
 			sm501_freq = (sm501_calc_pll(2 * req_freq,
 						     &to, 5) / 2);
-			reg=to.shift & 0x07;/* bottom 3 bits are shift */
+			reg = to.shift & 0x07;/* bottom 3 bits are shift */
 			if (to.divider == 3)
 				reg |= 0x08; /* /3 divider required */
 			else if (to.divider == 5)
@@ -570,7 +570,7 @@ unsigned long sm501_set_clock(struct dev
 		} else {
 			sm501_freq = (sm501_select_clock(2 * req_freq,
 							 &to, 5) / 2);
-			reg=to.shift & 0x07;/* bottom 3 bits are shift */
+			reg = to.shift & 0x07;/* bottom 3 bits are shift */
 			if (to.divider == 3)
 				reg |= 0x08; /* /3 divider required */
 			else if (to.divider == 5)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

rtc-add-support-for-the-s-35390a-rtc-chip.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fix-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
