Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C235C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1108561179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbhIIVFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347151AbhIIVEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED6F611CB;
        Thu,  9 Sep 2021 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221412;
        bh=SuqTNfnne/QcVYoVrIr/xxP8FtzFNY3oOsivmakaInE=;
        h=Date:From:To:Subject:From;
        b=EgnG+WlUPjBmHwz/tfHAmvlb8Wo1lCKLIhMNVMI+B0LZuhMFav0oWIFrifqGgRo6d
         cIbMNjlohbxHqlANEwi3E4UefiyAJR946jMBJJ5qXzeBKRMnp9TwJumTsMlhFr5dK8
         n84nbITAaMKKP5LJFyoSg6wOCecNZnF2SkEu/y1k=
Date:   Thu, 09 Sep 2021 14:03:31 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ceggers@arri.de,
        cw00.choi@samsung.com, daniel.lezcano@linaro.org, jic23@kernel.org,
        Jonathan.Cameron@huawei.com, kyungmin.park@samsung.com,
        lars@metafoo.de, linux@roeck-us.net, lukasz.luba@arm.com,
        mcoquelin.stm32@gmail.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, myungjoo.ham@samsung.com,
        pmeerw@pmeerw.net, rafael@kernel.org, rui.zhang@intel.com
Subject:  [merged] units-change-from-l-to-ul.patch removed from -mm
 tree
Message-ID: <20210909210331.WGryHlDDG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: change from 'L' to 'UL'
has been removed from the -mm tree.  Its filename was
     units-change-from-l-to-ul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


