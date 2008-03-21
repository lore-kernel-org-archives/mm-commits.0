From: akpm@linux-foundation.org
Subject: - iova-lockdep-false-alarm-fix.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:37 -0700
Message-ID: <200803212031.m2LKVbBg009085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757634AbYCUUbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     iova: lockdep false alarm fix
has been removed from the -mm tree.  Its filename was
     iova-lockdep-false-alarm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iova: lockdep false alarm fix
From: mark gross <mgross@linux.intel.com>

lockdep goes off on the iova copy_reserved_iova() because it and a function
it calls grabs locks in the from, and the to of the copy operation.

The function grab locks of the same lock classes triggering the warning.  The
first lock grabbed is for the constant reserved areas that is never accessed
after early boot.  Technically you could do without grabbing the locks for the
"from" structure its copying reserved areas from.

But dropping the from locks to me looks wrong, even though it would be ok.

The affected code only runs in early boot as its setting up the DMAR
engines.

This patch gives the reserved_ioval_list locks special lockdep classes.

Signed-off-by: <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/pci/intel-iommu.c~iova-lockdep-false-alarm-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~iova-lockdep-false-alarm-fix
+++ a/drivers/pci/intel-iommu.c
@@ -1125,6 +1125,8 @@ static void iommu_free_domain(struct dma
 }
 
 static struct iova_domain reserved_iova_list;
+static struct lock_class_key reserved_alloc_key;
+static struct lock_class_key reserved_rbtree_key;
 
 static void dmar_init_reserved_ranges(void)
 {
@@ -1135,6 +1137,11 @@ static void dmar_init_reserved_ranges(vo
 
 	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
 
+	lockdep_set_class(&reserved_iova_list.iova_alloc_lock,
+		&reserved_alloc_key);
+	lockdep_set_class(&reserved_iova_list.iova_rbtree_lock,
+		&reserved_rbtree_key);
+
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
 		IOVA_PFN(IOAPIC_RANGE_END));
_

Patches currently in -mm which might be from mgross@linux.intel.com are

pci-iommu-iotlb-flushing-speedup.patch

