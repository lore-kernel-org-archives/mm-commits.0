Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2223CC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F3CF60FDA
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 00:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhHQAdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 20:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233009AbhHQAdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 20:33:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A249860F39;
        Tue, 17 Aug 2021 00:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629160373;
        bh=Lzzst2Dx33zW3TU80VLxn3j4fYJGko0EGTp/86FgajU=;
        h=Date:From:To:Subject:From;
        b=ZAz6kWKgwLjogPNAgB5+gyJri4H4HjZ+YmuaHejY9vwjds/3ZZBn/8UsqYswKJ1X7
         rZmV9Lw134Nl+7m7AXnT9DbdlBg2GfRrFA1haZgbKFo3XoNWb6vV/6bqvHVdhoUjq9
         fg9t+T//5EwzKYWIj3lveSOZHnj73mX66+UhxsKw=
Date:   Mon, 16 Aug 2021 17:32:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rui.zhang@intel.com, rafael@kernel.org,
        pmeerw@pmeerw.net, myungjoo.ham@samsung.com,
        miquel.raynal@bootlin.com, mcoquelin.stm32@gmail.com,
        lukasz.luba@arm.com, linux@roeck-us.net, lars@metafoo.de,
        kyungmin.park@samsung.com, Jonathan.Cameron@huawei.com,
        jic23@kernel.org, cw00.choi@samsung.com, ceggers@arri.de,
        andriy.shevchenko@linux.intel.com, daniel.lezcano@linaro.org
Subject:  + units-add-the-hz-macros.patch added to -mm tree
Message-ID: <20210817003252.uS170%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: add the HZ macros
has been added to the -mm tree.  Its filename is
     units-add-the-hz-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/units-add-the-hz-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/units-add-the-hz-macros.patch

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
Subject: units: add the HZ macros

The macros for the unit conversion for frequency are duplicated in
different places.

Provide these macros in the 'units' header, so they can be reused.

Link: https://lkml.kernel.org/r/20210816114732.1834145-3-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

 include/linux/units.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/units.h~units-add-the-hz-macros
+++ a/include/linux/units.h
@@ -4,6 +4,10 @@
 
 #include <linux/math.h>
 
+#define HZ_PER_KHZ		1000UL
+#define KHZ_PER_MHZ		1000UL
+#define HZ_PER_MHZ		1000000UL
+
 #define MILLIWATT_PER_WATT	1000UL
 #define MICROWATT_PER_MILLIWATT	1000UL
 #define MICROWATT_PER_WATT	1000000UL
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

