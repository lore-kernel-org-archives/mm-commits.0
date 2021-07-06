Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E68C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3148E61CA9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhGFTYu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhGFTYu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698ED61CA8;
        Tue,  6 Jul 2021 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599330;
        bh=iHxgr47GWe6AgZ8iog+obYXYEO/i1G81AWyBsde7bks=;
        h=Date:From:To:Subject:From;
        b=cCE7PNAZ7kARPrgz6zd9hW61CFPlrs5CV4IIICscFPVN9TGjO8X5C2gWhyik68YuQ
         2ByU09edJf4Rjq282q8koog/Klc6F8x+hJ1ab8b4FYw/KdPB+vxt4Ho7rMMqdJPc6D
         TLFLPcBxP1xNnzTdF7no5u7o9J1BmK1jtUy9Kv0g=
Date:   Tue, 06 Jul 2021 12:22:10 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 =?US-ASCII?Q?lib-string=5Fhelpers-introduce-escape=5Fnap-to-escape-non-a?=
 =?US-ASCII?Q?scii-and-non-printable.patch?= removed from -mm tree
Message-ID: <20210706192210.X3WTAQ93p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: introduce ESCAPE_NAP to escape non-ASCII and non-printable
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


