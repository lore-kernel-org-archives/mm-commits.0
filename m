From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:03:36 -0700
Message-ID: <201107260003.p6Q03aZg006694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab1GZADh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aghayal@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data
has been removed from the -mm tree.  Its filename was
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data.patch

This patch was dropped because it was folded into drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data
From: Anirudh Ghayal <aghayal@codeaurora.org>

Signed-off-by: Anirudh Ghayal <aghayal@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -389,7 +389,8 @@ static int __devinit pm8xxx_rtc_probe(st
 	bool rtc_write_enable = false;
 	struct pm8xxx_rtc *rtc_dd;
 	struct resource *rtc_resource;
-	const struct pm8xxx_rtc_platform_data *pdata = mfd_get_data(pdev);
+	const struct pm8xxx_rtc_platform_data *pdata =
+						dev_get_platdata(&pdev->dev);
 
 	if (pdata != NULL)
 		rtc_write_enable = pdata->rtc_write_enable;
_

Patches currently in -mm which might be from aghayal@codeaurora.org are

drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch

