From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch added to -mm tree
Date: Mon, 04 Aug 2008 17:41:42 -0700
Message-ID: <200808050041.m750fgLK008279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759366AbYHEAlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 20:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch

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
Subject: scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#99: FILE: drivers/scsi/megaraid/megaraid_sas.c:387:
+	if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK)) {
+		return 1;
+	}

ERROR: code indent should use tabs where possible
#121: FILE: drivers/scsi/megaraid/megaraid_sas.c:409:
+                       struct megasas_register_set __iomem *regs)$

ERROR: Macros with complex values should be enclosed in parenthesis
#182: FILE: drivers/scsi/megaraid/megaraid_sas.h:586:
+#define MFI_GEN2_ENABLE_INTERRUPT_MASK		0x00000001 | 0x00000004

total: 2 errors, 1 warnings, 157 lines checked

./patches/scsi-megaraid_sas-add-the-new-controllers-support.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    5 ++---
 drivers/scsi/megaraid/megaraid_sas.h |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -384,9 +384,8 @@ megasas_clear_intr_gen2(struct megasas_r
 	 */
 	status = readl(&regs->outbound_intr_status);
 
-	if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK)) {
+	if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK))
 		return 1;
-	}
 
 	/*
 	 * Clear the interrupt by writing back the same value
@@ -406,7 +405,7 @@ megasas_clear_intr_gen2(struct megasas_r
  */
 static inline void
 megasas_fire_cmd_gen2(dma_addr_t frame_phys_addr, u32 frame_count,
-                       struct megasas_register_set __iomem *regs)
+			struct megasas_register_set __iomem *regs)
 {
 	writel((frame_phys_addr | (frame_count<<1))|1,
 			&(regs)->inbound_queue_port);
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -582,8 +582,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)
 
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
-#define MFI_REPLY_GEN2_MESSAGE_INTERRUPT       0x00000001
-#define MFI_GEN2_ENABLE_INTERRUPT_MASK		0x00000001 | 0x00000004
+#define MFI_REPLY_GEN2_MESSAGE_INTERRUPT	0x00000001
+#define MFI_GEN2_ENABLE_INTERRUPT_MASK		(0x00000001 | 0x00000004)
 
 /*
 * register set for both 1068 and 1078 controllers
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

