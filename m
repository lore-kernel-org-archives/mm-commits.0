From: akpm@osdl.org
Subject: + ia64-missing-exports-hwsw_sync_.patch added to -mm tree
Date: Wed, 03 Jan 2007 12:48:05 -0800
Message-ID: <200701032048.l03Km5wX030803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbXACUsL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 15:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, tony.luck@intel.com


The patch titled
     ia64: missing exports hwsw_sync_...
has been added to the -mm tree.  Its filename is
     ia64-missing-exports-hwsw_sync_.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: missing exports hwsw_sync_...
From: "Jan Beulich" <jbeulich@novell.com>

Add missing exports to allow several drivers to be built as module with
CONFIG_IA64_HP_ZX1_SWIOTLB.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/hp/common/hwsw_iommu.c |    4 ++++
 1 files changed, 4 insertions(+)

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

ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch
