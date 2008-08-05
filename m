From: akpm@linux-foundation.org
Subject: + e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch added to -mm tree
Date: Mon, 04 Aug 2008 17:33:15 -0700
Message-ID: <200808050033.m750XF9n007938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759770AbYHEAdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 20:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com


The patch titled
     e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

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
mm_initc-avoid-ifdef-inside-macro-expansion.patch
pm_qos-spelling-fixes-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
drivers-media-video-vinoc-needs-v4l2-ioctlh.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
usb-hubc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
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
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
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

