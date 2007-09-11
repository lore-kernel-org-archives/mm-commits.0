From: akpm@linux-foundation.org
Subject: + intel_agp-fix-gtt-map-size-on-g33.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:14:59 -0700
Message-ID: <200709110514.l8B5ExZ7026867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46371 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761519AbXIKFPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     intel_agp: fix GTT map size on G33
has been added to the -mm tree.  Its filename is
     intel_agp-fix-gtt-map-size-on-g33.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_agp: fix GTT map size on G33
From: Zhenyu Wang <zhenyu.z.wang@intel.com>

G33 has 1MB GTT table range.  Fix GTT mapping in case like 512MB aperture
size.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-fix-gtt-map-size-on-g33 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-fix-gtt-map-size-on-g33
+++ a/drivers/char/agp/intel-agp.c
@@ -926,6 +926,7 @@ static int intel_i915_create_gatt_table(
 	struct aper_size_info_fixed *size;
 	int num_entries;
 	u32 temp, temp2;
+	int gtt_map_size = 256 * 1024;
 
 	size = agp_bridge->current_size;
 	page_order = size->page_order;
@@ -935,7 +936,9 @@ static int intel_i915_create_gatt_table(
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

intel_agp-fix-stolen-mem-range-on-g33.patch
intel_agp-fix-gtt-map-size-on-g33.patch
