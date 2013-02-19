From: akpm@linux-foundation.org
Subject: + video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch added to -mm tree
Date: Tue, 19 Feb 2013 14:41:27 -0800
Message-ID: <20130219224128.2A20D5A43B8@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:43991 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab3BSWl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 17:41:29 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so467822qah.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 14:41:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajaykumar.rs@samsung.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com


The patch titled
     Subject: video: exynos_dp: move disable_irq() to exynos_dp_suspend()
has been added to the -mm tree.  Its filename is
     video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: video: exynos_dp: move disable_irq() to exynos_dp_suspend()

disable_irq() should be moved to exynos_dp_suspend(), because enable_irq()
is called at exynos_dp_resume().

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_dp_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-move-disable_irq-to-exynos_dp_suspend drivers/video/exynos/exynos_dp_core.c
--- a/drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-move-disable_irq-to-exynos_dp_suspend
+++ a/drivers/video/exynos/exynos_dp_core.c
@@ -1124,8 +1124,6 @@ static int exynos_dp_remove(struct platf
 	struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
 	struct exynos_dp_device *dp = platform_get_drvdata(pdev);
 
-	disable_irq(dp->irq);
