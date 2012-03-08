From: akpm@linux-foundation.org
Subject: [merged] x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:39 -0800
Message-ID: <20120308191739.81DCDA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:51308 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2CHTRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:41 -0500
Received: by vcbfk26 with SMTP id fk26so103738vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, chrisw@sous-sol.org, drahn@suse.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, pci: increase the number of iommus supported to be MAX_IO_APICS
has been removed from the -mm tree.  Its filename was
     x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86, pci: increase the number of iommus supported to be MAX_IO_APICS

The number of IOMMUs supported should be the same as the number of IO
APICS.  This limit comes into play when the IOMMUs are identity mapped,
thus the number of possible IOMMUs in the "static identity" (si) domain
should be this same number.

[akpm@linux-foundation.org: fix printk format string, code cleanup]
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Daniel Rahn <drahn@suse.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/intel-iommu.c |   39 ++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff -puN drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics
+++ a/drivers/iommu/intel-iommu.c
@@ -354,10 +354,18 @@ static int hw_pass_through = 1;
 /* si_domain contains mulitple devices */
 #define DOMAIN_FLAG_STATIC_IDENTITY	(1 << 2)
 
+/* define the limit of IOMMUs supported in each domain */
+#ifdef	CONFIG_X86
+#define	IOMMU_UNITS_SUPPORTED	MAX_IO_APICS
+#else
+#define	IOMMU_UNITS_SUPPORTED	64
+#endif
+
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
+	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
+					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
@@ -569,7 +577,7 @@ static struct intel_iommu *domain_get_io
 	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
 	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
 
-	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
 
@@ -582,7 +590,7 @@ static void domain_update_iommu_coherenc
 
 	domain->iommu_coherency = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
@@ -596,7 +604,7 @@ static void domain_update_iommu_snooping
 
 	domain->iommu_snooping = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
@@ -1332,7 +1340,7 @@ static struct dmar_domain *alloc_domain(
 		return NULL;
 
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
 
 	return domain;
@@ -1358,7 +1366,7 @@ static int iommu_attach_domain(struct dm
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, &domain->iommu_bmp);
+	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -1383,7 +1391,7 @@ static void iommu_detach_domain(struct d
 
 	if (found) {
 		clear_bit(num, iommu->domain_ids);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		iommu->domains[num] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -1525,7 +1533,7 @@ static void domain_exit(struct dmar_doma
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
 	for_each_active_iommu(iommu, drhd)
-		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 
 	free_domain_mem(domain);
@@ -1651,7 +1659,7 @@ static int domain_context_mapping_one(st
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
 		domain->iommu_count++;
 		if (domain->iommu_count == 1)
 			domain->nid = iommu->node;
@@ -2400,12 +2408,17 @@ static int __init init_dmars(void)
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
-		g_num_of_iommus++;
 		/*
 		 * lock not needed as this is only incremented in the single
 		 * threaded kernel __init code path all other access are read
 		 * only
 		 */
+		if (g_num_of_iommus < IOMMU_UNITS_SUPPORTED) {
+			g_num_of_iommus++;
+			continue;
+		}
+		printk_once(KERN_ERR "intel-iommu: exceeded %d IOMMUs\n",
+			  IOMMU_UNITS_SUPPORTED);
 	}
 
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
@@ -3747,7 +3760,7 @@ static void domain_remove_one_dev_info(s
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
@@ -3789,7 +3802,7 @@ static void vm_domain_remove_all_dev_inf
 		 */
 		spin_lock_irqsave(&domain->iommu_lock, flags2);
 		if (test_and_clear_bit(iommu->seq_id,
-				       &domain->iommu_bmp)) {
+				       domain->iommu_bmp)) {
 			domain->iommu_count--;
 			domain_update_iommu_cap(domain);
 		}
@@ -3814,7 +3827,7 @@ static struct dmar_domain *iommu_alloc_v
 
 	domain->id = vm_domid++;
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
 	return domain;
_

Patches currently in -mm which might be from travis@sgi.com are

linux-next.patch

