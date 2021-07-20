Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE3CC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F67610F7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhGTVPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhGTVPq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:15:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F95E60FF2;
        Tue, 20 Jul 2021 21:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626818183;
        bh=JS8KICCRtg5q+9h4rCRzhacjotF52YwMb7LxqpFfR/Y=;
        h=Date:From:To:Subject:From;
        b=DqRg1x6hhx3Ph9/emlGC6f+7NEeIYEuYmvfTVXYgBapYB7t+tDa6Y1AyCbKiJ99Wl
         f0E6L5KJjEwbQfM9C8JNi+RKASvmwdQpkxT2D9WAg5gH/fNb0gAOXRnlUxauKb9HMf
         8gKf7kzySOXHFWi7Wihwrq3miRgqfJIE+Oa29HYw=
Date:   Tue, 20 Jul 2021 14:56:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, peda@axentia.se,
        geert@linux-m68k.org, mcroce@microsoft.com
Subject:  +
 lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch added
 to -mm tree
Message-ID: <20210720215622.0pHuu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_string.c: move string selftest in the Runtime Testing menu
has been added to the -mm tree.  Its filename is
     lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: lib/test_string.c: move string selftest in the Runtime Testing menu

STRING_SELFTEST is presented in the "Library routines" menu.  Move it in
Kernel hacking > Kernel Testing and Coverage > Runtime Testing together
with other similar tests found in lib/

	--- Runtime Testing
	<*>   Test functions located in the hexdump module at runtime
	<*>   Test string functions (NEW)
	<*>   Test functions located in the string_helpers module at runtime
	<*>   Test strscpy*() family of functions at runtime
	<*>   Test kstrto*() family of functions at runtime
	<*>   Test printf() family of functions at runtime
	<*>   Test scanf() family of functions at runtime

Link: https://lkml.kernel.org/r/20210719185158.190371-1-mcroce@linux.microsoft.com
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Cc: Peter Rosin <peda@axentia.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig       |    3 ---
 lib/Kconfig.debug |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/lib/Kconfig~lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu
+++ a/lib/Kconfig
@@ -683,9 +683,6 @@ config PARMAN
 config OBJAGG
 	tristate "objagg" if COMPILE_TEST
 
-config STRING_SELFTEST
-	tristate "Test string functions"
-
 endmenu
 
 config GENERIC_IOREMAP
--- a/lib/Kconfig.debug~lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu
+++ a/lib/Kconfig.debug
@@ -2180,6 +2180,9 @@ config ASYNC_RAID6_TEST
 config TEST_HEXDUMP
 	tristate "Test functions located in the hexdump module at runtime"
 
+config STRING_SELFTEST
+	tristate "Test string functions at runtime"
+
 config TEST_STRING_HELPERS
 	tristate "Test functions located in the string_helpers module at runtime"
 
_

Patches currently in -mm which might be from mcroce@microsoft.com are

lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch
lib-string-optimized-memcpy.patch
lib-string-optimized-memmove.patch
lib-string-optimized-memset.patch

