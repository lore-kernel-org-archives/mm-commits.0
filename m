Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6EFC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267E22313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgLPEoF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgLPEoF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:05 -0500
Date:   Tue, 15 Dec 2020 20:43:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093821;
        bh=Rjb6iGyWbt9YpGfbpBTW7NYPHIqhZNEUHP8Kj3ctDTs=;
        h=From:To:Subject:In-Reply-To:From;
        b=OIdSCDZ10fjto4O9x4C1xesHbjxKNDXbGxZcxC+5lTWKxdm8OyJKNexolp/MYH+ju
         pAEeLZmP9Au+ZUSx94mtbNH6lkwINPRKQH0kXHVW+pgoU1z/AMrehqvuJXBM7Y6sYQ
         9l4egOZ6PA9nmZIbqW6oBPOxB8EFjyuX9EWljQMo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexandru.ardelean@analog.com,
        andriy.shevchenko@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, torvalds@linux-foundation.org,
        yamada.masahiro@socionext.com, yury.norov@gmail.com
Subject:  [patch 25/95] lib/string: remove unnecessary #undefs
Message-ID: <20201216044340.O6ttuQ1m0%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: lib/string: remove unnecessary #undefs

A few architecture specific string.h functions used to be implemented in
terms of preprocessor defines to the corresponding compiler builtins. 
Since this is no longer the case, remove unused #undefs.

Only memcmp is still defined in terms of builtins for a few arches.

Link: https://github.com/ClangBuiltLinux/linux/issues/428
Link: https://lkml.kernel.org/r/20201120041113.89382-1-ndesaulniers@google.com
Fixes: 5f074f3e192f ("lib/string.c: implement a basic bcmp")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/lib/string.c~lib-string-remove-unnecessary-undefs
+++ a/lib/string.c
@@ -85,7 +85,6 @@ EXPORT_SYMBOL(strcasecmp);
  * @dest: Where to copy the string to
  * @src: Where to copy the string from
  */
-#undef strcpy
 char *strcpy(char *dest, const char *src)
 {
 	char *tmp = dest;
@@ -302,7 +301,6 @@ EXPORT_SYMBOL(stpcpy);
  * @dest: The string to be appended to
  * @src: The string to append to it
  */
-#undef strcat
 char *strcat(char *dest, const char *src)
 {
 	char *tmp = dest;
@@ -378,7 +376,6 @@ EXPORT_SYMBOL(strlcat);
  * @cs: One string
  * @ct: Another string
  */
-#undef strcmp
 int strcmp(const char *cs, const char *ct)
 {
 	unsigned char c1, c2;
@@ -958,7 +955,6 @@ EXPORT_SYMBOL(memcmp);
  * while this particular implementation is a simple (tail) call to memcmp, do
  * not rely on anything but whether the return value is zero or non-zero.
  */
-#undef bcmp
 int bcmp(const void *a, const void *b, size_t len)
 {
 	return memcmp(a, b, len);
_
