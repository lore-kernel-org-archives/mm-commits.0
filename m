From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:15:33 -0700
Message-ID: <201105262315.p4QNFYw5026289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405Ab1EZXQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix
From: Andrew Morton <akpm@linux-foundation.org>

use resource_size()

Cc: Julia Lawall <julia@diku.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mrst.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix
+++ a/drivers/rtc/rtc-mrst.c
@@ -380,7 +380,7 @@ cleanup1:
 cleanup0:
 	dev_set_drvdata(dev, NULL);
 	mrst_rtc.dev = NULL;
-	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
 }
@@ -406,7 +406,7 @@ static void __devexit rtc_mrst_do_remove
 	mrst->rtc = NULL;
 
 	iomem = mrst->iomem;
-	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
ufs-truncated-values-handling-64-bit-metadata-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

