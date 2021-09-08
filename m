Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5BAC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02156115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbhIHC7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347361AbhIHC7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9865D61102;
        Wed,  8 Sep 2021 02:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069896;
        bh=HyCZB6ft9MjemUtYvrEY8stnp8yloeRKzg/Qyl04RQA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kw1F8ekG0bGOsRuZHikFJ/R7pdSU3UMYyLP99nfisZtrh5wBb07/61RQhDsyK3osW
         KepMc1uFycIef9YakCxBpBKtVrwKoC3GTSBXmj5WNPIASdiS7VxuaF76V/bY/Xpb99
         Dqph5//UieuK7Uu9aJR9TZoLCrhO17eqv9Wqw/sc=
Date:   Tue, 07 Sep 2021 19:58:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ceggers@arri.de, cw00.choi@samsung.com, daniel.lezcano@linaro.org,
        jic23@kernel.org, Jonathan.Cameron@huawei.com,
        kyungmin.park@samsung.com, lars@metafoo.de, linux-mm@kvack.org,
        linux@roeck-us.net, lukasz.luba@arm.com, mcoquelin.stm32@gmail.com,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        myungjoo.ham@samsung.com, pmeerw@pmeerw.net, rafael@kernel.org,
        rui.zhang@intel.com, torvalds@linux-foundation.org
Subject:  [patch 093/147] phy/drivers/stm32: use HZ macros
Message-ID: <20210908025815.wkJV0R3Qx%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: phy/drivers/stm32: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

Link: https://lkml.kernel.org/r/20210816114732.1834145-11-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Christian Eggers <ceggers@arri.de>
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

 drivers/phy/st/phy-stm32-usbphyc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/st/phy-stm32-usbphyc.c~phy-drivers-stm32-use-hz-macros
+++ a/drivers/phy/st/phy-stm32-usbphyc.c
@@ -15,6 +15,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 #include <linux/reset.h>
+#include <linux/units.h>
 
 #define STM32_USBPHYC_PLL	0x0
 #define STM32_USBPHYC_MISC	0x8
@@ -47,7 +48,6 @@
 #define PLL_FVCO_MHZ		2880
 #define PLL_INFF_MIN_RATE_HZ	19200000
 #define PLL_INFF_MAX_RATE_HZ	38400000
-#define HZ_PER_MHZ		1000000L
 
 struct pll_params {
 	u8 ndiv;
_
