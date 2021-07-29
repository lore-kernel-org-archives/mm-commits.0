Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CEDC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C5B360F48
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhG2Vxk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhG2Vxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C13DE6069E;
        Thu, 29 Jul 2021 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595616;
        bh=5qzEY99ziOgfzaAAlZVsCRtC8IbjE8wj4LfrVRkBtds=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J/U0NQ5tktBz47d+jTtwB280QYoip17Xr4UnEKljVxUh3DtLkapIO+2pI29g3rF6v
         tpvLSgPP12ZbT5Vn4+4OE9VowvPPsF4wGQ5jCmTPN4PeqahJFVqpQyWJnpNZAjuRWE
         +GmJ1/ygeK7X32ahoJIydvY/sF1wijMFY3KWNFus=
Date:   Thu, 29 Jul 2021 14:53:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, geert@linux-m68k.org,
        linux-mm@kvack.org, mcroce@microsoft.com,
        mm-commits@vger.kernel.org, peda@axentia.se, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/7] lib/test_string.c: move string selftest in
 the Runtime Testing menu
Message-ID: <20210729215335.VjpFgBWiV%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
