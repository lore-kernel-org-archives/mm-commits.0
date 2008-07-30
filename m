From: akpm@linux-foundation.org
Subject: + drivers-input-serio-xilinx_ps2c-fix-warning.patch added to -mm tree
Date: Tue, 29 Jul 2008 21:17:35 -0700
Message-ID: <200807300430.m6U4ULdE006970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbYG3Ea0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 00:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dtor@mail.ru


The patch titled
     drivers/input/serio/xilinx_ps2.c: fix warning
has been added to the -mm tree.  Its filename is
     drivers-input-serio-xilinx_ps2c-fix-warning.patch

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
Subject: drivers/input/serio/xilinx_ps2.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/serio/xilinx_ps2.c:272: warning: cast from pointer to integer of different size

Also, it is fishy that phys_addr has a 32-bit type.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/xilinx_ps2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/serio/xilinx_ps2.c~drivers-input-serio-xilinx_ps2c-fix-warning drivers/input/serio/xilinx_ps2.c
--- a/drivers/input/serio/xilinx_ps2.c~drivers-input-serio-xilinx_ps2c-fix-warning
+++ a/drivers/input/serio/xilinx_ps2.c
@@ -269,8 +269,8 @@ static int xps2_setup(struct device *dev
 	 * we have the PS2 in a good state */
 	out_be32(drvdata->base_address + XPS2_SRST_OFFSET, XPS2_SRST_RESET);
 
-	dev_info(dev, "Xilinx PS2 at 0x%08X mapped to 0x%08X, irq=%d\n",
-		drvdata->phys_addr, (u32)drvdata->base_address, drvdata->irq);
+	dev_info(dev, "Xilinx PS2 at 0x%08X mapped to 0x%p, irq=%d\n",
+		drvdata->phys_addr, drvdata->base_address, drvdata->irq);
 
 	serio = &drvdata->serio;
 	serio->id.type = SERIO_8042;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

connector-add-a-blackboard-user-to-connector-fix.patch
sched-make-scheduler-sysfs-attributes-sysdev-class-devices-checkpatch-fixes.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gru-driver-v3-fixes-to-resolve-code-review-comments-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
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
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
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
drivers-input-serio-xilinx_ps2c-fix-warning.patch

