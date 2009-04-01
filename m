From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-remove-a-couple-unnecessary-variables.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:03 -0700
Message-ID: <200904011842.n31Ig3IF009575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933483AbZDASre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: remove a couple unnecessary variables
has been removed from the -mm tree.  Its filename was
     rtc-parisc-remove-a-couple-unnecessary-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: remove a couple unnecessary variables
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-remove-a-couple-unnecessary-variables drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-remove-a-couple-unnecessary-variables
+++ a/drivers/rtc/rtc-parisc.c
@@ -25,11 +25,7 @@ static int parisc_get_time(struct device
 
 static int parisc_set_time(struct device *dev, struct rtc_time *tm)
 {
-	int ret;
-
-	ret = set_rtc_time(tm);
-
-	if (ret < 0)
+	if (set_rtc_time(tm) < 0)
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -46,10 +42,8 @@ static int __init parisc_rtc_probe(struc
 
 	p = rtc_device_register("rtc-parisc", &dev->dev, &parisc_rtc_ops,
 				THIS_MODULE);
-	if (IS_ERR(p)) {
-		int err = PTR_ERR(p);
-		return err;
-	}
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
 	platform_set_drvdata(dev, p);
 
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

