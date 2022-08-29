Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FA8ECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 21:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiH2VHz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2VHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 17:07:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FED37198F
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 14:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 091D3CE13A8
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 21:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4B1C43142;
        Mon, 29 Aug 2022 21:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661807267;
        bh=nWZsHb6/ZKrNHwIAszTW5mFzfHL3D1BBS8MyvcvFL4k=;
        h=Date:To:From:Subject:From;
        b=0K3vuIgcgTU1v2OGc7cWvGEiW7B48xLzZO4mopykDcM5HkumYjriEvAzUPiDSmukm
         /hjRXv3VZEVEyq9PT0ddBJ4Bqf8YauhHnmYh3u3WAS2PETfFgXb1AUIT4sYPUDSQWc
         VMP/2Zqtp+KsbfbZA7/QnzNgI+iQc5T0kvjtfqBM=
Date:   Mon, 29 Aug 2022 14:07:46 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] iio-accel-adxl345-use-hz-macro-from-unitsh.patch removed from -mm tree
Message-Id: <20220829210747.2F4B1C43142@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iio: accel: adxl345: use HZ macro from units.h
has been removed from the -mm tree.  Its filename was
     iio-accel-adxl345-use-hz-macro-from-unitsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Subject: iio: accel: adxl345: use HZ macro from units.h
Date: Mon, 1 Aug 2022 14:37:26 +0000

Remove duplicated definition of NHZ_PER_HZ, because it's available in
the units.h as NANOHZ_PER_HZ.

Link: https://lkml.kernel.org/r/20220801143811.14817-3-ddrokosov@sberdevices.ru
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

 drivers/iio/accel/adxl345_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/adxl345_core.c~iio-accel-adxl345-use-hz-macro-from-unitsh
+++ a/drivers/iio/accel/adxl345_core.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <linux/units.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -32,7 +33,6 @@
 
 #define ADXL345_BW_RATE			GENMASK(3, 0)
 #define ADXL345_BASE_RATE_NANO_HZ	97656250LL
-#define NHZ_PER_HZ			1000000000LL
 
 #define ADXL345_POWER_CTL_MEASURE	BIT(3)
 #define ADXL345_POWER_CTL_STANDBY	0x00
@@ -139,7 +139,7 @@ static int adxl345_read_raw(struct iio_d
 
 		samp_freq_nhz = ADXL345_BASE_RATE_NANO_HZ <<
 				(regval & ADXL345_BW_RATE);
-		*val = div_s64_rem(samp_freq_nhz, NHZ_PER_HZ, val2);
+		*val = div_s64_rem(samp_freq_nhz, NANOHZ_PER_HZ, val2);
 
 		return IIO_VAL_INT_PLUS_NANO;
 	}
@@ -164,7 +164,8 @@ static int adxl345_write_raw(struct iio_
 				    ADXL345_REG_OFS_AXIS(chan->address),
 				    val / 4);
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		n = div_s64(val * NHZ_PER_HZ + val2, ADXL345_BASE_RATE_NANO_HZ);
+		n = div_s64(val * NANOHZ_PER_HZ + val2,
+			    ADXL345_BASE_RATE_NANO_HZ);
 
 		return regmap_update_bits(data->regmap, ADXL345_REG_BW_RATE,
 					  ADXL345_BW_RATE,
_

Patches currently in -mm which might be from DDRokosov@sberdevices.ru are

iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

