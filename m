Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1486AECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 21:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiH2VHu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiH2VHt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 17:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05A7198F
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 14:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FF26B81217
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 21:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD03C4314F;
        Mon, 29 Aug 2022 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661807265;
        bh=lT6GYxjHHmxqD9kJ3FuHB2pzSShTQL4fTUbVygecICY=;
        h=Date:To:From:Subject:From;
        b=fG4ECdlLuZyrAnoHNrAxs9ddSJKCHyFIukV/fmrZ1+3eiYwvskbZs9s8oCvZ0Ss0T
         SQkUu7DhtFzqu1ZdakB6jPLVLV2/37F+gmsIJDxz0QIwPXdU+jLcVjSkjqOln5m9KB
         ReKAywO7p7kFJOqElal1a9txWrkW/mFc7M0kKh8o=
Date:   Mon, 29 Aug 2022 14:07:44 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] units-complement-the-set-of-hz-units.patch removed from -mm tree
Message-Id: <20220829210745.CCD03C4314F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: units: complement the set of Hz units
has been removed from the -mm tree.  Its filename was
     units-complement-the-set-of-hz-units.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Subject: units: complement the set of Hz units
Date: Mon, 1 Aug 2022 14:37:25 +0000

Patch series "units: complement the set of Hz units", v3.

During msa311 accel IIO driver development

https://lore.kernel.org/linux-iio/20220616104211.9257-1-ddrokosov@sberdevices.ru/

Andy requested to use proper units in the hz->ms calculation.  Current
units.h header doesn't have milli, micro and nano HZ coefficients, so some
drivers (in the IIO subsystem) implement their own copies for that.

The current patchset resolves such a problem and intoduces general
MILLIHZ_PER_HZ, MICROHZ_PER_HZ and NANOHZ_PER_HZ definitions in the
units.h, and fixes all drivers which duplicate these units.


This patch (of 3):

Currently, Hz units do not have milli, micro and nano Hz coefficients.
Some drivers (IIO especially) use their analogues to calculate
appropriate Hz values. This patch includes them to units.h definitions,
so they can be used from different kernel places.

Link: https://lkml.kernel.org/r/20220801143811.14817-1-ddrokosov@sberdevices.ru
Link: https://lkml.kernel.org/r/20220801143811.14817-2-ddrokosov@sberdevices.ru
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Jyoti Bhayana <jbhayana@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/units.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/units.h~units-complement-the-set-of-hz-units
+++ a/include/linux/units.h
@@ -20,6 +20,9 @@
 #define PICO	1000000000000ULL
 #define FEMTO	1000000000000000ULL
 
+#define NANOHZ_PER_HZ		1000000000UL
+#define MICROHZ_PER_HZ		1000000UL
+#define MILLIHZ_PER_HZ		1000UL
 #define HZ_PER_KHZ		1000UL
 #define KHZ_PER_MHZ		1000UL
 #define HZ_PER_MHZ		1000000UL
_

Patches currently in -mm which might be from DDRokosov@sberdevices.ru are

iio-accel-adxl345-use-hz-macro-from-unitsh.patch
iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

