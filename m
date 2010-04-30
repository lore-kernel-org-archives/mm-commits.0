From: akpm@linux-foundation.org
Subject: + drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch added to -mm tree
Date: Fri, 30 Apr 2010 15:27:27 -0700
Message-ID: <201004302227.o3UMRRWD017361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759831Ab0D3W2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 18:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pugs@cisco.com, chrisw@sous-sol.org, dwmw2@infradead.org, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, joerg.roedel@amd.com


The patch titled
     drivers/pci/intel-iommu.c: errors with smaller iommu widths
has been added to the -mm tree.  Its filename is
     drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

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
Subject: drivers/pci/intel-iommu.c: errors with smaller iommu widths
From: "Tom Lyon" <pugs@cisco.com>

When using iommu_domain_alloc with the Intel iommu, the domain address
width is always initialized to 48 bits (agaw 2).  This domain->agaw value
is then used by pfn_to_dma_pte to (always) build a 4 level page table. 
However, not all systems support iommu width of 48 or 4 level page tables.
In particular, the Core i5-660 and i5-670 support an address width of 36
bits (not 39!), an agaw of only 1, and only 3 level page tables.

This version of the patch simply lops off extra levels of the page tables
if the agaw value of the iommu is less than what is currently allocated
for the domain (in intel_iommu_attach_device).  If there were already
allocated addresses above what the new iommu can handle, EFAULT is
returned.

Signed-off-by: Tom Lyon <pugs@cisco.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   40 ++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths
+++ a/drivers/pci/intel-iommu.c
@@ -3433,19 +3433,6 @@ static void vm_domain_remove_all_dev_inf
 /* domain id for virtual machine, it won't be set in context */
 static unsigned long vm_domid;
 
-static int vm_domain_min_agaw(struct dmar_domain *domain)
-{
-	int i;
-	int min_agaw = domain->agaw;
-
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
-		if (min_agaw > g_iommus[i]->agaw)
-			min_agaw = g_iommus[i]->agaw;
-	}
-
-	return min_agaw;
-}
-
 static struct dmar_domain *iommu_alloc_vm_domain(void)
 {
 	struct dmar_domain *domain;
@@ -3574,7 +3561,6 @@ static int intel_iommu_attach_device(str
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct intel_iommu *iommu;
 	int addr_width;
-	u64 end;
 
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
@@ -3597,14 +3583,30 @@ static int intel_iommu_attach_device(str
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-	end = DOMAIN_MAX_ADDR(addr_width);
-	end = end & VTD_PAGE_MASK;
-	if (end < dmar_domain->max_addr) {
-		printk(KERN_ERR "%s: iommu agaw (%d) is not "
+	if (addr_width > cap_mgaw(iommu->cap))
+		addr_width = cap_mgaw(iommu->cap);
+
+	if (dmar_domain->max_addr > (1LL << addr_width)) {
+		printk(KERN_ERR "%s: iommu width (%d) is not "
 		       "sufficient for the mapped address (%llx)\n",
-		       __func__, iommu->agaw, dmar_domain->max_addr);
+		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
+	dmar_domain->gaw = addr_width;
+
+	/*
+	 * Knock out extra levels of page tables if necessary
+	 */
+	while (iommu->agaw < dmar_domain->agaw) {
+		struct dma_pte *pte;
+
+		pte = dmar_domain->pgd;
+		if (dma_pte_present(pte)) {
+			free_pgtable_page(dmar_domain->pgd);
+			dmar_domain->pgd = (struct dma_pte *)dma_pte_addr(pte);
+		}
+		dmar_domain->agaw--;
+	}
 
 	return domain_add_dev_info(dmar_domain, pdev, CONTEXT_TT_MULTI_LEVEL);
 }
_

Patches currently in -mm which might be from pugs@cisco.com are

drivers-pci-intel-iommuc-intel_iommu_map_range-failed-at-very-end-of-address-space.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

