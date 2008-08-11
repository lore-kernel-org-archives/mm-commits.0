From: akpm@linux-foundation.org
Subject: + viafb-accelc-accelh-checkpatch-fixes.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:11:23 -0700
Message-ID: <200808112311.m7BNBO5F026860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbYHKXME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm


The patch titled
     viafb-accelc-accelh-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     viafb-accelc-accelh-checkpatch-fixes.patch

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
Subject: viafb-accelc-accelh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: open brace '{' following function declarations go on the next line
#222: FILE: drivers/video/via/accel.c:204:
+void viafb_show_hw_cursor(struct fb_info *info, int Status) {

WARNING: suspect code indent for conditional statements
#249: FILE: drivers/video/via/accel.c:231:
+	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)

WARNING: suspect code indent for conditional statements
#253: FILE: drivers/video/via/accel.c:235:
+	while ((MMIO_IN32(VIA_REG_STATUS) &

total: 1 errors, 2 warnings, 421 lines checked

./patches/viafb-accelc-accelh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-accelc-accelh-checkpatch-fixes drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-accelc-accelh-checkpatch-fixes
+++ a/drivers/video/via/accel.c
@@ -201,7 +201,8 @@ void viafb_hw_cursor_init(void)
 	MMIO_OUT32(VIA_REG_CURSOR_FG, 0x0);
 }
 
-void viafb_show_hw_cursor(struct fb_info *info, int Status) {
+void viafb_show_hw_cursor(struct fb_info *info, int Status)
+{
 	u32 temp;
 	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
 
@@ -222,20 +223,21 @@ void viafb_show_hw_cursor(struct fb_info
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp); }
+	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+}
 
 int viafb_wait_engine_idle(void)
 {
 	int loop = 0;
 
-	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)
-	       && (loop++ < MAXLOOP))
-	       cpu_relax();
+	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) &&
+			(loop++ < MAXLOOP))
+		cpu_relax();
 
 	while ((MMIO_IN32(VIA_REG_STATUS) &
-		(VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
-	       (loop++ < MAXLOOP))
-	       cpu_relax();
+		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
+		    (loop++ < MAXLOOP))
+		cpu_relax();
 
 	return loop >= MAXLOOP;
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

