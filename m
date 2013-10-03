From: akpm@linux-foundation.org
Subject: +
 drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch added to -mm tree
Date: Thu, 03 Oct 2013 15:15:43 -0700
Message-ID: <524dec8f.kM8FjAWtlbjrTgxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab3JCWPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 18:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, yongjun_wei@trendmicro.com.cn

Subject: + drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 15:15:43 -0700


The patch titled
     Subject: drivers/video/backlight/lm3630a_bl.c: add missing destroy_workqueue() on error in lm3630a_intr_config()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/video/backlight/lm3630a_bl.c: add missing destroy_workqueue() on error in lm3630a_intr_config()

Add the missing destroy_workqueue() before return from
lm3630a_intr_config() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630a_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/lm3630a_bl.c~drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config drivers/video/backlight/lm3630a_bl.c
--- a/drivers/video/backlight/lm3630a_bl.c~drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config
+++ a/drivers/video/backlight/lm3630a_bl.c
@@ -154,6 +154,7 @@ static int lm3630a_intr_config(struct lm
 	    (pchip->irq, NULL, lm3630a_isr_func,
 	     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "lm3630a_irq", pchip)) {
 		dev_err(pchip->dev, "request threaded irq fail\n");
+		destroy_workqueue(pchip->irqthread);
 		return -ENOMEM;
 	}
 	return rval;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
drivers-video-backlight-lm3630a_blc-add-missing-destroy_workqueue-on-error-in-lm3630a_intr_config.patch
drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch
linux-next.patch

