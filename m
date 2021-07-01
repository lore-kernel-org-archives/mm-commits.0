Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93091C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF6E61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbhGAB5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9600D61476;
        Thu,  1 Jul 2021 01:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104517;
        bh=HtnzH4et/7uUBBU5CSmAMAU5ohVsctPE28Lz0R7p6/Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qzIViynqW2gKtKx3TArcWNFi4f6ThoQqVvU+pKiSHYBjcVvpV7EJKcp03x0nhXccw
         mYAXIoHZKBDJhrEGWmECs+3StHjNCHYxGODSkWnHQgpXi2W27iRAzQpxBHg+k/iKvV
         M1LsFpG0b2MvLC4qpCw8ymspA60H+idmArideipw=
Date:   Wed, 30 Jun 2021 18:55:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 152/192] lib/string_helpers: introduce ESCAPE_NAP
 to escape non-ASCII and non-printable
Message-ID: <20210701015517.qp0JG4ivY%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: introduce ESCAPE_NAP to escape non-ASCII and non-printable

Some users may want to have an ASCII based filter for printable only
characters, provided by conjunction of isascii() and isprint() functions.

Here is the addition of a such.

Link: https://lkml.kernel.org/r/20210504180819.73127-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 lib/string_helpers.c           |   20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

--- a/include/linux/string_helpers.h~lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable
+++ a/include/linux/string_helpers.h
@@ -53,6 +53,7 @@ static inline int string_unescape_any_in
 #define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
 #define ESCAPE_HEX		BIT(5)
 #define ESCAPE_NA		BIT(6)
+#define ESCAPE_NAP		BIT(7)
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
--- a/lib/string_helpers.c~lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable
+++ a/lib/string_helpers.c
@@ -454,9 +454,11 @@ static bool escape_hex(unsigned char c,
  *
  *	1. The character is not matched to the one from @only string and thus
  *	   must go as-is to the output.
- *	2. The character is matched to the printable or ASCII class, if asked,
+ *	2. The character is matched to the printable and ASCII classes, if asked,
  *	   and in case of match it passes through to the output.
- *	3. The character is checked if it falls into the class given by @flags.
+ *	3. The character is matched to the printable or ASCII class, if asked,
+ *	   and in case of match it passes through to the output.
+ *	4. The character is checked if it falls into the class given by @flags.
  *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
  *	   character. Note that they actually can't go together, otherwise
  *	   %ESCAPE_HEX will be ignored.
@@ -489,11 +491,15 @@ static bool escape_hex(unsigned char c,
  *		'\xHH' - byte with hexadecimal value HH (2 digits)
  *	%ESCAPE_NA:
  *		escape only non-ascii characters, checked by isascii()
+ *	%ESCAPE_NAP:
+ *		escape only non-printable or non-ascii characters
  *
- * One notable caveat, the %ESCAPE_NP and %ESCAPE_NA have higher priority
- * than the rest of the flags (%ESCAPE_NP is higher than %ESCAPE_NA).
+ * One notable caveat, the %ESCAPE_NAP, %ESCAPE_NP and %ESCAPE_NA have the
+ * higher priority than the rest of the flags (%ESCAPE_NAP is the highest).
  * It doesn't make much sense to use either of them without %ESCAPE_OCTAL
  * or %ESCAPE_HEX, because they cover most of the other character classes.
+ * %ESCAPE_NAP can utilize %ESCAPE_SPACE or %ESCAPE_SPECIAL in addition to
+ * the above.
  *
  * Return:
  * The total size of the escaped output that would be generated for
@@ -515,6 +521,8 @@ int string_escape_mem(const char *src, s
 		 * Apply rules in the following sequence:
 		 *	- the @only string is supplied and does not contain a
 		 *	  character under question
+		 *	- the character is printable and ASCII, when @flags has
+		 *	  %ESCAPE_NAP bit set
 		 *	- the character is printable, when @flags has
 		 *	  %ESCAPE_NP bit set
 		 *	- the character is ASCII, when @flags has
@@ -528,6 +536,10 @@ int string_escape_mem(const char *src, s
 					  escape_passthrough(c, &p, end))
 			continue;
 
+		if (isascii(c) && isprint(c) &&
+		    flags & ESCAPE_NAP && escape_passthrough(c, &p, end))
+			continue;
+
 		if (isprint(c) &&
 		    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
 			continue;
_
