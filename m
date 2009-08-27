From: akpm@linux-foundation.org
Subject: [merged] pps-fix-incorrect-verdict-check.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:07 -0700
Message-ID: <200908271918.n7RJI7mG009621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbZH0TSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joonwpark81@gmail.com, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     pps: fix incorrect verdict check
has been removed from the -mm tree.  Its filename was
     pps-fix-incorrect-verdict-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: fix incorrect verdict check
From: Joonwoo Park <joonwpark81@gmail.com>

Fix incorrect verdict check and returns error if device_create failed,
otherwise driver triggers kernel oops.

Signed-off-by: Joonwoo Park<joonwpark81@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/pps.c~pps-fix-incorrect-verdict-check drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-fix-incorrect-verdict-check
+++ a/drivers/pps/pps.c
@@ -244,7 +244,7 @@ int pps_register_cdev(struct pps_device 
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, pps->devno, NULL,
 							"pps%d", pps->id);
-	if (err)
+	if (IS_ERR(pps->dev))
 		goto del_cdev;
 	dev_set_drvdata(pps->dev, pps);
 
_

Patches currently in -mm which might be from joonwpark81@gmail.com are

origin.patch

