From: akpm@linux-foundation.org
Subject: - intel_agp-fix-gtt-map-size-on-g33.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:14 -0700
Message-ID: <200709160926.l8G9QEPu009169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbXIPJii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, airlied@linux.ie, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel_agp: fix GTT map size on G33
has been removed from the -mm tree.  Its filename was
     intel_agp-fix-gtt-map-size-on-g33.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_agp: fix GTT map size on G33
From: Zhenyu Wang <zhenyu.z.wang@intel.com>

G33 has 1MB GTT table range.  Fix GTT mapping in case like 512MB aperture
size.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Acked-by: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-fix-gtt-map-size-on-g33 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-fix-gtt-map-size-on-g33
+++ a/drivers/char/agp/intel-agp.c
@@ -919,6 +919,7 @@ static int intel_i915_create_gatt_table(
 	struct aper_size_info_fixed *size;
 	int num_entries;
 	u32 temp, temp2;
+	int gtt_map_size = 256 * 1024;
 
 	size = agp_bridge->current_size;
 	page_order = size->page_order;
@@ -928,7 +929,9 @@ static int intel_i915_create_gatt_table(
 	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);
 
-	intel_private.gtt = ioremap(temp2, 256 * 1024);
+	if (IS_G33)
+	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

origin.patch
intel-agp-fix-i830-mask-variable-that-changed-with-g33-support.patch
