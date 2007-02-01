From: akpm@osdl.org
Subject: + pm3fb-kill-pci_find_device-usage.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:44:32 -0800
Message-ID: <200702012144.l11LiWuK023719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXBAVoz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jsimmons@infradead.org


The patch titled
     pm3fb: kill pci_find_device usage
has been added to the -mm tree.  Its filename is
     pm3fb-kill-pci_find_device-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: kill pci_find_device usage
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/pm3fb.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-kill-pci_find_device-usage drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-kill-pci_find_device-usage
+++ a/drivers/video/pm3fb.c
@@ -3299,14 +3299,12 @@ static void pm3fb_detect(void)
 		fb_info[i].dev = NULL;
 	}
 
-	dev =
-	    pci_find_device(PCI_VENDOR_ID_3DLABS,
+	dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
 			    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
 
 	for (i = 0; ((i < PM3_MAX_BOARD) && dev); i++) {
 		dev_array[i] = dev;
-		dev =
-		    pci_find_device(PCI_VENDOR_ID_3DLABS,
+		dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
 				    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
 	}
 
@@ -3353,7 +3351,7 @@ static void pm3fb_detect(void)
 	/* now, initialize... or not */
 	for (i = 0; i < PM3_MAX_BOARD; i++) {
 		l_fb_info = &(fb_info[i]);
-		if ((l_fb_info->dev) && (!disable[i])) {	/* PCI device was found and not disabled by user */
+		if (l_fb_info->dev && !disable[i]) {	/* PCI device was found and not disabled by user */
 			DPRINTK(2,
 				"found @%lx Vendor %lx Device %lx ; base @ : %lx - %lx - %lx - %lx - %lx - %lx, irq %ld\n",
 				(unsigned long) l_fb_info->dev,
@@ -3608,7 +3606,7 @@ int init_module(void)
 
 	pm3fb_init();
 
-	return (0);
+	return 0;
 }
 
 void cleanup_module(void)
@@ -3619,23 +3617,18 @@ void cleanup_module(void)
 		struct pm3fb_info *l_fb_info;
 		for (i = 0; i < PM3_MAX_BOARD; i++) {
 			l_fb_info = &(fb_info[i]);
-			if ((l_fb_info->dev != NULL)
-			    && (!(disable[l_fb_info->board_num]))) {
-				if (l_fb_info->vIOBase !=
-				    (unsigned char *) -1) {
+			pci_dev_put(l_fb_info->dev);
+			if (l_fb_info->dev != NULL  && !(disable[l_fb_info->board_num])) {
+				if (l_fb_info->vIOBase != (unsigned char *) -1) {
 					pm3fb_unmapIO(l_fb_info);
 					release_mem_region(l_fb_info->p_fb,
-							   l_fb_info->
-							   fb_size);
-					release_mem_region(l_fb_info->
-							   pIOBase,
-							   PM3_REGS_SIZE);
+						   l_fb_info->fb_size);
+					release_mem_region(l_fb_info->pIOBase,
+						   PM3_REGS_SIZE);
 				}
-				unregister_framebuffer(&l_fb_info->gen.
-						       info);
+				unregister_framebuffer(&l_fb_info->gen.info);
 			}
 		}
 	}
-	return;
 }
 #endif /* MODULE */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

via-quirk-fix-update.patch
git-libata-all.patch
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
