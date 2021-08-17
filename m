Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF70C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE4F60FA0
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhHQAdW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 20:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhHQAdW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 20:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1BF60F55;
        Tue, 17 Aug 2021 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629160370;
        bh=4E/m8X7kMnik3+d2fPP3O6eeDbsPCqUjr6k+MaAhwq0=;
        h=Date:From:To:Subject:From;
        b=Mzrin8blhF94fCutNxpEyf/wKjVDPmFqOr80ASAWZsiomqlIYhYia5UbLV+fp9+l7
         HL5+tS0TJs0c+CRf7dYT8TN0a49kahVOTmyoOrVWYX0R4zKqlvBXIMatiSeSb7qD8P
         gabrsWxDx1QlM1yfrm6WyZaznThKhOpYuO4pbpqA=
Date:   Mon, 16 Aug 2021 17:32:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rui.zhang@intel.com, rafael@kernel.org,
        pmeerw@pmeerw.net, myungjoo.ham@samsung.com,
        miquel.raynal@bootlin.com, mcoquelin.stm32@gmail.com,
        lukasz.luba@arm.com, linux@roeck-us.net, lars@metafoo.de,
        kyungmin.park@samsung.com, Jonathan.Cameron@huawei.com,
        jic23@kernel.org, cw00.choi@samsung.com, ceggers@arri.de,
        andriy.shevchenko@linux.intel.com, daniel.lezcano@linaro.org
Subject:  + units-change-from-l-to-ul.patch added to -mm tree
Message-ID: <20210817003249.B8d6i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: change from 'L' to 'UL'
has been added to the -mm tree.  Its filename is
     units-change-from-l-to-ul.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/units-change-from-l-to-ul.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/units-change-from-l-to-ul.patch

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
Subject: units: change from 'L' to 'UL'

Patch series "Add Hz macros", v3.

There are multiple definitions of the HZ_PER_MHZ or HZ_PER_KHZ in the
different drivers.  Instead of duplicating this definition again and
again, add one in the units.h header to be reused in all the place the
redefiniton occurs.

At the same time, change the type of the Watts, as they can not be
negative.


This patch (of 10):

The users of the macros are safe to be assigned with an unsigned instead
of signed as the variables using them are themselves unsigned.

Link: https://lkml.kernel.org/r/20210816114732.1834145-1-daniel.lezcano@linaro.org
Link: https://lkml.kernel.org/r/20210816114732.1834145-2-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Christian Eggers <ceggers@arri.de>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/units.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/units.h~units-change-from-l-to-ul
+++ a/include/linux/units.h
@@ -4,9 +4,9 @@
 
 #include <linux/math.h>
 
-#define MILLIWATT_PER_WATT	1000L
-#define MICROWATT_PER_MILLIWATT	1000L
-#define MICROWATT_PER_WATT	1000000L
+#define MILLIWATT_PER_WATT	1000UL
+#define MICROWATT_PER_MILLIWATT	1000UL
+#define MICROWATT_PER_WATT	1000000UL
 
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
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

