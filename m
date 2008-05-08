From: akpm@linux-foundation.org
Subject: + memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch added to -mm tree
Date: Thu, 08 May 2008 12:58:08 -0700
Message-ID: <200805081958.m48Jw9qP002968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790AbYEHT65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:58:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, menage@google.com


The patch titled
     memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch

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
Subject: memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#43: FILE: include/linux/mm_types.h:229:
+        /*$

ERROR: code indent should use tabs where possible
#44: FILE: include/linux/mm_types.h:230:
+         * "owner" points to a task that is regarded as the canonical$

ERROR: code indent should use tabs where possible
#45: FILE: include/linux/mm_types.h:231:
+         * user/owner of this mm. All of the following must be true in$

ERROR: code indent should use tabs where possible
#46: FILE: include/linux/mm_types.h:232:
+         * order for it to be changed:$

ERROR: code indent should use tabs where possible
#47: FILE: include/linux/mm_types.h:233:
+         *$

ERROR: code indent should use tabs where possible
#48: FILE: include/linux/mm_types.h:234:
+         * current == mm->owner$

ERROR: code indent should use tabs where possible
#49: FILE: include/linux/mm_types.h:235:
+         * current->mm != mm$

ERROR: code indent should use tabs where possible
#50: FILE: include/linux/mm_types.h:236:
+         * new_owner->mm == mm$

ERROR: code indent should use tabs where possible
#51: FILE: include/linux/mm_types.h:237:
+         * new_owner->alloc_lock is held$

ERROR: code indent should use tabs where possible
#52: FILE: include/linux/mm_types.h:238:
+         */$

total: 10 errors, 0 warnings, 27 lines checked

./patches/memcg-fix-possible-panic-when-config_mm_owner=y.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Paul Menage" <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/mm_types.h~memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes include/linux/mm_types.h
--- a/include/linux/mm_types.h~memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes
+++ a/include/linux/mm_types.h
@@ -226,16 +226,16 @@ struct mm_struct {
 	rwlock_t		ioctx_list_lock;	/* aio lock */
 	struct kioctx		*ioctx_list;
 #ifdef CONFIG_MM_OWNER
-        /*
-         * "owner" points to a task that is regarded as the canonical
-         * user/owner of this mm. All of the following must be true in
-         * order for it to be changed:
-         *
-         * current == mm->owner
-         * current->mm != mm
-         * new_owner->mm == mm
-         * new_owner->alloc_lock is held
-         */
+	/*
+	 * "owner" points to a task that is regarded as the canonical
+	 * user/owner of this mm. All of the following must be true in
+	 * order for it to be changed:
+	 *
+	 * current == mm->owner
+	 * current->mm != mm
+	 * new_owner->mm == mm
+	 * new_owner->alloc_lock is held
+	 */
 	struct task_struct *owner;
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
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

