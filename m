From: akpm@linux-foundation.org
Subject: + drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch added to -mm tree
Date: Fri, 30 Apr 2010 15:27:18 -0700
Message-ID: <201004302227.o3UMRIaU017354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759838Ab0D3W2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 18:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pugs@cisco.com, chrisw@sous-sol.org, dwmw2@infradead.org, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, joerg.roedel@amd.com


The patch titled
     drivers/pci/intel-iommu.c: intel_iommu_map_range failed at very end of address space
has been added to the -mm tree.  Its filename is
     drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

