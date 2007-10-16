From: akpm@linux-foundation.org
Subject: - rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:21 -0700
Message-ID: <200710162041.l9GKfLbl015782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936110AbXJPV0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: make rtc-ds1553 driver hotplug-aware
has been removed from the -mm tree.  Its filename was
     rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: make rtc-ds1553 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The rtc-ds1553 platform driver name doesn't match its module name, which
might prevent it from properly hotplugging.  This driver has no in-tree
users.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-make-rtc-ds1553-driver-hotplug-aware-take-3 drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-make-rtc-ds1553-driver-hotplug-aware-take-3
+++ a/drivers/rtc/rtc-ds1553.c
@@ -395,7 +395,7 @@ static struct platform_driver ds1553_rtc
 	.probe		= ds1553_rtc_probe,
 	.remove		= __devexit_p(ds1553_rtc_remove),
 	.driver		= {
-		.name	= "ds1553",
+		.name	= "rtc-ds1553",
 		.owner	= THIS_MODULE,
 	},
 };
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
