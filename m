From: akpm@linux-foundation.org
Subject: - ia64-missing-exports-hwsw_sync_.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:59 -0800
Message-ID: <200702071951.l17JpxNI025206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161431AbXBGTwE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: missing exports hwsw_sync_...
has been removed from the -mm tree.  Its filename was
     ia64-missing-exports-hwsw_sync_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: missing exports hwsw_sync_...
From: "Jan Beulich" <jbeulich@novell.com>

Add missing exports to allow several drivers to be built as module with
CONFIG_IA64_HP_ZX1_SWIOTLB.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/hwsw_iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/ia64/hp/common/hwsw_iommu.c~ia64-missing-exports-hwsw_sync_ arch/ia64/hp/common/hwsw_iommu.c
--- a/arch/ia64/hp/common/hwsw_iommu.c~ia64-missing-exports-hwsw_sync_
+++ a/arch/ia64/hp/common/hwsw_iommu.c
@@ -192,3 +192,7 @@ EXPORT_SYMBOL(hwsw_unmap_sg);
 EXPORT_SYMBOL(hwsw_dma_supported);
 EXPORT_SYMBOL(hwsw_alloc_coherent);
 EXPORT_SYMBOL(hwsw_free_coherent);
+EXPORT_SYMBOL(hwsw_sync_single_for_cpu);
+EXPORT_SYMBOL(hwsw_sync_single_for_device);
+EXPORT_SYMBOL(hwsw_sync_sg_for_cpu);
+EXPORT_SYMBOL(hwsw_sync_sg_for_device);
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
missing-critical-phys_to_virt-in-lib-swiotlbc.patch
i386-entrys-end-endproc-annotations.patch
