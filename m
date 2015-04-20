From: akpm@linux-foundation.org
Subject: [merged]
 rtc-ds1685-remove-owner-assignment-from-platform_driver.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:17:46 -0700
Message-ID: <553550da.b4Wo9xqiCbYot6r+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbDTTLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumba@gentoo.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1685.c: remove .owner assignment from platform_driver
has been removed from the -mm tree.  Its filename was
     rtc-ds1685-remove-owner-assignment-from-platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joshua Kinard <kumba@gentoo.org>
Subject: drivers/rtc/rtc-ds1685.c: remove .owner assignment from platform_driver

The rtc driver core now sets the platform_driver 'owner' property, so
remove the assignment from the DS1685 driver.

Fixes: aaaf5fbf56f1: "rtc: add driver for DS1685 family of real time clocks"
Signed-off-by: Joshua Kinard <kumba@gentoo.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1685.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1685.c~rtc-ds1685-remove-owner-assignment-from-platform_driver drivers/rtc/rtc-ds1685.c
--- a/drivers/rtc/rtc-ds1685.c~rtc-ds1685-remove-owner-assignment-from-platform_driver
+++ a/drivers/rtc/rtc-ds1685.c
@@ -2139,7 +2139,6 @@ ds1685_rtc_remove(struct platform_device
 static struct platform_driver ds1685_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-ds1685",
-		.owner	= THIS_MODULE,
 	},
 	.probe		= ds1685_rtc_probe,
 	.remove		= ds1685_rtc_remove,
_

Patches currently in -mm which might be from kumba@gentoo.org are

origin.patch

