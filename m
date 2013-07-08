From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max77686c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:16 -0700
Message-ID: <51db1438.hMtvSCghaZCrCzTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GHTeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, woong.byun@samsung.com, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-max77686c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,woong.byun@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:16 -0700


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max77686c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max77686.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-remove-empty-function drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~drivers-rtc-rtc-max77686c-remove-empty-function
+++ a/drivers/rtc/rtc-max77686.c
@@ -567,11 +567,6 @@ err_rtc:
 	return ret;
 }
 
-static int max77686_rtc_remove(struct platform_device *pdev)
-{
-	return 0;
-}
