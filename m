Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AF0C433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E316142B
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEIDto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhEIDtk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD27B6142B;
        Sun,  9 May 2021 03:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620532118;
        bh=lcxJGzO1lWvbZsruFRa8UVe2iPAm+QOEURR4jYXVGH8=;
        h=Date:From:To:Subject:From;
        b=g5RKWDBMZ3H2e5SshRgYf+ah8rahijyVv68n/qqFeTwx/hU4GvEgrOKGX28YrW3nA
         JqXOv4hexhxvPmTA0oU0psjjQIP+zifrKBHh+ilUKoWmSkgK0HL8DDu6DR8R8Os5Rz
         ZaSZ0zP9DA5MjR7rhBqN9o62VAa+VyfOr5hN3ywg=
Date:   Sat, 08 May 2021 20:48:37 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  +
 lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch added
 to -mm tree
Message-ID: <20210509034837.gHQ8FGTcx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: introduce ESCAPE_NA for escaping non-ASCII
has been added to the -mm tree.  Its filename is
     lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch

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
Subject: lib/string_helpers: introduce ESCAPE_NA for escaping non-ASCII

Some users may want to have an ASCII based filter, provided by isascii()
function.  Here is the addition of a such.

Link: https://lkml.kernel.org/r/20210504180819.73127-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 lib/string_helpers.c           |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/string_helpers.h~lib-string_helpers-introduce-escape_na-for-escaping-non-ascii
+++ a/include/linux/string_helpers.h
@@ -52,6 +52,7 @@ static inline int string_unescape_any_in
 #define ESCAPE_NP		BIT(4)
 #define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
 #define ESCAPE_HEX		BIT(5)
+#define ESCAPE_NA		BIT(6)
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
--- a/lib/string_helpers.c~lib-string_helpers-introduce-escape_na-for-escaping-non-ascii
+++ a/lib/string_helpers.c
@@ -454,8 +454,8 @@ static bool escape_hex(unsigned char c,
  *
  *	1. The character is not matched to the one from @only string and thus
  *	   must go as-is to the output.
- *	2. The character is matched to the printable class, if asked, and in
- *	   case of match it passes through to the output.
+ *	2. The character is matched to the printable or ASCII class, if asked,
+ *	   and in case of match it passes through to the output.
  *	3. The character is checked if it falls into the class given by @flags.
  *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
  *	   character. Note that they actually can't go together, otherwise
@@ -463,7 +463,7 @@ static bool escape_hex(unsigned char c,
  *
  * Caller must provide valid source and destination pointers. Be aware that
  * destination buffer will not be NULL-terminated, thus caller have to append
- * it if needs.   The supported flags are::
+ * it if needs. The supported flags are::
  *
  *	%ESCAPE_SPACE: (special white space, not space itself)
  *		'\f' - form feed
@@ -482,11 +482,18 @@ static bool escape_hex(unsigned char c,
  *	%ESCAPE_ANY:
  *		all previous together
  *	%ESCAPE_NP:
- *		escape only non-printable characters (checked by isprint)
+ *		escape only non-printable characters, checked by isprint()
  *	%ESCAPE_ANY_NP:
  *		all previous together
  *	%ESCAPE_HEX:
  *		'\xHH' - byte with hexadecimal value HH (2 digits)
+ *	%ESCAPE_NA:
+ *		escape only non-ascii characters, checked by isascii()
+ *
+ * One notable caveat, the %ESCAPE_NP and %ESCAPE_NA have higher priority
+ * than the rest of the flags (%ESCAPE_NP is higher than %ESCAPE_NA).
+ * It doesn't make much sense to use either of them without %ESCAPE_OCTAL
+ * or %ESCAPE_HEX, because they cover most of the other character classes.
  *
  * Return:
  * The total size of the escaped output that would be generated for
@@ -510,6 +517,8 @@ int string_escape_mem(const char *src, s
 		 *	  character under question
 		 *	- the character is printable, when @flags has
 		 *	  %ESCAPE_NP bit set
+		 *	- the character is ASCII, when @flags has
+		 *	  %ESCAPE_NA bit set
 		 *	- the character doesn't fall into a class of symbols
 		 *	  defined by given @flags
 		 * In these cases we just pass through a character to the
@@ -523,6 +532,10 @@ int string_escape_mem(const char *src, s
 		    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
 			continue;
 
+		if (isascii(c) &&
+		    flags & ESCAPE_NA && escape_passthrough(c, &p, end))
+			continue;
+
 		if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
 			continue;
 
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

