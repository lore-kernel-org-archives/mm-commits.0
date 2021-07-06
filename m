Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3598CC11F69
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2030061CAA
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhGFTY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhGFTY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BAA61CA3;
        Tue,  6 Jul 2021 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599336;
        bh=2aFFNocBzBjzv4BobGon27idfKoVsWZ3fWw3zZcaayo=;
        h=Date:From:To:Subject:From;
        b=cWgeaETkkT92o9NZlEO6C7nuN/GFdBs9q5b7v3rYTSffPVyMpjZWOEAU532tnHVZh
         w3711t/8PCCnPIboznbqcp7K/gwyBrch9XtGlg5wmQWXyW08xMTnBfngtIt8cEoQFo
         8OZCMVP5ZX7hCi2T6Sj82ahJl1+HQGA341yFoHjA=
Date:   Tue, 06 Jul 2021 12:22:16 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
 removed from -mm tree
Message-ID: <20210706192216.tBrk_EpxC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers: get rid of trailing comma in terminators
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test-string_helpers: get rid of trailing comma in terminators

Terminators by definition shouldn't accept anything behind.  Make them
robust by removing trailing commas.

Link: https://lkml.kernel.org/r/20210504180819.73127-9-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/lib/test-string_helpers.c~lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators
+++ a/lib/test-string_helpers.c
@@ -136,7 +136,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_SPACE | ESCAPE_HEX,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	.in = "\\h\\\"\a\e\\",
 	.s1 = {{
@@ -150,7 +150,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_SPECIAL | ESCAPE_HEX,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	.in = "\eb \\C\007\"\x90\r]",
 	.s1 = {{
@@ -201,7 +201,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_NP | ESCAPE_HEX,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	/* terminator */
 }};
@@ -217,7 +217,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_HEX,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	.in = "\\h\\\"\a\e\\",
 	.s1 = {{
@@ -225,7 +225,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_OCTAL,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	.in = "\eb \\C\007\"\x90\r]",
 	.s1 = {{
@@ -233,7 +233,7 @@ static const struct test_string_2 escape
 		.flags = ESCAPE_OCTAL,
 	},{
 		/* terminator */
-	}},
+	}}
 },{
 	/* terminator */
 }};
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


