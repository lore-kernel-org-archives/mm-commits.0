From: akpm@linux-foundation.org
Subject: + drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:44:03 -0700
Message-ID: <201004192244.o3JMi3EH014071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab0DSWoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:44:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pugs@cisco.com, dwmw2@infradead.org, fenghua.yu@intel.com, jbarnes@virtuousgeek.org, joerg.roedel@amd.com


The patch titled
     drivers/pci/intel-iommu.c: errors with smaller iommu widths
has been added to the -mm tree.  Its filename is
     drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/pci/intel-iommu.c: errors with smaller iommu widths
=46rom: "Tom Lyon" <pugs@cisco.com>

When using iommu_domain_alloc with the Intel iommu, the domain address
width is always initialized to 48 bits (agaw 2).  =C2=A0This domain->ag=
aw
value is then used by pfn_to_dma_pte to (always) build a 4 level page
table.  =C2=A0However, not all systems support iommu width of 48 or 4 l=
evel
page tables.  =C2=A0In particular, the Core i5-660 and i5-670 support a=
n
address width of 36 bits (not 39!), an agaw of only 1, and only 3 level
page tables.

This version of the patch simply lops off extra levels of the page tabl=
es
if the agaw value of the iommu is less than what is currently allocated
for the domain (in intel_iommu_attach_device).  If there were already
allocated addresses above what the new iommu can handle, EFAULT is
returned.

A related bug in intel_iommu_map_range() didn't allow allocation at the
very end of the address space, that code has been simplified and
corrected.

Signed-off-by: Tom Lyon <pugs@cisco.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   51 ++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff -puN drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-errors-wit=
h-smaller-iommu-widths drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~drivers-pci-intel-iommuc-errors-with-sm=
aller-iommu-widths
+++ a/drivers/pci/intel-iommu.c
@@ -3433,19 +3433,6 @@ static void vm_domain_remove_all_dev_inf
 /* domain id for virtual machine, it won't be set in context */
 static unsigned long vm_domid;
=20
-static int vm_domain_min_agaw(struct dmar_domain *domain)
-{
-	int i;
-	int min_agaw =3D domain->agaw;
-
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
-		if (min_agaw > g_iommus[i]->agaw)
-			min_agaw =3D g_iommus[i]->agaw;
-	}
-
-	return min_agaw;
-}
-
 static struct dmar_domain *iommu_alloc_vm_domain(void)
 {
 	struct dmar_domain *domain;
@@ -3574,7 +3561,6 @@ static int intel_iommu_attach_device(str
 	struct pci_dev *pdev =3D to_pci_dev(dev);
 	struct intel_iommu *iommu;
 	int addr_width;
-	u64 end;
=20
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
@@ -3597,14 +3583,30 @@ static int intel_iommu_attach_device(str
=20
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width =3D agaw_to_width(iommu->agaw);
-	end =3D DOMAIN_MAX_ADDR(addr_width);
-	end =3D end & VTD_PAGE_MASK;
-	if (end < dmar_domain->max_addr) {
-		printk(KERN_ERR "%s: iommu agaw (%d) is not "
+	if (addr_width > cap_mgaw(iommu->cap))
+		addr_width =3D cap_mgaw(iommu->cap);
+
+	if (dmar_domain->max_addr > (1LL << addr_width)) {
+		printk(KERN_ERR "%s: iommu width (%d) is not "
 		       "sufficient for the mapped address (%llx)\n",
-		       __func__, iommu->agaw, dmar_domain->max_addr);
+		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
+	dmar_domain->gaw =3D addr_width;
+
+	/*
+	 * Knock out extra levels of page tables if necessary
+	 */
+	while (iommu->agaw < dmar_domain->agaw) {
+		struct dma_pte *pte;
+
+		pte =3D dmar_domain->pgd;
+		if (dma_pte_present(pte)) {
+			free_pgtable_page(dmar_domain->pgd);
+			dmar_domain->pgd =3D (struct dma_pte *)dma_pte_addr(pte);
+		}
+		dmar_domain->agaw--;
+	}
=20
 	return domain_add_dev_info(dmar_domain, pdev, CONTEXT_TT_MULTI_LEVEL)=
;
 }
@@ -3624,7 +3626,6 @@ static int intel_iommu_map_range(struct=20
 {
 	struct dmar_domain *dmar_domain =3D domain->priv;
 	u64 max_addr;
-	int addr_width;
 	int prot =3D 0;
 	int ret;
=20
@@ -3637,18 +3638,14 @@ static int intel_iommu_map_range(struct=20
=20
 	max_addr =3D iova + size;
 	if (dmar_domain->max_addr < max_addr) {
-		int min_agaw;
 		u64 end;
=20
 		/* check if minimum agaw is sufficient for mapped address */
-		min_agaw =3D vm_domain_min_agaw(dmar_domain);
-		addr_width =3D agaw_to_width(min_agaw);
-		end =3D DOMAIN_MAX_ADDR(addr_width);
-		end =3D end & VTD_PAGE_MASK;
+		end =3D __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
 		if (end < max_addr) {
-			printk(KERN_ERR "%s: iommu agaw (%d) is not "
+			printk(KERN_ERR "%s: iommu width (%d) is not "
 			       "sufficient for the mapped address (%llx)\n",
-			       __func__, min_agaw, max_addr);
+			       __func__, dmar_domain->gaw, max_addr);
 			return -EFAULT;
 		}
 		dmar_domain->max_addr =3D max_addr;
_

Patches currently in -mm which might be from pugs@cisco.com are

drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
