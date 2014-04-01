From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch added to -mm tree
Date: Tue, 01 Apr 2014 15:51:16 -0700
Message-ID: <533b42e4.eVBa0QNl7aDhWFnx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaDAWvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 18:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dmitry.torokhov@gmail.com, a.zummo@towertech.it, Adam.Thomson.Opensource@diasemi.com

Subject: + drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch added to -mm tree
To: Adam.Thomson.Opensource@diasemi.com,a.zummo@towertech.it,dmitry.torokhov@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 15:51:16 -0700


The patch titled
     Subject: drivers/rtc/rtc-da9055.c: remove use of regmap_irq_get_virq()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9055.c: remove use of regmap_irq_get_virq()

Using platform_get_irq_byname() to retrieve the IRQ number returns the
VIRQ number rather than the local IRQ number for the device.  Passing that
value then into regmap_irq_get_virq() causes a failure because the
function is expecting the local IRQ number (e.g.  0, 1, 2, 3, etc).

This patch removes use of regmap_irq_get_virq() to prevent this failure
from happening

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9055.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-da9055.c~drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq drivers/rtc/rtc-da9055.c
--- a/drivers/rtc/rtc-da9055.c~drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq
+++ a/drivers/rtc/rtc-da9055.c
@@ -302,7 +302,9 @@ static int da9055_rtc_probe(struct platf
 	}
 
 	alm_irq = platform_get_irq_byname(pdev, "ALM");
-	alm_irq = regmap_irq_get_virq(rtc->da9055->irq_data, alm_irq);
+	if (alm_irq < 0)
+		return alm_irq;
+
 	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
 					da9055_rtc_alm_irq,
 					IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
_

Patches currently in -mm which might be from Adam.Thomson.Opensource@diasemi.com are

drivers-rtc-rtc-da9055c-remove-use-of-regmap_irq_get_virq.patch
input-da9055_onkey-remove-use-of-regmap_irq_get_virq.patch
linux-next.patch

