From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch added to -mm tree
Date: Thu, 07 Apr 2011 16:02:26 -0700
Message-ID: <201104072302.p37N2QON005629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab1DGXDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 19:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, a.zummo@towertech.it


The patch titled
     drivers/rtc/rtc-mrst.c: use release_mem_region after request_mem_region
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
+	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
 }
@@ -406,7 +406,7 @@ static void __devexit rtc_mrst_do_remove
 	mrst->rtc = NULL;
 
 	iomem = mrst->iomem;
-	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch

