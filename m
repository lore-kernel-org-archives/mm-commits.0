From: akpm@linux-foundation.org
Subject: + rtc-tps65910-fix-potential-null-pointer-dereference.patch added to -mm tree
Date: Wed, 06 Aug 2014 13:09:50 -0700
Message-ID: <53e28b8e.90tL2wfyYdT8xFcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:63173 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHFUJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 16:09:51 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so407992ykb.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 13:09:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: fix potential NULL-pointer dereference
has been added to the -mm tree.  Its filename is
     rtc-tps65910-fix-potential-null-pointer-dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-tps65910-fix-potential-null-pointer-dereference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-tps65910-fix-potential-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
