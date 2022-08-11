Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75EBBC25B0E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 23:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiHKXMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 19:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbiHKXMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 19:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CDD90805
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 16:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F247961536
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 23:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503DAC433C1;
        Thu, 11 Aug 2022 23:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660259528;
        bh=rnpZmFnxdr2PklYfHcm8yK6RQJW67IPoa7ixh5hgoN4=;
        h=Date:To:From:Subject:From;
        b=ovP4efAaCp45PZ32ey3dT8pW7cXs3XUJQ6UEBhr8NF4Zx9/bsNt2UbBTstcpcnPv5
         FJ9pr5Os0SR/Z29PLrakZ4rK1JAex+stLBzg06z0PJ+Iyd4tsMGwSqzs4ZFi4aFPS0
         YRgxQuMxhLk/kPhVNH6pUtN4RmKoH6GkZRr3Zf1o=
Date:   Thu, 11 Aug 2022 16:12:07 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch added to mm-nonmm-unstable branch
Message-Id: <20220811231208.503DAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iio: common: scmi_sensors: use HZ macro from units.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Subject: iio: common: scmi_sensors: use HZ macro from units.h
Date: Mon, 1 Aug 2022 14:37:27 +0000

Remove duplicated definition of UHZ_PER_HZ, because it's available in
the units.h as MICROHZ_PER_HZ.

Link: https://lkml.kernel.org/r/20220801143811.14817-4-ddrokosov@sberdevices.ru
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jyoti Bhayana <jbhayana@google.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/common/scmi_sensors/scmi_iio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/common/scmi_sensors/scmi_iio.c~iio-common-scmi_sensors-use-hz-macro-from-unitsh
+++ a/drivers/iio/common/scmi_sensors/scmi_iio.c
@@ -18,6 +18,7 @@
 #include <linux/scmi_protocol.h>
 #include <linux/time.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 #define SCMI_IIO_NUM_OF_AXIS 3
 
@@ -130,7 +131,6 @@ static const struct iio_buffer_setup_ops
 static int scmi_iio_set_odr_val(struct iio_dev *iio_dev, int val, int val2)
 {
 	struct scmi_iio_priv *sensor = iio_priv(iio_dev);
-	const unsigned long UHZ_PER_HZ = 1000000UL;
 	u64 sec, mult, uHz, sf;
 	u32 sensor_config;
 	char buf[32];
@@ -145,7 +145,7 @@ static int scmi_iio_set_odr_val(struct i
 		return err;
 	}
 
-	uHz = val * UHZ_PER_HZ + val2;
+	uHz = val * MICROHZ_PER_HZ + val2;
 
 	/*
 	 * The seconds field in the sensor interval in SCMI is 16 bits long
@@ -156,10 +156,10 @@ static int scmi_iio_set_odr_val(struct i
 	 * count the number of characters
 	 */
 	sf = (u64)uHz * 0xFFFF;
-	do_div(sf,  UHZ_PER_HZ);
+	do_div(sf,  MICROHZ_PER_HZ);
 	mult = scnprintf(buf, sizeof(buf), "%llu", sf) - 1;
 
-	sec = int_pow(10, mult) * UHZ_PER_HZ;
+	sec = int_pow(10, mult) * MICROHZ_PER_HZ;
 	do_div(sec, uHz);
 	if (sec == 0) {
 		dev_err(&iio_dev->dev,
_

Patches currently in -mm which might be from DDRokosov@sberdevices.ru are

units-complement-the-set-of-hz-units.patch
iio-accel-adxl345-use-hz-macro-from-unitsh.patch
iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

