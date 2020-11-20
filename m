Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C719FC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91CC32242A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PUAF74zQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgKTXVL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgKTXVK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:21:10 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6C2D2240C;
        Fri, 20 Nov 2020 23:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605914470;
        bh=NnFggj72giTkmQPs5uxC6y5nLoO+2EkuFz+ntzM/5Pc=;
        h=Date:From:To:Subject:From;
        b=PUAF74zQjBC1tJoo2Xpgiu97f/HfoQyYjq1LZZ4sdAy9KR0mzc+Z4tLoN1D7HQ7vH
         cSEPDeNrx+NGipmk3kUox/QYk6k6C+TE4idb4ipwhTpwDBn2LTWfSW1LtJIGu82n6O
         KtSY3Lwa3cCJfR7M+xP5Y18YsFnl8/lzjkFzIoA4=
Date:   Fri, 20 Nov 2020 15:21:09 -0800
From:   akpm@linux-foundation.org
To:     alexandru.ardelean@analog.com, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, yamada.masahiro@socionext.com,
        yury.norov@gmail.com
Subject:  + lib-string-remove-unnecessary-undefs.patch added to -mm
 tree
Message-ID: <20201120232109.HrXAxHYaB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: remove unnecessary #undefs
has been added to the -mm tree.  Its filename is
     lib-string-remove-unnecessary-undefs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string-remove-unnecessary-undefs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string-remove-unnecessary-undefs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-remove-version-check-for-bpf-tracing.patch
lib-string-remove-unnecessary-undefs.patch
gcov-remove-support-for-gcc-49.patch

