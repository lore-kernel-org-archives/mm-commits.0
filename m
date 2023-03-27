Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25610C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjC0UPb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjC0UPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:15:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA86A6
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74318B8190C
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A5C433AC;
        Mon, 27 Mar 2023 20:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679948119;
        bh=qNP+njT1zoOuHt5Vfz+/xRPbrk5stkMPWeLJTadhdlQ=;
        h=Date:To:From:Subject:From;
        b=zOWGkU0lipsJrPOSIcjxJZbCX5P5zaiFt46zADl29WeGt3AyIYF9aSqfjpM9C2CcC
         4HNDBXofk1VznHy7WGNSMd4HNm1naoCgI44KS9objI9pYwYO1xuNfmlTREf5C7qlGR
         XKJJ0EetldpvvV00Rur5znEJsm59iZoYxA3lAdhk=
Date:   Mon, 27 Mar 2023 13:15:18 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch added to mm-nonmm-unstable branch
Message-Id: <20230327201519.203A5C433AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers: replace UNESCAPE_ANY by UNESCAPE_ALL_MASK
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test-string_helpers: replace UNESCAPE_ANY by UNESCAPE_ALL_MASK
Date: Mon, 27 Mar 2023 17:26:04 +0300

When we get a random number to generate a flag in the valid range of
UNESCAPE flags, use UNESCAPE_ALL_MASK, It's more correct and prevents from
missed updates of the test coverage in the future if any.

Link: https://lkml.kernel.org/r/20230327142604.48213-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test-string_helpers.c~lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask
+++ a/lib/test-string_helpers.c
@@ -587,7 +587,7 @@ static int __init test_string_helpers_in
 	for (i = 0; i < UNESCAPE_ALL_MASK + 1; i++)
 		test_string_unescape("unescape", i, false);
 	test_string_unescape("unescape inplace",
-			     get_random_u32_below(UNESCAPE_ANY + 1), true);
+			     get_random_u32_below(UNESCAPE_ALL_MASK + 1), true);
 
 	/* Without dictionary */
 	for (i = 0; i < ESCAPE_ALL_MASK + 1; i++)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-the-hexadecimal-related-helpers-to-hexh.patch
lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch

