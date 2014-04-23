From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch added
 to -mm tree
Date: Wed, 23 Apr 2014 13:13:50 -0700
Message-ID: <53581efe.sEASbDR0vq7fMpHS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbaDWUNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 16:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, jg1.han@samsung.com, haojian.zhuang@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: + drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch added to -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,haojian.zhuang@linaro.org,jg1.han@samsung.com,sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 13:13:50 -0700


The patch titled
     Subject: drivers/rtc/rtc-88pm860x.c: add missing of_node_put()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-88pm860x.c: add missing of_node_put()

Add missing of_node_put() to decrement the reference count.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm860x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-add-missing-of_node_put drivers/rtc/rtc-88pm860x.c
--- a/drivers/rtc/rtc-88pm860x.c~drivers-rtc-rtc-88pm860xc-add-missing-of_node_put
+++ a/drivers/rtc/rtc-88pm860x.c
@@ -301,6 +301,7 @@ static int pm860x_rtc_dt_init(struct pla
 	ret = of_property_read_u32(np, "marvell,88pm860x-vrtc", &info->vrtc);
 	if (ret)
 		info->vrtc = 0;
+	of_node_put(np);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

drivers-rtc-rtc-88pm860xc-use-of_get_child_by_name.patch
drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch
linux-next.patch
mfd-rtc-s5m-do-not-allocate-rtc-i2c-dummy-and-regmap-for-unsupported-chipsets.patch
mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch
rtc-s5m-remove-undocumented-time-init-on-first-boot.patch
rtc-s5m-use-shorter-time-of-register-update.patch
rtc-s5m-support-different-register-layout.patch
rtc-s5m-add-support-for-s2mps14-rtc.patch
rtc-s5m-consolidate-two-device-type-switch-statements.patch

