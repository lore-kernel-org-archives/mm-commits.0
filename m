From: akpm@linux-foundation.org
Subject: + viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:21:06 -0700
Message-ID: <200808112321.m7BNL7Iw027315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbYHKXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, jirislaby@gmail.com, josephchan@via.com.tw, krzysztof.h1@poczta.fm


The patch titled
     viafb-viafbdevc-viafbdevh-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch

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
Subject: viafb-viafbdevc-viafbdevh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements
#306: FILE: drivers/video/via/viafbdev.c:285:
+	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {

WARNING: suspect code indent for conditional statements
#408: FILE: drivers/video/via/viafbdev.c:387:
+	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {

WARNING: suspect code indent for conditional statements
#585: FILE: drivers/video/via/viafbdev.c:564:
+		if (copy_to_user(argp, viaparinfo->chip_info,

WARNING: suspect code indent for conditional statements
#782: FILE: drivers/video/via/viafbdev.c:761:
+		if (copy_from_user

WARNING: suspect code indent for conditional statements
#1377: FILE: drivers/video/via/viafbdev.c:1356:
+	if ((active_dev.samm == STATE_OFF)

total: 0 errors, 5 warnings, 2675 lines checked

./patches/viafb-viafbdevc-viafbdevh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-viafbdevc-viafbdevh-checkpatch-fixes drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-viafbdevc-viafbdevh-checkpatch-fixes
+++ a/drivers/video/via/viafbdev.c
@@ -283,7 +283,9 @@ unsigned blue, unsigned transp, struct f
 	if (regno >= cmap_entries)
 		return 1;
 	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-	/* Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev. */
+		/*
+		 * Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev.
+		 */
 		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
 		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
 	}
@@ -385,7 +387,10 @@ static int viafb_setcmap(struct fb_cmap 
 	if (len > 256)
 		return 1;
 	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-	/* Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip rev. */
+		/*
+		 * Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip
+		 * rev.
+		 */
 		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
 		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
 	}
@@ -562,8 +567,8 @@ static int viafb_ioctl(struct fb_info *i
 	switch (cmd) {
 	case VIAFB_GET_CHIP_INFO:
 		if (copy_to_user(argp, viaparinfo->chip_info,
-		sizeof(struct chip_information)))
-		return -EFAULT;
+				sizeof(struct chip_information)))
+			return -EFAULT;
 		break;
 	case VIAFB_GET_INFO_SIZE:
 		return put_user(viainfo_size, argp);
@@ -758,10 +763,10 @@ static int viafb_ioctl(struct fb_info *i
 		viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
 		if (!viafb_gamma_table)
 			return -ENOMEM;
-		if (copy_from_user
-		    (viafb_gamma_table, argp, sizeof(viafb_gamma_table))) {
-		    kfree(viafb_gamma_table);
-		    return -EFAULT;
+		if (copy_from_user(viafb_gamma_table, argp,
+				sizeof(viafb_gamma_table))) {
+			kfree(viafb_gamma_table);
+			return -EFAULT;
 		}
 		viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
 		kfree(viafb_gamma_table);
@@ -1353,9 +1358,8 @@ static void viafb_set_device(struct devi
 		viafb_refresh = active_dev.refresh;
 	if (active_dev.refresh1 != 0)
 		viafb_refresh1 = active_dev.refresh1;
-	if ((active_dev.samm == STATE_OFF)
-	    || (active_dev.samm == STATE_ON))
-	    viafb_SAMM_ON = active_dev.samm;
+	if ((active_dev.samm == STATE_OFF) || (active_dev.samm == STATE_ON))
+		viafb_SAMM_ON = active_dev.samm;
 	viafb_primary_dev = active_dev.primary_dev;
 
 	viafb_set_start_addr();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-robustify-printk-fix.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix-fix.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
sched-type-fix.patch
lockdep-spin_lock_nest_lock-fix-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

