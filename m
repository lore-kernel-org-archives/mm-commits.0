From: akpm@linux-foundation.org
Subject: - intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix.patch removed from -mm tree
Date: Tue, 13 May 2008 14:35:00 -0700
Message-ID: <200805132135.m4DLZ0OK000980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756333AbYEMVfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, greg@kroah.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running fix
has been removed from the -mm tree.  Its filename was
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running fix
From: mark gross <mgross@linux.intel.com>

Think-oh in patch.  it works as implemented but the panic line does not
need the KERN_ERR string included :(  Can you use the following?

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running-fix
+++ a/drivers/pci/intel-iommu.c
@@ -496,7 +496,7 @@ static int iommu_alloc_root_entry(struct
 		if (cond)\
 			break;\
 		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
-			panic(KERN_ERR "DMAR hardware is malfunctioning\n");\
+			panic("DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
linux-next.patch

