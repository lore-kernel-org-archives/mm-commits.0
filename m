From: akpm@linux-foundation.org
Subject: [merged]
 iommu-common-do-not-try-to-deref-a-null-iommu-lazy_flush-pointer-when-n-pool-hint.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:04 -0700
Message-ID: <560983e4.3Y0Kmdn/jPAhSBkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sowmini.varadhan@oracle.com, benh@kernel.crashing.org, davem@davemloft.net, linux@roeck-us.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/iommu-common.c: do not try to deref a null iommu->lazy_flush() pointer when n < pool->hint
has been removed from the -mm tree.  Its filename was
     iommu-common-do-not-try-to-deref-a-null-iommu-lazy_flush-pointer-when-n-pool-hint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: lib/iommu-common.c: do not try to deref a null iommu->lazy_flush() pointer when n < pool->hint

The check for invoking iommu->lazy_flush() from iommu_tbl_range_alloc()
has to be refactored so that we only call ->lazy_flush() if it is
non-null.

I had a sparc kernel that was crashing when I was trying to process
some very large perf.data files- the crash happens when the scsi
driver calls into dma_4v_map_sg and thus the iommu_tbl_range_alloc().

Signed-off-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iommu-common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/iommu-common.c~iommu-common-do-not-try-to-deref-a-null-iommu-lazy_flush-pointer-when-n-pool-hint lib/iommu-common.c
--- a/lib/iommu-common.c~iommu-common-do-not-try-to-deref-a-null-iommu-lazy_flush-pointer-when-n-pool-hint
+++ a/lib/iommu-common.c
@@ -21,8 +21,7 @@ static	DEFINE_PER_CPU(unsigned int, iomm
 
 static inline bool need_flush(struct iommu_map_table *iommu)
 {
-	return (iommu->lazy_flush != NULL &&
-		(iommu->flags & IOMMU_NEED_FLUSH) != 0);
+	return ((iommu->flags & IOMMU_NEED_FLUSH) != 0);
 }
 
 static inline void set_flush(struct iommu_map_table *iommu)
@@ -211,7 +210,8 @@ unsigned long iommu_tbl_range_alloc(stru
 			goto bail;
 		}
 	}
-	if (n < pool->hint || need_flush(iommu)) {
+	if (iommu->lazy_flush &&
+	    (n < pool->hint || need_flush(iommu))) {
 		clear_flush(iommu);
 		iommu->lazy_flush(iommu);
 	}
_

Patches currently in -mm which might be from sowmini.varadhan@oracle.com are


