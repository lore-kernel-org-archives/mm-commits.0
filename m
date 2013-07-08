From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tilec-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:32:46 -0700
Message-ID: <51db13de.QFq+4cWH3yLWnfgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-tilec-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:32:46 -0700


The patch titled
     Subject: drivers/rtc/rtc-tile.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tilec-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-tile.c: remove empty function

After the switch to devm_ functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything. 
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tile.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/rtc/rtc-tile.c~drivers-rtc-rtc-tilec-remove-empty-function drivers/rtc/rtc-tile.c
--- a/drivers/rtc/rtc-tile.c~drivers-rtc-rtc-tilec-remove-empty-function
+++ a/drivers/rtc/rtc-tile.c
@@ -91,21 +91,12 @@ static int tile_rtc_probe(struct platfor
 	return 0;
 }
 
-/*
- * Device cleanup routine.
- */
-static int tile_rtc_remove(struct platform_device *dev)
-{
-	return 0;
-}
