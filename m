From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing.patch added to -mm tree
Date: Thu, 23 May 2013 16:55:13 -0700
Message-ID: <519eac61.xOa0QVUkiLPeUGRZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab3EWXzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, kyungmin.park@samsung.com, jg1.han@samsung.com, t.figa@samsung.com

Subject: + drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing.patch added to -mm tree
To: t.figa@samsung.com,jg1.han@samsung.com,kyungmin.park@samsung.com,sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:55:13 -0700


The patch titled
     Subject: drivers/rtc/rtc-max8998.c: check for pdata presence before dereferencing
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomasz Figa <t.figa@samsung.com>
Subject: drivers/rtc/rtc-max8998.c: check for pdata presence before dereferencing

Currently the driver can crash with a NULL pointer dereference if no pdata
is provided, despite of successful registration of the MFD part.  This
patch fixes the problem by adding a NULL check before dereferencing the
pdata pointer.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max8998.c~drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing drivers/rtc/rtc-max8998.c
--- a/drivers/rtc/rtc-max8998.c~drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing
+++ a/drivers/rtc/rtc-max8998.c
@@ -285,7 +285,7 @@ static int max8998_rtc_probe(struct plat
 			info->irq, ret);
 
 	dev_info(&pdev->dev, "RTC CHIP NAME: %s\n", pdev->id_entry->name);
-	if (pdata->rtc_delay) {
+	if (pdata && pdata->rtc_delay) {
 		info->lp3974_bug_workaround = true;
 		dev_warn(&pdev->dev, "LP3974 with RTC REGERR option."
 				" RTC updates will be extremely slow.\n");
_

Patches currently in -mm which might be from t.figa@samsung.com are

linux-next.patch
drivers-rtc-rtc-max8998c-check-for-pdata-presence-before-dereferencing.patch

