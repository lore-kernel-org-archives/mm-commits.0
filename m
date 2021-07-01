Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DB1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60836146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhGAB55 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB55 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B4B6147D;
        Thu,  1 Jul 2021 01:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104526;
        bh=YABlZvrkIRQAM39pgP7bivPIaKU83C0SruaqZYLMPUw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I/fm0KIpfbgAJx6beU+/NtHV2NY0wdHLLg5/pcovr8kdTL3OJPyXISCZCJQucvfdx
         UC0qApY00UXmab+KWfjaZQpqH1ab1TWc4tTEnwKX7MtQoe5yqzlLTNrkKFQmW8Gctw
         g8v+i6bY/ZiLZNdIjZIXzFqKM8NJ9A3nbrA0lDhk=
Date:   Wed, 30 Jun 2021 18:55:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 155/192] lib/test-string_helpers: get rid of
 trailing comma in terminators
Message-ID: <20210701015526.YCbwPm9CE%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
