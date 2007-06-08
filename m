From: akpm@linux-foundation.org
Subject: + driver-edac-fix-ignored-return-i82875p.patch added to -mm tree
Date: Fri, 08 Jun 2007 12:40:35 -0700
Message-ID: <200706081940.l58JeZiV009871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133AbXFHTkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 15:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     drivers/edac: fix ignored return i82875p
has been added to the -mm tree.  Its filename is
     driver-edac-fix-ignored-return-i82875p.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: fix ignored return i82875p
From: Douglas Thompson <dougthompson@xmission.com>

Compiling this module gave a warning that the return value of
'pci_bus_add_device()' was not checked.

This patch adds that check and an output message

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/edac/i82875p_edac.c~driver-edac-fix-ignored-return-i82875p drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~driver-edac-fix-ignored-return-i82875p
+++ a/drivers/edac/i82875p_edac.c
@@ -270,6 +270,7 @@ static int i82875p_setup_overfl_dev(stru
 {
 	struct pci_dev *dev;
 	void __iomem *window;
+	int err;
 
 	*ovrfl_pdev = NULL;
 	*ovrfl_window = NULL;
@@ -287,7 +288,12 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev == NULL)
 			return 1;
 
-		pci_bus_add_device(dev);
+		err = pci_bus_add_device(dev);
+		if (err) {
+			i82875p_printk(KERN_ERR,
+				"%s(): pci_bus_add_device() Failed\n",
+				__func__);
+		}
 	}
 
 	*ovrfl_pdev = dev;
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
