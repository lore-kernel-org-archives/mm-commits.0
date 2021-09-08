Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8370C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0E5361163
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhIHC6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347409AbhIHC6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24B606113C;
        Wed,  8 Sep 2021 02:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069865;
        bh=Y7wqP9Db0Yl6TGwjg4MxxuXEgYY6S3Wn0qK9QjkNEOI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ww+79m1vvi0/rLx0Trd32Uoj97dFZqmMvWI1qUvwmsM6qpOUPU4HmdsN3PA9//Lcw
         e/dhZW1U6xHqvAhjtZ2rllg8ucXxDul5ycNKJO36tWboWkgai48s3tQXuSlel7yIRm
         pubi7+kUVZuq0P4b/A5myrPzKyokFSap8Q2ts3ng=
Date:   Tue, 07 Sep 2021 19:57:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ceggers@arri.de, cw00.choi@samsung.com, daniel.lezcano@linaro.org,
        jic23@kernel.org, Jonathan.Cameron@huawei.com,
        kyungmin.park@samsung.com, lars@metafoo.de, linux-mm@kvack.org,
        linux@roeck-us.net, lukasz.luba@arm.com, mcoquelin.stm32@gmail.com,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        myungjoo.ham@samsung.com, pmeerw@pmeerw.net, rafael@kernel.org,
        rui.zhang@intel.com, torvalds@linux-foundation.org
Subject:  [patch 084/147] units: change from 'L' to 'UL'
Message-ID: <20210908025744.2ZyJFN1S9%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
