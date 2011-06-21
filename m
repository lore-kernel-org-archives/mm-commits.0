From: akpm@linux-foundation.org
Subject: + drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data.patch added to -mm tree
Date: Tue, 21 Jun 2011 11:52:28 -0700
Message-ID: <201106211852.p5LIqSDt017335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396Ab1FUSwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 14:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aghayal@codeaurora.org


The patch titled
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data
has been added to the -mm tree.  Its filename is
     drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-do-not-use-mfd_get_data.patch

