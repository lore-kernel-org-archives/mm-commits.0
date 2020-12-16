Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8BAC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75A2A23407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgLPRMC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:02 -0500
Date:   Wed, 16 Dec 2020 09:11:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138681;
        bh=6QgPvlg8aOYYAgeGEmhH+SZhMfWsx+WTgiTMy3yhcTc=;
        h=From:To:Subject:From;
        b=ZyRkuvjPo2bZpkSlbieOsRnsuJGWXGtKUKvCtg4jbDUHlozQBwYXkNxwZ+CMYtTEK
         5fDF9bCsYwlNnrXHqahnxaUKbUYx9XzPdNPyCJRTHXsJEcF//B9jdlUXnRee3nN1tc
         r6plrtBQHZbgCCq9BnliKkqRpUsF3qXu2Pmhq8Mw=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [merged]
 ubsan-disable-object-size-sanitizer-under-gcc.patch removed from -mm tree
Message-ID: <20201216171120.Kyusu4dnL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: disable object-size sanitizer under GCC
has been removed from the -mm tree.  Its filename was
     ubsan-disable-object-size-sanitizer-under-gcc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: disable object-size sanitizer under GCC

GCC's -fsanitize=object-size (as part of CONFIG_UBSAN_MISC) greatly
increases stack utilization.  Do not allow this under GCC.

Link: https://lkml.kernel.org/r/20201203004437.389959-4-keescook@chromium.org
Link: https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/Kconfig.ubsan~ubsan-disable-object-size-sanitizer-under-gcc
+++ a/lib/Kconfig.ubsan
@@ -113,6 +113,9 @@ config UBSAN_UNSIGNED_OVERFLOW
 
 config UBSAN_OBJECT_SIZE
 	def_bool UBSAN_MISC
+	# gcc hugely expands stack usage with -fsanitize=object-size
+	# https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
+	depends on !CC_IS_GCC
 	depends on $(cc-option,-fsanitize=object-size)
 
 config UBSAN_BOOL
_

Patches currently in -mm which might be from keescook@chromium.org are


