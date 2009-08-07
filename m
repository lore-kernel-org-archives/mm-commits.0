From: akpm@linux-foundation.org
Subject: [obsolete] drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored.patch removed from -mm tree
Date: Fri, 07 Aug 2009 01:11:59 -0700
Message-ID: <200908070811.n778Bx0A014592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757206AbZHGIMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 04:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, joerg.roedel@amd.com, luming.yu@intel.com, mingo@elte.hu, weidong.han@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/intel-iommu.c: return early if all dmar HW unit ignored
has been removed from the -mm tree.  Its filename was
     drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pci/intel-iommu.c: return early if all dmar HW unit ignored
From: Luming Yu <luming.yu@gmail.com>

When debugging an IOMMU problem, I noticed it would be much more safe to
return early than late if all remapping HW unit are ignored.

To figure out what device causes the iommu problem on my linux box:
hp-compaq dc7800, I tried to mark all dmar HW unit ignored,but still got a
lot of unxepcted dmar_fault.  So I think the proposed patch make sense. 
The next step is to add a boot option to make dmar HW units selectable
enable/disable individually.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Yu Luming <luming.yu@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Weidong Han <weidong.han@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored
+++ a/drivers/pci/intel-iommu.c
@@ -2983,9 +2983,11 @@ static void __init iommu_exit_mempool(vo
 
 }
 
-static void __init init_no_remapping_devices(void)
+static int __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
+	int drhd_total = 0;
+	int drhd_ignored = 0;
 
 	for_each_drhd_unit(drhd) {
 		if (!drhd->include_all) {
@@ -2997,32 +2999,33 @@ static void __init init_no_remapping_dev
 			if (i == drhd->devices_cnt)
 				drhd->ignored = 1;
 		}
+		drhd_total++;
 	}
-
-	if (dmar_map_gfx)
-		return;
-
 	for_each_drhd_unit(drhd) {
 		int i;
+		if (drhd->ignored)
+			drhd_ignored++;
 		if (drhd->ignored || drhd->include_all)
 			continue;
-
+		if (dmar_map_gfx)
+			continue;
 		for (i = 0; i < drhd->devices_cnt; i++)
 			if (drhd->devices[i] &&
 				!IS_GFX_DEVICE(drhd->devices[i]))
 				break;
-
 		if (i < drhd->devices_cnt)
 			continue;
 
 		/* bypass IOMMU if it is just for gfx devices */
 		drhd->ignored = 1;
+		drhd_ignored++;
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
 			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
+	return (drhd_total == drhd_ignored);
 }
 
 #ifdef CONFIG_SUSPEND
@@ -3189,7 +3192,12 @@ int __init intel_iommu_init(void)
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
-	init_no_remapping_devices();
+	if (init_no_remapping_devices()) {
+		printk(KERN_ERR "IOMMU: all dmar HW unit ignored\n");
+		put_iova_domain(&reserved_iova_list);
+		iommu_exit_mempool();
+		return ret;
+	}
 
 	ret = init_dmars();
 	if (ret) {
_

Patches currently in -mm which might be from luming.yu@gmail.com are

drivers-pci-intel-iommuc-return-early-if-all-dmar-hw-unit-ignored.patch

