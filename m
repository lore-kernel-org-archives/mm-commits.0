From: akpm@linux-foundation.org
Subject: + rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
 added to -mm tree
Date: Mon, 02 Mar 2015 16:00:10 -0800
Message-ID: <54f4f98a.VYvdZD/FHMLtaz9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbCCAAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumba@gentoo.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1685.c: remove .owner assignment from platform_driver
has been added to the -mm tree.  Its filename is
     rtc-ds1685-remove-owner-assignment-from-platform_driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1685-remove-owner-assignment-from-platform_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-ds1685-remove-owner-assignment-from-platform_driver.patch
mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch

