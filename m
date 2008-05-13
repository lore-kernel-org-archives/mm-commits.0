From: akpm@linux-foundation.org
Subject: - intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:58 -0700
Message-ID: <200805132134.m4DLYwQs000972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760466AbYEMVfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:35:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, greg@kroah.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     intel-iommu: make intel iommu_wait_op() work when jiffies aren't running
has been removed from the -mm tree.  Its filename was
     intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu: make intel iommu_wait_op() work when jiffies aren't running
From: mark gross <mgross@linux.intel.com>

I've noticed that a few times when the bios is buggy the code for detecting
failing DMAR hardware can get stuck in an infinite loop in early boot waiting
for jiffies to time out.  Which are not running at the time we get stuck in
this macro.

This patch replaces the use of the jiffies to detect the failing hardware with
the tsc counter.  Not a big change, instead of getting a black screen forever,
you get a panic...

I also changed the time out from an arbitrary 60 seconds to an arbitrary 10
seconds.

Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-make-intel-iommu_wait_op-work-when-jiffies-arent-running
+++ a/drivers/pci/intel-iommu.c
@@ -49,7 +49,7 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
 
-#define DMAR_OPERATION_TIMEOUT (HZ*60) /* 1m */
+#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
 
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
@@ -490,13 +490,13 @@ static int iommu_alloc_root_entry(struct
 
 #define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
 {\
-	unsigned long start_time = jiffies;\
+	cycles_t start_time = get_cycles();\
 	while (1) {\
 		sts = op (iommu->reg + offset);\
 		if (cond)\
 			break;\
-		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))\
-			panic("DMAR hardware is malfunctioning\n");\
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+			panic(KERN_ERR "DMAR hardware is malfunctioning\n");\
 		cpu_relax();\
 	}\
 }
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
linux-next.patch

