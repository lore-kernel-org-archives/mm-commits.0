Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D69EC25B06
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 23:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiHKXMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 19:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiHKXMG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 19:12:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA328D3FF
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 16:12:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D91F361536
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 23:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274C3C433C1;
        Thu, 11 Aug 2022 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660259524;
        bh=nWWYMoZqy7aPOjrekqtR/QmXV1m/WwqZFjHeJZIJLU4=;
        h=Date:To:From:Subject:From;
        b=jCRKJiqjREzZCs9hYi05bbIdDqfT1nGzZvi1utkRSUNTv/DWwR7vZ+2G4/xBfTiD/
         RVOwAvDPLFi5pbwHhyBDXvKwVlpWULaa4tzb9jh0bH9817JIX/c/Ru0UaWeOJE/50Y
         EEF6U8XK49DRUUxnMDRp1a5R27IGAi36m6PitUQg=
Date:   Thu, 11 Aug 2022 16:12:03 -0700
To:     mm-commits@vger.kernel.org, wsa@kernel.org,
        michael.hennerich@analog.com, lars@metafoo.de, jic23@kernel.org,
        jbhayana@google.com, ddrokosov@sberdevices.ru,
        daniel.lezcano@linaro.org, andy.shevchenko@gmail.com,
        andriy.shevchenko@linux.intel.com, DDRokosov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + units-complement-the-set-of-hz-units.patch added to mm-nonmm-unstable branch
Message-Id: <20220811231204.274C3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: complement the set of Hz units
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     units-complement-the-set-of-hz-units.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/units-complement-the-set-of-hz-units.patch

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

units-complement-the-set-of-hz-units.patch
iio-accel-adxl345-use-hz-macro-from-unitsh.patch
iio-common-scmi_sensors-use-hz-macro-from-unitsh.patch

