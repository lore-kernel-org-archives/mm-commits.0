Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E070C25B06
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 23:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiHKXML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 19:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiHKXMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 19:12:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39C190C45
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 16:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9C12B82317
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 23:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486B2C433D6;
        Thu, 11 Aug 2022 23:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660259526;
        bh=3XU4qNJGD4YNb2YW+W8vmQCBiw2d+9w5WaL78JcXBsE=;
        h=Date:To:From:Subject:From;
        b=IxV/+5U2xBlAcwyMDhqATThuopwGznL7rmPnfy9ldJhFcg1E/ZEhkOCSY2npibZvi
         YsQKYflh21xwL3U/tNkdfhd0zFjy9QECnn8JSfaaJyIrDig9azifVlHPGuG0f1Wf8A
         oWSuRN3FboT8+5Cmzn6pxxGHJ6bXnAcWzqOY4pFc=
Date:   Thu, 11 Aug 2022 16:12:05 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iio-accel-adxl345-use-hz-macro-from-unitsh.patch added to mm-nonmm-unstable branch
Message-Id: <20220811231206.486B2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iio: accel: adxl345: use HZ macro from units.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iio-accel-adxl345-use-hz-macro-from-unitsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iio-accel-adxl345-use-hz-macro-from-unitsh.patch

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

units-complement-the-set-of-hz-units.patch
iio-accel-adxl345-use-hz-macro-from-unitsh.patch
iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

