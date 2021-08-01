Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA9FC4338F
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C4361050
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhHATL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHATL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 679E060EFF;
        Sun,  1 Aug 2021 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627845109;
        bh=Gm9u1dyjkWPOJexG+GUgjPfwIppbBhzjDKVtC1maAPU=;
        h=Date:From:To:Subject:From;
        b=mK/RcyxBE7OydGdEaWaF1f4O+ycXZ2pudEmwjPWByRHTVSk2UufzhxiDKntI/Nbr7
         VMFDvPCd9hGFQZt0gO6VetmHMCYCrt69bdaKVwhjGzPsCpIGxlrWSFsJdxmZaz9lC8
         EDPCaesnZPFyxJ7BRLYdYpTUv2UpTJuBFHAHKY7c=
Date:   Sun, 01 Aug 2021 12:11:49 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mcroce@microsoft.com,
        mm-commits@vger.kernel.org, peda@axentia.se, rdunlap@infradead.org
Subject:  [merged]
 lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch
 removed from -mm tree
Message-ID: <20210801191149.Ebb7jgifh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_string.c: move string selftest in the Runtime Testing menu
has been removed from the -mm tree.  Its filename was
     lib-test_stringc-move-string-selftest-in-the-runtime-testing-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-string-optimized-memcpy.patch
lib-string-optimized-memmove.patch
lib-string-optimized-memset.patch

