Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA95C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjDFCye (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjDFCxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A210F6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0032D64246
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56609C433EF;
        Thu,  6 Apr 2023 02:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749603;
        bh=7oebtFaOVyMlRXhrH3id9kwolLwddMFMP5XtiG9amkE=;
        h=Date:To:From:Subject:From;
        b=mnp+fEycQaGBFSk5x5DAN+I4WeFzRfxn6+goqmEqFIxiz7IVL+25DPxVTvY6dL/GB
         urNdAaLRINBhQKloiBIUtj1+q5orIlPCq8C9/fGagE29DjYw7oVlZoej3eNyd9sgos
         KBvwlQ+Pq0EKvbiB587ywNYI7OdSwRaFglLN0iBc=
Date:   Wed, 05 Apr 2023 19:53:22 -0700
To:     mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch removed from -mm tree
Message-Id: <20230406025323.56609C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test-string_helpers: replace UNESCAPE_ANY by UNESCAPE_ALL_MASK
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpers-replace-unescape_any-by-unescape_all_mask.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


