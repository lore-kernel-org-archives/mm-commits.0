From: akpm@linux-foundation.org
Subject: - e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 18 Aug 2008 14:35:30 -0700
Message-ID: <200808182135.m7ILZUlw013955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYHRVgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#106: FILE: drivers/net/e1000e/netdev.c:4245:
+^I                                  pci_select_bars(pdev, IORESOURCE_MEM),$

ERROR: code indent should use tabs where possible
#107: FILE: drivers/net/e1000e/netdev.c:4246:
+^I                                  e1000e_driver_name);$

ERROR: code indent should use tabs where possible
#126: FILE: drivers/net/e1000e/netdev.c:4510:
+^I                             pci_select_bars(pdev, IORESOURCE_MEM));$

ERROR: code indent should use tabs where possible
#136: FILE: drivers/net/e1000e/netdev.c:4559:
+^I                             pci_select_bars(pdev, IORESOURCE_MEM));$

total: 4 errors, 0 warnings, 109 lines checked

./patches/e1000e-remove-inapplicable-test-for-ioport.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes
+++ a/drivers/net/e1000e/netdev.c
@@ -4242,8 +4242,8 @@ static int __devinit e1000_probe(struct 
 	}
 
 	err = pci_request_selected_regions(pdev,
-	                                  pci_select_bars(pdev, IORESOURCE_MEM),
-	                                  e1000e_driver_name);
+					  pci_select_bars(pdev, IORESOURCE_MEM),
+					  e1000e_driver_name);
 	if (err)
 		goto err_pci_reg;
 
@@ -4507,7 +4507,7 @@ err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
 	pci_release_selected_regions(pdev,
-	                             pci_select_bars(pdev, IORESOURCE_MEM));
+				     pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_reg:
 err_dma:
 	pci_disable_device(pdev);
@@ -4556,7 +4556,7 @@ static void __devexit e1000_remove(struc
 	if (adapter->hw.flash_address)
 		iounmap(adapter->hw.flash_address);
 	pci_release_selected_regions(pdev,
-	                             pci_select_bars(pdev, IORESOURCE_MEM));
+				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	free_netdev(netdev);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-self-maps-doesnt-display-the-real-file-offset-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
ftrace-printk-formatting-infrastructure.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-watchdog.patch
git-xtensa.patch
drivers-char-ipmi-ipmi_si_intfc-default_find_bmc-fix-leak.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-media-video-gspca-zc3xxc-fix-oops-checkpatch-fixes.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
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
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
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

