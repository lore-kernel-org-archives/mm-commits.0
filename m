From: akpm@linux-foundation.org
Subject: + x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch added to -mm tree
Date: Wed, 22 Feb 2012 12:20:49 -0800
Message-ID: <20120222202049.F0C57A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:61776 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2BVUUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2012 15:20:51 -0500
Received: by vcbf1 with SMTP id f1so57769vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Feb 2012 12:20:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, chrisw@sous-sol.org, drahn@suse.com, dwmw2@infradead.org, jbarnes@virtuousgeek.org, mingo@elte.hu, steiner@sgi.com


The patch titled
     Subject: x86, pci: increase the number of iommus supported to be MAX_IO_APICS
has been added to the -mm tree.  Its filename is
     x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Travis <travis@sgi.com>
Subject: x86, pci: increase the number of iommus supported to be MAX_IO_APICS

The number of IOMMUs supported should be the same as the number of IO
APICS.  This limit comes into play when the IOMMUs are identity mapped,
thus the number of possible IOMMUs in the "static identity" (si) domain
should be this same number.

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

 drivers/iommu/intel-iommu.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics
+++ a/drivers/iommu/intel-iommu.c
@@ -357,7 +357,8 @@ static int hw_pass_through = 1;
 struct dmar_domain {
 	int	id;			/* domain id */
 	int	nid;			/* node id */
-	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
+	DECLARE_BITMAP(iommu_bmp, MAX_IO_APICS);
+					/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
@@ -569,7 +570,7 @@ static struct intel_iommu *domain_get_io
 	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
 	BUG_ON(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY);
 
-	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
+	iommu_id = find_first_bit(domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
 		return NULL;
 
@@ -582,7 +583,7 @@ static void domain_update_iommu_coherenc
 
 	domain->iommu_coherency = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
@@ -596,7 +597,7 @@ static void domain_update_iommu_snooping
 
 	domain->iommu_snooping = 1;
 
-	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
+	for_each_set_bit(i, domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
@@ -1332,7 +1333,7 @@ static struct dmar_domain *alloc_domain(
 		return NULL;
 
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = 0;
 
 	return domain;
@@ -1358,7 +1359,7 @@ static int iommu_attach_domain(struct dm
 
 	domain->id = num;
 	set_bit(num, iommu->domain_ids);
-	set_bit(iommu->seq_id, &domain->iommu_bmp);
+	set_bit(iommu->seq_id, domain->iommu_bmp);
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -1383,7 +1384,7 @@ static void iommu_detach_domain(struct d
 
 	if (found) {
 		clear_bit(num, iommu->domain_ids);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		iommu->domains[num] = NULL;
 	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -1525,7 +1526,7 @@ static void domain_exit(struct dmar_doma
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
 	for_each_active_iommu(iommu, drhd)
-		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
 
 	free_domain_mem(domain);
@@ -1651,7 +1652,7 @@ static int domain_context_mapping_one(st
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	spin_lock_irqsave(&domain->iommu_lock, flags);
-	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
+	if (!test_and_set_bit(iommu->seq_id, domain->iommu_bmp)) {
 		domain->iommu_count++;
 		if (domain->iommu_count == 1)
 			domain->nid = iommu->node;
@@ -3747,7 +3748,7 @@ static void domain_remove_one_dev_info(s
 	if (found == 0) {
 		unsigned long tmp_flags;
 		spin_lock_irqsave(&domain->iommu_lock, tmp_flags);
-		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		clear_bit(iommu->seq_id, domain->iommu_bmp);
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
@@ -3789,7 +3790,7 @@ static void vm_domain_remove_all_dev_inf
 		 */
 		spin_lock_irqsave(&domain->iommu_lock, flags2);
 		if (test_and_clear_bit(iommu->seq_id,
-				       &domain->iommu_bmp)) {
+				       domain->iommu_bmp)) {
 			domain->iommu_count--;
 			domain_update_iommu_cap(domain);
 		}
@@ -3814,7 +3815,7 @@ static struct dmar_domain *iommu_alloc_v
 
 	domain->id = vm_domid++;
 	domain->nid = -1;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	memset(domain->iommu_bmp, 0, sizeof(domain->iommu_bmp));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
 	return domain;
_
Subject: Subject: x86, pci: increase the number of iommus supported to be MAX_IO_APICS

Patches currently in -mm which might be from travis@sgi.com are

x86-pci-fix-identity-mapping-for-sandy-bridge.patch
x86-pci-increase-the-number-of-iommus-supported-to-be-max_io_apics.patch

