Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F232C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2925361432
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhEIDtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDtt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C937A6142B;
        Sun,  9 May 2021 03:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532126;
        bh=6LdiwXiK1I5jfTzpQbu+cyAmx77mOBCvEjTKBmy+pq0=;
        h=Date:From:To:Subject:From;
        b=wkFNn+mLi2oz5gti1HbmTSP+33nopkZ/a/OUKArqOevpc6kPG9mfPLGFKS7y98flU
         gX/rnJ17G553IX3KN/SGj6A9b16kPQpOk2bXd8F6M37GExy5j/jR4jaW+nDJy7MTkK
         gzxQs8XbqLz6AwhMdqHAFMfBRZeOhky1xR0scEow=
Date:   Sat, 08 May 2021 20:48:45 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
 added to -mm tree
Message-ID: <20210509034845.3tqOGppq6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers: get rid of trailing comma in terminators
has been added to the -mm tree.  Its filename is
     lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch

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

lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch

