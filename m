From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:31:48 -0700
Message-ID: <51db13a4.Sk4K5WJQ9O+0dpt3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:32:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:31:48 -0700


The patch titled
     Subject: rtc: rtc-ds1302: remove unnecessary platform_set_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1302: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d063100 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata
+++ a/drivers/rtc/rtc-ds1302.c
@@ -236,8 +236,6 @@ static int __init ds1302_rtc_probe(struc
 
 static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
