Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED6DECAAD2
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 21:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiH2VH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiH2VHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 17:07:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8BF8E4CD
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 14:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B86FB81162
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 21:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2F6C4347C;
        Mon, 29 Aug 2022 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661807268;
        bh=8yZsoK+KS/+wuKycYVl1L1DlQKtww+8ojHu43fTux5M=;
        h=Date:To:From:Subject:From;
        b=FFE8AS/9zEKfYF/xdOJ9a5vwwIcpy6/IDgXfhpjK4zNWL78bWOdvH3+EAJDn46Bs1
         sPPBTHURDLBLI/bmX6xrRsf6sNwW71DJ4aQWYYC6f8ElwtH0RG7UfW9hDmP8xQbqwg
         FwKsdJB14rqyWwxlVs0YSAXUyhRzXY2f9PexPr8Y=
Date:   Mon, 29 Aug 2022 14:07:47 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch removed from -mm tree
Message-Id: <20220829210748.8D2F6C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iio: common: scmi_sensors: use HZ macro from units.h
has been removed from the -mm tree.  Its filename was
     iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


