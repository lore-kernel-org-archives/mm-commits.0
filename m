From: akpm@linux-foundation.org
Subject: [merged] fb-intelfb-conflict-with-drm_i915-and-hide-by-default.patch removed from -mm tree
Date: Mon, 20 Jul 2009 12:00:27 -0700
Message-ID: <200907201900.n6KJ0R4N013751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbZGTTBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, airlied@linux.ie, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fb/intelfb: conflict with DRM_I915 and hide by default
has been removed from the -mm tree.  Its filename was
     fb-intelfb-conflict-with-drm_i915-and-hide-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb/intelfb: conflict with DRM_I915 and hide by default
From: Jesse Barnes <jbarnes@virtuousgeek.org>

Users get confused by this driver.  It's really a special purpose embedded
driver, and causes a lot of problems if enabled.  So hide it under
EMBEDDED by default, and make sure it doesn't get enabled with the i915
DRM driver.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fb-intelfb-conflict-with-drm_i915-and-hide-by-default drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-intelfb-conflict-with-drm_i915-and-hide-by-default
+++ a/drivers/video/Kconfig
@@ -1119,12 +1119,13 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
+	depends on !DRM_I915
 	help
 	  This driver supports the on-board graphics built in to the Intel
           830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

origin.patch
linux-next.patch
acpi-reintroduce-acpi_device_ops-shutdown-method.patch
mm-count-only-reclaimable-lru-pages-v2.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-update.patch

