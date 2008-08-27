From: akpm@linux-foundation.org
Subject: + v4l-dvb-follow-lspci-device-vendor-style.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:14:54 -0700
Message-ID: <200808272314.m7RNEsfs027857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbYH0XPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, mchehab@infradead.org


The patch titled
     v4l/dvb: follow lspci device/vendor style
has been added to the -mm tree.  Its filename is
     v4l-dvb-follow-lspci-device-vendor-style.patch

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
Subject: v4l/dvb: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |    2 +-
 drivers/media/dvb/ttpci/av7110.c                  |    2 +-
 drivers/media/dvb/ttpci/budget-av.c               |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c               |    2 +-
 drivers/media/dvb/ttpci/budget-patch.c            |    2 +-
 drivers/media/dvb/ttpci/budget.c                  |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    2 +-
 drivers/media/video/cx18/cx18-driver.c            |    4 ++--
 drivers/media/video/ivtv/ivtv-driver.c            |    4 ++--
 10 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/media/dvb/bt8xx/dvb-bt8xx.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -702,7 +702,7 @@ static void frontend_init(struct dvb_bt8
 	}
 
 	if (card->fe == NULL)
-		printk("dvb-bt8xx: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-bt8xx: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       card->bt->dev->vendor,
 		       card->bt->dev->device,
 		       card->bt->dev->subsystem_vendor,
diff -puN drivers/media/dvb/ttpci/av7110.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -2240,7 +2240,7 @@ static int frontend_init(struct av7110 *
 	if (!av7110->fe) {
 		/* FIXME: propagate the failure code from the lower layers */
 		ret = -ENOMEM;
-		printk("dvb-ttpci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-ttpci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       av7110->dev->pci->vendor,
 		       av7110->dev->pci->device,
 		       av7110->dev->pci->subsystem_vendor,
diff -puN drivers/media/dvb/ttpci/budget-av.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttpci/budget-av.c
--- a/drivers/media/dvb/ttpci/budget-av.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttpci/budget-av.c
@@ -1049,7 +1049,7 @@ static void frontend_init(struct budget_
 
 	if (fe == NULL) {
 		printk(KERN_ERR "budget-av: A frontend driver was not found "
-				"for device %04x/%04x subsystem %04x/%04x\n",
+				"for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       saa->pci->vendor,
 		       saa->pci->device,
 		       saa->pci->subsystem_vendor,
diff -puN drivers/media/dvb/ttpci/budget-ci.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttpci/budget-ci.c
--- a/drivers/media/dvb/ttpci/budget-ci.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttpci/budget-ci.c
@@ -1153,7 +1153,7 @@ static void frontend_init(struct budget_
 	}
 
 	if (budget_ci->budget.dvb_frontend == NULL) {
-		printk("budget-ci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("budget-ci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget_ci->budget.dev->pci->vendor,
 		       budget_ci->budget.dev->pci->device,
 		       budget_ci->budget.dev->pci->subsystem_vendor,
diff -puN drivers/media/dvb/ttpci/budget-patch.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttpci/budget-patch.c
--- a/drivers/media/dvb/ttpci/budget-patch.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttpci/budget-patch.c
@@ -359,7 +359,7 @@ static void frontend_init(struct budget_
 	}
 
 	if (budget->dvb_frontend == NULL) {
-		printk("dvb-ttpci: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("dvb-ttpci: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget->dev->pci->vendor,
 		       budget->dev->pci->device,
 		       budget->dev->pci->subsystem_vendor,
diff -puN drivers/media/dvb/ttpci/budget.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttpci/budget.c
--- a/drivers/media/dvb/ttpci/budget.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttpci/budget.c
@@ -549,7 +549,7 @@ static void frontend_init(struct budget 
 	}
 
 	if (budget->dvb_frontend == NULL) {
-		printk("budget: A frontend driver was not found for device %04x/%04x subsystem %04x/%04x\n",
+		printk("budget: A frontend driver was not found for device [%04x:%04x] subsystem [%04x:%04x]\n",
 		       budget->dev->pci->vendor,
 		       budget->dev->pci->device,
 		       budget->dev->pci->subsystem_vendor,
diff -puN drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1614,7 +1614,7 @@ static void frontend_init(struct ttusb* 
 	}
 
 	if (ttusb->fe == NULL) {
-		printk("dvb-ttusb-budget: A frontend driver was not found for device %04x/%04x\n",
+		printk("dvb-ttusb-budget: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(ttusb->dev->descriptor.idVendor),
 		       le16_to_cpu(ttusb->dev->descriptor.idProduct));
 	} else {
diff -puN drivers/media/dvb/ttusb-dec/ttusb_dec.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1665,7 +1665,7 @@ static int ttusb_dec_probe(struct usb_in
 	}
 
 	if (dec->fe == NULL) {
-		printk("dvb-ttusb-dec: A frontend driver was not found for device %04x/%04x\n",
+		printk("dvb-ttusb-dec: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(dec->udev->descriptor.idVendor),
 		       le16_to_cpu(dec->udev->descriptor.idProduct));
 	} else {
diff -puN drivers/media/video/cx18/cx18-driver.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/video/cx18/cx18-driver.c
--- a/drivers/media/video/cx18/cx18-driver.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/video/cx18/cx18-driver.c
@@ -395,9 +395,9 @@ done:
 
 	if (cx->card == NULL) {
 		cx->card = cx18_get_card(CX18_CARD_HVR_1600_ESMT);
-		CX18_ERR("Unknown card: vendor/device: %04x/%04x\n",
+		CX18_ERR("Unknown card: vendor/device: [%04x:%04x]\n",
 		     cx->dev->vendor, cx->dev->device);
-		CX18_ERR("              subsystem vendor/device: %04x/%04x\n",
+		CX18_ERR("              subsystem vendor/device: [%04x:%04x]\n",
 		     cx->dev->subsystem_vendor, cx->dev->subsystem_device);
 		CX18_ERR("Defaulting to %s card\n", cx->card->name);
 		CX18_ERR("Please mail the vendor/device and subsystem vendor/device IDs and what kind of\n");
diff -puN drivers/media/video/ivtv/ivtv-driver.c~v4l-dvb-follow-lspci-device-vendor-style drivers/media/video/ivtv/ivtv-driver.c
--- a/drivers/media/video/ivtv/ivtv-driver.c~v4l-dvb-follow-lspci-device-vendor-style
+++ a/drivers/media/video/ivtv/ivtv-driver.c
@@ -655,9 +655,9 @@ done:
 
 	if (itv->card == NULL) {
 		itv->card = ivtv_get_card(IVTV_CARD_PVR_150);
-		IVTV_ERR("Unknown card: vendor/device: %04x/%04x\n",
+		IVTV_ERR("Unknown card: vendor/device: [%04x:%04x]\n",
 		     itv->dev->vendor, itv->dev->device);
-		IVTV_ERR("              subsystem vendor/device: %04x/%04x\n",
+		IVTV_ERR("              subsystem vendor/device: [%04x:%04x]\n",
 		     itv->dev->subsystem_vendor, itv->dev->subsystem_device);
 		IVTV_ERR("              %s based\n", chipname);
 		IVTV_ERR("Defaulting to %s card\n", itv->card->name);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
pci-tidy-pme-support-messages.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch
x86-pci-follow-lspci-device-vendor-style.patch
agp-follow-lspci-device-vendor-style.patch
v4l-dvb-follow-lspci-device-vendor-style.patch
irda-follow-lspci-device-vendor-style.patch
pci-follow-lspci-device-vendor-style.patch

