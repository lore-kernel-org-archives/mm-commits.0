From: akpm@linux-foundation.org
Subject: - i915-filter-pci-devices-based-on-pci_class_display_vga.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:10 -0800
Message-ID: <200811122047.mACKlAuc006908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbYKLUrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric@anholt.net, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     i915: filter pci devices based on PCI_CLASS_DISPLAY_VGA
has been removed from the -mm tree.  Its filename was
     i915-filter-pci-devices-based-on-pci_class_display_vga.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i915: filter pci devices based on PCI_CLASS_DISPLAY_VGA
From: Eric Anholt <eric@anholt.net>

This fixes hangs on 855-class hardware by avoiding double attachment of
the driver due to the stub second head device having the same pci id as
the real device.

Other DRM drivers probably want this treatment as well, but I'm applying
it just to this one for safety.

Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_drv.c |   10 ++++++
 include/drm/drm_pciids.h  |   52 ++++++++++++++++++++----------------
 2 files changed, 38 insertions(+), 24 deletions(-)

diff -puN drivers/gpu/drm/drm_drv.c~i915-filter-pci-devices-based-on-pci_class_display_vga drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~i915-filter-pci-devices-based-on-pci_class_display_vga
+++ a/drivers/gpu/drm/drm_drv.c
@@ -266,11 +266,19 @@ int drm_init(struct drm_driver *driver)
 	for (i = 0; driver->pci_driver.id_table[i].vendor != 0; i++) {
 		pid = (struct pci_device_id *)&driver->pci_driver.id_table[i];
 
+		/* Loop around setting up a DRM device for each PCI device
+		 * matching our ID and device class.  If we had the internal
+		 * function that pci_get_subsys and pci_get_class used, we'd
+		 * be able to just pass pid in instead of doing a two-stage
+		 * thing.
+		 */
 		pdev = NULL;
-		/* pass back in pdev to account for multiple identical cards */
 		while ((pdev =
 			pci_get_subsys(pid->vendor, pid->device, pid->subvendor,
 				       pid->subdevice, pdev)) != NULL) {
+			if ((pdev->class & pid->class_mask) != pid->class)
+				continue;
+
 			/* stealth mode requires a manual probe */
 			pci_dev_get(pdev);
 			drm_get_dev(pdev, pid, driver);
diff -puN include/drm/drm_pciids.h~i915-filter-pci-devices-based-on-pci_class_display_vga include/drm/drm_pciids.h
--- a/include/drm/drm_pciids.h~i915-filter-pci-devices-based-on-pci_class_display_vga
+++ a/include/drm/drm_pciids.h
@@ -394,28 +394,34 @@
 #define ffb_PCI_IDS \
 	{0, 0, 0}
 
+#define i915_PCI_DEVID(vendor, device) {				\
+	vendor, device,							\
+	PCI_ANY_ID, PCI_ANY_ID,						\
+	PCI_CLASS_DISPLAY_VGA << 8, 0xffff00,				\
+	0								\
+}
 #define i915_PCI_IDS \
-	{0x8086, 0x3577, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2562, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x3582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2572, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x258a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2592, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x27a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x27ae, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2972, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2982, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2992, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29b2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29c2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x29d2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a02, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a12, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2a42, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e02, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e12, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-	{0x8086, 0x2e22, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	i915_PCI_DEVID(0x8086, 0x3577), \
+	i915_PCI_DEVID(0x8086, 0x2562), \
+	i915_PCI_DEVID(0x8086, 0x3582), \
+	i915_PCI_DEVID(0x8086, 0x2572), \
+	i915_PCI_DEVID(0x8086, 0x2582), \
+	i915_PCI_DEVID(0x8086, 0x258a), \
+	i915_PCI_DEVID(0x8086, 0x2592), \
+	i915_PCI_DEVID(0x8086, 0x2772), \
+	i915_PCI_DEVID(0x8086, 0x27a2), \
+	i915_PCI_DEVID(0x8086, 0x27ae), \
+	i915_PCI_DEVID(0x8086, 0x2972), \
+	i915_PCI_DEVID(0x8086, 0x2982), \
+	i915_PCI_DEVID(0x8086, 0x2992), \
+	i915_PCI_DEVID(0x8086, 0x29a2), \
+	i915_PCI_DEVID(0x8086, 0x29b2), \
+	i915_PCI_DEVID(0x8086, 0x29c2), \
+	i915_PCI_DEVID(0x8086, 0x29d2), \
+	i915_PCI_DEVID(0x8086, 0x2a02), \
+	i915_PCI_DEVID(0x8086, 0x2a12), \
+	i915_PCI_DEVID(0x8086, 0x2a42), \
+	i915_PCI_DEVID(0x8086, 0x2e02), \
+	i915_PCI_DEVID(0x8086, 0x2e12), \
+	i915_PCI_DEVID(0x8086, 0x2e22), \
 	{0, 0, 0}
_

Patches currently in -mm which might be from eric@anholt.net are

origin.patch

