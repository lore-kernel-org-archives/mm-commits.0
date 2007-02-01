From: akpm@osdl.org
Subject: + cyrix-fails-to-detect-mediagx.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:53:01 -0800
Message-ID: <200702012153.l11Lr1xU023969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbXBAVxX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, ak@suse.de, alan@redhat.com, jordan.crouse@amd.com, takada@mbf.nifty.com


The patch titled
     cyrix: fails to detect MediaGX
has been added to the -mm tree.  Its filename is
     cyrix-fails-to-detect-mediagx.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyrix: fails to detect MediaGX
From: Alan <alan@lxorguk.ukuu.org.uk>

The old Cyrix 5520 CPU detection code relied upon the PCI layer setup being
done earlier than the CPU setup, which is no longer true.  Fortunately we
know that if the processor is a MediaGX we can do type 1 pci config
accesses to check the companion chip.  We thus do those directly and from
this find the 5520 and implement the workarounds for the timer problem

Original report from takada@mbf.nifty.com, I sent a proposed patch which
Takara then corrected, tested and sent back to the list on 10th January.

Submitting for merging as it seems to have been missed

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <takada@mbf.nifty.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cyrix.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~cyrix-fails-to-detect-mediagx arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~cyrix-fails-to-detect-mediagx
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -8,6 +8,7 @@
 #include <asm/timer.h>
 
 #include "cpu.h"
+#include "../../pci/pci.h"
 
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
@@ -183,19 +184,12 @@ static void __cpuinit geode_configure(vo
 }
 
 
-#ifdef CONFIG_PCI
-static struct pci_device_id __cpuinitdata cyrix_55x0[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5510) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5520) },
-	{ },
-};
-#endif
-
 static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir0_lsn, dir1 = 0;
 	char *buf = c->x86_model_id;
 	const char *p = NULL;
+	u32 vendor, device;
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
@@ -273,11 +267,16 @@ static void __cpuinit init_cyrix(struct 
 		printk(KERN_INFO "Working around Cyrix MediaGX virtual DMA bugs.\n");
 		isa_dma_bridge_buggy = 2;
 
+		/* We do this before the PCI layer is running. However we
+		   are safe here as we know the bridge must be a Cyrix
+		   companion and must be present */
+		pci_conf1_read(0, 0, PCI_DEVFN(0x12, 0), PCI_VENDOR_ID, 2, &vendor);
+		pci_conf1_read(0, 0, PCI_DEVFN(0x12, 0), PCI_DEVICE_ID, 2, &device);
 
 		/*
 		 *  The 5510/5520 companion chips have a funky PIT.
 		 */  
-		if (pci_dev_present(cyrix_55x0))
+		if (vendor == PCI_VENDOR_ID_CYRIX && (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
 			pit_latch_buggy = 1;
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

via-quirk-fix-update.patch
git-libata-all.patch
pata_atiixp-propogate-cable-detection-hack-from.patch
pata_via-correct-missing-comments.patch
git-mtd.patch
ubi-int-versus-size_t-printk-warnings.patch
atl1_main-pci_module_int-returns-to-haunt-us.patch
z85230-spinlock-logic.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
geode-support-classic-mediagxm.patch
cyrix-fails-to-detect-mediagx.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-tty_wakeup-cleanup.patch
proc-remove-useless-and-buggy-nlink-settings.patch
tty-improve-encode_baud_rate-logic.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
sched-avoid-div-in-rebalance_tick.patch
pm3fb-kill-pci_find_device-usage.patch
