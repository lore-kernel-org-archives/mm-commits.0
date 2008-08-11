From: akpm@linux-foundation.org
Subject: + viafb-hwc-hwh-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:13:57 -0700
Message-ID: <200808112313.m7BNDv8D026988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYHKXOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm


The patch titled
     viafb-hwc-hwh-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     viafb-hwc-hwh-checkpatch-fixes.patch

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
Subject: viafb-hwc-hwh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing statements should be on next line
#1022: FILE: drivers/video/via/hw.c:1004:
+	while ((i < NUM_TOTAL_MODETABLE)

ERROR: trailing statements should be on next line
#1041: FILE: drivers/video/via/hw.c:1023:
+	while ((i < NUM_TOTAL_CEA_MODES)

WARNING: suspect code indent for conditional statements
#1048: FILE: drivers/video/via/hw.c:1030:
+		while ((i < NUM_TOTAL_MODETABLE)

total: 2 errors, 1 warnings, 3796 lines checked

./patches/viafb-hwc-hwh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-hwc-hwh-checkpatch-fixes drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-hwc-hwh-checkpatch-fixes
+++ a/drivers/video/via/hw.c
@@ -1001,9 +1001,10 @@ static int search_mode_setting(int ModeI
 {
 	int i = 0;
 
-	while ((i < NUM_TOTAL_MODETABLE)
-	       && (ModeInfoIndex != CLE266Modes[i].ModeIndex)) i++;
-	if ((i >= NUM_TOTAL_MODETABLE))
+	while ((i < NUM_TOTAL_MODETABLE) &&
+			(ModeInfoIndex != CLE266Modes[i].ModeIndex))
+		i++;
+	if (i >= NUM_TOTAL_MODETABLE)
 		i = 0;
 	return i;
 
@@ -1020,17 +1021,18 @@ struct VideoModeTable *viafb_get_cea_mod
 {
 	struct VideoModeTable *TmpTbl = NULL;
 	int i = 0;
-	while ((i < NUM_TOTAL_CEA_MODES)
-	       && (Index != CEA_HDMI_Modes[i].ModeIndex)) i++;
+	while ((i < NUM_TOTAL_CEA_MODES) &&
+			(Index != CEA_HDMI_Modes[i].ModeIndex))
+		i++;
 	if ((i < NUM_TOTAL_CEA_MODES))
 		TmpTbl = &CEA_HDMI_Modes[i];
 	 else {
 		/*Still use general timing if don't find CEA timing */
 		i = 0;
-		while ((i < NUM_TOTAL_MODETABLE)
-		       && (Index != CLE266Modes[i].ModeIndex))
+		while ((i < NUM_TOTAL_MODETABLE) &&
+				(Index != CLE266Modes[i].ModeIndex))
 		       i++;
-		if ((i >= NUM_TOTAL_MODETABLE))
+		if (i >= NUM_TOTAL_MODETABLE)
 			i = 0;
 		TmpTbl = &CLE266Modes[i];
 	}
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

