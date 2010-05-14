From: akpm@linux-foundation.org
Subject: [merged] drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch removed from -mm tree
Date: Fri, 14 May 2010 10:28:49 -0400
Message-ID: <201005141730.o4EHUHbB012340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757633Ab0ENRbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 13:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pugs@cisco.com, chrisw@sous-sol.org, dwmw2@infradead.org, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/intel-iommu.c: intel_iommu_map_range failed at very end of address space
has been removed from the -mm tree.  Its filename was
     drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pci/intel-iommu.c: intel_iommu_map_range failed at very end of address space
From: "Tom Lyon" <pugs@cisco.com>

intel_iommu_map_range() doesn't allow allocation at the very end of the
address space, that code has been simplified and corrected.

Signed-off-by: Tom Lyon <pugs@cisco.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space
+++ a/drivers/pci/intel-iommu.c
@@ -3624,7 +3624,6 @@ static int intel_iommu_map_range(struct 
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
-	int addr_width;
 	int prot = 0;
 	int ret;
 
@@ -3637,18 +3636,14 @@ static int intel_iommu_map_range(struct 
 
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
-		int min_agaw;
 		u64 end;
 
 		/* check if minimum agaw is sufficient for mapped address */
-		min_agaw = vm_domain_min_agaw(dmar_domain);
-		addr_width = agaw_to_width(min_agaw);
-		end = DOMAIN_MAX_ADDR(addr_width);
-		end = end & VTD_PAGE_MASK;
+		end = __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
 		if (end < max_addr) {
-			printk(KERN_ERR "%s: iommu agaw (%d) is not "
+			printk(KERN_ERR "%s: iommu width (%d) is not "
 			       "sufficient for the mapped address (%llx)\n",
-			       __func__, min_agaw, max_addr);
+			       __func__, dmar_domain->gaw, max_addr);
 			return -EFAULT;
 		}
 		dmar_domain->max_addr = max_addr;
_

Patches currently in -mm which might be from pugs@cisco.com are

drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

