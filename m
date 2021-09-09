Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D284AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD554611C1
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347151AbhIIVFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345533AbhIIVFA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B070661205;
        Thu,  9 Sep 2021 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221430;
        bh=MoEG6RYpbr6l9U4OJxM98+mLzH30TF8hdhRZo45Sqc8=;
        h=Date:From:To:Subject:From;
        b=aQcEu4yDPZhc2rrONdj2FHzTyfHqc64WBIa89P7TKlb+FNuPJ9GZv/uk1Z/qeB5lS
         s9yN828GfNM7QoNQ8VjP+tvkCR4P0B3026knLgtERwkgLbCCtRwYQZqHHTQAPuOaui
         uLmgKdHrjeTuvsdSn2AxGw0hsiCMluM6WTEVuvmE=
Date:   Thu, 09 Sep 2021 14:03:49 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ceggers@arri.de,
        cw00.choi@samsung.com, daniel.lezcano@linaro.org, jic23@kernel.org,
        Jonathan.Cameron@huawei.com, kyungmin.park@samsung.com,
        lars@metafoo.de, linux@roeck-us.net, lukasz.luba@arm.com,
        mcoquelin.stm32@gmail.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, myungjoo.ham@samsung.com,
        pmeerw@pmeerw.net, rafael@kernel.org, rui.zhang@intel.com
Subject:  [merged] iio-drivers-hid-sensor-use-hz-macros.patch
 removed from -mm tree
Message-ID: <20210909210349.0UgUnyfB-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iio/drivers/hid-sensor: use HZ macros
has been removed from the -mm tree.  Its filename was
     iio-drivers-hid-sensor-use-hz-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: iio/drivers/hid-sensor: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

Link: https://lkml.kernel.org/r/20210816114732.1834145-8-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Christian Eggers <ceggers@arri.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Cameron <jic23@kernel.org>
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

 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c~iio-drivers-hid-sensor-use-hz-macros
+++ a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -6,12 +6,11 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/time.h>
+#include <linux/units.h>
 
 #include <linux/hid-sensor-hub.h>
 #include <linux/iio/iio.h>
 
-#define HZ_PER_MHZ	1000000L
-
 static struct {
 	u32 usage_id;
 	int unit; /* 0 for default others from HID sensor spec */
_

Patches currently in -mm which might be from daniel.lezcano@linaro.org are


