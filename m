From: akpm@osdl.org
Subject: + make-isa_bridge-alpha-only.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:32:24 -0800
Message-ID: <200701082332.l08NWO9Z022730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXAHXfs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, greg@kroah.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     make isa_bridge Alpha-only
has been added to the -mm tree.  Its filename is
     make-isa_bridge-alpha-only.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make isa_bridge Alpha-only
From: Adrian Bunk <bunk@stusta.de>

Since isa_bridge is neither assigned any value !NULL nor used on !Alpha,
there's no reason for providing it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/pci.c |    4 ++++
 drivers/pci/pci.c       |    6 ------
 include/asm-alpha/pci.h |    2 ++
 include/linux/pci.h     |    6 ------
 4 files changed, 6 insertions(+), 12 deletions(-)

diff -puN arch/alpha/kernel/pci.c~make-isa_bridge-alpha-only arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~make-isa_bridge-alpha-only
+++ a/arch/alpha/kernel/pci.c
@@ -575,3 +575,7 @@ void pci_iounmap(struct pci_dev *dev, vo
 
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
+
+/* FIXME: Some boxes have multiple ISA bridges! */
+struct pci_dev *isa_bridge;
+EXPORT_SYMBOL(isa_bridge);
diff -puN drivers/pci/pci.c~make-isa_bridge-alpha-only drivers/pci/pci.c
--- a/drivers/pci/pci.c~make-isa_bridge-alpha-only
+++ a/drivers/pci/pci.c
@@ -1224,12 +1224,6 @@ early_param("pci", pci_setup);
 
 device_initcall(pci_init);
 
-#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
-/* FIXME: Some boxes have multiple ISA bridges! */
-struct pci_dev *isa_bridge;
-EXPORT_SYMBOL(isa_bridge);
-#endif
-
 EXPORT_SYMBOL_GPL(pci_restore_bars);
 EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device);
diff -puN include/asm-alpha/pci.h~make-isa_bridge-alpha-only include/asm-alpha/pci.h
--- a/include/asm-alpha/pci.h~make-isa_bridge-alpha-only
+++ a/include/asm-alpha/pci.h
@@ -293,4 +293,6 @@ struct pci_dev *alpha_gendev_to_pci(stru
 #define IOBASE_ROOT_BUS		5
 #define IOBASE_FROM_HOSE	0x10000
 
+extern struct pci_dev *isa_bridge;
+
 #endif /* __ALPHA_PCI_H */
diff -puN include/linux/pci.h~make-isa_bridge-alpha-only include/linux/pci.h
--- a/include/linux/pci.h~make-isa_bridge-alpha-only
+++ a/include/linux/pci.h
@@ -616,10 +616,6 @@ enum pci_dma_burst_strategy {
 				   strategy_parameter byte boundaries */
 };
 
-#if defined(CONFIG_ISA) || defined(CONFIG_EISA)
-extern struct pci_dev *isa_bridge;
-#endif
-
 struct msix_entry {
 	u16 	vector;	/* kernel uses to write allocated vector */
 	u16	entry;	/* driver uses to specify entry, OS writes */
@@ -727,8 +723,6 @@ static inline int pci_set_power_state(st
 static inline pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state) { return PCI_D0; }
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable) { return 0; }
 
-#define	isa_bridge	((struct pci_dev *)NULL)
-
 #define pci_dma_burst_advice(pdev, strat, strategy_parameter) do { } while (0)
 
 static inline void pci_block_user_cfg_access(struct pci_dev *dev) { }
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
make-isa_bridge-alpha-only.patch
git-scsi-rc-fixes.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
