From: akpm@linux-foundation.org
Subject: [merged] intel-iommu-use-for_each_set_bit.patch removed from -mm tree
Date: Mon, 12 Apr 2010 12:16:48 -0400
Message-ID: <201004121918.o3CJIPIY022003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab0DLTS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 15:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     intel-iommu: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     intel-iommu-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-use-for_each_set_bit drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-use-for_each_set_bit
+++ a/drivers/pci/intel-iommu.c
@@ -491,13 +491,11 @@ static void domain_update_iommu_coherenc
 
 	domain->iommu_coherency = 1;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_coherent(g_iommus[i]->ecap)) {
 			domain->iommu_coherency = 0;
 			break;
 		}
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 }
 
@@ -507,13 +505,11 @@ static void domain_update_iommu_snooping
 
 	domain->iommu_snooping = 1;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (!ecap_sc_support(g_iommus[i]->ecap)) {
 			domain->iommu_snooping = 0;
 			break;
 		}
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 }
 
@@ -1194,8 +1190,7 @@ void free_dmar_iommu(struct intel_iommu 
 	unsigned long flags;
 
 	if ((iommu->domains) && (iommu->domain_ids)) {
-		i = find_first_bit(iommu->domain_ids, cap_ndoms(iommu->cap));
-		for (; i < cap_ndoms(iommu->cap); ) {
+		for_each_set_bit(i, iommu->domain_ids, cap_ndoms(iommu->cap)) {
 			domain = iommu->domains[i];
 			clear_bit(i, iommu->domain_ids);
 
@@ -1207,9 +1202,6 @@ void free_dmar_iommu(struct intel_iommu 
 					domain_exit(domain);
 			}
 			spin_unlock_irqrestore(&domain->iommu_lock, flags);
-
-			i = find_next_bit(iommu->domain_ids,
-				cap_ndoms(iommu->cap), i+1);
 		}
 	}
 
@@ -1292,14 +1284,11 @@ static void iommu_detach_domain(struct d
 
 	spin_lock_irqsave(&iommu->lock, flags);
 	ndomains = cap_ndoms(iommu->cap);
-	num = find_first_bit(iommu->domain_ids, ndomains);
-	for (; num < ndomains; ) {
+	for_each_set_bit(num, iommu->domain_ids, ndomains) {
 		if (iommu->domains[num] == domain) {
 			found = 1;
 			break;
 		}
-		num = find_next_bit(iommu->domain_ids,
-				    cap_ndoms(iommu->cap), num+1);
 	}
 
 	if (found) {
@@ -1485,15 +1474,12 @@ static int domain_context_mapping_one(st
 
 		/* find an available domain id for this device in iommu */
 		ndomains = cap_ndoms(iommu->cap);
-		num = find_first_bit(iommu->domain_ids, ndomains);
-		for (; num < ndomains; ) {
+		for_each_set_bit(num, iommu->domain_ids, ndomains) {
 			if (iommu->domains[num] == domain) {
 				id = num;
 				found = 1;
 				break;
 			}
-			num = find_next_bit(iommu->domain_ids,
-					    cap_ndoms(iommu->cap), num+1);
 		}
 
 		if (found == 0) {
@@ -3441,12 +3427,9 @@ static int vm_domain_min_agaw(struct dma
 	int i;
 	int min_agaw = domain->agaw;
 
-	i = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
-	for (; i < g_num_of_iommus; ) {
+	for_each_set_bit(i, &domain->iommu_bmp, g_num_of_iommus) {
 		if (min_agaw > g_iommus[i]->agaw)
 			min_agaw = g_iommus[i]->agaw;
-
-		i = find_next_bit(&domain->iommu_bmp, g_num_of_iommus, i+1);
 	}
 
 	return min_agaw;
@@ -3512,8 +3495,7 @@ static void iommu_free_vm_domain(struct 
 		iommu = drhd->iommu;
 
 		ndomains = cap_ndoms(iommu->cap);
-		i = find_first_bit(iommu->domain_ids, ndomains);
-		for (; i < ndomains; ) {
+		for_each_set_bit(i, iommu->domain_ids, ndomains) {
 			if (iommu->domains[i] == domain) {
 				spin_lock_irqsave(&iommu->lock, flags);
 				clear_bit(i, iommu->domain_ids);
@@ -3521,7 +3503,6 @@ static void iommu_free_vm_domain(struct 
 				spin_unlock_irqrestore(&iommu->lock, flags);
 				break;
 			}
-			i = find_next_bit(iommu->domain_ids, ndomains, i+1);
 		}
 	}
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
cpu-hotplug-introduce-cpu_notify-__cpu_notify-cpu_notify_nofail.patch
cpu-hotplug-return-better-errno-on-cpu-hotplug-failure.patch
notifier-change-notifier_from_errno0-to-return-notify_ok.patch
x86-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
topology-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
kernel-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
slab-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
iucv-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
ehca-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
md-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fault-injection-add-cpu-notifier-error-injection-module.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch

