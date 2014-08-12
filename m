From: akpm@linux-foundation.org
Subject: [merged]
 rtc-tps65910-fix-potential-null-pointer-dereference.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:38:56 -0700
Message-ID: <53ea6d50.Z436scsCRGgiMxHn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49687 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaHLTi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:56 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2671133pab.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: fix potential NULL-pointer dereference
has been removed from the -mm tree.  Its filename was
     rtc-tps65910-fix-potential-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: fix potential NULL-pointer dereference

The interrupt handler gets the driver data associated with the RTC device
and doesn't check it for validity.  This can cause a NULL pointer being
dereferenced when and interrupt fires before the driver data was properly
set up.

Fix this by setting the driver data earlier (before the interrupt is
requested).

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~rtc-tps65910-fix-potential-null-pointer-dereference drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~rtc-tps65910-fix-potential-null-pointer-dereference
+++ a/drivers/rtc/rtc-tps65910.c
@@ -258,6 +258,8 @@ static int tps65910_rtc_probe(struct pla
 	if (ret < 0)
 		return ret;
 
+	platform_set_drvdata(pdev, tps_rtc);
+
 	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
@@ -283,8 +285,6 @@ static int tps65910_rtc_probe(struct pla
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, tps_rtc);
