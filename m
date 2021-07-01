Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187A4C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0443561476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbhGAB57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB57 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5E96146D;
        Thu,  1 Jul 2021 01:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104529;
        bh=DVRUBa6gTcLU53zvZlPrv70B8B4tyU/yVpZLkBY91DE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=avWv3LKTR+bYjzFg+Ejf8xiI5FzptwUI3TzWDMamDaAE7n0DzAQiLdId6Ii600imX
         kJ8uJTURGiMdQNhc+T1kpQSwFAxroL68xuu+vElQNkAOTSL6+xVRPbxryI2/L1CFIZ
         w8r/hQSgc4cyX6GPo/tZbeE+wdUOBaKPjVnH5Fuw=
Date:   Wed, 30 Jun 2021 18:55:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 156/192] lib/test-string_helpers: add test cases
 for new features
Message-ID: <20210701015529.TnkAtUVM1%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test-string_helpers: add test cases for new features

We have got new flags and hence new features of string_escape_mem().
Add test cases for that.

Link: https://lkml.kernel.org/r/20210504180819.73127-10-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    4 
 lib/test-string_helpers.c      |  141 +++++++++++++++++++++++++++++--
 2 files changed, 137 insertions(+), 8 deletions(-)

--- a/include/linux/string_helpers.h~lib-test-string_helpers-add-test-cases-for-new-features
+++ a/include/linux/string_helpers.h
@@ -26,6 +26,8 @@ void string_get_size(u64 size, u64 blk_s
 #define UNESCAPE_ANY		\
 	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
 
+#define UNESCAPE_ALL_MASK	GENMASK(3, 0)
+
 int string_unescape(char *src, char *dst, size_t size, unsigned int flags);
 
 static inline int string_unescape_inplace(char *buf, unsigned int flags)
@@ -56,6 +58,8 @@ static inline int string_unescape_any_in
 #define ESCAPE_NAP		BIT(7)
 #define ESCAPE_APPEND		BIT(8)
 
+#define ESCAPE_ALL_MASK		GENMASK(8, 0)
+
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
 
--- a/lib/test-string_helpers.c~lib-test-string_helpers-add-test-cases-for-new-features
+++ a/lib/test-string_helpers.c
@@ -203,10 +203,24 @@ static const struct test_string_2 escape
 		/* terminator */
 	}}
 },{
+	.in = "\007 \eb\"\x90\xCF\r",
+	.s1 = {{
+		.out = "\007 \eb\"\\220\\317\r",
+		.flags = ESCAPE_OCTAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\\x90\\xcf\r",
+		.flags = ESCAPE_HEX | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_NA,
+	},{
+		/* terminator */
+	}}
+},{
 	/* terminator */
 }};
 
-#define	TEST_STRING_2_DICT_1		"b\\ \t\r"
+#define	TEST_STRING_2_DICT_1		"b\\ \t\r\xCF"
 static const struct test_string_2 escape1[] __initconst = {{
 	.in = "\f\\ \n\r\t\v",
 	.s1 = {{
@@ -216,14 +230,38 @@ static const struct test_string_2 escape
 		.out = "\f\\x5c\\x20\n\\x0d\\x09\v",
 		.flags = ESCAPE_HEX,
 	},{
+		.out = "\f\\134\\040\n\\015\\011\v",
+		.flags = ESCAPE_ANY | ESCAPE_APPEND,
+	},{
+		.out = "\\014\\134\\040\\012\\015\\011\\013",
+		.flags = ESCAPE_OCTAL | ESCAPE_APPEND | ESCAPE_NAP,
+	},{
+		.out = "\\x0c\\x5c\\x20\\x0a\\x0d\\x09\\x0b",
+		.flags = ESCAPE_HEX | ESCAPE_APPEND | ESCAPE_NAP,
+	},{
+		.out = "\f\\134\\040\n\\015\\011\v",
+		.flags = ESCAPE_OCTAL | ESCAPE_APPEND | ESCAPE_NA,
+	},{
+		.out = "\f\\x5c\\x20\n\\x0d\\x09\v",
+		.flags = ESCAPE_HEX | ESCAPE_APPEND | ESCAPE_NA,
+	},{
 		/* terminator */
 	}}
 },{
-	.in = "\\h\\\"\a\e\\",
+	.in = "\\h\\\"\a\xCF\e\\",
 	.s1 = {{
-		.out = "\\134h\\134\"\a\e\\134",
+		.out = "\\134h\\134\"\a\\317\e\\134",
 		.flags = ESCAPE_OCTAL,
 	},{
+		.out = "\\134h\\134\"\a\\317\e\\134",
+		.flags = ESCAPE_ANY | ESCAPE_APPEND,
+	},{
+		.out = "\\134h\\134\"\\007\\317\\033\\134",
+		.flags = ESCAPE_OCTAL | ESCAPE_APPEND | ESCAPE_NAP,
+	},{
+		.out = "\\134h\\134\"\a\\317\e\\134",
+		.flags = ESCAPE_OCTAL | ESCAPE_APPEND | ESCAPE_NA,
+	},{
 		/* terminator */
 	}}
 },{
@@ -235,6 +273,88 @@ static const struct test_string_2 escape
 		/* terminator */
 	}}
 },{
+	.in = "\007 \eb\"\x90\xCF\r",
+	.s1 = {{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_SPACE | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_SPECIAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\317\r",
+		.flags = ESCAPE_OCTAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\317\r",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\317\r",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\317\r",
+		.flags = ESCAPE_ANY | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\r",
+		.flags = ESCAPE_HEX | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\r",
+		.flags = ESCAPE_SPACE | ESCAPE_HEX | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\r",
+		.flags = ESCAPE_SPECIAL | ESCAPE_HEX | ESCAPE_NA,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\r",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_HEX | ESCAPE_NA,
+	},{
+		/* terminator */
+	}}
+},{
+	.in = "\007 \eb\"\x90\xCF\r",
+	.s1 = {{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\xCF\\r",
+		.flags = ESCAPE_SPACE | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\xCF\r",
+		.flags = ESCAPE_SPECIAL | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\xCF\\r",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\317\\015",
+		.flags = ESCAPE_OCTAL | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\317\\r",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\317\\015",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\317\r",
+		.flags = ESCAPE_ANY | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\\x0d",
+		.flags = ESCAPE_HEX | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\\r",
+		.flags = ESCAPE_SPACE | ESCAPE_HEX | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\\x0d",
+		.flags = ESCAPE_SPECIAL | ESCAPE_HEX | ESCAPE_NAP,
+	},{
+		.out = "\007 \eb\"\x90\\xcf\\r",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_HEX | ESCAPE_NAP,
+	},{
+		/* terminator */
+	}}
+},{
 	/* terminator */
 }};
 
@@ -315,8 +435,13 @@ static __init void test_string_escape(co
 		/* NULL injection */
 		if (flags & ESCAPE_NULL) {
 			in[p++] = '\0';
-			out_test[q_test++] = '\\';
-			out_test[q_test++] = '0';
+			/* '\0' passes isascii() test */
+			if (flags & ESCAPE_NA && !(flags & ESCAPE_APPEND && esc)) {
+				out_test[q_test++] = '\0';
+			} else {
+				out_test[q_test++] = '\\';
+				out_test[q_test++] = '0';
+			}
 		}
 
 		/* Don't try strings that have no output */
@@ -459,17 +584,17 @@ static int __init test_string_helpers_in
 	unsigned int i;
 
 	pr_info("Running tests...\n");
-	for (i = 0; i < UNESCAPE_ANY + 1; i++)
+	for (i = 0; i < UNESCAPE_ALL_MASK + 1; i++)
 		test_string_unescape("unescape", i, false);
 	test_string_unescape("unescape inplace",
 			     get_random_int() % (UNESCAPE_ANY + 1), true);
 
 	/* Without dictionary */
-	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+	for (i = 0; i < ESCAPE_ALL_MASK + 1; i++)
 		test_string_escape("escape 0", escape0, i, TEST_STRING_2_DICT_0);
 
 	/* With dictionary */
-	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+	for (i = 0; i < ESCAPE_ALL_MASK + 1; i++)
 		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
 
 	/* Test string_get_size() */
_
