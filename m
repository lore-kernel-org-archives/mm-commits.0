From: akpm@linux-foundation.org
Subject: + common-implementation-of-iterative-div-mod-fix.patch added to -mm tree
Date: Thu, 08 May 2008 13:27:53 -0700
Message-ID: <200805082027.m48KRrDA004248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411AbYEHU3K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hancockr@shaw.ca, jeremy.fitzhardinge@citrix.com, jeremy@goop.org, johnstul@us.ibm.com, lists@nerdbynature.de, mingo@elte.hu, segher@kernel.crashing.org, tglx@linutronix.de


The patch titled
     common-implementation-of-iterative-div-mod-fix
has been added to the -mm tree.  Its filename is
     common-implementation-of-iterative-div-mod-fix.patch

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
Subject: common-implementation-of-iterative-div-mod-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math64.h |    2 +-
 lib/div64.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/math64.h~common-implementation-of-iterative-div-mod-fix include/linux/math64.h
--- a/include/linux/math64.h~common-implementation-of-iterative-div-mod-fix
+++ a/include/linux/math64.h
@@ -81,6 +81,6 @@ static inline s64 div_s64(s64 dividend, 
 }
 #endif
 
-unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
+u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder);
 
 #endif /* _LINUX_MATH64_H */
diff -puN lib/div64.c~common-implementation-of-iterative-div-mod-fix lib/div64.c
--- a/lib/div64.c~common-implementation-of-iterative-div-mod-fix
+++ a/lib/div64.c
@@ -103,9 +103,9 @@ EXPORT_SYMBOL(div64_u64);
  * Iterative div/mod for use when dividend is not expected to be much
  * bigger than divisor.
  */
-unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
+u32 iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 {
-	unsigned ret = 0;
+	u32 ret = 0;
 
 	while(dividend >= divisor) {
 		/* The following asm() prevents the compiler from
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
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
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
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
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

