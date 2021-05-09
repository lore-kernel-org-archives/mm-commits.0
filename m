Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36982C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F9F6142D
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhEIDtv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhEIDtu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEFF761401;
        Sun,  9 May 2021 03:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532128;
        bh=zvKigNVvXRrXlBS233jUSr3VrqgahysrWp9QVa3NTfA=;
        h=Date:From:To:Subject:From;
        b=IOEbRxfG3pUlYtrnbLjMR1OIMSA3SPj91XfoO163WwVNBpcxrSe63TszhCN45gCl4
         xt5JMlXAGZtUd4snhwggHbqSAVWTV7cmPP1SzeXjIn9Fzy8HBXzJhFV4sdvaHd0T8z
         qPU2g206yc5XT9e8uQ2KNT72229b0K2TF4D+IFsM=
Date:   Sat, 08 May 2021 20:48:47 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 lib-test-string_helpers-add-test-cases-for-new-features.patch added to -mm
 tree
Message-ID: <20210509034847.73eOf8eQS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers: add test cases for new features
has been added to the -mm tree.  Its filename is
     lib-test-string_helpers-add-test-cases-for-new-features.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test-string_helpers-add-test-cases-for-new-features.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test-string_helpers-add-test-cases-for-new-features.patch

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

