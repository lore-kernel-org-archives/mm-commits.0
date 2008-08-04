From: akpm@linux-foundation.org
Subject: - pci-make-pci_register_driver-a-macro.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:04 -0700
Message-ID: <200808042006.m74K64EF027649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759237AbYHDUKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, jbarnes@virtuousgeek.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     pci: make pci_register_driver() a macro
has been removed from the -mm tree.  Its filename was
     pci-make-pci_register_driver-a-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: make pci_register_driver() a macro
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

CC [M]  drivers/usb/gadget/u_ether.o
In file included from include/asm/dma-mapping.h:7,
                 from include/linux/dma-mapping.h:52,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/if_ether.h:114,
                 from include/linux/etherdevice.h:27,
                 from drivers/usb/gadget/u_ether.c:29:
include/linux/pci.h: In function 'pci_register_driver':
include/linux/pci.h:673: error: 'KBUILD_MODNAME' undeclared (first use in this function)
include/linux/pci.h:673: error: (Each undeclared identifier is reported only once
include/linux/pci.h:673: error: for each function it appears in.)


Sam says:

The problem is that u_ether.o is used by two modules so when we build it
KBUILD_MODNAME is not defined because kbuild does not know what value to
use.

And in pci.h we have the following inline:

static inline int __must_check pci_register_driver(struct pci_driver *driver)
{
        return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
}

And alpha uses dma-mapping.h to nullify a number of functions that seem to
require something from pci.h.

Making it a macro seems to fix this.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/pci.h~pci-make-pci_register_driver-a-macro include/linux/pci.h
--- a/include/linux/pci.h~pci-make-pci_register_driver-a-macro
+++ a/include/linux/pci.h
@@ -680,10 +680,12 @@ void pci_enable_bridges(struct pci_bus *
 /* Proper probing supporting hot-pluggable devices */
 int __must_check __pci_register_driver(struct pci_driver *, struct module *,
 				       const char *mod_name);
-static inline int __must_check pci_register_driver(struct pci_driver *driver)
-{
-	return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
-}
+
+/*
+ * pci_register_driver must be a macro so that KBUILD_MODNAME can be expanded
+ */
+#define pci_register_driver(driver)		\
+	__pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 
 void pci_unregister_driver(struct pci_driver *dev);
 void pci_remove_behind_bridge(struct pci_dev *dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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

