From: akpm@linux-foundation.org
Subject: - intel_agp-add-support-for-965gme-gle.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:20 -0700
Message-ID: <200706081735.l58HZKqo006355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36387 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764512AbXFHRnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel_agp: add support for 965GME/GLE
has been removed from the -mm tree.  Its filename was
     intel_agp-add-support-for-965gme-gle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_agp: add support for 965GME/GLE
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

Add pci id info for 965GME/GLE support.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-add-support-for-965gme-gle drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-add-support-for-965gme-gle
+++ a/drivers/char/agp/intel-agp.c
@@ -20,6 +20,7 @@
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
 #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
+#define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
@@ -1798,6 +1799,8 @@ static const struct intel_driver_descrip
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, "965GM",
 		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, "965GME/GLE",
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
 	{ 0, 0, NULL, NULL, NULL }
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

git-agpgart.patch
