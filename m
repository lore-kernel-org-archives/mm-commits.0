From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:12 -0700
Message-ID: <53960b08.fVcEU55BCPh/yCOQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaFIT3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, jg1.han@samsung.com, haojian.zhuang@linaro.org, a.zummo@towertech.it, k.kozlowski@samsung.com

Subject: [merged] drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch removed from -mm tree
To: k.kozlowski@samsung.com,a.zummo@towertech.it,haojian.zhuang@linaro.org,jg1.han@samsung.com,sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:12 -0700


The patch titled
     Subject: drivers/rtc/rtc-88pm860x.c: add missing of_node_put()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-88pm860xc-add-missing-of_node_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mfd-rtc-sec-s5m-rename-sec-symbols-to-s5m.patch
rtc-s5m-remove-undocumented-time-init-on-first-boot.patch
rtc-s5m-use-shorter-time-of-register-update.patch
rtc-s5m-support-different-register-layout.patch
rtc-s5m-add-support-for-s2mps14-rtc.patch
rtc-s5m-consolidate-two-device-type-switch-statements.patch

