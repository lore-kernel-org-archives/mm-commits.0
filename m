From: akpm@linux-foundation.org
Subject: + video-backlight-progear-fix-pci-device-refcounting.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:42:36 -0800
Message-ID: <201001262142.o0QLgain022206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab0AZVmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, jbarnes@virtuousgeek.org, rpurdie@rpsys.net


The patch titled
     video: backlight/progear, fix pci device refcounting
has been added to the -mm tree.  Its filename is
     video-backlight-progear-fix-pci-device-refcounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: backlight/progear, fix pci device refcounting
From: Jiri Slaby <jslaby@suse.cz>

Stanse found an ommitted pci_dev_puts on error path in progearbl_probe. 
pmu_dev and sb_dev are gotten, but never put when
backlight_device_register fails.

So unify fail paths and put the devs when the failure occurs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/progear_bl.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/progear_bl.c~video-backlight-progear-fix-pci-device-refcounting drivers/video/backlight/progear_bl.c
--- a/drivers/video/backlight/progear_bl.c~video-backlight-progear-fix-pci-device-refcounting
+++ a/drivers/video/backlight/progear_bl.c
@@ -63,6 +63,7 @@ static int progearbl_probe(struct platfo
 {
 	u8 temp;
 	struct backlight_device *progear_backlight_device;
+	int ret;
 
 	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
@@ -73,8 +74,8 @@ static int progearbl_probe(struct platfo
 	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (!sb_dev) {
 		printk("ALI 1533 SB not found.\n");
-		pci_dev_put(pmu_dev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto put_pmu;
 	}
 
 	/*     Set SB_MPS1 to enable brightness control. */
@@ -84,8 +85,10 @@ static int progearbl_probe(struct platfo
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
 							     &progearbl_ops);
-	if (IS_ERR(progear_backlight_device))
-		return PTR_ERR(progear_backlight_device);
+	if (IS_ERR(progear_backlight_device)) {
+		ret = PTR_ERR(progear_backlight_device);
+		goto put_sb;
+	}
 
 	platform_set_drvdata(pdev, progear_backlight_device);
 
@@ -95,6 +98,11 @@ static int progearbl_probe(struct platfo
 	progearbl_set_intensity(progear_backlight_device);
 
 	return 0;
+put_sb:
+	pci_dev_put(sb_dev);
+put_pmu:
+	pci_dev_put(pmu_dev);
+	return ret;
 }
 
 static int progearbl_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
video-backlight-progear-fix-pci-device-refcounting.patch
pci-hotplug-cpcihp-fix-pci-device-refcounting.patch
mm-use-rlimit-helpers.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

