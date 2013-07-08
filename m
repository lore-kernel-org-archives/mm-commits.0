From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-max6900c-remove-empty-function.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:12 -0700
Message-ID: <51db1434.UKqsNfowqTl3N/Uo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GHTeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dale@farnsworth.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-max6900c-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,dale@farnsworth.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:12 -0700


The patch titled
     Subject: drivers/rtc/rtc-max6900.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-max6900c-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-max6900.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Dale Farnsworth <dale@farnsworth.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-max6900.c~drivers-rtc-rtc-max6900c-remove-empty-function drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~drivers-rtc-rtc-max6900c-remove-empty-function
+++ a/drivers/rtc/rtc-max6900.c
@@ -212,11 +212,6 @@ static int max6900_rtc_set_time(struct d
 	return max6900_i2c_set_time(to_i2c_client(dev), tm);
 }
 
-static int max6900_remove(struct i2c_client *client)
-{
-	return 0;
-}
