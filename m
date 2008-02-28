From: akpm@linux-foundation.org
Subject: + maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Feb 2008 18:23:21 -0800
Message-ID: <200802280223.m1S2NLfm011108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbYB1CXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 21:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adrian@mcmen.demon.co.uk, adrian@newgolddream.dyndns.info, dtor@mail.ru, lethal@linux-sh.org


The patch titled
     maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch

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
Subject: maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need a space before the open brace '{'
#79: FILE: drivers/input/joystick/maplecontrol.c:86:
+	if (!pad){

WARNING: line over 80 characters
#98: FILE: drivers/input/joystick/maplecontrol.c:103:
+			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |= BIT_MASK(btn_bit[i]);

total: 1 errors, 1 warnings, 123 lines checked

./patches/maple-add-driver-for-sega-dreamcast-controller-update.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/maplecontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/input/joystick/maplecontrol.c~maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes drivers/input/joystick/maplecontrol.c
--- a/drivers/input/joystick/maplecontrol.c~maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes
+++ a/drivers/input/joystick/maplecontrol.c
@@ -83,7 +83,7 @@ static int dc_pad_connect(struct maple_d
 	};
 
 	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
-	if (!pad){
+	if (!pad) {
 		error = ENOMEM;
 		goto fail_nomem_1;
 	}
@@ -100,7 +100,8 @@ static int dc_pad_connect(struct maple_d
 
 	for (i = 0; i < 32; i++)
 		if (data & (1<<i) && btn_bit[i] >= 0)
-			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |= BIT_MASK(btn_bit[i]);
+			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |=
+					BIT_MASK(btn_bit[i]);
 
 	if (pad->dev->keybit[BTN_JOYSTICK/32])
 		pad->dev->evbit[0] |= BIT_MASK(EV_KEY);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
git-x86.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
git-v9fs.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
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
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
