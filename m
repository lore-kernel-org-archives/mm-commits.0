From: akpm@linux-foundation.org
Subject: + make-b43_mac_enablesuspend-static.patch added to -mm tree
Date: Tue, 05 Feb 2008 01:43:52 -0800
Message-ID: <200802050943.m159hXAU014494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbYBEJnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 04:43:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mb@bu3sch.de


The patch titled
     make b43_mac_{enable,suspend}() static
has been added to the -mm tree.  Its filename is
     make-b43_mac_enablesuspend-static.patch

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
Subject: make b43_mac_{enable,suspend}() static
From: Adrian Bunk <bunk@kernel.org>

b43_mac_{enable,suspend}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/main.c |    4 ++--
 drivers/net/wireless/b43/main.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.c
@@ -2043,7 +2043,7 @@ static void b43_gpio_cleanup(struct b43_
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-void b43_mac_enable(struct b43_wldev *dev)
+static void b43_mac_enable(struct b43_wldev *dev)
 {
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
@@ -2067,7 +2067,7 @@ void b43_mac_enable(struct b43_wldev *de
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-void b43_mac_suspend(struct b43_wldev *dev)
+static void b43_mac_suspend(struct b43_wldev *dev)
 {
 	int i;
 	u32 tmp;
diff -puN drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static drivers/net/wireless/b43/main.h
--- a/drivers/net/wireless/b43/main.h~make-b43_mac_enablesuspend-static
+++ a/drivers/net/wireless/b43/main.h
@@ -102,9 +102,6 @@ void b43_dummy_transmission(struct b43_w
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
-void b43_mac_suspend(struct b43_wldev *dev);
-void b43_mac_enable(struct b43_wldev *dev);
-
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-aic94xx-cleanups.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
