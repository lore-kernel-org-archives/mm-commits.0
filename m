From: akpm@linux-foundation.org
Subject: - drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:32 -0700
Message-ID: <200808082208.m78M8WaF031261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764671AbYHHWMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/netxen/netxen_nic_hw.c: fix printk warnings
has been removed from the -mm tree.  Its filename was
     drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/netxen/netxen_nic_hw.c: fix printk warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/netxen/netxen_nic_hw.c: In function 'netxen_nic_pci_mem_read_direct':
drivers/net/netxen/netxen_nic_hw.c:1414: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'
drivers/net/netxen/netxen_nic_hw.c: In function 'netxen_nic_pci_mem_write_direct':
drivers/net/netxen/netxen_nic_hw.c:1487: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

You don't know what type was used for u64 hence they cannot be printed without
casting.

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netxen/netxen_nic_hw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/netxen/netxen_nic_hw.c~drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings drivers/net/netxen/netxen_nic_hw.c
--- a/drivers/net/netxen/netxen_nic_hw.c~drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings
+++ a/drivers/net/netxen/netxen_nic_hw.c
@@ -1411,7 +1411,8 @@ static int netxen_nic_pci_mem_read_direc
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
 	}
 
@@ -1484,7 +1485,8 @@ netxen_nic_pci_mem_write_direct(struct n
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
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
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
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
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
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

