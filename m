From: akpm@linux-foundation.org
Subject: - fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:57 -0700
Message-ID: <200804300551.m3U5pvxc030259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757734AbYD3Fw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout
From: Andrew Morton <akpm@linux-foundation.org>

drivers/usb/host/ohci-hub.c: In function 'ohci_hub_control':
drivers/usb/host/ohci-hub.c:564: warning: 'temp' may be used uninitialized in this function

Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ohci-hub.c~fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout drivers/usb/host/ohci-hub.c
--- a/drivers/usb/host/ohci-hub.c~fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout
+++ a/drivers/usb/host/ohci-hub.c
@@ -613,7 +613,6 @@ static void start_hnp(struct ohci_hcd *o
 static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 {
 	__hc32 __iomem *portstat = &ohci->regs->roothub.portstatus [port];
-	u32	temp;
 	u16	now = ohci_readl(ohci, &ohci->regs->fmnumber);
 	u16	reset_done = now + PORT_RESET_MSEC;
 	int	limit_1 = DIV_ROUND_UP(PORT_RESET_MSEC, PORT_RESET_HW_MSEC);
@@ -624,6 +623,7 @@ static inline int root_port_reset (struc
 	 */
 	do {
 		int limit_2;
+		u32 uninitialized_var(temp);
 
 		/* spin until any current reset finishes */
 		limit_2 = PORT_RESET_HW_MSEC * 2;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
x86-ptrace-pebs-support-warning-fix.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

