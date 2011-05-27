From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:11 -0700
Message-ID: <201105271955.p4RJtGIf017438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756976Ab1E0Tzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-mrst.c: use release_mem_region after request_mem_region
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-mrst.c: use release_mem_region after request_mem_region
From: Julia Lawall <julia@diku.dk>

The memory allocated using request_mem_region should be released using
release_mem_region, not release_region.

The semantic patch that fixes part of this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1,E2,E3;
@@

request_mem_region(E1,E2,E3)
...
?- release_region(E1,E2)
+ release_mem_region(E1,E2)
// </smpl>

[akpm@linux-foundation.org: use resource_size()]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mrst.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region
+++ a/drivers/rtc/rtc-mrst.c
@@ -380,7 +380,7 @@ cleanup1:
 cleanup0:
 	dev_set_drvdata(dev, NULL);
 	mrst_rtc.dev = NULL;
-	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
 }
@@ -406,7 +406,7 @@ static void __devexit rtc_mrst_do_remove
 	mrst->rtc = NULL;
 
 	iomem = mrst->iomem;
-	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, resource_size(iomem));
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch

