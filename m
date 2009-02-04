From: akpm@linux-foundation.org
Subject: [to-be-updated] intel_iommu-default-to-off.patch removed from -mm tree
Date: Wed, 04 Feb 2009 14:23:21 -0800
Message-ID: <200902042223.n14MNLUL019964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbZBDWZD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 17:25:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@redhat.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, markmc@redhat.com, stable@kernel.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel_iommu: default to off
has been removed from the -mm tree.  Its filename was
     intel_iommu-default-to-off.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_iommu: default to off
From: Kyle McMartin <kyle@redhat.com>

Due to reports of data corruption due to aborted DMA when using the intel
iommu code, disable it by default and provide a command line parameter
"intel_iommu=on" to turn it back on again.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel_iommu-default-to-off drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel_iommu-default-to-off
+++ a/drivers/pci/intel-iommu.c
@@ -268,7 +268,7 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-int dmar_disabled;
+int dmar_disabled = 1;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
@@ -284,9 +284,12 @@ static int __init intel_iommu_setup(char
 	if (!str)
 		return -EINVAL;
 	while (*str) {
-		if (!strncmp(str, "off", 3)) {
+		if (!strncmp(str, "on", 2)) {
+			dmar_disabled = 0;
+			printk(KERN_INFO "Intel-IOMMU: enabled\n");
+		} else if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
-			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+			printk(KERN_INFO "Intel-IOMMU: disabled\n");
 		} else if (!strncmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
_

Patches currently in -mm which might be from kyle@redhat.com are

intel_iommu-default-to-off.patch

