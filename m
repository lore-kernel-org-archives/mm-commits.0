From: akpm@linux-foundation.org
Subject: + revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch added to -mm tree
Date: Wed, 07 May 2008 18:10:38 -0700
Message-ID: <200805080110.m481Ac7N026311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287AbYEHBLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 21:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JRottmann@LiPPERT-AT.de, adaplas@pol.net, dilinger@queued.net, jordan.crouse@amd.com


The patch titled
     revert "lxfb: extend PLL table to support dotclocks below 25 MHz"
has been added to the -mm tree.  Its filename is
     revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch

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
Subject: revert "lxfb: extend PLL table to support dotclocks below 25 MHz"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 3888d4639e78802c4ec1086127124e890461b9e4
Author: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Date:   Mon Apr 28 02:15:22 2008 -0700

    lxfb: extend PLL table to support dotclocks below 25 MHz
    
    Extends the PLL frequency table of the AMD Geode-LX frame buffer driver to
    make use of the DIV4 bit, thus adding support for dotclocks between 6 and 25
    MHz.  These are needed for small LCDs (e.g.  320x240).  Also inserts some
    intermediate steps between pre-existing frequencies.

Andreas says:

Without this patch, I get the following (correct) output from the lxfb
and console code:

[    0.939827] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
[    1.009194] Console: switching to colour frame buffer device 150x56     

Without it, the cols/width is screwy (and I get a blank white screen):

[   20.706836] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
[   20.788538] Console: switching to colour frame buffer device 100x40          

Cc: Andres Salomon <dilinger@queued.net>
Cc: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |  112 ++++++++-----------------------
 1 file changed, 31 insertions(+), 81 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz
+++ a/drivers/video/geode/lxfb_ops.c
@@ -35,85 +35,35 @@ static const struct {
   unsigned int pllval;
   unsigned int freq;
 } pll_table[] = {
-  { 0x000131AC,   6231 },
-  { 0x0001215D,   6294 },
-  { 0x00011087,   6750 },
-  { 0x0001216C,   7081 },
-  { 0x0001218D,   7140 },
-  { 0x000110C9,   7800 },
-  { 0x00013147,   7875 },
-  { 0x000110A7,   8258 },
-  { 0x00012159,   8778 },
-  { 0x00014249,   8875 },
-  { 0x00010057,   9000 },
-  { 0x0001219A,   9472 },
-  { 0x00012158,   9792 },
-  { 0x00010045,  10000 },
-  { 0x00010089,  10791 },
-  { 0x000110E7,  11225 },
-  { 0x00012136,  11430 },
-  { 0x00013207,  12375 },
-  { 0x00012187,  12500 },
-  { 0x00014286,  14063 },
-  { 0x000110E5,  15016 },
-  { 0x00014214,  16250 },
-  { 0x00011105,  17045 },
-  { 0x000131E4,  18563 },
-  { 0x00013183,  18750 },
-  { 0x00014284,  19688 },
-  { 0x00011104,  20400 },
-  { 0x00016363,  23625 },
-  { 0x00015303,  24380 },
-  { 0x000031AC,  24923 },
-  { 0x0000215D,  25175 },
-  { 0x00001087,  27000 },
-  { 0x0000216C,  28322 },
-  { 0x0000218D,  28560 },
-  { 0x00010041,  29913 },
-  { 0x000010C9,  31200 },
-  { 0x00003147,  31500 },
-  { 0x000141A1,  32400 },
-  { 0x000010A7,  33032 },
-  { 0x00012182,  33375 },
-  { 0x000141B1,  33750 },
-  { 0x00002159,  35112 },
-  { 0x00004249,  35500 },
-  { 0x00000057,  36000 },
-  { 0x000141E1,  37125 },
-  { 0x0000219A,  37889 },
-  { 0x00002158,  39168 },
-  { 0x00000045,  40000 },
-  { 0x000131A1,  40500 },
-  { 0x00010061,  42301 },
-  { 0x00000089,  43163 },
-  { 0x00012151,  43875 },
-  { 0x000010E7,  44900 },
-  { 0x00002136,  45720 },
-  { 0x000152E1,  47250 },
-  { 0x00010071,  48000 },
-  { 0x00003207,  49500 },
-  { 0x00002187,  50000 },
-  { 0x00014291,  50625 },
-  { 0x00011101,  51188 },
-  { 0x00017481,  54563 },
-  { 0x00004286,  56250 },
-  { 0x00014170,  57375 },
-  { 0x00016210,  58500 },
-  { 0x000010E5,  60065 },
-  { 0x00013140,  62796 },
-  { 0x00004214,  65000 },
-  { 0x00016250,  65250 },
-  { 0x00001105,  68179 },
-  { 0x000141C0,  69600 },
-  { 0x00015220,  70160 },
-  { 0x00010050,  72000 },
-  { 0x000031E4,  74250 },
-  { 0x00003183,  75000 },
-  { 0x00004284,  78750 },
-  { 0x00012130,  80052 },
-  { 0x00001104,  81600 },
-  { 0x00006363,  94500 },
-  { 0x00005303,  97520 },
+  { 0x000031AC, 24923 },
+  { 0x0000215D, 25175 },
+  { 0x00001087, 27000 },
+  { 0x0000216C, 28322 },
+  { 0x0000218D, 28560 },
+  { 0x000010C9, 31200 },
+  { 0x00003147, 31500 },
+  { 0x000010A7, 33032 },
+  { 0x00002159, 35112 },
+  { 0x00004249, 35500 },
+  { 0x00000057, 36000 },
+  { 0x0000219A, 37889 },
+  { 0x00002158, 39168 },
+  { 0x00000045, 40000 },
+  { 0x00000089, 43163 },
+  { 0x000010E7, 44900 },
+  { 0x00002136, 45720 },
+  { 0x00003207, 49500 },
+  { 0x00002187, 50000 },
+  { 0x00004286, 56250 },
+  { 0x000010E5, 60065 },
+  { 0x00004214, 65000 },
+  { 0x00001105, 68179 },
+  { 0x000031E4, 74250 },
+  { 0x00003183, 75000 },
+  { 0x00004284, 78750 },
+  { 0x00001104, 81600 },
+  { 0x00006363, 94500 },
+  { 0x00005303, 97520 },
   { 0x00002183, 100187 },
   { 0x00002122, 101420 },
   { 0x00001081, 108000 },
@@ -188,7 +138,7 @@ static void lx_set_clock(struct fb_info 
 	unsigned int diff, min, best = 0;
 	unsigned int freq, i;
 
-	freq = (unsigned int) (1000000000 / info->var.pixclock);
+	freq = (unsigned int) (0x3b9aca00 / info->var.pixclock);
 
 	min = abs(pll_table[0].freq - freq);
 
@@ -200,7 +150,7 @@ static void lx_set_clock(struct fb_info 
 		}
 	}
 
-	lx_set_dotpll(pll_table[best].pllval & 0x00017FFF);
+	lx_set_dotpll(pll_table[best].pllval & 0x7FFF);
 }
 
 static void lx_graphics_disable(struct fb_info *info)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
linux-next.patch
linux-next-fixup.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
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

