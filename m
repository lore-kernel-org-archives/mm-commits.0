From: akpm@linux-foundation.org
Subject: [merged] video-backlight-progear-fix-pci-device-refcounting.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:45 -0800
Message-ID: <201002121903.o1CJ3jCr021141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab0BLTE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jbarnes@virtuousgeek.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     video: backlight/progear, fix pci device refcounting
has been removed from the -mm tree.  Its filename was
     video-backlight-progear-fix-pci-device-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
posix-cpu-timers-cleanup-rlimits-usage.patch
kernel-core-use-helpers-for-rlimits.patch
kernel-core-use-helpers-for-rlimits-fix.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

