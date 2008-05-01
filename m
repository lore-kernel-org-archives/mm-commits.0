From: akpm@linux-foundation.org
Subject: + usb-fix-integer-as-null-pointer-sparse-warnings.patch added to -mm tree
Date: Thu, 01 May 2008 16:01:53 -0700
Message-ID: <200805012301.m41N1rs5030015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbYEAXB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 19:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, greg@kroah.com


The patch titled
     usb: fix integer as NULL pointer sparse warnings
has been added to the -mm tree.  Its filename is
     usb-fix-integer-as-null-pointer-sparse-warnings.patch

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
frv-unbreak-misalignment-handling-changes.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
fuse-use-clamp-rather-than-nested-min-max.patch
block-remove-remaining-__function__-occurances.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

