Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA00C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiBGVAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiBGVAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86763C0401E4
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50A4DB816FB
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0788DC004E1;
        Mon,  7 Feb 2022 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267628;
        bh=hoCbvHNnfgWqC0UaihriJ4MjNaVWE3NXw8Mwp/Xr2vU=;
        h=Date:To:From:Subject:From;
        b=v9N7/gYn3lUDLMQ6OGtZHoUg5BTjHs1pF5loGKjh72QsI9Tw/LAEa/4w7OkwQUEOc
         CIBF96TaUWjJdlJqMLk/mV1c+WgyvR+YVBRA8KmGS+gv4vmxamguJ75ECxbdjEtD7L
         4Ya0KnDANRFTXa477Ar041343bmzkXhhJ//KN91U=
Date:   Mon, 07 Feb 2022 13:00:27 -0800
To:     mm-commits@vger.kernel.org, peterz@infradead.org, jsd@semihalf.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bitfield-add-explicit-inclusions-to-the-example.patch added to -mm tree
Message-Id: <20220207210028.0788DC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitfield: add explicit inclusions to the example
has been added to the -mm tree.  Its filename is
     bitfield-add-explicit-inclusions-to-the-example.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitfield-add-explicit-inclusions-to-the-example.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitfield-add-explicit-inclusions-to-the-example.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: bitfield: add explicit inclusions to the example

It's not obvious that bitfield.h doesn't guarantee the bits.h inclusion
and the example in the former is confusing.  Some developers think that
it's okay to just include bitfield.h to get it working.  Change example to
explicitly include necessary headers in order to avoid confusion.

Link: https://lkml.kernel.org/r/20220207123341.47533-1-andriy.shevchenko@linux.intel.com
Fixes: 3e9b3112ec74 ("add basic register-field manipulation macros")
Depends-on: 8bd9cb51daac ("locking/atomics, asm-generic: Move some macros from <linux/bitops.h> to a new <linux/bits.h> file")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Jan Dąbroś <jsd@semihalf.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitfield.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/bitfield.h~bitfield-add-explicit-inclusions-to-the-example
+++ a/include/linux/bitfield.h
@@ -19,6 +19,9 @@
  *
  * Example:
  *
+ *  #include <linux/bitfield.h>
+ *  #include <linux/bits.h>
+ *
  *  #define REG_FIELD_A  GENMASK(6, 0)
  *  #define REG_FIELD_B  BIT(7)
  *  #define REG_FIELD_C  GENMASK(15, 8)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

bitfield-add-explicit-inclusions-to-the-example.patch

