Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906B5C43219
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD87611C1
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347719AbhIIVFf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347901AbhIIVEp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DA0611C4;
        Thu,  9 Sep 2021 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221415;
        bh=8SBXlzkncU17b6i6naS5FxZlst/pAOrKE8Eg9dnqQXc=;
        h=Date:From:To:Subject:From;
        b=aCr93ECzAQ95CP4yxmf0BEPVbCwem70bsrdHlkovJ2konnyh0JMRCC4rD5IBYapzx
         iKbg8exZCXwXhzhUsPlHxhiVzGuzcpwawnTmGLAdAMoJH+wwNcT0XPjjuXUi7Lc0Fs
         sDf5ORYf4y9NJdX1JAWHE97+1pKEb3CB6TTKUZ4M=
Date:   Thu, 09 Sep 2021 14:03:34 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ceggers@arri.de,
        cw00.choi@samsung.com, daniel.lezcano@linaro.org, jic23@kernel.org,
        Jonathan.Cameron@huawei.com, kyungmin.park@samsung.com,
        lars@metafoo.de, linux@roeck-us.net, lukasz.luba@arm.com,
        mcoquelin.stm32@gmail.com, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, myungjoo.ham@samsung.com,
        pmeerw@pmeerw.net, rafael@kernel.org, rui.zhang@intel.com
Subject:  [merged] units-add-the-hz-macros.patch removed from -mm
 tree
Message-ID: <20210909210334.kZKCgspyj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: add the HZ macros
has been removed from the -mm tree.  Its filename was
     units-add-the-hz-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


