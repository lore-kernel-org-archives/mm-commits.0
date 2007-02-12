From: akpm@linux-foundation.org
Subject: - pm3fb-kill-pci_find_device-usage.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:46 -0800
Message-ID: <200702122249.l1CMnkXB014155@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030395AbXBLWuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     pm3fb: kill pci_find_device usage
has been removed from the -mm tree.  Its filename was
     pm3fb-kill-pci_find_device-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: kill pci_find_device usage
From: Alan <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

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

origin.patch
sis-warning-fixes.patch
libata-add-a-host-flag-to-indicate-lack-of-iordy.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
