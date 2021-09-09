Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84493C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F54E611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbhIIVFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347624AbhIIVEr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2F2611CC;
        Thu,  9 Sep 2021 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221418;
        bh=x7hHDIfhO05PREdA63A65yoYFR0hol592MpvpEt0B/E=;
        h=Date:From:To:Subject:From;
        b=NaZphm4n6i79OZ/Gs0a2YvL6gxgGVTEE7qgqjT3r8ExGpD/4+Ds+E3egqo1pJQkeS
         c8Sb1MQvoP2Mb5/StzHnIPBrradaRgHJvMX/OtK6tzKNK9Q3Pwi7UZsfaT9g5Fk5vk
         ELP80++jhGB0gdD0Mw5EInyT4kNjwqRk5bR+jj4s=
Date:   Thu, 09 Sep 2021 14:03:37 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ceggers@arri.de,
        cw00.choi@samsung.com, daniel.lezcano@linaro.org, jic23@kernel.org,
        Jonathan.Cameron@huawei.com, kyungmin.park@samsung.com,
        lars@metafoo.de, linux@roeck-us.net, lukasz.luba@arm.com,
        mcoquelin.stm32@gmail.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, myungjoo.ham@samsung.com,
        pmeerw@pmeerw.net, rafael@kernel.org, rui.zhang@intel.com
Subject:  [merged]
 thermal-drivers-devfreq_cooling-use-hz-macros.patch removed from -mm tree
Message-ID: <20210909210337.WakKh63kh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: thermal/drivers/devfreq_cooling: use HZ macros
has been removed from the -mm tree.  Its filename was
     thermal-drivers-devfreq_cooling-use-hz-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: thermal/drivers/devfreq_cooling: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

The new macro uses a unsigned long type which is already the type in the
current code via the 'freq' variable.

Link: https://lkml.kernel.org/r/20210816114732.1834145-4-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/devfreq_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/devfreq_cooling.c~thermal-drivers-devfreq_cooling-use-hz-macros
+++ a/drivers/thermal/devfreq_cooling.c
@@ -18,10 +18,10 @@
 #include <linux/pm_opp.h>
 #include <linux/pm_qos.h>
 #include <linux/thermal.h>
+#include <linux/units.h>
 
 #include <trace/events/thermal.h>
 
-#define HZ_PER_KHZ		1000
 #define SCALE_ERROR_MITIGATION	100
 
 /**
_

Patches currently in -mm which might be from daniel.lezcano@linaro.org are


