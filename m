Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFA7C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D5D6115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhIHC7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347339AbhIHC7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0CE46113C;
        Wed,  8 Sep 2021 02:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069879;
        bh=zcSue9b6FEUd9NTM7wO+hDx4cX87QcQ+F8i70jJa42Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iyPWmw91UpczCdTFQhulILCNS0jufyi+seMz8z+wuT8oyaB47D0eFfyhBNfhSB8v9
         lXSl8xv+DZLDfhStDYk6EPySVzJENKEdlD3IbTiHwkxZuM3L9rIAepntKUEG+xtrca
         G94AkFxfReSQn3lFzoocDOfh1DHElePwV+9GvWhc=
Date:   Tue, 07 Sep 2021 19:57:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        ceggers@arri.de, cw00.choi@samsung.com, daniel.lezcano@linaro.org,
        jic23@kernel.org, Jonathan.Cameron@huawei.com,
        kyungmin.park@samsung.com, lars@metafoo.de, linux-mm@kvack.org,
        linux@roeck-us.net, lukasz.luba@arm.com, mcoquelin.stm32@gmail.com,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        myungjoo.ham@samsung.com, pmeerw@pmeerw.net, rafael@kernel.org,
        rui.zhang@intel.com, torvalds@linux-foundation.org
Subject:  [patch 088/147] iio/drivers/as73211: use HZ macros
Message-ID: <20210908025758.QDL9cIW2n%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: iio/drivers/as73211: use HZ macros

HZ unit conversion macros are available in units.h, use them and remove
the duplicate definition.

Link: https://lkml.kernel.org/r/20210816114732.1834145-6-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
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

 drivers/iio/light/as73211.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/as73211.c~iio-drivers-as73211-use-hz-macros
+++ a/drivers/iio/light/as73211.c
@@ -24,8 +24,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
-
-#define HZ_PER_KHZ 1000
+#include <linux/units.h>
 
 #define AS73211_DRV_NAME "as73211"
 
_
