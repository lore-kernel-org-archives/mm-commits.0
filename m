Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8300C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3EF16141A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbhGAB5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95E7E6147E;
        Thu,  1 Jul 2021 01:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104520;
        bh=BLC+64tC2Oh0WoAv7v65CAfBZKCM7Oa+8avD+we9koQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WNvstbqIYY42VswoY/V0cPHxUgOYHSnFe90hvfOM8yKaNME9WxiIgqOzFl3gt4kA4
         qRNnqm5HeHk25/RvmWQb3xv7KilpQ/LNQGqcBUNStQja7oIGJf3k8XM2Hkty6X26bf
         V3P4Gd5dQuEXBpr8g+8w8gQc1oBCX3HxCX41Qqg4=
Date:   Wed, 30 Jun 2021 18:55:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 153/192] lib/string_helpers: allow to append
 additional characters to be escaped
Message-ID: <20210701015520.3p-rGfCUh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: allow to append additional characters to be escaped

Introduce a new flag to append additional characters, passed in 'only'
parameter, to be escaped if they fall in the corresponding class.

Link: https://lkml.kernel.org/r/20210504180819.73127-7-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 lib/string_helpers.c           |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/include/linux/string_helpers.h~lib-string_helpers-allow-to-append-additional-characters-to-be-escaped
+++ a/include/linux/string_helpers.h
@@ -54,6 +54,7 @@ static inline int string_unescape_any_in
 #define ESCAPE_HEX		BIT(5)
 #define ESCAPE_NA		BIT(6)
 #define ESCAPE_NAP		BIT(7)
+#define ESCAPE_APPEND		BIT(8)
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
--- a/lib/string_helpers.c~lib-string_helpers-allow-to-append-additional-characters-to-be-escaped
+++ a/lib/string_helpers.c
@@ -493,6 +493,11 @@ static bool escape_hex(unsigned char c,
  *		escape only non-ascii characters, checked by isascii()
  *	%ESCAPE_NAP:
  *		escape only non-printable or non-ascii characters
+ *	%ESCAPE_APPEND:
+ *		append characters from @only to be escaped by the given classes
+ *
+ * %ESCAPE_APPEND would help to pass additional characters to the escaped, when
+ * one of %ESCAPE_NP, %ESCAPE_NA, or %ESCAPE_NAP is provided.
  *
  * One notable caveat, the %ESCAPE_NAP, %ESCAPE_NP and %ESCAPE_NA have the
  * higher priority than the rest of the flags (%ESCAPE_NAP is the highest).
@@ -513,9 +518,11 @@ int string_escape_mem(const char *src, s
 	char *p = dst;
 	char *end = p + osz;
 	bool is_dict = only && *only;
+	bool is_append = flags & ESCAPE_APPEND;
 
 	while (isz--) {
 		unsigned char c = *src++;
+		bool in_dict = is_dict && strchr(only, c);
 
 		/*
 		 * Apply rules in the following sequence:
@@ -531,20 +538,24 @@ int string_escape_mem(const char *src, s
 		 *	  defined by given @flags
 		 * In these cases we just pass through a character to the
 		 * output buffer.
+		 *
+		 * When %ESCAPE_APPEND is passed, the characters from @only
+		 * have been excluded from the %ESCAPE_NAP, %ESCAPE_NP, and
+		 * %ESCAPE_NA cases.
 		 */
-		if (is_dict && !strchr(only, c) &&
+		if (!(is_append || in_dict) && is_dict &&
 					  escape_passthrough(c, &p, end))
 			continue;
 
-		if (isascii(c) && isprint(c) &&
+		if (!(is_append && in_dict) && isascii(c) && isprint(c) &&
 		    flags & ESCAPE_NAP && escape_passthrough(c, &p, end))
 			continue;
 
-		if (isprint(c) &&
+		if (!(is_append && in_dict) && isprint(c) &&
 		    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
 			continue;
 
-		if (isascii(c) &&
+		if (!(is_append && in_dict) && isascii(c) &&
 		    flags & ESCAPE_NA && escape_passthrough(c, &p, end))
 			continue;
 
_
