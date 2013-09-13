From: akpm@linux-foundation.org
Subject: + w1-ds1wm-use-dev_get_platdata.patch added to -mm tree
Date: Fri, 13 Sep 2013 16:01:16 -0700
Message-ID: <5233993c.bgZTH9/3zWWr0pmA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3IMXBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 19:01:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, jg1.han@samsung.com

Subject: + w1-ds1wm-use-dev_get_platdata.patch added to -mm tree
To: jg1.han@samsung.com,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 16:01:16 -0700


The patch titled
     Subject: drivers/w1/masters/ds1wm.cuse dev_get_platdata()
has been added to the -mm tree.  Its filename is
     w1-ds1wm-use-dev_get_platdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-ds1wm-use-dev_get_platdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-ds1wm-use-dev_get_platdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/w1/masters/ds1wm.cuse dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wm-use-dev_get_platdata drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wm-use-dev_get_platdata
+++ a/drivers/w1/masters/ds1wm.c
@@ -255,17 +255,17 @@ static int ds1wm_find_divisor(int gclk)
 static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
 	int divisor;
-	struct ds1wm_driver_data *plat = ds1wm_data->pdev->dev.platform_data;
+	struct device *dev = &ds1wm_data->pdev->dev;
+	struct ds1wm_driver_data *plat = dev_get_platdata(dev);
 
 	if (ds1wm_data->cell->enable)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
 
 	divisor = ds1wm_find_divisor(plat->clock_rate);
-	dev_dbg(&ds1wm_data->pdev->dev,
-		"found divisor 0x%x for clock %d\n", divisor, plat->clock_rate);
+	dev_dbg(dev, "found divisor 0x%x for clock %d\n",
+		divisor, plat->clock_rate);
 	if (divisor == 0) {
-		dev_err(&ds1wm_data->pdev->dev,
-			"no suitable divisor for %dHz clock\n",
+		dev_err(dev, "no suitable divisor for %dHz clock\n",
 			plat->clock_rate);
 		return;
 	}
@@ -481,7 +481,7 @@ static int ds1wm_probe(struct platform_d
 	ds1wm_data->cell = mfd_get_cell(pdev);
 	if (!ds1wm_data->cell)
 		return -ENODEV;
-	plat = pdev->dev.platform_data;
+	plat = dev_get_platdata(&pdev->dev);
 	if (!plat)
 		return -ENODEV;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch

