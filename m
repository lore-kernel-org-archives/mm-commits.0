Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5641EC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5646113E
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHC7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHC7J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E43E61152;
        Wed,  8 Sep 2021 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069882;
        bh=PCgB2Uj6hXfJpCCWq9jQAPkRlDerTNEIzfIN+cUn60c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kIfEppWskoFLX6V7x8Y6oCwgdal1nweEI+PiacoScFotpB8j97gdhwZNCvVqChPVW
         9I9Nob8hNreoeyOyU9jCIDQVJ0UNlmxTJ8CRQg93VNCZgaq73Wl27LKHBO0OccAAxN
         5wS7Jseqz8GfYlTOawuuLMSVWNjH/fRkQ0ur6o/8=
Date:   Tue, 07 Sep 2021 19:58:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ceggers@arri.de, cw00.choi@samsung.com, daniel.lezcano@linaro.org,
        jic23@kernel.org, Jonathan.Cameron@huawei.com,
        kyungmin.park@samsung.com, lars@metafoo.de, linux-mm@kvack.org,
        linux@roeck-us.net, lukasz.luba@arm.com, mcoquelin.stm32@gmail.com,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        myungjoo.ham@samsung.com, pmeerw@pmeerw.net, rafael@kernel.org,
        rui.zhang@intel.com, torvalds@linux-foundation.org
Subject:  [patch 089/147] hwmon/drivers/mr75203: use HZ macros
Message-ID: <20210908025801.OWz4mGd30%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: hwmon/drivers/mr75203: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

The new macro is an unsigned long.  The code dealing with it is
considering as an unsigned long also.

Link: https://lkml.kernel.org/r/20210816114732.1834145-7-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
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

 drivers/hwmon/mr75203.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/mr75203.c~hwmon-drivers-mr75203-use-hz-macros
+++ a/drivers/hwmon/mr75203.c
@@ -17,6 +17,7 @@
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
+#include <linux/units.h>
 
 /* PVT Common register */
 #define PVT_IP_CONFIG	0x04
@@ -37,7 +38,6 @@
 #define CLK_SYNTH_EN		BIT(24)
 #define CLK_SYS_CYCLES_MAX	514
 #define CLK_SYS_CYCLES_MIN	2
-#define HZ_PER_MHZ		1000000L
 
 #define SDIF_DISABLE	0x04
 
_
