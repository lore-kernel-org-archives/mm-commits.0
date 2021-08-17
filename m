Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28560C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1062261029
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhHQAd3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 20:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhHQAd3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 20:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C7260F5C;
        Tue, 17 Aug 2021 00:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629160377;
        bh=guEdd5uUlsuUsrNNFthkv/sWBXJSR84qzT75jlR1Y8k=;
        h=Date:From:To:Subject:From;
        b=cP4gE1lZ3vUckM1524EEzmv0Y7VVaT1H8M4aggxQB+5Yg38AINBNMQ8IjfgHHbJDv
         h13lAPg2fkSyVPtt07qFwpaLkMYRo7/XUyl004YAn5qEtkYWq1Wdqvj93IUUd6e7LL
         Q/R+HcE+2u2XNumL/k1qYJ/0zact9HSVTJua5/OI=
Date:   Mon, 16 Aug 2021 17:32:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rui.zhang@intel.com, rafael@kernel.org,
        pmeerw@pmeerw.net, myungjoo.ham@samsung.com,
        miquel.raynal@bootlin.com, mcoquelin.stm32@gmail.com,
        lukasz.luba@arm.com, linux@roeck-us.net, lars@metafoo.de,
        kyungmin.park@samsung.com, Jonathan.Cameron@huawei.com,
        jic23@kernel.org, cw00.choi@samsung.com, ceggers@arri.de,
        andriy.shevchenko@linux.intel.com, daniel.lezcano@linaro.org
Subject:  + devfreq-use-hz-macros.patch added to -mm tree
Message-ID: <20210817003256.9P3Fn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: devfreq: use HZ macros
has been added to the -mm tree.  Its filename is
     devfreq-use-hz-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/devfreq-use-hz-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/devfreq-use-hz-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: devfreq: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

The new macro has an unsigned long type.

All the code is dealing with unsigned long and the code using the macro is
doing a coercitive cast to unsigned long.

Link: https://lkml.kernel.org/r/20210816114732.1834145-5-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
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

 drivers/devfreq/devfreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/devfreq/devfreq.c~devfreq-use-hz-macros
+++ a/drivers/devfreq/devfreq.c
@@ -27,6 +27,7 @@
 #include <linux/hrtimer.h>
 #include <linux/of.h>
 #include <linux/pm_qos.h>
+#include <linux/units.h>
 #include "governor.h"
 
 #define CREATE_TRACE_POINTS
@@ -34,7 +35,6 @@
 
 #define IS_SUPPORTED_FLAG(f, name) ((f & DEVFREQ_GOV_FLAG_##name) ? true : false)
 #define IS_SUPPORTED_ATTR(f, name) ((f & DEVFREQ_GOV_ATTR_##name) ? true : false)
-#define HZ_PER_KHZ	1000
 
 static struct class *devfreq_class;
 static struct dentry *devfreq_debugfs;
_

Patches currently in -mm which might be from daniel.lezcano@linaro.org are

units-change-from-l-to-ul.patch
units-add-the-hz-macros.patch
thermal-drivers-devfreq_cooling-use-hz-macros.patch
devfreq-use-hz-macros.patch
iio-drivers-as73211-use-hz-macros.patch
hwmon-drivers-mr75203-use-hz-macros.patch
iio-drivers-hid-sensor-use-hz-macros.patch
i2c-drivers-ov02q10-use-hz-macros.patch
mtd-drivers-nand-use-hz-macros.patch
phy-drivers-stm32-use-hz-macros.patch

