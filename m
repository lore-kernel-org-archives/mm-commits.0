Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37DFC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 723D160C3E
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBMExa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhBMExZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C1560C3E;
        Sat, 13 Feb 2021 04:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191965;
        bh=zZ2bXkVqctW7aCZ03p336vZ0+lt8jVcgmKb6Uc753/w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JIR5x3qzB2ANl3eUMD2Ws0CcgIYwJWJvTAxgNn/jZk/3zOlq+BcTTy7xtiNfcuajv
         yfKHPZPBMlI2svTtq/pLL3rFIzYVsG1oSa2IL4hHeRV9r3NwByQjm7EfNRBoB87XJy
         prDLHAS4ip4iD2uFNlANz5Y17+Dpv75T6U+pdEoc=
Date:   Fri, 12 Feb 2021 20:52:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 3/6] MAINTAINERS: update KASAN file list
Message-ID: <20210213045244.KHDVAQ7yL%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: MAINTAINERS: update KASAN file list

Account for the following files:

- lib/Kconfig.kasan
- lib/test_kasan_module.c
- arch/arm64/include/asm/mte-kasan.h

Link: https://lkml.kernel.org/r/7f9771d97b34d396bfdc4e288ad93486bb865a06.1613150186.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-kasan-file-list
+++ a/MAINTAINERS
@@ -9565,10 +9565,11 @@ R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 F:	Documentation/dev-tools/kasan.rst
-F:	arch/*/include/asm/kasan.h
+F:	arch/*/include/asm/*kasan.h
 F:	arch/*/mm/kasan_init*
 F:	include/linux/kasan*.h
-F:	lib/test_kasan.c
+F:	lib/Kconfig.kasan
+F:	lib/test_kasan*.c
 F:	mm/kasan/
 F:	scripts/Makefile.kasan
 
_
