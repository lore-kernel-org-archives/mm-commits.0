Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B87C11F6C
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA506146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbhGAB5g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238543AbhGAB5g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE3261469;
        Thu,  1 Jul 2021 01:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104506;
        bh=pM0+FeXVkO9cDXZDX8AB6B9LS+cW/LwCvoFYQ/g2jM4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HPyyNrb6l38vkJ0RmVjhOvpTR+7OpYpeS4kgKvO1uPNAd+naNzATW+le/U2rANWOt
         8VA4dBrAjXblYRZqFKy5b/lD469nnCI4UekHLUJvsICPjDools17P22d5XqRkSpdsL
         Vn+rpX9YzDvFfk7HqMLQG5lrgLEjKb4gNCnzf4b4=
Date:   Wed, 30 Jun 2021 18:55:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 148/192] lib/string_helpers: switch to use BIT()
 macro
Message-ID: <20210701015505.B7JgnSQKB%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: switch to use BIT() macro

Patch series "lib/string_helpers: get rid of ugly *_escape_mem_ascii()", v3.

Get rid of ugly *_escape_mem_ascii() API since it's not flexible and has
the only single user.  Provide better approach based on usage of the
string_escape_mem() with appropriate flags.

Test cases has been expanded accordingly to cover new functionality.


This patch (of 15):

Switch to use BIT() macro for flag definitions.  No changes implied.

Link: https://lkml.kernel.org/r/20210504180819.73127-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20210504180819.73127-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/string_helpers.h~lib-string_helpers-switch-to-use-bit-macro
+++ a/include/linux/string_helpers.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_STRING_HELPERS_H_
 #define _LINUX_STRING_HELPERS_H_
 
+#include <linux/bits.h>
 #include <linux/ctype.h>
 #include <linux/types.h>
 
@@ -18,10 +19,10 @@ enum string_size_units {
 void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
 		     char *buf, int len);
 
-#define UNESCAPE_SPACE		0x01
-#define UNESCAPE_OCTAL		0x02
-#define UNESCAPE_HEX		0x04
-#define UNESCAPE_SPECIAL	0x08
+#define UNESCAPE_SPACE		BIT(0)
+#define UNESCAPE_OCTAL		BIT(1)
+#define UNESCAPE_HEX		BIT(2)
+#define UNESCAPE_SPECIAL	BIT(3)
 #define UNESCAPE_ANY		\
 	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
 
@@ -42,15 +43,15 @@ static inline int string_unescape_any_in
 	return string_unescape_any(buf, buf, 0);
 }
 
-#define ESCAPE_SPACE		0x01
-#define ESCAPE_SPECIAL		0x02
-#define ESCAPE_NULL		0x04
-#define ESCAPE_OCTAL		0x08
+#define ESCAPE_SPACE		BIT(0)
+#define ESCAPE_SPECIAL		BIT(1)
+#define ESCAPE_NULL		BIT(2)
+#define ESCAPE_OCTAL		BIT(3)
 #define ESCAPE_ANY		\
 	(ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_SPECIAL | ESCAPE_NULL)
-#define ESCAPE_NP		0x10
+#define ESCAPE_NP		BIT(4)
 #define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
-#define ESCAPE_HEX		0x20
+#define ESCAPE_HEX		BIT(5)
 
 int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
 		unsigned int flags, const char *only);
_
