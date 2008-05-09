From: akpm@linux-foundation.org
Subject: - usb-fix-integer-as-null-pointer-sparse-warnings.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:24 -0700
Message-ID: <200805092147.m49LlOZi027228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbYEIVr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: fix integer as NULL pointer sparse warnings
has been removed from the -mm tree.  Its filename was
     usb-fix-integer-as-null-pointer-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fix integer as NULL pointer sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/usb/host/ohci-sm501.c:93:24: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3254:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3267:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3277:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3285:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3293:9: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/amd5536udc.c |   10 +++++-----
 drivers/usb/host/ohci-sm501.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/usb/gadget/amd5536udc.c~usb-fix-integer-as-null-pointer-sparse-warnings drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c~usb-fix-integer-as-null-pointer-sparse-warnings
+++ a/drivers/usb/gadget/amd5536udc.c
@@ -3251,7 +3251,7 @@ static int udc_pci_probe(
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3264,7 +3264,7 @@ static int udc_pci_probe(
 	if (!request_mem_region(resource, len, name)) {
 		dev_dbg(&pdev->dev, "pci device used already\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EBUSY;
 		goto finished;
 	}
@@ -3274,7 +3274,7 @@ static int udc_pci_probe(
 	if (dev->virt_addr == NULL) {
 		dev_dbg(&pdev->dev, "start address cannot be mapped\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EFAULT;
 		goto finished;
 	}
@@ -3282,7 +3282,7 @@ static int udc_pci_probe(
 	if (!pdev->irq) {
 		dev_err(&dev->pdev->dev, "irq not set\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3290,7 +3290,7 @@ static int udc_pci_probe(
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EBUSY;
 		goto finished;
 	}
diff -puN drivers/usb/host/ohci-sm501.c~usb-fix-integer-as-null-pointer-sparse-warnings drivers/usb/host/ohci-sm501.c
--- a/drivers/usb/host/ohci-sm501.c~usb-fix-integer-as-null-pointer-sparse-warnings
+++ a/drivers/usb/host/ohci-sm501.c
@@ -90,7 +90,7 @@ static int ohci_hcd_sm501_drv_probe(stru
 	struct device *dev = &pdev->dev;
 	struct resource	*res, *mem;
 	int retval, irq;
-	struct usb_hcd *hcd = 0;
+	struct usb_hcd *hcd = NULL;
 
 	irq = retval = platform_get_irq(pdev, 0);
 	if (retval < 0)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
wireless-use-get-put_unaligned_-helpers.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
lib-add-ascii-hex-helper-functions.patch
lib-add-ascii-hex-helper-functions-update.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
aacraid-linitc-make-aac_show_serial_number-static.patch

